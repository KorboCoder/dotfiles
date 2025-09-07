local M = {}

-- Generic helper function to apply transformations to visual selection
function M.apply_to_visual_selection(transform_func)
  return function()
    -- Get the visual selection marks
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    
    -- Extract current selection
    local lines = vim.fn.getline(start_pos[2], end_pos[2])
    if #lines == 0 then return end
    
    local text
    if #lines == 1 then
      -- Character-wise selection within a single line
      local start_col = start_pos[3] - 1
      local end_col = end_pos[3]
      text = string.sub(lines[1], start_col + 1, end_col)
    else
      -- Multi-line selection
      local start_col = start_pos[3] - 1
      local end_col = end_pos[3]
      
      -- First line (from start_col to end)
      lines[1] = string.sub(lines[1], start_col + 1)
      -- Last line (from beginning to end_col)
      lines[#lines] = string.sub(lines[#lines], 1, end_col)
      
      text = table.concat(lines, '\n')
    end
    
    -- Apply transformation
    local success, result = pcall(transform_func, text)
    if not success then
      vim.notify("Transform error: " .. result, vim.log.levels.ERROR)
      return
    end
    
    if not result or result == "" then
      vim.notify("Transform returned empty result", vim.log.levels.WARN)
      return
    end
    
    -- Replace the selection with transformed text
    local result_lines = vim.split(result, '\n', { plain = true })
    
    if #lines == 1 and #result_lines == 1 then
      -- Single line replacement
      local line = vim.fn.getline(start_pos[2])
      local start_col = start_pos[3] - 1
      local end_col = end_pos[3]
      local new_line = string.sub(line, 1, start_col) .. result_lines[1] .. string.sub(line, end_col + 1)
      vim.fn.setline(start_pos[2], new_line)
    else
      -- Multi-line replacement
      local start_col = start_pos[3] - 1
      local end_col = end_pos[3]
      local first_line = vim.fn.getline(start_pos[2])
      local last_line = vim.fn.getline(end_pos[2])
      
      -- Prepare new lines
      if #result_lines == 1 then
        -- Result is single line, but original was multi-line
        local new_line = string.sub(first_line, 1, start_col) .. result_lines[1] .. string.sub(last_line, end_col + 1)
        vim.fn.setline(start_pos[2], new_line)
        -- Delete the remaining lines
        if end_pos[2] > start_pos[2] then
          vim.cmd(string.format("%d,%dd", start_pos[2] + 1, end_pos[2]))
        end
      else
        -- Multi-line result
        result_lines[1] = string.sub(first_line, 1, start_col) .. result_lines[1]
        result_lines[#result_lines] = result_lines[#result_lines] .. string.sub(last_line, end_col + 1)
        
        -- Replace lines
        vim.fn.setline(start_pos[2], result_lines[1])
        if #result_lines > 1 then
          -- Delete old lines first if necessary
          if end_pos[2] > start_pos[2] then
            vim.cmd(string.format("%d,%dd", start_pos[2] + 1, end_pos[2]))
          end
          -- Insert new lines
          vim.fn.append(start_pos[2], vim.list_slice(result_lines, 2))
        end
      end
    end
  end
end

-- External command helper using echo and pipe
local function run_external_command(cmd, text)
  -- Escape the text for shell
  local escaped_text = vim.fn.shellescape(text)
  
  -- Use echo to pipe the text to the command
  local full_cmd = 'echo ' .. escaped_text .. ' | ' .. cmd
  local result = vim.fn.system(full_cmd)
  local exit_code = vim.v.shell_error
  
  if exit_code ~= 0 then
    error("Command '" .. cmd .. "' failed with exit code " .. exit_code .. ": " .. result)
  end
  
  -- Remove trailing newline if present
  return result:gsub('\n$', '')
end

-- JSON transformations
function M.json_beautify(text)
  return run_external_command('jq .', text)
end

function M.json_minify(text)
  return run_external_command('jq -c .', text)
end

-- C-string escaping transformations
function M.cstring_escape(text)
  return run_external_command('jq -Rs .', text):gsub('^"', ''):gsub('"$', '')
end

function M.cstring_unescape(text)
  return run_external_command('jq -r .', '"' .. text .. '"')
end

-- Base64 transformations
function M.base64_encode(text)
  return run_external_command('base64', text):gsub('\n', '')
end

function M.base64_decode(text)
  return run_external_command('base64 -d', text)
end

-- URL encoding transformations (pure Lua implementation)
function M.url_encode(text)
  local function char_to_hex(c)
    return string.format("%%%02X", string.byte(c))
  end
  
  -- Encode all characters except unreserved (ALPHA / DIGIT / "-" / "." / "_" / "~")
  return text:gsub("([^%w%-%.%_%~])", char_to_hex)
end

function M.url_decode(text)
  local function hex_to_char(x)
    return string.char(tonumber(x, 16))
  end
  
  return text:gsub("%%(%x%x)", hex_to_char):gsub("+", " ")
end

-- Simple test function for debugging
function M.test_transform()
  vim.notify("Transform module loaded successfully!", vim.log.levels.INFO)
  
  -- Test JSON functionality
  local test_json = '{"name": "test", "value": 123}'
  vim.notify("Testing with JSON: " .. test_json, vim.log.levels.INFO)
  
  local success, encoded = pcall(M.json_beautify, test_json)
  if success then
    vim.notify("JSON beautify success: " .. encoded, vim.log.levels.INFO)
  else
    vim.notify("JSON beautify failed: " .. encoded, vim.log.levels.ERROR)
  end
  
  -- Test base64 functionality
  local test_text = "hello"
  local success2, b64 = pcall(M.base64_encode, test_text)
  if success2 then
    vim.notify("Base64 encoded 'hello': " .. b64, vim.log.levels.INFO)
  else
    vim.notify("Base64 failed: " .. b64, vim.log.levels.ERROR)
  end
end
M.transforms = {
  json_beautify = M.apply_to_visual_selection(M.json_beautify),
  json_minify = M.apply_to_visual_selection(M.json_minify),
  cstring_escape = M.apply_to_visual_selection(M.cstring_escape),
  cstring_unescape = M.apply_to_visual_selection(M.cstring_unescape),
  base64_encode = M.apply_to_visual_selection(M.base64_encode),
  base64_decode = M.apply_to_visual_selection(M.base64_decode),
  url_encode = M.apply_to_visual_selection(M.url_encode),
  url_decode = M.apply_to_visual_selection(M.url_decode),
}

return M