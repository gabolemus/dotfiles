local globals = require("conf.utils.globals")

local cmd_output = globals.cmd_output
local icons_dir = globals.icons_dir

local function round_to(value, step)
	return math.floor((value / step) + 0.5) * step
end

local function get_backlight()
	local cur = tonumber(cmd_output("brightnessctl g"))
	local max = tonumber(cmd_output("brightnessctl m"))

	if not cur or not max or max == 0 then
		return 0
	end

	local percent = (cur / max) * 100

	return round_to(percent, 5)
end

local function get_brightness_icon(percent)
	if percent <= 20 then
		return icons_dir .. "/brightness-20.png"
	elseif percent <= 40 then
		return icons_dir .. "/brightness-40.png"
	elseif percent <= 60 then
		return icons_dir .. "/brightness-60.png"
	elseif percent <= 80 then
		return icons_dir .. "/brightness-80.png"
	else
		return icons_dir .. "/brightness-100.png"
	end
end

local function notify_brightness()
	local percent = get_backlight()
	local icon = get_brightness_icon(percent)

	hl.exec_cmd(
		string.format(
			"notify-send -t 5000 -h string:x-canonical-private-synchronous:sys-notify -u low -i %q 'Brightness: %d%%'",
			icon,
			percent
		)
	)
end

local function increase_brightness()
	os.execute("brightnessctl s +5%")
	notify_brightness()
end

local function decrease_brightness()
	os.execute("brightnessctl s 5%-")
	notify_brightness()
end

local M = {}

M.increase_brightness = increase_brightness
M.decrease_brightness = decrease_brightness

return M
