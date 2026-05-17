local inactive_opacity = hl.get_config("decoration.inactive_opacity")
local dim_inactive = hl.get_config("decoration.dim_inactive")

local function toggle_inactive_opacity()
	if inactive_opacity == 0.85 then
		inactive_opacity = 1.0
	else
		inactive_opacity = 0.85
	end

	dim_inactive = not dim_inactive

	hl.config({
		decoration = {
			inactive_opacity = inactive_opacity,
			-- dim_inactive = dim_inactive,
		},
	})

	hl.exec_cmd(string.format("notify-send 'Hyprland' 'Inactive opacity: %.2f'", inactive_opacity))
end

local M = {}

M.toggle = toggle_inactive_opacity

return M
