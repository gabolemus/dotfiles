local icons_dir = os.getenv("HOME") .. "/.config/mako/icons"

local function cmd_output(cmd)
	local handle = io.popen(cmd)
	if not handle then
		return nil
	end

	local result = handle:read("*l")
	handle:close()

	return result
end

local function notify(icon, message)
	hl.exec_cmd(
		string.format(
			"notify-send -t 5000 -h string:x-canonical-private-synchronous:sys-notify -u low -i %q %q",
			icon,
			message
		)
	)
end

local M = {}

M.icons_dir = icons_dir
M.cmd_output = cmd_output
M.notify = notify

return M
