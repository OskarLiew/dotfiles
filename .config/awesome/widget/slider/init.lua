local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local clickable_container = require("widget.clickable-container")
local dpi = require("beautiful").xresources.apply_dpi
local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. "widget/volume/icons/"
local apps = require("configuration.apps")
local beautiful = require("beautiful")
local naughty = require("naughty")

local function slider(args)
	local screen = args.screen or awful.screen.focused()
	local container_height = args.height or dpi(156)
	local container_width = args.width or dpi(36)

	local container = wibox({
		screen = screen,
		x = screen.geometry.width - container_width - 3 * beautiful.useless_gap,
		y = (container_height / 2),
		width = container_width,
		height = container_height,
		shape = gears.shape.rounded_rect,
		visible = false,
		ontop = true,
		opacity = 0.75,
	})

	local bar = wibox.widget({
		widget = wibox.widget.progressbar,
		shape = gears.shape.rounded_rect,
		color = beautiful.hud_slider_fg,
		background_color = beautiful.hud_slider_bg,
		max_value = args.max_value or 100,
		value = 0,
	})

	container:setup({
		layout = wibox.layout.align.vertical,
		{
			wibox.container.margin(
				bar,
				container_width * 0.25,
				container_width * 0.40,
				container_width * 0.40,
				container_width * 0.40
			),
			forced_height = container_height * 0.80,
			direction = "east",
			layout = wibox.container.rotate,
		},
		wibox.container.margin(args.imagebox, container_width * 0.25, container_width * 0.25),
	})

	-- create a 4 second timer to hide the volume adjust
	-- component whenever the timer is started
	local hide_adjust = gears.timer({
		timeout = 3,
		autostart = true,
		callback = function()
			container.visible = false
		end,
	})

	container.display = function()
		-- make adjust component visible
		if container.visible then
			hide_adjust:again()
		else
			container.visible = true
			hide_adjust:start()
		end
	end

	container.set_value = function(val)
		bar.value = val
	end

	return container
end

return slider
