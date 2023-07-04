local filesystem = require("gears.filesystem")
local config_dir = filesystem.get_configuration_dir()
local rofi_dir = config_dir .. "/rofi"

local default_apps = {
	-- Default terminal emulator
	terminal = "alacritty",
	-- Default web browser
	web_browser = "firefox",
	-- Default text editor
	visual_editor = "code",
	editor = os.getenv("EDITOR") or "nvim",
	-- Default file manager
	file_manager = "ranger",
	-- Default media player
	multimedia = "vlc",
	music = "spotify",
	notes = "obsidian",
	rofi_appmenu = rofi_dir .. "/config/applauncher.sh",
	rofi_windowmenu = rofi_dir .. "/config/windowselector.sh",
	rofi_powermenu = rofi_dir .. "/config/powermenu.sh",
}

return {
	-- The default applications that we will use in keybindings and widgets
	default = default_apps,

	-- List of apps to start once on start-up
	run_on_start_up = {
		-- Compositor
		"picom",
	},
}
