local awful = require("awful")

local script = [[
  sh -c "playerctl metadata --format 'artist_start{{artist}}title_start{{title}}status_start{{status}}player_start{{playerName}}' --follow"
]]

local function emit_info(stdout)
	local artist = stdout:match("artist_start(.*)title_start")
	local title = stdout:match("title_start(.*)status_start")
	local status = stdout:match("status_start(.*)player_start"):lower()
	local player = stdout:match("player_start(.*)")

	awesome.emit_signal("daemon::playerctl", { artist = artist, title = title, status = status, player = player })
end

-- Kill old playerctl process
awful.spawn.easy_async_with_shell(
	"ps x | grep \"playerctl metadata\" | grep -v grep | awk '{print $1}' | xargs kill",
	function()
		-- Emit song info with each line printed
		awful.spawn.with_line_callback(script, {
			stdout = function(line)
				emit_info(line)
			end,
		})
	end
)

awesome.connect_signal("daemon::playerctl-play-pause", function()
	awful.util.spawn("playerctl play-pause")
end)
awesome.connect_signal("daemon::playerctl-next", function()
	awful.util.spawn("playerctl next")
end)
awesome.connect_signal("daemon::playerctl-previous", function()
	awful.util.spawn("playerctl previous")
end)
