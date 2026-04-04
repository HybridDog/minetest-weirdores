minetest.register_craftitem("weirdores:ruby", {
	description = "Ruby",
	inventory_image = "weirdores_ruby.png",
})

minetest.register_node("weirdores:stone_with_ruby", {
	description = "Rubies in Stone",
	tiles = {"default_stone.png^weirdores_mineral_ruby.png"},
	groups = {cracky=1},
	drop = "weirdores:ruby",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("weirdores:rubyblock", {
	description = "Ruby Block",
	tiles = {"weirdores_ruby_block.png"},
	groups = {cracky=1,level=2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "weirdores:stone_with_ruby",
	wherein        = "default:stone",
	clust_scarcity = 18*18*18,
	clust_num_ores = 4,
	clust_size     = 3,
	y_min          = -5119,
	y_max          = -1024,
})


minetest.register_ore({
	ore_type       = "scatter",
	ore            = "weirdores:stone_with_ruby",
	wherein        = "default:stone",
	clust_scarcity = 12*12*12,
	clust_num_ores = 4,
	clust_size     = 3,
	y_min          = -31000,
	y_max          = -5120,
})

minetest.register_craft({
	output = 'weirdores:rubyblock',
	recipe = {
		{'weirdores:ruby', 'weirdores:ruby', 'weirdores:ruby'},
		{'weirdores:ruby', 'weirdores:ruby', 'weirdores:ruby'},
		{'weirdores:ruby', 'weirdores:ruby', 'weirdores:ruby'},
	}
})


-- This is for compatibility with the original version of the mod, which was a patch to default game
minetest.register_alias("default:stone_with_ruby","weirdores:stone_with_ruby")
minetest.register_alias("default:ruby","weirdores:ruby")


-- for old versions which were called "ruby"...
minetest.register_alias("ruby:ruby","weirdores:ruby")
minetest.register_alias("ruby:stone_with_ruby","weirdores:stone_with_ruby")
minetest.register_alias("ruby:rubyblock","weirdores:rubyblock")

