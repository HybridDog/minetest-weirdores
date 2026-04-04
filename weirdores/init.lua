local modpath = minetest.get_modpath("weirdores")
dofile(modpath .. "/ruby.lua")
dofile(modpath .. "/antimese.lua")
dofile(modpath .. "/antigravity.lua")
if minetest.settings:get_bool("weirdores.ruby_legacy_aliases") then
	dofile(modpath .. "/ruby_legacy_aliases.lua")
end
