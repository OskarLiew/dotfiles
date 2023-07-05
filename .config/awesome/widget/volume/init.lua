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

local function return_button()
	local volume_imagebox = wibox.widget({
		nil,
		{
			id = "icon",
			image = widget_icon_dir .. "volume-mute.svg",
			widget = wibox.widget.imagebox,
			resize = true,
		},
		nil,
		expland = "none",
		layout = wibox.layout.align.vertical,
	})

	local volume_widget = wibox.widget({
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(0),
		volume_imagebox,
	})

	local volume_button = wibox.widget({
		{
			volume_widget,
			margins = dpi(4),
			widget = wibox.container.margin,
		},
		widget = clickable_container,
	})

	volume_button:buttons(gears.table.join(awful.button({}, 1, nil, function()
		awful.spawn(apps.default.volume_mixer, false)
	end)))

	local volume_tooltip = awful.tooltip({
		objects = { volume_button },
		text = "None",
		mode = "outside",
		align = "right",
		margin_leftright = dpi(8),
		margin_topbottom = dpi(8),
		preferred_positions = { "right", "left", "top", "bottom" },
	})

	local adjust_screen = awful.screen.focused()
	local adjust_height = dpi(156)
	local adjust_width = dpi(36)
	local volume_adjust = wibox({
		screen = adjust_screen,
		x = adjust_screen.geometry.width - adjust_width - beautiful.useless_gap,
		y = (adjust_height / 2),
		width = adjust_width,
		height = adjust_height,
		shape = gears.shape.rounded_rect,
		visible = false,
		ontop = true,
	})

	local volume_bar = wibox.widget({
		widget = wibox.widget.progressbar,
		shape = gears.shape.rounded_rect,
		color = beautiful.hud_slider_fg,
		background_color = beautiful.hud_slider_bg,
		max_value = 100,
		value = 0,
	})

	volume_adjust:setup({
		layout = wibox.layout.align.vertical,
		{
			wibox.container.margin(
				volume_bar,
				adjust_width * 0.25,
				adjust_width * 0.40,
				adjust_width * 0.40,
				adjust_width * 0.40
			),
			forced_height = adjust_height * 0.80,
			direction = "east",
			layout = wibox.container.rotate,
		},
		wibox.container.margin(volume_imagebox, adjust_width * 0.25, adjust_width * 0.25),
	})

	-- create a 4 second timer to hide the volume adjust
	-- component whenever the timer is started
	local hide_volume_adjust = gears.timer({
		timeout = 3,
		autostart = true,
		callback = function()
			volume_adjust.visible = false
		end,
	})

	-- Functionality

	local function update_volume(muted)
		awful.spawn.easy_async_with_shell(
			[[awk -F"[][]" '/Left:/ { print $2 }' <(amixer sget Master) | tr -d '\n%']],
			function(stdout)
				local volume_percentage = tonumber(stdout)

				-- Stop if null
				if not volume_percentage then
					return
				end

				volume_widget.spacing = dpi(5)
				volume_bar.value = volume_percentage

				-- Update tooltip text
				local tooltip_text = volume_percentage .. "%"
				if muted then
					tooltip_text = "Muted (" .. tooltip_text .. ")"
				end
				volume_tooltip:set_text(tooltip_text)

				-- Set icon
				local icon_name = "volume"

				if muted then
					icon_name = icon_name .. "-mute"
					volume_imagebox.icon:set_image(gears.surface.load_uncached(widget_icon_dir .. icon_name .. ".svg"))
					return
				end

				if volume_percentage < 50 then
					icon_name = icon_name .. "-small"
				else
					icon_name = icon_name .. "-notice"
				end
				volume_imagebox.icon:set_image(gears.surface.load_uncached(widget_icon_dir .. icon_name .. ".svg"))

				-- make volume_adjust component visible
				if volume_adjust.visible then
					hide_volume_adjust:again()
				else
					volume_adjust.visible = true
					hide_volume_adjust:start()
				end
			end
		)
	end

	local function set_volume()
		awful.spawn.easy_async_with_shell(
			-- Sleep to avoid race condition
			[[sleep 0.01 && pacmd list-sinks | awk '/muted/ { print $2 }']],
			function(stdout)
				local muted = stdout:gsub("%s+", "") == "yes"

				update_volume(muted)
			end
		)
	end

	-- Trigger events
	awesome.connect_signal("volume_change", set_volume)
	volume_widget:connect_signal("mouse::enter", set_volume)

	set_volume()
	return volume_button
end

return return_button
