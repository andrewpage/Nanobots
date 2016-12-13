-- local NANO = require("config")
local recipe_nano_gun = {
  type = "recipe",
  name = "gun-nano-emitter",
  energy_required = 30,
  ingredients =
  {
    {"copper-plate", 5},
    {"iron-plate", 10},
    {"electronic-circuit", 2},
  },
  result = "gun-nano-emitter"
}

local item_nano_gun = {
  type = "gun",
  name = "gun-nano-emitter",
  icon = "__Nanobots__/graphics/icons/nano-gun.png",
  flags = {"goes-to-main-inventory"},
  subgroup = "tool",
  order = "c[automated-construction]-g[gun-nano-emitter]",
  attack_parameters =
  {
    type = "projectile",
    ammo_category = "nano-ammo",
    cooldown = 30,
    movement_slow_down_factor = 0.0,
    shell_particle = nil,
    -- {
    -- name = "shell-particle",
    -- direction_deviation = 0.1,
    -- speed = 0.1,
    -- speed_deviation = 0.03,
    -- center = {0, 0.1},
    -- creation_distance = -0.5,
    -- starting_frame_speed = 0.4,
    -- starting_frame_speed_deviation = 0.1
    -- },
    projectile_creation_distance = 1.125,
    range = 30,
    sound = {
      filename = "__base__/sound/roboport-door.ogg",
      --filename = "__Nanobots__/sounds/robostep.ogg",
      volume = 0.75

    },
  },
  stack_size = 1
}

local category_nano_gun = {
  type = "ammo-category",
  name = "nano-ammo"
}

data:extend({recipe_nano_gun, item_nano_gun, category_nano_gun})

local effects = data.raw.technology["automated-construction"].effects
effects[#effects + 1] = {type = "unlock-recipe", recipe="gun-nano-emitter"}
--effects[#effects + 1] = {type = "unlock-recipe", recipe="nano-ammo"}
