local function is_waybar_running()
	local handle = io.popen("pgrep -x waybar")

	if not handle then
		return false
	end

	local result = handle:read("*a")
	handle:close()

	return result ~= nil and result ~= ""
end

local function toggle_waybar()
	if is_waybar_running() then
		os.execute("pkill -SIGUSR1 waybar")
	else
		hl.exec_cmd("waybar")
	end
end

local function reload_waybar()
	os.execute("pkill -SIGUSR2 waybar")
end

local M = {}

M.toggle = toggle_waybar
M.reload = reload_waybar

return M
