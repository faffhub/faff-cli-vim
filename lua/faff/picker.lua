-- Faff Telescope picker for session fields
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local entry_display = require('telescope.pickers.entry_display')

local M = {}

-- Parse current line to detect field
local function detect_field()
  local line = vim.api.nvim_get_current_line()
  local field = line:match('^%s*(%w+)%s*=')

  if not field then
    return nil
  end

  -- Normalize trackers -> tracker
  if field == 'trackers' then
    field = 'tracker'
  end

  -- Validate it's a faff session field
  local valid_fields = {role = true, impact = true, mode = true, subject = true, tracker = true}
  if valid_fields[field] then
    return field
  end

  return nil
end

-- Get field values from faff CLI
local function get_field_values(field)
  local faff_cmd = vim.g.faff_command or 'faff'
  local cmd = string.format('%s field list %s --plain 2>/dev/null | tail -n +2', faff_cmd, field)

  local handle = io.popen(cmd)
  if not handle then
    return {}
  end

  local result = handle:read('*a')
  handle:close()

  local entries = {}
  for line in result:gmatch('[^\r\n]+') do
    local parts = vim.split(line, '\t')
    if #parts > 0 then
      local entry = {
        value = parts[1],
        name = #parts > 1 and parts[2] or '',
        intents = #parts > 2 and parts[3] or '0',
        sessions = #parts > 3 and parts[4] or '0',
      }
      table.insert(entries, entry)
    end
  end

  return entries
end

-- Insert selected value into buffer
local function insert_value(field, entry)
  local line = vim.api.nvim_get_current_line()
  local row = vim.api.nvim_win_get_cursor(0)[1]

  -- Find the position after '=' and any quote
  local _, end_pos = line:find('=%s*"?')
  if not end_pos then
    return
  end

  -- Build insertion text
  local insert_text
  if field == 'tracker' and entry.name ~= '' then
    insert_text = '"' .. entry.value .. '", # ' .. entry.name
  else
    insert_text = entry.value
  end

  -- Clear existing value and insert new one
  local before = line:sub(1, end_pos)
  local after = line:match('[",%]].*') or ''

  local new_line = before .. insert_text .. after
  vim.api.nvim_buf_set_lines(0, row - 1, row, false, {new_line})

  -- Move cursor after insertion
  vim.api.nvim_win_set_cursor(0, {row, end_pos + #insert_text})
end

-- Create Telescope picker
function M.pick_field()
  local field = detect_field()

  if not field then
    vim.notify('Not on a faff session field line', vim.log.levels.WARN)
    return
  end

  local entries = get_field_values(field)

  if #entries == 0 then
    vim.notify('No ' .. field .. ' values found', vim.log.levels.WARN)
    return
  end

  -- Create custom displayer for tracker entries
  local displayer
  if field == 'tracker' then
    displayer = entry_display.create({
      separator = ' ',
      items = {
        { width = 50 },  -- Name
        { width = 20 },  -- ID
        { width = 8 },   -- Sessions
      },
    })
  end

  pickers.new({}, {
    prompt_title = string.format('Select %s', field),
    finder = finders.new_table({
      results = entries,
      entry_maker = function(entry)
        if field == 'tracker' then
          return {
            value = entry,
            display = function(e)
              return displayer({
                {e.value.name, 'TelescopeResultsIdentifier'},
                {e.value.value, 'TelescopeResultsComment'},
                {e.value.sessions .. ' sessions', 'TelescopeResultsNumber'},
              })
            end,
            ordinal = entry.name .. ' ' .. entry.value,  -- Search by both name and ID
          }
        else
          return {
            value = entry,
            display = string.format('%s (%s sessions)', entry.value, entry.sessions),
            ordinal = entry.value,
          }
        end
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        insert_value(field, selection.value)
      end)
      return true
    end,
  }):find()
end

return M
