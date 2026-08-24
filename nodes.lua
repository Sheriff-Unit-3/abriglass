local S = core.get_translator(core.get_current_modname())

-- undecorated coloured glass, all using plain glass texture
abriglass.glass_list = {
	{ "black", S("Darkened"), "292421" },
	{ "blue", S("Blue"), "0000FF" },
	{ "cyan", S("Cyan"), "00FFFF" },
	{ "green", S("Green"), "00FF00" },
	{ "magenta", S("Magenta"), "FF00FF" },
	{ "orange", S("Orange"), "FF6103" },
	{ "purple", S("Purple"), "800080" },
	{ "red", S("Red"), "FF0000" },
	{ "yellow", S("Yellow"), "FFFF00" },
	{ "frosted", S("Frosted"), "FFFFFF" },
}

local palette = "[combine:16x16:"
for k, v in ipairs(abriglass.glass_list) do
	palette = palette .. ":" .. (k - 1) .. ",0=[combine\\:1x1\\^[noalpha\\^[colorize\\:#" .. v[3] .. "\\:255"
end

core.register_node("abriglass:stained_glass_hardware", {
	description = S("Hardware Glass"),
	tiles = { "abriglass_baseglass.png" },
	groups = { cracky = 3 },
	is_ground_content = false,
	use_texture_alpha = "blend",
	sunlight_propagates = true,
	light_source = 4,
	drawtype = "glasslike",
	paramtype = "light",
	paramtype2 = "color",
	palette = palette,
	sounds = default.node_sound_glass_defaults(),
	preserve_metadata = function(pos, oldnode, oldmeta, drops)
		if abriglass.glass_list[oldnode.param2 + 1] then
			drops[1]:get_meta():set_string("description", S("@1 Glass", abriglass.glass_list[oldnode.param2 + 1][1]))
		else
			drops[1]:get_meta():set_string("description", S("Hardware Glass"))
		end
	end,
})

-- boring glass because why not?
core.register_node("abriglass:clear_glass", {
	description = S("Clear Glass"),
	tiles = { "abriglass_clearglass.png" },
	groups = { cracky = 3 },
	is_ground_content = false,
	use_texture_alpha = "blend",
	sunlight_propagates = true,
	paramtype = "light",
	drawtype = "glasslike",
	sounds = default.node_sound_glass_defaults(),
})

-- glass lights
core.register_node("abriglass:glass_light_hardware", {
	description = S("Hardware Glass Light"),
	tiles = { "abriglass_baseglass.png" },
	overlay_tiles = {
		{ name = "abriglass_clearglass.png", color = "white" },
	},
	groups = { cracky = 3 },
	is_ground_content = false,
	use_texture_alpha = "blend",
	sunlight_propagates = true,
	paramtype = "light",
	drawtype = "glasslike",
	paramtype2 = "color",
	palette = palette,
	sounds = default.node_sound_glass_defaults(),
	preserve_metadata = function(pos, oldnode, oldmeta, drops)
		if abriglass.glass_list[oldnode.param2 + 1] then
			drops[1]:get_meta():set_string("description", abriglass.glass_list[oldnode.param2 + 1][1] .. " glass light")
		else
			drops[1]:get_meta():set_string("description", "Hardware Glass Light")
		end
	end,
})

-- patterned glass
local pattern_list = { --{name, description, image}
	{ "stainedglass_tiles_dark", S("Stained Glass"), "stainedglass_tiles1" },
	{ "stainedglass_tiles_pale", S("Stained Glass"), "stainedglass_tiles2" },
	{ "stainedglass_pattern01", S("Stained Glass"), "stainedglass_pattern01" },
	{ "stainedglass_pattern02", S("Cage Glass"), "stainedglass_pattern02" },
	{ "stainedglass_pattern03", S("Stained Glass"), "stainedglass_pattern03" },
	{ "stainedglass_pattern04", S("Stained Glass Cross"), "stainedglass_pattern04" },
	{ "stainedglass_pattern05", S("Stained Glass"), "stainedglass_pattern05" },
}

for i in ipairs(pattern_list) do
	local name = pattern_list[i][1]
	local description = pattern_list[i][2]
	local image = pattern_list[i][3]

	core.register_node("abriglass:" .. name, {
		description = description,
		tiles = { "abriglass_" .. image .. ".png" },
		groups = { cracky = 3 },
		is_ground_content = false,
		use_texture_alpha = "blend",
		sunlight_propagates = true,
		light_source = 5,
		drawtype = "glasslike",
		paramtype = "light",
		paramtype2 = "facedir",
		sounds = default.node_sound_glass_defaults(),
	})
end

-- portholes
local port_list = {
	{ "wood" },
	{ "junglewood" },
}

for i in ipairs(port_list) do
	local name = port_list[i][1]

	core.register_node("abriglass:porthole_" .. name, {
		description = S("Porthole"),
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		node_box = {
			type = "fixed",
			fixed = {
				{ -0.5, -0.5, -0.5, 0.5, 0.5, 0.5 },
			},
		},
		groups = { choppy = 2, flammable = 2, wood = 1 },
		tiles = {
			"default_" .. name .. ".png", -- up
			"default_" .. name .. ".png", -- down
			"default_" .. name .. ".png", -- right
			"default_" .. name .. ".png", -- left
			"abriglass_porthole_" .. name .. ".png", -- back
			"abriglass_porthole_" .. name .. ".png", -- front
		},
		is_ground_content = false,
		sunlight_propagates = true,
		use_texture_alpha = "clip",
	})
end

-- one-way glass
local oneway_list = {
	{ "dark", S("Dark"), "oneway_face.png", "abriglass_oneway_wall.png" },
	{ "pale", S("White"), "oneway_face.png^[colorize:#F8F8FF:200", "abriglass_oneway_wall.png^[colorize:#E6E6FA:200" },
	{ "desert_brick", S("Desert Brick"), "oneway_face.png^[colorize:#814F3C:200", "default_desert_stone_brick.png" },
	{ "stone_brick", S("Stone Brick"), "oneway_face.png^[colorize:#615E5D:200", "default_stone_brick.png" },
	{ "sandstone_brick", S("Sandstone Brick"), "oneway_face.png^[colorize:#FFF9C5:200", "default_sandstone_brick.png" },
}

for i in ipairs(oneway_list) do
	local name = oneway_list[i][1]
	local description = oneway_list[i][2]
	local image1 = oneway_list[i][3]
	local image2 = oneway_list[i][4]

	core.register_node("abriglass:oneway_glass_" .. name, {
		description = S("@1 One-Way Glass", description),
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		node_box = {
			type = "fixed",
			fixed = {
				{ -0.5, -0.5, -0.5, 0.5, 0.5, 0.5 },
			},
		},
		groups = { cracky = 3 },
		tiles = {
			"blank.png", -- up
			"blank.png", -- down
			"blank.png", -- right
			"blank.png", -- left
			"abriglass_" .. image1, -- back
			image2, -- front
		},
		use_texture_alpha = "blend",
		is_ground_content = false,
		sunlight_propagates = true,
		inventory_image = core.inventorycube("abriglass_" .. image1),
	})
end

-- normal nodes to match one-way glass
core.register_node("abriglass:oneway_wall_dark", {
	description = S("Dark Block"),
	tiles = { "abriglass_oneway_wall.png" },
	groups = { cracky = 3 },
	is_ground_content = false,
	paramtype2 = "facedir",
})

core.register_node("abriglass:oneway_wall_pale", {
	description = S("Pale Block"),
	tiles = { "abriglass_oneway_wall.png^[colorize:#E6E6FA:200" },
	groups = { cracky = 3 },
	is_ground_content = false,
	paramtype2 = "facedir",
})

-- crystal, for later use in crafting recipes
core.register_node("abriglass:ghost_crystal", {
	description = S("Ghost Crystal"),
	tiles = { "abriglass_ghost_crystal.png" },
	wield_image = "abriglass_ghost_crystal_wield.png",
	groups = { cracky = 3 },
	is_ground_content = false,
	use_texture_alpha = "blend",
	sunlight_propagates = true,
	light_source = 14,
	drawtype = "glasslike",
	paramtype = "light",
	sounds = default.node_sound_glass_defaults(),
})

if not core.get_modpath("maptools") then
	-- hidden light node
	core.register_node("abriglass:hidden_light", {
		description = S("Hidden Light"),
		tiles = { "blank.png" },
		groups = { cracky = 3, not_in_creative_inventory = 1 },
		is_ground_content = false,
		use_texture_alpha = "blend",
		sunlight_propagates = true,
		walkable = false,
		light_source = 14,
		drawtype = "glasslike",
		paramtype = "light",
		pointable = false,
	})
else
	core.register_alias("abriglass:hidden_light", "maptools:lightbulb")
end
