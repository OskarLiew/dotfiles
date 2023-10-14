local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- {{{ Titlebars
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	-- buttons for the titlebar
	local buttons = {
		awful.button({}, 1, function()
			c:activate({ context = "titlebar", action = "mouse_move" })
		end),
		awful.button({}, 3, function()
			c:activate({ context = "titlebar", action = "mouse_resize" })
		end),
	}

	local function titlebar_button(w, kind)
		local bg_normal = beautiful.bg1
		local bg = bg_normal
		if kind then
			bg = beautiful["titlebar_color_" .. kind .. "_bg"]
		end
		local button = wibox.widget({
			{
				w,
				widget = wibox.container.margin,
				margins = dpi(3),
			},
			widget = wibox.container.background,
			shape = gears.shape.circle,
			bg = bg_normal,
		})
		c:connect_signal("focus", function()
			button.bg = bg
		end)
		c:connect_signal("unfocus", function()
			button.bg = bg_normal
		end)
		return button
	end

	awful.titlebar(c).widget = {
		{
			{ -- Left
				awful.titlebar.widget.iconwidget(c),
				buttons = buttons,
				layout = wibox.layout.fixed.horizontal,
			},
			{ -- Middle
				{ -- Title
					halign = "center",
					widget = awful.titlebar.widget.titlewidget(c),
				},
				buttons = buttons,
				layout = wibox.layout.flex.horizontal,
			},
			{ -- Right
				titlebar_button(awful.titlebar.widget.floatingbutton(c), "float"),
				titlebar_button(awful.titlebar.widget.maximizedbutton(c), "max"),
				titlebar_button(awful.titlebar.widget.ontopbutton(c), "on_top"),
				titlebar_button(awful.titlebar.widget.closebutton(c), "close"),
				layout = wibox.layout.fixed.horizontal,
				spacing = dpi(4),
			},
			layout = wibox.layout.align.horizontal,
		},
		widget = wibox.container.margin,
		top = dpi(3),
		bottom = dpi(3),
		left = dpi(10),
		right = dpi(10),
	}
end)
-- }}}

-- Titlebars only for floating windows

client.connect_signal("property::floating", function(c)
	local layout_name = nil
	if c.first_tag then
		layout_name = c.first_tag.layout.name
	end
	if c.floating or layout_name == "floating" then
		awful.titlebar.show(c)
	else
		awful.titlebar.hide(c)
	end
end)

client.connect_signal("manage", function(c)
	if c.floating or c.first_tag.layout.name == "floating" then
		awful.titlebar.show(c)
	else
		awful.titlebar.hide(c)
	end
end)

tag.connect_signal("property::layout", function(t)
	local clients = t:clients()
	for _, c in pairs(clients) do
		if c.floating or c.first_tag.layout.name == "floating" then
			awful.titlebar.show(c)
		else
			awful.titlebar.hide(c)
		end
	end
end)
