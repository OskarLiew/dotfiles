local gears = require("gears")
local wibox = require("wibox")

local function init_icon(image, size, color)
	if color then
		image = gears.color.recolor_image(image, color)
	end
	return wibox.widget({
		image = image,
		forced_height = size,
		forced_width = size,
		widget = wibox.widget.imagebox,
	})
end

return {
	init_icon = init_icon,
}
