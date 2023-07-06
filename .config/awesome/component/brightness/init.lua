local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local slider = require("widget.slider")
local config_dir = gears.filesystem.get_configuration_dir()
local icon_dir = config_dir .. "component/brightness/icons/"
local apps = require("configuration.apps")
local beautiful = require("beautiful")
local naughty = require("naughty")

local brightness_imagebox = wibox.widget({
	nil,
	{
		id = "icon",
		image = icon_dir .. "brightness.svg",
		widget = wibox.widget.imagebox,
		resize = true,
	},
	nil,
	expland = "none",
	layout = wibox.layout.align.vertical,
})

local brightness_slider = slider({
	imagebox = brightness_imagebox,
})

-- Functionality

local function update_brightness()
	-- Sleep to avoid race condition
	awful.spawn.easy_async_with_shell("sleep 0.01 && xbacklight -get", function(stdout)
		stdout = stdout:gsub("\n", "")
		local brightness_percentage = tonumber(stdout)

		-- Stop if null
		if not brightness_percentage then
			return
		end
		local brightness_scaled = math.log(brightness_percentage) / math.log(100)

		brightness_slider.set_value(brightness_scaled * 100)

		-- Set icon
		local icon_name = "brightness"
		if brightness_scaled < 0.33 then
			icon_name = icon_name .. "-low"
		elseif brightness_scaled > 0.66 then
			icon_name = icon_name .. "-high"
		end
		brightness_imagebox.icon:set_image(gears.surface.load_uncached(icon_dir .. icon_name .. ".svg"))

		-- make volume_adjust component visible
		brightness_slider.display()
	end)
end

-- Trigger events
awesome.connect_signal("backlight_change", update_brightness)
