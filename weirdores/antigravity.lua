-- List of antigravity node positions
local antigravities = {}
-- Sparse mapping from (x, z) to the lowest antigravity nodes' y position
local antigravity_map = {}

-- Check if there is antigravity at pos
local function is_antigravity(pos)
	local vi = (pos.z + 0x8000) * 0x10000 + (pos.x + 0x8000)
	return antigravity_map[vi] and antigravity_map[vi] < pos.y
end

-- Idempotently register an antigravity node for is_antigravity()
local function register_antigravity(pos)
	local vi = (pos.z + 0x8000) * 0x10000 + (pos.x + 0x8000)
	if not antigravity_map[vi] then
		-- A single new antigravity node at the xz position
		antigravity_map[vi] = pos.y
		antigravities[#antigravities+1] = pos
		return
	end
	-- Multiple antigravity nodes are in the same line at xz or we are already
	-- registered.
	antigravity_map[vi] = math.min(antigravity_map[vi], pos.y)
	for i = 1,#antigravities do
		if antigravities[i].y == pos.y then
			return
		end
	end
	antigravities[#antigravities+1] = pos
end

-- Idempotently unregister an antigravity node for is_antigravity()
local function unregister_antigravity(pos)
	local vi = (pos.z + 0x8000) * 0x10000 + (pos.x + 0x8000)
	if not antigravity_map[vi] then
		return
	end
	local new_min_y
	local i_toremove
	for i = 1,#antigravities do
		local pos_other = antigravities[i]
		if pos_other.x == pos.x and pos_other.z == pos.z then
			if pos_other.y == pos.y then
				i_toremove = i
			else
				new_min_y = new_min_y and math.min(new_min_y, pos_other.y) or
					pos_other.y
			end
		end
	end
	antigravity_map[vi] = new_min_y
	if i_toremove then
		antigravities[i_toremove] = antigravities[#antigravities]
		antigravities[#antigravities] = nil
	end
end

minetest.register_node("weirdores:antigravity",{
	description = "Antigravity",
	tiles = {"weirdores_antigravity.png"},
	groups = {anti=1,level=2},
	sounds = default.node_sound_stone_defaults(),
	on_construct = register_antigravity,
	on_destruct = unregister_antigravity,
})

-- A mapping from player name to the gravity of the player before they've
-- entered the antigravity
local antigravity_players = {}
minetest.register_globalstep(function()
	for _, p in ipairs(minetest.get_connected_players()) do
		local pos = p:get_pos()
		local rpos = vector.new(
			math.floor(pos.x + 0.5),
			math.floor(pos.y + 0.5),
			math.floor(pos.z + 0.5)
		)
		local pname = p:get_player_name()
		if is_antigravity(rpos) then
			local current_gravity = p:get_physics_override().gravity or 1
			if current_gravity ~= -1 then
				antigravity_players[pname] = current_gravity
				p:set_physics_override({gravity = -1})
			end
		elseif antigravity_players[pname] then
			p:set_physics_override({gravity = antigravity_players[pname]})
			antigravity_players[pname] = nil
		end
	end
end)

minetest.register_on_leaveplayer(function(player)
	antigravity_players[player:get_player_name()] = nil
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
	end,
})

minetest.register_lbm({
	name = "weirdores:register_antigravity_nodes",
	nodenames = {"weirdores:antigravity"},
	run_at_every_load = true,
	bulk_action = function(pos_list)
		for i = 1,#pos_list do
			register_antigravity(pos_list[i])
		end
	end
})

minetest.register_craft({
	output = 'weirdores:antigravity',
	recipe = {
		{'default:mese_crystal','default:mese_crystal','default:mese_crystal'},
		{'default:mese_crystal','weirdores:antimeseblock','default:mese_crystal'},
		{'default:mese_crystal','default:mese_crystal','default:mese_crystal'},
	}
})
