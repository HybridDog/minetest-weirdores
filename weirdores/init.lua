-- Configuration
-- Remove the modules you do not want to load
local MODULES = {
	"ruby",
	"antimese",
	"antigravity",
}

-- End of configuration

local MODPATH = minetest.get_modpath("weirdores")
for i, m in ipairs(MODULES) do
	dofile(MODPATH.."/"..m..".lua")
end
