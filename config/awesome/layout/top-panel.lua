local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local config = require("configuration.widget")

local top_panel = function(s)
	-- Playground
	local offsetx = 2 * beautiful.useless_gap
	local panel_height = dpi(30)
	local bg_opacity = "60"
	local widget_spacing = 0.1 * panel_height
	local widget_margins = 0.1 * panel_height
	local icon_margins = 0.1 * panel_height

	local panel_shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, panel_height / 2)
	end

	-- Create panel
	local panel = wibox({
		visible = true,
		ontop = false,
		screen = s,
		type = "dock",
		height = panel_height,
		width = s.geometry.width - 2 * offsetx,
		x = s.geometry.x + offsetx,
		y = s.geometry.y + beautiful.useless_gap,
		shape = panel_shape,
		stretch = false,
		bg = beautiful.transparent,
	})

	panel:struts({
		top = panel.height + panel.y - beautiful.useless_gap,
	})

	-- Initialize widgets
	local textclock = wibox.widget.textclock()
	local battery = require("widget.battery")()
	local volume = require("widget.volume")()
	local keyboardlayout = require("widget.keyboard-layout")
	local network = require("widget.network")(config.network.wireless_interface)
	local power_button = require("widget.power-button")(icon_margins)
	s.layoutbox = require("widget.layoutbox")(s)
	s.tag_list = require("widget.tag-list")(s, { spacing = widget_spacing, margins = icon_margins })

	s.systray = wibox.widget({
		visible = true,
		base_size = dpi(20),
		horizontal = true,
		screen = "primary",
		widget = wibox.widget.systray,
	})

	-- Create layouts
	local left = {
		{
			{
				s.tag_list,
				widget = wibox.layout.fixed.horizontal,
			},
			widget = wibox.container.margin,
			margins = widget_margins,
		},
		widget = wibox.container.background,
		shape = panel_shape,
		bg = beautiful.bg_normal .. bg_opacity,
	}

	local center = wibox.widget({
		{
			textclock,
			widget = wibox.container.margin,
			left = dpi(18),
			right = dpi(18),
		},
		widget = wibox.container.background,
		shape = panel_shape,
		bg = beautiful.bg_normal .. beautiful.bg_opacity,
	})

	local right_widgets = {
		-- s.systray,
		s.systray,
		network,
		volume,
		battery,
		keyboardlayout,
		s.layoutbox,
	}
	local right_widgets_layout = wibox.widget({
		layout = wibox.layout.fixed.horizontal,
		spacing = widget_spacing,
	})

	for _, w in ipairs(right_widgets) do
		local widget = wibox.widget({
			{
				w,
				widget = wibox.container.margin,
				margins = icon_margins,
			},
			widget = wibox.container.background,
			bg = beautiful.bg_normal .. beautiful.bg_opacity,
			shape = panel_shape,
		})
		right_widgets_layout:add(widget)
	end
	right_widgets_layout:add(power_button)

	local right = {
		{
			right_widgets_layout,
			widget = wibox.container.margin,
			margins = widget_margins,
		},
		widget = wibox.container.background,
		shape = panel_shape,
		bg = beautiful.bg_dim .. bg_opacity,
	}
	panel:setup({
		{
			layout = wibox.layout.align.horizontal,
			expand = "none",
			left,
			center,
			right,
		},
		widget = wibox.container.margin,
	})

	local function set_panel_visible(t)
		local clients = t:clients()
		for _, c in pairs(clients) do
			if c.max or c.first_tag.layout.name == "max" then
				panel.visible = false
			else
				panel.visible = true
			end
		end
	end

	tag.connect_signal("property::layout", set_panel_visible)
	tag.connect_signal("property::selected", function(t)
		if t.selected then
			set_panel_visible(t)
		end
	end)
	awesome.connect_signal("top_panel::toggle", function()
		-- Don't toggle in fullscreen
		if panel.visible then
			panel.visible = false
		else
			set_panel_visible(awful.tag.selected())
		end
	end)

	return panel
end

return top_panel
