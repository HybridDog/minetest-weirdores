
-- ITEMS --

minetest.register_craftitem("weirdores:antimese", {
	description = "Antimese Crystal",
	inventory_image = "weirdores_antimese.png",
})

minetest.register_node("weirdores:antimeseblock", {
	description = "Antimese Block",
	tiles = {"weirdores_antimese_block.png"},
	groups = {anti=1,level=2},
	sounds = default.node_sound_stone_defaults(),
})


local APS = 0.25 -- Antimese Pickaxe Speed
local APU = 100 -- Antimese Pickaxe Uses

minetest.register_tool("weirdores:pick_antimese", {
	description = "Antimese Pickaxe",
	inventory_image = "weirdores_tool_antimesepick.png",
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level=3,
		groupcaps={
			cracky = {times={[1]=APS, [2]=APS, [3]=APS}, uses=APU, maxlevel=3},
			choppy={times={[1]=APS, [2]=APS, [3]=APS}, uses=APU, maxlevel=3},
			crumbly = {times={[1]=APS, [2]=APS, [3]=APS}, uses=APU, maxlevel=3},
			snappy={times={[1]=APS, [2]=APS, [3]=APS}, uses=APU, maxlevel=3},
			anti={times={[1]=APS*5, [2]=APS*5, [3]=APS*5}, uses=APU, maxlevel=3},
		},
		damage_groups = {fleshy=7},
	},
})

-- CRAFTING --

minetest.register_craft({
	output = 'weirdores:pick_antimese',
	recipe = {
		{'weirdores:antimese', 'weirdores:antimese', 'weirdores:antimese'},
		{'', 'default:stick', ''},
		{'', 'default:stick', ''},
	}
})

minetest.register_craft({
	output = 'weirdores:antimeseblock',
	recipe = {
		{'weirdores:antimese', 'weirdores:antimese', 'weirdores:antimese'},
		{'weirdores:antimese', 'weirdores:antimese', 'weirdores:antimese'},
		{'weirdores:antimese', 'weirdores:antimese', 'weirdores:antimese'},
	}
})

-- ABM --

-- Ruby block + Mese block --> Antimese
minetest.register_abm({
	nodenames={"default:mese"},
	neighbors={"weirdores:rubyblock"},
	interval = 5.0,
	chance = 5,
	action = function(pos)
		minetest.add_particlespawner({
			amount = 10,
			time = 1,
			pos = pos,
			vel = {
				min = vector.new(-10, -10, -10),
				max = vector.new(10, 10, 10)
			},
			acc = {
				min = vector.new(-100, -100, -100),
				max = vector.new(100, 100, 10)
			},
			exptime = 1,
			size = {min = 0.1, max = 10},
			collisiondetection = false,
			texture = "weirdores_particle_ruby.png",
		})
		minetest.add_particlespawner({
			amount = 100,
			time = 1,
			pos = pos,
			vel = {
				min = vector.new(-10, -10, -10),
				max = vector.new(10, 10, 10)
			},
			acc = {
				min = vector.new(-100, -100, -100),
				max = vector.new(100, 100, 100)
			},
			exptime = 1,
			size = {min = 0.1, max = 10},
			collisiondetection = false,
			texture = "weirdores_particle_mese.png",
		})
		local destroy_radius = 2
		local nodes_in_area = minetest.find_nodes_in_area(
			vector.subtract(pos, destroy_radius),
			vector.add(pos, destroy_radius),
			{"weirdores:rubyblock", "default:mese"},
			true
		)
		for _, cpos in ipairs(nodes_in_area["weirdores:rubyblock"]) do
			minetest.add_item(cpos, {name="weirdores:antimese"})
				:set_velocity(vector.new(0, 10, 0))
		end
		for _, positions in pairs(nodes_in_area) do
			minetest.bulk_set_node(positions, {name="air"})
		end
	end,
})
