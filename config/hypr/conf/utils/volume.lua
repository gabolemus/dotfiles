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

local function notify_volume()
	local volume = get_volume()
	NOTIFY(get_volume_icon(volume), string.format("Volume: %d%%", volume))
end

function increase_volume()
	hl.exec_cmd("pamixer -i 2")
	notify_volume()
end

function decrease_volume()
	hl.exec_cmd("pamixer -d 2")
	notify_volume()
end

function toggle_mute()
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

function increase_mic_volume()
	hl.exec_cmd("pamixer --default-source -i 2")
	notify_mic_volume()
end

function decrease_mic_volume()
	hl.exec_cmd("pamixer --default-source -d 2")
	notify_mic_volume()
end

function toggle_mic()
	local muted = CMD_OUTPUT("pamixer --default-source --get-mute")

	if muted == "false" then
		hl.exec_cmd("pamixer --default-source -m")
		NOTIFY(ICON_DIR .. "/microphone-mute.png", "Microphone Switched OFF")
	elseif muted == "true" then
		hl.exec_cmd("pamixer --default-source -u")
		NOTIFY(ICON_DIR .. "/microphone.png", "Microphone Switched ON")
	end
end
