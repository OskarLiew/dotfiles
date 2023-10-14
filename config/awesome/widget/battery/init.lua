local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local dpi = require("beautiful").xresources.apply_dpi
local beautiful = require("beautiful")

local apps = require("configuration.apps")
local clickable_container = require("widget.clickable-container")

local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. "widget/battery/icons/"

local return_button = function()
	local battery_imagebox = wibox.widget({
		nil,
		{
			id = "icon",
			image = widget_icon_dir .. "battery" .. ".svg",
			widget = wibox.widget.imagebox,
			resize = true,
		},
		nil,
		expand = "none",
		layout = wibox.layout.align.vertical,
	})

	local battery_percentage_text = wibox.widget({
		id = "percent_text",
		text = "100%",
		font = "Inter 10",
		align = "center",
		valign = "center",
		visible = false,
		widget = wibox.widget.textbox,
	})

	local battery_widget = wibox.widget({
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(2),
		battery_imagebox,
		battery_percentage_text,
	})

	local battery_button = wibox.widget({
		{
			battery_widget,
			widget = wibox.container.margin,
			left = dpi(4),
			right = dpi(4),
		},
		widget = clickable_container,
	})

	battery_button:buttons(gears.table.join(awful.button({}, 1, nil, function()
		awful.spawn(apps.default.power_manager, false)
	end)))

	local battery_tooltip = awful.tooltip({
		objects = { battery_button },
		text = "None",
		mode = "outside",
		align = "right",
		margin_leftright = dpi(8),
		margin_topbottom = dpi(8),
		preferred_positions = { "right", "left", "top", "bottom" },
	})

	local get_battery_info = function()
		awful.spawn.easy_async_with_shell("upower -i $(upower -e | grep BAT)", function(stdout)
			if stdout == nil or stdout == "" then
				battery_tooltip:set_text("No battery detected!")
				return
			end

			-- Remove new line from the last line
			battery_tooltip:set_text(stdout:sub(1, -2))
		end)
	end
	get_battery_info()

	battery_widget:connect_signal("mouse::enter", function()
		get_battery_info()
	end)

	local last_battery_check = os.time()
	local notify_critcal_battery = true

	local show_battery_warning = function()
		naughty.notification({
			icon = widget_icon_dir .. "battery-alert.svg",
			app_name = "System notification",
			title = "Battery is dying!",
			message = "Battery is about to run out. Plug in the machine, or at least save!",
			urgency = "critical",
		})
	end

	local update_battery = function(status)
		awful.spawn.easy_async_with_shell(
			[[sh -c "
			upower -i $(upower -e | grep BAT) | grep percentage | awk '{print \$2}' | tr -d '\n%'
			"]],
			function(stdout)
				local battery_percentage = tonumber(stdout)

				-- Stop if null
				if not battery_percentage then
					return
				end

				battery_widget.spacing = dpi(5)
				battery_percentage_text.visible = true
				battery_percentage_text:set_text(battery_percentage .. "%")

				local icon_name = "battery"

				-- Charging or fully charged
				if status == "charging" or (status == "fully-charged" and battery_percentage == 100) then
					icon_name = icon_name .. "-charging"
					battery_imagebox.icon:set_image(gears.surface.load_uncached(widget_icon_dir .. icon_name .. ".svg"))
					return
				end

				-- Critical level warning message
				if (battery_percentage > 0 and battery_percentage < 10) and status == "discharging" then
					icon_name = icon_name .. "-" .. "alert-red"

					if os.difftime(os.time(), last_battery_check) > 300 or notify_critcal_battery then
						last_battery_check = os.time()
						notify_critcal_battery = false
						show_battery_warning()
					end
					battery_imagebox.icon:set_image(gears.surface.load_uncached(widget_icon_dir .. icon_name .. ".svg"))
					return
				end

				-- Discharging
				icon_name = icon_name .. "-working-"
				if battery_percentage < 15 then
					icon_name = icon_name .. "15"
				elseif battery_percentage < 25 then
					icon_name = icon_name .. "25"
				elseif battery_percentage < 40 then
					icon_name = icon_name .. "40"
				elseif battery_percentage < 50 then
					icon_name = icon_name .. "50"
				elseif battery_percentage < 65 then
					icon_name = icon_name .. "65"
				elseif battery_percentage < 75 then
					icon_name = icon_name .. "75"
				elseif battery_percentage < 90 then
					icon_name = icon_name .. "90"
				else
					icon_name = icon_name .. "100"
				end
				battery_imagebox.icon:set_image(gears.surface.load_uncached(widget_icon_dir .. icon_name .. ".svg"))
			end
		)
	end

	-- Watch status if charging, discharging, fully-charged
	awful.widget.watch(
		[[sh -c "
		upower -i $(upower -e | grep BAT) | grep state | awk '{print \$2}' | tr -d '\n'
		"]],
		5,
		function(widget, stdout)
			local status = stdout:gsub("%\n", "")

			-- If no output or no battery detected
			if status == nil or status == "" then
				battery_widget.spacing = dpi(0)
				battery_percentage_text.visible = false
				battery_tooltip:set_text("No battery detected!")
				battery_imagebox.icon:set_image(
					gears.surface.load_uncached(widget_icon_dir .. "battery-unknown" .. ".svg")
				)
				return
			end

			update_battery(status)
		end
	)

	return battery_button
end

return return_button
