local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

function init_sidebar(s)
	sidebar_shape = function(cr, width, height)
		return gears.shape.partially_rounded_rect(
			cr,
			width,
			height,
			false,
			true,
			false,
			false,
			2 * beautiful.edge_radius
		)
	end

	-- Create panel
	local top_margin = dpi(20)
	local panel = wibox({
		visible = false,
		ontop = true,
		type = "normal",
		height = s.tiling_area.height,
		width = s.geometry.width / 4,
		x = 0,
		y = s.geometry.height - s.tiling_area.height + 2 * beautiful.useless_gap,
		shape = sidebar_shape,
		stretch = false,
		bg = beautiful.bg_dim .. "AA",
		fg = beautiful.fg_normal,
	})

	-- Define widgets
	local big_clock = wibox.widget({
		{
			layout = wibox.layout.fixed.vertical,
			{
				format = "%H:%M",
				align = "center",
				font = "Inter 88",
				widget = wibox.widget.textclock,
			},
			{
				format = "%A, %B %d",
				align = "center",
				font = "Inter 24",
				widget = wibox.widget.textclock,
			},
		},
		top = dpi(10),
		widget = wibox.container.margin,
	})

	local hardware = wibox.widget({
		require("widget.hardware-bar")("temp"),
		require("widget.hardware-bar")("ram"),
		require("widget.hardware-bar")("cpu"),
		widget = wibox.layout.fixed.vertical,
	})

	local uptime_textbox = wibox.widget({
		text = " ",
		widget = wibox.widget.textbox,
		halign = "center",
		font = "Inter 16",
	})

	awful.widget.watch([[sh -c "uptime -p | sed -e 's/up //g'"]], 60, function(widget, stdout)
		stdout = stdout:gsub("\n", "")
		uptime_textbox.text = stdout
	end)

	local power_button = wibox.widget({
		{
			{
				require("widget.power-button")(),
				uptime_textbox,
				layout = wibox.layout.align.horizontal,
				spacing = dpi(10),
			},
			widget = wibox.container.margin,
			margins = dpi(10),
		},
		widget = wibox.container.background,
		bg = beautiful.bg_popup .. "90",
		shape = function(cr, w, h)
			gears.shape.rounded_rect(cr, w, h, dpi(40))
		end,
		forced_height = dpi(80),
	})

	local widgets = wibox.widget({
		{
			hardware,
			require("widget.music-player")(),
			require("widget.weather")(),
			layout = wibox.layout.fixed.vertical,
			spacing = dpi(60),
		},
		nil,
		power_button,
		layout = wibox.layout.align.vertical,
	})

	local widget_area = wibox.widget({
		{
			widgets,
			widget = wibox.container.margin,
			left = dpi(40),
			right = dpi(40),
			top = dpi(40),
			bottom = dpi(40),
		},
		bg = beautiful.bg_dim .. "90",
		shape = sidebar_shape,
		widget = wibox.container.background,
		forced_height = s.tiling_area.height * 0.77, -- A better way to do this?
	})

	panel:setup({
		{
			layout = wibox.layout.fixed.vertical,
			spacing = dpi(30),
			big_clock,
			widget_area,
		},
		top = 20,
		widget = wibox.container.margin,
	})
	return panel
end

return init_sidebar
