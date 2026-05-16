require("conf.utils.globals")

local function get_backlight()
	local cur = tonumber(CMD_OUTPUT("brightnessctl g"))
	local max = tonumber(CMD_OUTPUT("brightnessctl m"))

	if not cur or not max or max == 0 then
		return 0
	end

	return math.floor((cur / max) * 100)
end

local function get_brightness_icon(percent)
	if percent <= 20 then
		return ICON_DIR .. "/brightness-20.png"
	elseif percent <= 40 then
		return ICON_DIR .. "/brightness-40.png"
	elseif percent <= 60 then
		return ICON_DIR .. "/brightness-60.png"
	elseif percent <= 80 then
		return ICON_DIR .. "/brightness-80.png"
	else
		return ICON_DIR .. "/brightness-100.png"
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

function increase_brightness()
	hl.exec_cmd("brightnessctl s +5%")
	notify_brightness()
end

function decrease_brightness()
	hl.exec_cmd("brightnessctl s 5%-")
	notify_brightness()
end
