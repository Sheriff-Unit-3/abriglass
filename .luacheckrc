unused_args = false
allow_defined_top = true

globals = {
  "abriglass",
}

read_globals = {
  -- Luanti
  "minetest", "core",
  "vector", "ItemStack",
  "dump", "DIR_DELIM",
  "VoxelArea", "Settings",
  "PcgRandom", "VoxelManip",
  "PseudoRandom",
  string = {fields = {"split"}},
  table = {fields = {"copy", "getn"}},

  -- Dependencies
  "default",
}