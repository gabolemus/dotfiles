require("conf.utils.globals")

local function get_volume()
	return tonumber(CMD_OUTPUT("pamixer --get-volume")) or 0
end

local function get_volume_icon(volume)
	if volume == 0 then
		return ICON_DIR .. "/volume-mute.png"
	elseif volume <= 30 then
		return ICON_DIR .. "/volume-low.png"
	elseif volume <= 60 then
		return ICON_DIR .. "/volume-mid.png"
	else
		return ICON_DIR .. "/volume-high.png"
	end
end

local function change_volume(args)
	local volume = tonumber(CMD_OUTPUT("pamixer " .. args .. " && pamixer --get-volume")) or 0
	NOTIFY(get_volume_icon(volume), string.format("Volume: %d%%", volume))
end

local function increase_volume()
	change_volume("-i 2")
end

local function decrease_volume()
	change_volume("-d 2")
end

local function toggle_mute()
	local muted = CMD_OUTPUT("pamixer --get-mute")

	if muted == "false" then
		hl.exec_cmd("pamixer -m")
		NOTIFY(ICON_DIR .. "/volume-mute.png", "Volume Switched OFF")
	elseif muted == "true" then
		hl.exec_cmd("pamixer -u")
		NOTIFY(get_volume_icon(get_volume()), "Volume Switched ON")
	end
end

local function get_mic_volume()
	return tonumber(CMD_OUTPUT("pamixer --default-source --get-volume")) or 0
end

local function notify_mic_volume()
	local volume = get_mic_volume()
	NOTIFY(ICON_DIR .. "/microphone.png", string.format("Mic-Level: %d%%", volume))
end

local function increase_mic_volume()
	hl.exec_cmd("pamixer --default-source -i 2")
	notify_mic_volume()
end

local function decrease_mic_volume()
	hl.exec_cmd("pamixer --default-source -d 2")
	notify_mic_volume()
end

local function toggle_mic()
	local muted = CMD_OUTPUT("pamixer --default-source --get-mute")

	if muted == "false" then
		hl.exec_cmd("pamixer --default-source -m")
		NOTIFY(ICON_DIR .. "/microphone-mute.png", "Microphone Switched OFF")
	elseif muted == "true" then
		hl.exec_cmd("pamixer --default-source -u")
		NOTIFY(ICON_DIR .. "/microphone.png", "Microphone Switched ON")
	end
end

local M = {}

M.increase_volume = increase_volume
M.decrease_volume = decrease_volume
M.toggle_mute = toggle_mute
M.increase_mic_volume = increase_mic_volume
M.decrease_mic_volume = decrease_mic_volume
M.toggle_mic = toggle_mic

return M
