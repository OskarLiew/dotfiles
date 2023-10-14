local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful").xresources.apply_dpi
local clickable_container = require("widget.clickable-container")
local gears = require("gears")

local function init_tag_list(s, custom_style)
	local bg_opacity = custom_style.bg_opacity or beautiful.bg_opacity
	local style = {
		shape = gears.shape.circle,
		fg_focus = beautiful.fg_focus,
		bg_focus = beautiful.green .. bg_opacity,
		fg_empty = beautiful.fg_inactive,
		bg_empty = beautiful.bg_normal .. bg_opacity,
		fg_urgent = beautiful.bg_urgent,
		bg_urgent = beautiful.fg_urgent .. bg_opacity,
		fg_occupied = beautiful.fg_normal,
		bg_occupied = beautiful.bg_normal .. bg_opacity,
	}

	local function new_tag_icon(tag)
		local color = style.fg_empty
		if tag.selected then
			color = style.fg_focus
		elseif #tag:clients() > 0 then
			color = style.fg_occupied
		end
		return gears.color.recolor_image(tag.icon, color)
	end

	local taglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		style = style,
		layout = {
			spacing = custom_style.spacing or dpi(4),
			layout = wibox.layout.fixed.horizontal,
		},
		widget_template = {
			{
				{
					{
						id = "icon_role",
						widget = wibox.widget.imagebox,
					},
					widget = wibox.container.margin,
					margins = custom_style.margins or dpi(4),
				},
				widget = clickable_container,
			},
			id = "background_role",
			widget = wibox.container.background,
			-- Add support for tag colors and click to change
			create_callback = function(self, tag, index, tags) --luacheck: no unused args
				tag.icon = new_tag_icon(tag)

				tag:connect_signal("property::selected", function(selected)
					tag.icon = new_tag_icon(tag)
				end)

				tag:connect_signal("property::urgent", function(urgent)
					if tag.selected then
						tag.icon = new_tag_icon(tag)
					elseif urgent then
						tag.icon = gears.color.recolor_image(tag.icon, style.fg_urgent)
					end
				end)

				tag:connect_signal("tagged", function()
					tag.icon = new_tag_icon(tag)
				end)

				tag:connect_signal("untagged", function()
					tag.icon = new_tag_icon(tag)
				end)

				self:connect_signal("button::press", function()
					tags[index]:view_only()
				end)
			end,
			update_callback = function(self, tag, index, tags) --luacheck: no unused args
				self:get_children_by_id("icon_role")[1].image = "/home/oskar/awesome/theme/icons/code.svg"
				-- self:get_children_by_id("index_role")[1].markup = "<b> "..c3.index.." </b>"
			end,
		},
		buttons = taglist_buttons,
	})

	return taglist
end

return init_tag_list
