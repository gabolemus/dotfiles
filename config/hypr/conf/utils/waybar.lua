local function is_waybar_running()
	local handle = io.popen("pgrep -x waybar")

	if not handle then
		return false
	end

	local result = handle:read("*a")
	handle:close()

	return result ~= nil and result ~= ""
end

function TOGGLE_WAYBAR()
	if is_waybar_running() then
		os.execute("pkill -SIGUSR1 waybar")
	else
		hl.exec_cmd("waybar")
	end
end

function RELOAD_WAYBAR()
	os.execute("pkill -SIGUSR2 waybar")
end
