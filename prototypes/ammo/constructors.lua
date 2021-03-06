local constants = require("constants")

local recipe = {
    type = "recipe",
    name = "ammo-nano-constructors",
    enabled = false,
    energy_required = 5,
    ingredients =
    {
        {"copper-plate", 5},
        {"electronic-circuit", 1},
        {"repair-pack", 1}
    },
    result = "ammo-nano-constructors"
}

-------------------------------------------------------------------------------
local constructors = {
    type = "ammo",
    name = "ammo-nano-constructors",
    icon="__Nanobots__/graphics/icons/nano-ammo-constructors.png",
    flags = {"goes-to-main-inventory"},
    magazine_size = 10,
    subgroup = "tool",
    order = "c[automated-construction]-g[gun-nano-emitter]-constructors",
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
                        entity_name = "nano-cloud-big-constructors",
                        trigger_created_entity=false
                    },
                }
            }
        }
    },
}

-------------------------------------------------------------------------------
local projectile_constructors = {
    type = "projectile",
    name = "nano-projectile-constructors",
    flags = {"not-on-map"},
    acceleration = -0.005,
    direction_only = false,
    animation = constants.projectile_animation,
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
                    entity_name = "nano-cloud-small-constructors",
                    check_buildability = false
                },
            }
        }
    },
}

local cloud_big_constructors = {
    type = "smoke-with-trigger",
    name = "nano-cloud-big-constructors",
    flags = {"not-on-map"},
    show_when_smoke_off = true,
    animation = constants.cloud_animation(4),
    slow_down_factor = 0,
    affected_by_wind = false,
    cyclic = true,
    duration = 60*2,
    fade_away_duration = 60,
    spread_duration = 10,
    color = Color.set(defines.colors.lightblue, .035),
    action = nil,
}

local cloud_small_constructors = {
    type = "smoke-with-trigger",
    name = "nano-cloud-small-constructors",
    flags = {"not-on-map"},
    show_when_smoke_off = true,
    animation = constants.cloud_animation(.4),
    slow_down_factor = 0,
    affected_by_wind = false,
    cyclic = true,
    duration = 60*2,
    fade_away_duration = 60,
    spread_duration = 10,
    color = Color.set(defines.colors.lightblue, .035),
    action = nil,
}

-------------------------------------------------------------------------------
--Projectile for the healers, shoots from player to target,
--release healing cloud.
local projectile_repair = {
    type = "projectile",
    name = "nano-projectile-repair",
    flags = {"not-on-map"},
    acceleration = -0.005,
    direction_only = false,
    animation = constants.projectile_animation,
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
                    entity_name = "nano-cloud-small-repair",
                    check_buildability = false
                },
            }
        }
    },
}

--Healing cloud.
local cloud_small_repair = {
    type = "smoke-with-trigger",
    name = "nano-cloud-small-repair",
    flags = {"not-on-map"},
    show_when_smoke_off = true,
    animation = constants.cloud_animation(.4),
    slow_down_factor = 0,
    affected_by_wind = false,
    cyclic = true,
    duration = 200,
    fade_away_duration = 2*60,
    spread_duration = 10,
    color = Color.set(defines.colors.darkblue, 0.35),
    action_frequency = 1,
    action = {
        type = "direct",
        action_delivery =
        {
            type = "instant",
            target_effects =
            {
                type = "nested-result",
                action = {
                    {
                        type = "area",
                        perimeter = 0.75,
                        force="ally",
                        entity_flags = {"player-creation"},
                        action_delivery =
                        {
                            type = "instant",
                            target_effects =
                            {
                                type = "damage",
                                damage = { amount = -1, type = "physical"},
                            }
                        }
                    }
                }
            }
        }
    }
}

-------------------------------------------------------------------------------
data:extend({
        recipe, constructors,
        projectile_constructors, cloud_big_constructors, cloud_small_constructors,
        projectile_repair, cloud_small_repair
    })

local effects = data.raw.technology["automated-construction"].effects
effects[#effects + 1] = {type = "unlock-recipe", recipe="ammo-nano-constructors"}
