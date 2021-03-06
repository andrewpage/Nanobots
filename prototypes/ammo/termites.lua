local constants = require("constants")

local recipe = {
    type = "recipe",
    name = "ammo-nano-termites",
    enabled = false,
    energy_required = 5,
    ingredients =
    {
        {"iron-axe", 1},
        {"electronic-circuit", 1}
    },
    result = "ammo-nano-termites"
}

-------------------------------------------------------------------------------
local termites = {
    type = "ammo",
    name = "ammo-nano-termites",
    icon = "__Nanobots__/graphics/icons/nano-ammo-termites.png",
    flags = {"goes-to-main-inventory"},
    magazine_size = 10,
    subgroup = "tool",
    order = "c[automated-construction]-g[gun-nano-emitter]-termites",
    stack_size = 100,
    ammo_type =
    {
        category = "nano-ammo",
        target_type = "position",
        action =
        {
            type = "direct",
            action_delivery =
            {
                type = "instant",
                target_effects =
                {
                    {
                        type = "create-entity",
                        entity_name = "nano-cloud-big-termites",
                        trigger_created_entity=true
                    },
                }
            }
        }
    },
}

-------------------------------------------------------------------------------
--cloud-big is for the gun, cloud-small is for the individual item.
local cloud_big_termites = {
    type = "smoke-with-trigger",
    name = "nano-cloud-big-termites",
    flags = {"not-on-map"},
    show_when_smoke_off = true,
    animation = constants.cloud_animation(4),
    slow_down_factor = 0,
    affected_by_wind = false,
    cyclic = true,
    duration = 60*2,
    fade_away_duration = 60,
    spread_duration = 10,
    color = Color.set(defines.colors.lightgreen, .35),
    action_frequency = 60,
    action =
    {
        type = "direct",
        action_delivery =
        {
            type = "instant",
            source_effects = {
                {
                    type = "play-sound",
                    sound = {
                        filename = "__Nanobots__/sounds/robostep.ogg",
                        volume = 0.75
                    },
                },
            },
        }
    },
}
cloud_big_termites.animation.scale = 4

-------------------------------------------------------------------------------
local cloud_small_termites = {
    type = "smoke-with-trigger",
    name = "nano-cloud-small-termites",
    flags = {"not-on-map"},
    show_when_smoke_off = true,
    animation = constants.cloud_animation(.4),
    slow_down_factor = 0,
    affected_by_wind = false,
    cyclic = true,
    duration = 60*10,
    fade_away_duration = 2*60,
    spread_duration = 10,
    color = Color.set(defines.colors.lightgreen, .35),
    action_frequency = 30,
    action =
    {
        type = "direct",
        action_delivery =
        {
            type = "instant",
            target_effects =
            {
                {
                    type = "nested-result",
                    action =
                    {
                        type = "area",
                        perimeter = .75,
                        force="all",
                        entity_flags = {"placeable-neutral"},
                        action_delivery =
                        {
                            type = "instant",
                            target_effects =
                            {
                                type = "damage",
                                damage = { amount = 4, type = "poison"}
                            }
                        }
                    },
                },
            }
        }
    },
}

-------------------------------------------------------------------------------
local projectile_termites = {
    type = "projectile",
    name = "nano-projectile-termites",
    flags = {"not-on-map"},
    acceleration = -0.005,
    direction_only = false,
    animation = constants.projectile_animation,
    action = nil,
    final_action =
    {
        type = "direct",
        action_delivery =
        {
            type = "instant",
            target_effects =
            {
                {
                    type = "create-entity",
                    entity_name = "nano-cloud-small-termites",
                    check_buildability = false
                },
                {
                    type = "create-entity",
                    entity_name = "nano-proxy-health",
                    check_buildability = false,
                },
            }
        }
    },
}

-------------------------------------------------------------------------------
data:extend({recipe, termites, cloud_big_termites, cloud_small_termites, projectile_termites})

local effects = data.raw.technology["automated-construction"].effects
effects[#effects + 1] = {type = "unlock-recipe", recipe="ammo-nano-termites"}
