local globals = require("conf.utils.globals")

local icons_dir = globals.icons_dir
local cmd_output = globals.cmd_output
local notify = globals.notify

local function get_volume()
	return tonumber(cmd_output("pamixer --get-volume")) or 0
end

local function get_volume_icon(volume)
	if volume == 0 then
		return icons_dir .. "/volume-mute.png"
	elseif volume <= 30 then
		return icons_dir .. "/volume-low.png"
	elseif volume <= 60 then
		return icons_dir .. "/volume-mid.png"
	else
		return icons_dir .. "/volume-high.png"
	end
end

local function change_volume(args)
	local volume = tonumber(cmd_output("pamixer " .. args .. " && pamixer --get-volume")) or 0
	notify(get_volume_icon(volume), string.format("Volume: %d%%", volume))
end

local function increase_volume()
	change_volume("-i 2")
end

local function decrease_volume()
	change_volume("-d 2")
end

local function toggle_mute()
	local muted = cmd_output("pamixer --get-mute")

	if muted == "false" then
		hl.exec_cmd("pamixer -m")
		notify(icons_dir .. "/volume-mute.png", "Volume Switched OFF")
	elseif muted == "true" then
		hl.exec_cmd("pamixer -u")
		notify(get_volume_icon(get_volume()), "Volume Switched ON")
	end
end

local function get_mic_volume()
	return tonumber(cmd_output("pamixer --default-source --get-volume")) or 0
end

local function notify_mic_volume()
	local volume = get_mic_volume()
	notify(icons_dir .. "/microphone.png", string.format("Mic-Level: %d%%", volume))
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
	local muted = cmd_output("pamixer --default-source --get-mute")

	if muted == "false" then
		hl.exec_cmd("pamixer --default-source -m")
		notify(icons_dir .. "/microphone-mute.png", "Microphone Switched OFF")
	elseif muted == "true" then
		hl.exec_cmd("pamixer --default-source -u")
		notify(icons_dir .. "/microphone.png", "Microphone Switched ON")
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
