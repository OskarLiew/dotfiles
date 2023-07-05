local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local watch = awful.widget.watch
local clickable_container = require("widget.clickable-container")
local dpi = require("beautiful").xresources.apply_dpi
local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. "widget/network/icons/"
local apps = require("configuration.apps")
local config = require("configuration.widget").network

local function return_button()
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
		{
			network_widget,
			margins = dpi(4),
			widget = wibox.container.margin,
		},
		widget = clickable_container,
	})

	network_button:buttons(gears.table.join(awful.button({}, 1, nil, function()
		awful.spawn(apps.default.network_manager, false)
	end)))

	local function update_network()
		local cmd = "iwconfig "
			.. config.wireless_interface
			.. [[ | awk '/Link Quality=/ {print $2}' | tr -d 'Quality=']]
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
	watch("iw dev " .. config.wireless_interface .. " link", refresh_rate, function(widget, stdout)
		-- Disconnected
		if string.find(stdout, "^Not connected") then
			network_widget.spacing = dpi(0)
			network_imagebox.icon:set_image(gears.surface.load_uncached(widget_icon_dir .. "wifi-disconnected.svg"))
			return
		end
		update_network()
	end)

	return network_button
end

return return_button
