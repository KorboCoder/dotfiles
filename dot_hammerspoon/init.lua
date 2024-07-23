-- Variable to keep track of typing status
local isTyping = false

-- Function to type out clipboard contents with a delay
function typeClipboard()
    local clipboardContents = hs.pasteboard.getContents()
    if clipboardContents then
        isTyping = true
        -- Loop through each character and type it with a delay
        for char in clipboardContents:gmatch(".") do
            if not isTyping then
                hs.alert.show("Typing canceled")
                return
            end
            hs.eventtap.keyStrokes(char)
            hs.timer.usleep(10000) -- 10 milliseconds delay
        end
        isTyping = false
    else
        hs.alert.show("Clipboard is empty")
    end
end

-- Function to cancel typing
function cancelTyping()
        hs.alert.show("Canceling Typing")
	if isTyping then
        isTyping = false
    end
end

-- Bind the function to a hotkey
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "V", typeClipboard)
-- Bind the cancel function to the Esc key
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "escape", cancelTyping)


local log = hs.logger.new('test', 'info')

hs.hotkey.bind({ "cmd" }, "\\", function()
	local wez = hs.application.find("Wezterm")
	if not wez then
		wez = hs.application.open("Wezterm")
	end
	if wez then
		if wez:isFrontmost() then
			wez:hide()
		else
			local wez_window = wez:mainWindow()
			wez_window:maximize()

			-- yabai calls so we can move the wezterm window to whatever space on the main screen, follow
			-- this issue for any update on cleaner way to do this natively: https://github.com/Hammerspoon/hammerspoon/issues/3636
			-- local windowid = hs.execute("$HOME/.nix-profile/bin/yabai -m query --windows | $HOME/.nix-profile/bin/jq 'map(select(.app == \"WezTerm\" or .app == \"wezterm-gui\")) | sort_by(.id) | last' | jq '.id'")
			-- log.i(windowid)
			-- windowid = string.gsub(windowid, "\n", "")
			-- hs.execute( "$HOME/.nix-profile/bin/yabai -m window ".. windowid .." --grid 1:1:0:0:1:1 --display 1 --focus")
			hs.execute("./focus-wezterm.sh")
		end
	end
end)
