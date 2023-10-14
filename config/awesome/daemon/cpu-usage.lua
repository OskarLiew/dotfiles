local awful = require("awful")

local script = [[
  sh -c "top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\([0-9.]*\)%* id.*/\1/'"
  ]]

awful.widget.watch(script, 5, function(widget, stdout)
	stdout = stdout:gsub("\n", "")
	local cpu = tonumber(stdout)
	awesome.emit_signal("daemon::cpu-usage", 100 - cpu)
end)
