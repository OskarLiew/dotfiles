local gears = require("gears")
local config_dir = gears.filesystem.get_configuration_dir()

local function get_icon_dir(widget)
	return config_dir .. "widget/" .. widget .. "/icons/"
end

return {
	get_icon_dir = get_icon_dir,
}
