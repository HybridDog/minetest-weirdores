
local antigravities = {}

local is_antigravity = function(pos)
	for _, i in ipairs(antigravities) do
		if  i.x == pos.x
		and i.y < pos.y
		and i.z == pos.z then
			return true
		end
	end
	return false
end

minetest.register_node("weirdores:antigravity",{
	description = "Antigravity",
	tiles = {"weirdores_antigravity.png"},
	groups = {anti=1,level=2},
	sounds = default.node_sound_stone_defaults(),
	on_destruct = function(pos)
		for i, a in ipairs(antigravities) do
			if a.x == pos.x and a.y == pos.y and a.z == pos.z then
				table.remove(antigravities,i)
			end
		end
	end,
})

minetest.register_globalstep(function()
	for _, p in ipairs(minetest.get_connected_players()) do
		local pos = p:get_pos()
		local rpos = {
			x = math.floor(pos.x+.5),
			y = math.floor(pos.y+.5),
			z = math.floor(pos.z+.5)
		}
		if is_antigravity(rpos) then
			p:set_physics_override({gravity = -1})
		else
			p:set_physics_override({gravity = 1})
		end
	end
end)

minetest.register_abm({
	nodenames={"weirdores:antigravity"},
	interval = 5,
	chance = 1,
	action = function(pos)
		minetest.add_particlespawner({
			amount = 100,
			time = 10,
			pos = {
				min = vector.new(pos.x - 0.5, pos.y, pos.z - 0.5),
				max = vector.new(pos.x + 0.5, pos.y, pos.z + 0.5)
			},
			vel = vector.new(0, 20, 0),
			exptime = 10,
			size = {min = 0.1, max = 1},
			collisiondetection = false,
			texture = "weirdores_particle_mese.png",
		})

		if not is_antigravity({x=pos.x, y=pos.y+1, z=pos.z}) then
			table.insert(antigravities,pos)
		end
	end,
})

minetest.register_craft({
	output = 'weirdores:antigravity',
	recipe = {
		{'default:mese_crystal','default:mese_crystal','default:mese_crystal'},
		{'default:mese_crystal','weirdores:antimeseblock','default:mese_crystal'},
		{'default:mese_crystal','default:mese_crystal','default:mese_crystal'},
	}
})

minetest.register_alias("ruby:antigravity","weirdores:antigravity")

