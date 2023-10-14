local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local icon_dir = require("helpers.widget").get_icon_dir("power-button")
local clickable_container = require("widget.clickable-container")
local init_icon = require("helpers.icon").init_icon

local apps = require("configuration.apps")

local function init_power_button(margins)
	local power_icon = wibox.widget({
		{
			init_icon(icon_dir .. "power.svg", nil, beautiful.red),
			widget = wibox.container.margin,
			margins = margins or dpi(8),
		},
		widget = wibox.container.place,
		halign = "center",
		valign = "center",
	})

	local power_button = wibox.widget({
		{
			power_icon,
			widget = wibox.container.background,
			bg = beautiful.bg_red,
		},
		widget = clickable_container,
		shape = gears.shape.circle,
	})
	power_button:buttons(gears.table.join(awful.button({}, 1, nil, function()
		awful.util.spawn(apps.default.rofi_powermenu)
	end)))

	return power_button
end

return init_power_button
