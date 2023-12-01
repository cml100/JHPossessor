-- Copyright (c) ChaosForge Sp. z o.o.
nova.require "data/lua/gfx/common"

register_gfx_blueprint "animator_possessor"
{
	pose_animator = "data/model/warlock_poses.nmd",
	{
		pose_layer = {
			name     = "base",
			default  = "idle",
		},
		{
			pose_state = {
				name        = "idle",
				duration    = 2.0,
				pose_set    = "summoner_idle_wings_open",
			},
			pose_transition = { 
				{ name = "to_run", target = "run", duration  = 0.2 },
				{ name = "to_shot", target = "fire", duration  = 0.1 },
				{ name = "to_teleport", target = "teleport", duration  = 0.2 },
				{ name = "to_summon", target = "summon", duration  = 0.2 },
			}
		},
		{
			pose_state = {
				name        = "run",
				pose_set    = "summoner_run2",
				duration    = 0.5,
			},
			pose_transition = { 
				{ name = "to_idle", target = "idle", duration  = 0.2 },
				{ name = "to_teleport", target = "teleport", duration  = 0.2 },
				{ name = "to_summon", target = "summon", duration  = 0.2 },
			}
		},
		{
			pose_state = {
				name        = "summon",
				duration    = 0.7,
				pose_set    = "summoner_attack_summon",
				on_finish   = "to_done",
				loop        = false,
			},
			pose_transition = { 
				{ name = "to_run",  target = "run",  duration  = 0.2 },
				{ name = "to_done", target = "idle", duration  = 0.2 },
			}
		},
		{
			pose_state = {
				name        = "fire",
				duration    = 0.7,
				pose_set    = "summoner_attack_summon",
				on_finish   = "to_done",
				loop        = false,
			},
			pose_transition = { 
				{ name = "to_run",  target = "run",  duration  = 0.2 },
				{ name = "to_done", target = "idle", duration  = 0.2 },
			}
		},
		{
			pose_state = {
				name        = "teleport",
				duration    = 0.6,
				pose_set    = "summoner_teleport",
				on_finish   = "to_done",
				loop        = false,
			},
			pose_transition = { 
				{ name = "to_summon", target = "summon", duration  = 0.2 },
				{ name = "to_run",    target = "run",    duration  = 0.1 },
				{ name = "to_done",   target = "idle",   duration  = 0.1 },
			},
		},

	},
	{
		pose_layer = {
			name = "upper",
			default = "empty",
			mask = "CATRigPelvis",
		},
		{
			pose_state = {
				name = "empty",
			},
			pose_transition = { 
				{ name = "to_melee",  target = "melee",   duration = 0.1, },
				{ name = "to_melee2", target = "melee",   duration = 0.1, },
			}
		},
		{
			pose_state = {
				name      = "melee",
				pose_set  = "summoner_attack_melee",
				duration  = 0.5,
				loop      = false,
				on_finish = "to_done",
			},
			pose_transition = { 
				{ name = "to_done", target = "empty", duration = 0.1 },
			},
		},
	},
}

register_gfx_blueprint "ragdoll_possessor"
{
	limb = { 
		name   = "pelvis",
		bone   = "CATRigPelvis",
		radius = 0.03,
		target = "CATRigSpine2",
		mass   = 2.0 * RAGDOLL_MASS,
	},
	{
		limb = {
			name    = "spine",
			joint   = "cone_twist",
			limits  = vec3( 0.2, PI_4, PI_4 ),
			bone    = "CATRigSpine2",
			radius  = 0.09,
			target  = "CATRigHead",
			mass    = 5.0 * RAGDOLL_MASS, 
			hitable = true,
		},
		{
			limb = {
				name    = "head",
				joint   = "cone_twist",
				limits  = vec3( PI_8, PI_8, PI_8 ),
				bone    = "CATRigHead",
				radius  = 0.06,
				length  = 0.05,
				mass    = 2.0 * RAGDOLL_MASS,
				hitable = true,
			},
		},
		{
			limb = {
				name    = "upper_left_arm",
				joint   = "cone_twist",
				limits  = vec3( PI_2, PI_2, PI_2 ),
				bone    = "CATRigLArm11",
				target  = "CATRigLArm121",
				radius  = 0.03,
				mass    = 1.0 * RAGDOLL_MASS,
				hitable = true,
			},
			{
				limb = {
					name    = "lower_left_arm",
					joint   = "hinge",
					limits  = vec3( -PI_2, 0, 0 ),
					bone    = "CATRigLArm121",
					length  = 0.4,
					radius  = 0.025,
					mass    = 1.0 * RAGDOLL_MASS,
					hitable = true,
				},
			},
		},
		{
			limb = {
				name    = "upper_right_arm",
				joint   = "cone_twist",
				limits  = vec3( PI_2, PI_2, PI_2 ),
				bone    = "CATRigRArm11",
				target  = "CATRigRArm121",
				radius  = 0.03,
				mass    = 1.0 * RAGDOLL_MASS,
				hitable = true,
			},
			{
				limb = {
					name    = "lower_right_arm",
					joint   = "hinge",
					limits  = vec3( -PI_2, 0, 0 ),
					bone    = "CATRigRArm121",
					length  = 0.4,
					radius  = 0.025,
					mass    = 1.0 * RAGDOLL_MASS,
					hitable = true,
				},
			},			
		},
	},
	{
		limb = {
			name   = "upper_left_leg",
			joint  = "cone_twist",
			limits = vec3( PI_4, -PI_2, 0.1 ),
			bone   = "CATRigLLeg1",
			target = "CATRigLLeg2",
			radius = 0.03,
			mass   = 2.0 * RAGDOLL_MASS,
		},
		{
			limb = {
				name   = "lower_left_leg",
				joint  = "hinge",
				limits = vec3( -0.1, PI_2, 0 ),
				bone   = "CATRigLLeg2",
				length = 0.5,
				radius = 0.035,
				mass   = 2.0 * RAGDOLL_MASS,
			},
		},
	},
	{
		limb = {
			name   = "upper_right_leg",
			joint  = "cone_twist",
			limits = vec3( PI_4, -PI_2, 0.1 ),
			bone   = "CATRigRLeg1",
			target = "CATRigRLeg2",
			radius = 0.03,
			mass   = 2.0 * RAGDOLL_MASS,
		},
		{
			limb = {
				name   = "lower_right_leg",
				joint  = "hinge",
				limits = vec3( -0.1, PI_2, 0 ),
				bone   = "CATRigRLeg2",
				length = 0.5,
				radius = 0.035,
				mass   = 2.0 * RAGDOLL_MASS,
			},
		},
	}
}

register_gfx_blueprint "buff_possession_base"
{
	equip = {},
	persist = true,
	point_generator = {
		type     = "point",
		position = vec3(0.0,1,0.0),
	},
	particle_emitter = {
		rate     = 1,
		size     = 0.75,
		velocity = 0.2,
		lifetime = 2.0,
	},
	particle_transform = {
		force    = vec3(0,-0.2,0),
		rotation = 0.4,
	},
	particle_fade = {
		fade_in  = 0.5,
		fade_out = 1.0,
	},
}


register_gfx_blueprint "buff_possession"
{
	blueprint = "buff_possession_base",
	particle = {
		material        = "data/texture/fx/ring_01/ring_blue_02",
		group_id        = "pgroup_nightmare",
		localized       = true,
		destroy_owner   = true,
	},
}



register_gfx_blueprint "fx_on_shot_possessor"
{
	velocity = {
		value = 16.0,
		mortar = true,
	},
	target = {
		offset   = vec3( 0.0, 0.0, 0.0 ),
		position = true,
		ground   = true,
	},
	lifetime = {
		duration = 0.7,
	},
}

register_gfx_blueprint "fx_on_fire_possessor"
{
    fx = {
		tag    = "muzzle",
		attach = true,
	},
	scene = {},
	light = {
		color       = vec4(3.0,2.0,0.0,1.0),
        range       = 5,
	},
	fade = {
		fade_in  = 0.2,
		fade_out = 0.6,
	},
	lifetime = {
		duration = 1.0,
	},
	camera_shake = {
		power 		= 0.100,
		duration 	= 0.3,
	},
}

register_gfx_blueprint "fx_on_hit_possessor"
{
	lifetime = {
		duration = 2.0,
	},
	light = {
		color       = vec4(3.0,2.0,0.0,1.0),
		range       = 3.0,
	},
	fade = {
		fade_out = 1.0,
	},
	physics_explosion = {
		radius = 1.0,
	},
	{
		scene = {},
		point_generator = {
			type     = "sphere",
			position = vec3(0.0,0.1,0.0),
			extents  = vec3(0.6,0.6,0.0),
		},
		particle = {
			material        = "data/texture/particles/explosion_02/explosion_02",
			group_id        = "pgroup_fx",
			tiling          = 8,
			orientation     = PS_ORIENTED,
		},
		particle_emitter = {
			rate     = 256,
			size     = vec2(0.15,0.6),
			velocity = 1,
			color    = vec4(0.7,0.7,0.5,0.75),
			lifetime = 0.8,
			duration = 0.5,
		},
		particle_animator = {
			range = ivec2(0,63),
			rate  = 60.0,
		},	
		particle_transform = {
			force = vec3(0,15,0),
		},
		particle_fade = {
			fade_out = 0.5,
		},
	},
	camera_shake = {
		power 		= 0.495,
		duration 	= 0.35,
	},
	"ps_explosion_crater",
}

register_gfx_blueprint "possessor_claws"
{
	weapon_fx = {
		advance   = 0.5,
	},
	equip = {},
}


register_gfx_blueprint "possessor"
{
	entity_fx = {
		on_hit      = "ps_bleed",
		on_critical = "ps_bleed_critical",
	},
	ragdoll  = "ragdoll_possessor",
	animator = "animator_possessor",
	skeleton = "data/model/warlock.nmd",
	scale = { scale = 0.8, },
	render = {
		mesh = "data/model/warlock.nmd:summoner_body_01",
		material = "enemy_gfx/textures/Possessor/possessor_01",
	},
	{
		scale = { scale = 0.8, },
		attach = "CATRigHead",
		render = {
			mesh = "data/model/warlock.nmd:summoner_01_head_01",
			material = "enemy_gfx/textures/Possessor/possessor_01_head_01",
		},

	}
}
