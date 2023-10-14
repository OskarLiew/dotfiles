local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi
local naughty = require("naughty")

local config = require("configuration.widget").network
local apps = require("configuration.apps")
local clickable_container = require("widget.clickable-container")

local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. "widget/network/icons/"

local function return_button(wireless_interface)
	local network_imagebox = wibox.widget({
		nil,
		{
			id = "icon",
			image = widget_icon_dir .. "wifi.svg",
			widget = wibox.widget.imagebox,
			resize = true,
		},
		nil,
		expland = "none",
		layout = wibox.layout.align.vertical,
	})

	local network_widget = wibox.widget({
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(0),
		network_imagebox,
	})

	local network_button = wibox.widget({
		network_widget,
		widget = clickable_container,
	})

	network_button:buttons(gears.table.join(awful.button({}, 1, nil, function()
		awful.spawn(apps.default.network_manager, false)
	end)))

	local network_tooltip = awful.tooltip({
		objects = { network_button },
		text = "None",
		mode = "outside",
		align = "right",
		margin_leftright = dpi(8),
		margin_topbottom = dpi(8),
		preferred_positions = { "right", "left", "top", "bottom" },
	})

	local get_network_info = function()
		awful.spawn.easy_async_with_shell("iwconfig " .. wireless_interface, function(stdout)
			if stdout == nil or stdout == "" then
				network_tooltip:set_text("iwconfig error with interface " .. wireless_interface)
				return
			end

			-- Remove new line from the last line
			network_tooltip:set_text(stdout:sub(1, -3))
		end)
	end
	get_network_info()

	network_widget:connect_signal("mouse::enter", function()
		get_network_info()
	end)

	local connected = false
	local show_disconnected_notification = function()
		naughty.notification({
			icon = widget_icon_dir .. "wifi-disconnected.svg",
			app_name = "System notification",
			title = "Disconnection",
			message = "You have been disconnected from a network",
			urgency = "normal",
		})
	end

	local show_connected_notification = function()
		naughty.notification({
			icon = widget_icon_dir .. "wifi-high.svg",
			app_name = "System notification",
			title = "Connection",
			message = "You have been connected to a network",
			urgency = "normal",
		})
	end

	local function update_network()
		local cmd = "iwconfig " .. wireless_interface .. [[ | awk '/Link Quality=/ {print $2}' | tr -d 'Quality=']]
		awful.spawn.easy_async_with_shell(cmd, function(stdout)
			stdout = stdout:gsub("\n", "")
			local numer, denom = stdout:match("([^,]+)/([^,]+)")
			local network_strength = tonumber(numer) / tonumber(denom)

			-- Stop if null
			if not network_strength then
				return
			end

			network_widget.spacing = dpi(5)

			local icon_name = "wifi"

			if network_strength < 0.33 then
				icon_name = icon_name .. "-low"
			elseif network_strength < 0.67 then
				icon_name = icon_name .. "-mid"
			else
				icon_name = icon_name .. "-high"
			end
			network_imagebox.icon:set_image(gears.surface.load_uncached(widget_icon_dir .. icon_name .. ".svg"))
		end)
	end

	local refresh_rate = 5 -- In seconds
	awful.widget.watch("iw dev " .. wireless_interface .. " link", refresh_rate, function(widget, stdout)
		-- Disconnected
		local connected_tmp = false
		if string.find(stdout, "^Connected") then
			connected_tmp = true
			update_network()
		else
			network_widget.spacing = dpi(0)
			network_imagebox.icon:set_image(gears.surface.load_uncached(widget_icon_dir .. "wifi-disconnected.svg"))
		end

		if connected and not connected_tmp then
			show_disconnected_notification()
		elseif not connected and connected_tmp then
			show_connected_notification()
		end
		connected = connected_tmp
	end)

	return network_button
end

return return_button
