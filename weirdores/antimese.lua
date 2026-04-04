
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
		local r = 2 -- Radius for destroying
		for x = pos.x-r, pos.x+r, 1 do
			for y = pos.y-r, pos.y+r, 1 do
				for z = pos.z-r, pos.z+r, 1 do
					local cpos = {x=x,y=y,z=z}
					if minetest.get_node(cpos).name == "weirdores:rubyblock" then
						local e = minetest.add_item(cpos,{name="weirdores:antimese"})
						e:set_velocity({x=0,y=10,z=0})
					end
					-- The commented part allows to randomly destroy nodes around
					if --[[math.random(0,1) == 1
					or]] minetest.get_node(cpos).name == "weirdores:rubyblock"
					or minetest.get_node(cpos).name == "default:mese" then
						minetest.remove_node(cpos)
					end
				end
			end
		end
	end,
})

-- ALIASES --
-- This is for compatibility with older versions of the mod, "the ruby mod"
minetest.register_alias("ruby:anticrystal","weirdores:antimese")
minetest.register_alias("ruby:anticrystalblock","weirdores:antimeseblock")
minetest.register_alias("ruby:pick_anticrystal", "weirdores:pick_antimese")
minetest.register_alias("ruby:antimese","weirdores:antimese")
minetest.register_alias("ruby:antimeseblock","weirdores:antimeseblock")
minetest.register_alias("ruby:pick_antimese", "weirdores:pick_antimese")

