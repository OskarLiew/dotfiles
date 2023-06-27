local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")
local task_list = require("widget.task-list")

local top_panel = function(s)
	-- Playground
	local offsetx = dpi(45)
	local panel_height = dpi(22)

	-- Create panel
	local panel = wibox({
		ontop = true,
		screen = s,
		type = "dock",
		height = panel_height,
		width = s.geometry.width - 2 * offsetx,
		x = s.geometry.x + offsetx,
		y = s.geometry.y + 0.2 * panel_height,
		stretch = false,
		bg = beautiful.background,
		fg = beautiful.fg_normal,
	})

	panel:struts({
		top = panel_height,
	})

	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = {
			awful.button({}, 1, function(t)
				t:view_only()
			end),
			awful.button({ modkey }, 1, function(t)
				if client.focus then
					client.focus:move_to_tag(t)
				end
			end),
			awful.button({}, 3, awful.tag.viewtoggle),
			awful.button({ modkey }, 3, function(t)
				if client.focus then
					client.focus:toggle_tag(t)
				end
			end),
			awful.button({}, 4, function(t)
				awful.tag.viewprev(t.screen)
			end),
			awful.button({}, 5, function(t)
				awful.tag.viewnext(t.screen)
			end),
		},
	})

	-- Initialize widgets
	s.battery = require("widget.battery")()
	s.keyboardlayout = awful.widget.keyboardlayout()
	local textclock = wibox.widget.textclock()
	-- we need one layoutbox per screen.
	s.layoutbox = require("widget.layoutbox")(s)

	s.systray = wibox.widget({
		visible = false,
		base_size = dpi(20),
		horizontal = true,
		screen = "primary",
		widget = wibox.widget.systray,
	})

	panel:setup({
		layout = wibox.layout.align.horizontal,
		expand = "none",
		{
			layout = wibox.layout.fixed.horizontal,
			task_list(s),
		},
		textclock,
		{
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(5),
			{
				s.systray,
				margins = dpi(5),
				widget = wibox.container.margin,
			},
			s.battery,
			s.keyboardlayout,
			s.layoutbox,
		},
		textclock,
	})
	return panel
end

return top_panel
