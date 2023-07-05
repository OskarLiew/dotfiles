local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local clickable_container = require("widget.clickable-container")
local dpi = require("beautiful").xresources.apply_dpi
local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. "widget/volume/icons/"
local apps = require("configuration.apps")
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

	local volume_percentage_text = wibox.widget({
		id = "percent_text",
		text = "100%",
		font = "Inter 10",
		align = "center",
		valign = "center",
		visible = false,
		widget = wibox.widget.textbox,
	})

	local volume_widget = wibox.widget({
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(0),
		volume_imagebox,
		volume_percentage_text,
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
				volume_percentage_text.visible = true
				volume_percentage_text:set_text(volume_percentage .. "%")

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
