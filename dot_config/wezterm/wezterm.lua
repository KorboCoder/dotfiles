-- Pull in the wezterm API
local wezterm = require 'wezterm'
local mux = wezterm.mux

wezterm.log_info('Version: ' .. wezterm.version)

wezterm.on('gui-startup', function(domain)
	-- maximize all displayed windows on startup
	local workspace = mux.get_active_workspace()
	for _, window in ipairs(mux.all_windows()) do
		if window:get_workspace() == workspace then
			window:gui_window():maximize()
		end
	end
end)

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.term = 'wezterm'
config.set_environment_variables = {
	TERMINFO_DIRS = '/home/user/.nix-profile/share/terminfo',
	WSLENV = 'TERMINFO_DIRS',
}

config.force_reverse_video_cursor = true
config.cursor_thickness = 1.8
config.font_size = 17

local scheme = wezterm.color.get_builtin_schemes()["Catppuccin Macchiato"]
-- For example, changing the color scheme:
config.color_scheme = 'Catppuccin Macchiato'
config.background = {
	{
		source = {
			Color = scheme.background
		},
		width = "100%",
		height = "100%",
		opacity = 1.0
	},
	{
		source = {
			File = wezterm.home_dir .. '/.config/assets/power_wallpaper5.png',
		},
		opacity = 0.05,
		vertical_align = 'Bottom',
		horizontal_align = 'Right'
	}
}
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.enable_tab_bar = false
config.font = wezterm.font_with_fallback {
	"Mononoki Nerd Font Mono",
	"Noto Color Emoji",
}

config.window_padding = {
	left = "1cell",
	right = "1cell",
	top = "0.5cell",
	bottom = 0
}

-- keys
config.keys = {
	{
		key = 'f',
		mods = 'CTRL|SUPER',
		action = wezterm.action.ToggleFullScreen,
	},
	-- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
	{
		key = "LeftArrow",
		mods = "OPT",
		action = wezterm.action { SendString = "\x1bb" },
	},
	-- Make Option-Right equivalent to Alt-f; forward-word
	{
		key = "RightArrow",
		mods = "OPT",
		action = wezterm.action { SendString = "\x1bf" },
	}
}

-- and finally, return the configuration to wezterm
return config
