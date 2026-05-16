hl.on("hyprland.start", function()
	hl.exec_cmd("/usr/lib/pam_kwallet_init")
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("$HOME/.config/hypr/scripts/set_wallpaper.sh")
	hl.exec_cmd("hypridle &")
	hl.exec_cmd("waybar &")
	-- hl.exec_cmd("mullvad-vpn &")
	hl.exec_cmd("nm-applet --indicator & udiskie -ans")
	hl.exec_cmd("wl-paste --type text --watch cliphist store") -- Stores only text data
	hl.exec_cmd("wl-paste --type image --watch cliphist store") -- Stores only image data
	hl.exec_cmd(
		'/usr/bin/rclone --vfs-cache-mode writes mount \'OneDrive Personal\': "$HOME/OneDrive Personal/" --config "$HOME/.config/rclone/rclone.conf"'
	)
	hl.exec_cmd(
		'/usr/bin/rclone --vfs-cache-mode writes mount \'OneDrive UNIS\': "$HOME/OneDrive UNIS/" --config "$HOME/.config/rclone/rclone.conf"'
	)
	hl.exec_cmd("xrdb -merge ~/.Xresources")
	hl.exec_cmd("elephant")
	hl.exec_cmd("walker --gapplication-service")
end)
