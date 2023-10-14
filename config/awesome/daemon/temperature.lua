local awful = require("awful")

local script = [[
  sh -c 'sensors | awk "/Core 0/ {gsub(/[+-]/, \"\", \$3); sub(/°C$/, \"\", \$3); print \$3}"'
]]

awful.widget.watch(script, 5, function(widget, stdout)
	stdout = stdout:gsub("\n", "")
	local temp = tonumber(stdout)
	awesome.emit_signal("daemon::cpu-temp", temp)
end)
