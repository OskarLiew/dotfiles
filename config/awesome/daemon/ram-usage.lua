local awful = require("awful")

local script = [[
  sh -c "free | awk '/Mem:/ {usage = (\$3 / \$2) * 100; printf usage}'"]]

awful.widget.watch(script, 5, function(widget, stdout)
	stdout = stdout:gsub("\n", "")
	local ram = tonumber(stdout)
	awesome.emit_signal("daemon::ram-usage", ram)
end)
