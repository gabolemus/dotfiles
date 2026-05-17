local brightness = require("conf.utils.brightness")
local globals = require("conf.utils.globals")
local mullvad = require("conf.utils.mullvad")
local volume = require("conf.utils.volume")
local wallpaper = require("conf.utils.wallpaper")
local waybar = require("conf.utils.waybar")
local window_opacity = require("conf.utils.window_opacity")

local Utils = {}

-- Globals
Utils.icons_dir = globals.icons_dir
Utils.cmd_output = globals.cmd_output
Utils.notify = globals.notify

-- Volume controls
Utils.vol = {}
Utils.vol.increase_volume = volume.increase_volume
Utils.vol.decrease_volume = volume.decrease_volume
Utils.vol.toggle_mute = volume.toggle_mute
Utils.vol.increase_mic_volume = volume.increase_mic_volume
Utils.vol.decrease_mic_volume = volume.decrease_mic_volume
Utils.vol.toggle_mic = volume.toggle_mic

-- Brightness controls
Utils.brightness = {}
Utils.brightness.increase_brightness = brightness.increase_brightness
Utils.brightness.decrease_brightness = brightness.decrease_brightness

-- Mullvad controls
Utils.vpn = {}
Utils.vpn.toggle = mullvad.toggle

-- Waybar controls
Utils.wallpaper = {}
Utils.wallpaper.set_random = wallpaper.set_wallpaper

-- Waybar controls
Utils.waybar = {}
Utils.waybar.toggle = waybar.toggle
Utils.waybar.reload = waybar.reload

-- Window opacity controls
Utils.window_opacity = {}
Utils.window_opacity.toggle = window_opacity.toggle

return Utils
