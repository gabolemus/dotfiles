require("conf.utils.utils")
-- require("scripts.set_wallpaper")

---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "kitty"
local browser = "brave --disable-features=WaylandWpColorManagerV1"
local fileManager = "nemo"
local menu = "walker"
local menu_windows_provider = " --provider windows"
local displaySettings = "nwg-displays"

local mainMod = "SUPER" -- Sets the "Windows" key as main modifier

---------------------
---- KEYBINDINGS ----
---------------------

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + CTRL + SHIFT + Q", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd(menu .. menu_windows_provider))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(displaySettings))
hl.bind(mainMod .. " + CTRL + SHIFT + F", hl.dsp.exec_cmd("fsearch"))
hl.bind("ALT + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + CTRL + SHIFT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + XF86PowerOff", hl.dsp.exec_cmd("wlogout"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("env LD_PRELOAD=/usr/lib/spotify-adblock.so spotify --uri=%U"))

-- Window Management
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))

-- Clipboard managements
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("walker -m clipboard"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("cliphist wipe"))

-- Change layouts
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.window.pseudo())

-- Helpful scripts
hl.bind(mainMod .. " + V", function()
	toggle_mullvad()
end)
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("mullvad-vpn"))
hl.bind(mainMod .. " + O", function()
	toggle_inactive_opacity()
end)

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Moving windows
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Window resizing                       X  Y
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -50, y = 0 }))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x = 50, y = 0 }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = -50 }))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = 50 }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Keyboard backlight
-- TODO: find out how to do this

-- Volume
hl.bind("XF86AudioRaiseVolume", increase_volume)
hl.bind("XF86AudioLowerVolume", decrease_volume)
hl.bind("XF86AudioMicMute", toggle_mic)
hl.bind("XF86AudioMute", toggle_mute)

-- Screen brightness
hl.bind("XF86MonBrightnessUp", increase_brightness)
hl.bind("XF86MonBrightnessDown", decrease_brightness)

-- Waybar
hl.bind(mainMod .. " + W", TOGGLE_WAYBAR)
hl.bind(mainMod .. " + SHIFT + W", RELOAD_WAYBAR)

-- Hyprpaper (Wallpapers)
-- hl.bind(mainMod .. " + CTRL + SHIFT + W", set_wallpaper)
hl.bind(mainMod .. " + CTRL + SHIFT + W", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/set_wallpaper.sh"))

-- Requires playerctl
-- TODO: replace the keybinds to other keys
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
