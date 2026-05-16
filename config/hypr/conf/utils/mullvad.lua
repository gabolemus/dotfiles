function toggle_mullvad()
	local handle = io.popen("mullvad status")
	if not handle then
		return
	end

	local first_line = handle:read("*l") or ""
	handle:close()

	local status = first_line:match("^(%S+)")

	if status == "Connected" then
		hl.exec_cmd("mullvad disconnect")
	elseif status == "Disconnected" then
		hl.exec_cmd("mullvad connect")
	else
		hl.exec_cmd("notify-send 'Mullvad' 'Unrecognized status: " .. tostring(status) .. "'")
	end
end
