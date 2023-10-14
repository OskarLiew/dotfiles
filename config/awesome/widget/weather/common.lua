local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

local icon_dir = require("helpers.widget").get_icon_dir("weather")
local init_icon = require("helpers.icon").init_icon
local read_file = require("helpers.io").read_file

local config = require("configuration.widget").weather
local token = read_file(config.api_key_path)
if token == nil then
	naughty.notification({
		title = "Error in the weather widget",
		message = "API key path at " .. config.api_key_path .. " not found.",
		urgency = "critical",
	})
	token = ""
else
	token = token:gsub("\n", "")
end

local json = require("cjson")

local function convert_temp(degrees_k)
	local degrees_c = tonumber(degrees_k) - 273.15
	return string.format("%.0f", degrees_c) .. "°"
end

local function get_weather_icon(icon_code)
	local mapping = {
		["01d"] = "sun.svg",
		["01n"] = "moon.svg",
		["02d"] = "sunny.svg",
		["02n"] = "cloudy-night.svg",
		["03d"] = "cloudy.svg",
		["03n"] = "cloudy-night.svg",
		["04d"] = "cloud.svg",
		["04n"] = "cloud-dark.svg",
		["09d"] = "light-rain.svg",
		["09n"] = "light-rain-dark.svg",
		["10d"] = "heavy-rain.svg",
		["10n"] = "heavy-rain-dark.svg",
		["11d"] = "thunderstorm.svg",
		["11n"] = "thunderstorm-dark.svg",
		["13d"] = "snow.svg",
		["13n"] = "snow-dark.svg",
		["50d"] = "fog.svg",
		["50n"] = "fog-dark.svg",
	}
	return icon_dir .. mapping[icon_code]
end

local function init_weather_imagebox(size)
	local icon_stylesheet = ""
		.. ".sun { stroke:"
		.. beautiful.yellow
		.. "; fill:"
		.. beautiful.yellow
		.. ";} "
		.. ".moon { stroke:"
		.. beautiful.blue
		.. "; fill:"
		.. beautiful.blue
		.. ";} "
		.. ".cloud { stroke:"
		.. beautiful.fg
		.. ";}"
		.. ".cloud-dark { stroke:"
		.. beautiful.gray2
		.. ";}"
		.. ".lightning { stroke:"
		.. beautiful.yellow
		.. ";}"
		.. ".fog { stroke:"
		.. beautiful.blue
		.. ";}"
		.. ".snow { stroke:"
		.. beautiful.blue
		.. ";}"
		.. ".rain {stroke:"
		.. beautiful.blue
		.. ";}"
		.. ".error {stroke:"
		.. beautiful.red
		.. ";}"
	local weather_icon = init_icon(icon_dir .. "error.svg", size)
	weather_icon.stylesheet = icon_stylesheet
	return weather_icon
end

return {
	init_weather_imagebox = init_weather_imagebox,
	get_weather_icon = get_weather_icon,
	convert_temp = convert_temp,
	token = token,
	config = config,
}
