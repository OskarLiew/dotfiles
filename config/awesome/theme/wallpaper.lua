local gears = require("gears")
local config_dir = gears.filesystem.get_configuration_dir()

local wallpaper_dir = config_dir .. "theme/wallpapers/"

function RandomWallpaper()
	local wallpaper_files = ReadDirFilenames(wallpaper_dir)

	SeedByDate()
	local random_idx = math.random(#wallpaper_files)
	return wallpaper_dir .. wallpaper_files[random_idx]
end

function ReadDirFilenames(dir)
	local files = {}
	for d in io.popen("ls -pa " .. dir .. " | grep -v /"):lines() do
		files[#files + 1] = d
	end
	return files
end

function SeedByDate()
	local datetime = os.date("*t")
	math.randomseed(datetime.day, datetime.month)
end

return RandomWallpaper()
