------------------
---- MONITORS ----
------------------

require("conf.monitors")

-------------------
---- AUTOSTART ----
-------------------

require("conf.autostart")

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "breeze_cursors")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "breeze_cursors")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-----------------------
---- LOOK AND FEEL ----
-----------------------

require("conf.general")
require("conf.cursor")
require("conf.decoration")

-- TODO: configure the animations
-- TODO: check if the layouts need to be configured

---------------
---- INPUT ----
---------------

require("conf.input")
require("conf.gestures")

-----------------------
----- PERMISSIONS -----
-----------------------

require("conf.permissions")

---------------------
---- KEYBINDINGS ----
---------------------

require("conf.keybindings")

----------------
----  MISC  ----
----------------

hl.config({
	misc = {
		force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
	},
})


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

require("conf.window_rules")
