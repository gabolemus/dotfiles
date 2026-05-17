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

require("conf.misc")

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

require("conf.window_rules")
