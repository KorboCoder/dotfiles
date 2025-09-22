-- Ref: https://www.reddit.com/r/neovim/s/6Mmi83v58m
-- Initialize an empty table
local printable_chars = {}

-- Loop through the ASCII codes from 32 (space) to 127 (delete)
for i = 32, 127 do
  -- Convert the code to a character and insert it into the table
  table.insert(printable_chars, string.char(i))
end

local spinner = {
			max_length = 20,
			min_length = 1,
			max_distance_from_cursor = 5,
			max_lines = 3,
			repeat_ms = 50,

			-- stylua: ignore
			chars = printable_chars,
			rand_hl_group = "CopilotSpinnerHLGroup",
			ns = vim.api.nvim_create_namespace("custom_copilot_spinner"),
			timer = nil,
		}

		function spinner:next_string()
			local result = {}
			local spaces = math.random(0, self.max_distance_from_cursor)
			for _ = 1, spaces do
				table.insert(result, " ")
			end

			local length = math.random(self.min_length, self.max_length)
			for _ = 1, length do
				local index = math.random(1, #self.chars)
				table.insert(result, self.chars[index])
			end

			return table.concat(result)
		end

		function spinner:reset()
			vim.api.nvim_buf_clear_namespace(0, self.ns, 0, -1)
			if self.timer then
				self.timer:stop()
				self.timer = nil
			end
		end

		vim.api.nvim_create_autocmd({ "CursorMovedI", "InsertLeave" }, {
			callback = function()
				spinner:reset()
			end,
		})

		require("copilot.status").register_status_notification_handler(function(data)
			spinner:reset()
			if data.status ~= "InProgress" then
				return
			end

			if spinner.timer then
				spinner.timer:stop()
			end
			spinner.timer = vim.uv.new_timer()
			if not spinner.timer then
				return
			end

			spinner.timer:start(
				0,
				spinner.repeat_ms,
				vim.schedule_wrap(function()
					if require("copilot.suggestion").is_visible() then
						spinner:reset()
						return
					end

					local pos = vim.api.nvim_win_get_cursor(0)
					local cursor_row, cursor_col = pos[1] - 1, pos[2]
					local cursor_line = vim.api.nvim_buf_get_lines(0, cursor_row, cursor_row + 1, false)[1] or ""
					if cursor_col > #cursor_line then
						cursor_col = #cursor_line
					end

					vim.api.nvim_set_hl(0, spinner.rand_hl_group, {
						fg = "#00" .. string.format("%02x", math.random(110, 180)) .. "44",
						bold = true,
					})

					local extmark_ids = {}
					local num_lines = math.random(1, spinner.max_lines)
					local buf_line_count = vim.api.nvim_buf_line_count(0)

					for i = 1, num_lines do
						local row = cursor_row + i - 1
						if row >= buf_line_count then
							break
						end
						local col = (i == 1) and cursor_col or 0

						local extmark_id = vim.api.nvim_buf_set_extmark(0, spinner.ns, row, col, {
							virt_text = { { spinner:next_string(), spinner.rand_hl_group } },
							virt_text_pos = "overlay",
							priority = 0,
						})
						table.insert(extmark_ids, extmark_id)
					end

					vim.defer_fn(function()
						for _, extmark_id in ipairs(extmark_ids) do
							pcall(vim.api.nvim_buf_del_extmark, 0, spinner.ns, extmark_id)
						end
					end, spinner.repeat_ms + math.random(1, 100))
				end)
			)
		end)
