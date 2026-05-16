ICON_DIR = os.getenv("HOME") .. "/.config/mako/icons"

function CMD_OUTPUT(cmd)
	local handle = io.popen(cmd)
	if not handle then
		return nil
	end

	local result = handle:read("*l")
	handle:close()

	return result
end

function NOTIFY(icon, message)
	hl.exec_cmd(
		string.format(
			"notify-send -t 5000 -h string:x-canonical-private-synchronous:sys-notify -u low -i %q %q",
			icon,
			message
		)
	)
end
