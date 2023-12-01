-- Copyright (c) ChaosForge Sp. z o.o.
nova.require "data/lua/core/common"
nova.require "data/lua/core/aitk"
nova.require "data/lua/jh/data/common"

function possessor_spawn_location( self, start_coord)
	local max_range = 5
	
	local floor_id = self:get_nid( "floor" )
	local function can_spawn( p, c )
		if self:raw_get_cell( c ) ~= floor_id then return false end
		if self:get_cell_flags( c )[ EF_NOSPAWN ] then return false end
		if self:get_cell_flags( c )[ EF_NOMOVE ] then return false end
		local being = world:get_level():get_being( c )		
		if being then return false end
		for e in world:get_level():entities( c ) do
			if e.flags and e.flags.data and e.flags.data [ EF_NOMOVE ] then 
				return false 
			end
			if e.data and e.data.is_player then 
				return false 
			end
		end
		if not p then return true end

		local pc = p - c
		if pc.x < 0 then pc.x = -pc.x end
		if pc.y < 0 then pc.y = -pc.y end
		return pc.x <= max_range or pc.y <= max_range
	end
	
	local function spiral_get_values(range)
		local cx = 0
		local cy = 0
		local d = 1
		local m = 1
		local spiral_coords = {}
		while cx <= range and cy <= range do
			while (2 * cx * d) < m do
				table.insert(spiral_coords, {x=cx, y=cy})
				cx = cx + d
			end
			while (2 * cy * d) < m do
				table.insert(spiral_coords, {x=cx, y=cy})
				cy = cy + d
			end
			d = -1 * d
			m = m + 1			
		end
		return spiral_coords
	end
	
	local p = start_coord
	if can_spawn( p, p ) then
		return p
	end
	
	local spawn_coords = spiral_get_values(max_range)
	for k,v in ipairs(spawn_coords) do
		p.x = start_coord.x + v.x
		p.y = start_coord.y + v.y
		nova.log("Checking "..tostring(p.x)..","..tostring(p.y))
		if can_spawn( start_coord, p ) then
			return p
		end
	end
end

register_blueprint "buff_possession"
{
	flags = { EF_NOPICKUP }, 
	text = {
		name = "Possessed",
		desc = "{!25%} faster movement, increased damage and resistance to impact, slashing and piercing. A Possessor will be forced out of the body upon death.",
	},
	ui_buff = {
		color = YELLOW,
	},
	attributes = {
		damage_mult = 1.25,
		move_time = 0.8,
		resist = {
			impact   = 25,
			slash  = 25,
			pierce = 25,
		},
	},
	callbacks = {
		on_action = [=[
			function ( self, actor, time_passed, last )
				world:add_buff(actor, "buff_possession", 500, true )
			end
		]=],
		on_die = [=[
			function( self, entity )
				local loc   = possessor_spawn_location( world:get_level(), entity:get_position())
				local p = world:get_level():add_entity( "possessor", loc, nil )
				world:mark_destroy(entity)
				local level = world:get_level()
				--nova.log("POSSESSOR count before spawn: "..level.level_info.enemies)
				--level.level_info.enemies = level.level_info.enemies + 1. DON'T DO THIS. THIS CAUSES THE INCOMPLETE LEVEL BUG!!!
				world:add_buff( p, "disabled", 500, true )
				--nova.log("POSSESSOR count after spawn: "..level.level_info.enemies)
			end
		]=],
	},
}

register_blueprint "possessor_claws"
{
	weapon = {
		group       = "melee",
		type        = "melee",
		natural     = true,
		damage_type = "slash",
		fire_sound  = "summoner_melee",
		hit_sound   = "sword",
		slevel = { cold = 2, },
	},
	attributes = {
		damage   = 20,
		accuracy = 30,
	},
		callbacks = {
		on_create = [=[
		function( self )
			self:attach( "apply_cold" )
		end
		]=],
	},	
}

register_blueprint "possessor_base"
{
	blueprint = "being",
	health = {},
	sound = {
		idle = "warlock_idle",
		die  = "warlock_die",
	},
	attributes = {
		health           = 60,
		experience_value = 120,
		resist = {
			ignite = -50,
			impact   = 60,
			slash  = 60,
			pierce = 60,
			acid   = 100,
			toxin  = 100,
			bleed  = 100,
		},
	},
	callbacks = {
		on_action = "aitk.standard_ai",
	},
	data = {
		nightmare = {
			id   = false,
		},
		possessed = true,
		ai = {
            aware     = false,
			alert     = 1,
			group     = "demon",
			state     = "idle",
			melee     = 2,			
		},
	},
	listen = {
		active   = true,
		strength = 3,
	},
}


register_blueprint "possessor"
{
	blueprint = "possessor_base",
	text = {
		name      = "possessor",
		namep     = "possessors",
	},
	lists = {
		group = "being",
		{ { "possessor", "ice_fiend", "ice_fiend" }, keywords = { "europa", "dante", "pack", "demon", "demon1","cryo"}, weight = 30, dmax = 11 },
		{ { "possessor", "cryoreaver"}, keywords = { "europa", "dante", "pack", "demon", "demon2", "cryo"}, weight = 40, dmin = 11 },
		{ { "possessor", "ice_fiend", "ice_fiend" }, keywords = { "europa", "dante", "pack", "demon", "demon1","cryo"}, weight = 30, dmin = 12 },
		{ { "possessor", "ice_fiend", "ice_fiend", "ice_fiend" }, keywords = { "europa", "dante", "swarm", "demon", "demon1", "cryo"}, weight = 40, dmin = 12 },
		{ { "possessor", "ravager"}, keywords = {"europa", "demon", "demon2" }, weight = 40, dmin = 13, dmax = 15},
		{ { "possessor", "cryoreaver", "cryoreaver"}, keywords = { "europa", "dante", "pack", "demon", "demon2", "cryo"}, weight = 50, dmin = 13 },
		{ { "possessor", "cryoreaver", "ice_fiend", "ice_fiend" }, keywords = { "europa", "dante", "pack", "demon", "demon2","cryo"}, weight = 40, dmin = 14 },
		{ { "possessor", "cryoreaver", "cryoreaver", "cryoreaver" }, keywords = { "europa", "dante", "pack", "demon", "demon2","cryo"}, weight = 50, dmin = 15 },
	},
	ascii     = {
		glyph     = "P",
		color     = YELLOW,
	},
	callbacks = {
		on_create = [=[
		function(self)
			self:attach( "possessor_claws" )
			local attr = self.attributes
		end
		]=],
		on_post_command = [=[
			function ( actor, cmt, tgt, time )
				if cmt ~= COMMAND_WAIT then
					local valid = {}
					local level = world:get_level()
					for b in level:targets( actor, 4 ) do
						if b.data then
							local data = b.data
							if data.ai and (not data.is_mechanical) then
								if data.ai.group ~= "player" and data.ai.group ~= "cri" and text.name ~= "possessor" and text.name ~= "Ancient" and text.name ~= "Harbinger" and text.name ~= "Harbinger's Throne" and text.name ~= "CalSec Warden" and text.name ~= "Cryomancer" then
									if not data.possessed then --is set to true for the chosen target later
										table.insert(valid,b)
									end
								end
							end
						end
					end
					if #valid >= 1 then
						local target = valid[math.random(#valid)]
						world:add_buff(target, "buff_possession", 500, true ) --Doing this using target:attach instead causes multiple possessors to be able to possess a single enemy at the same time.
						target.data.possessed = true --important. Multiple possessions still happen otherwise, only the buff is applied once instead of twice.
						actor.attributes.experience_value = 0
						local level = world:get_level()
						--nova.log("POSSESSOR count before possession: "..level.level_info.enemies)
						level.level_info.enemies = level.level_info.enemies - 1
						world:mark_destroy(actor)
						--nova.log("POSSESSOR count after possession: "..level.level_info.enemies)
					end
				end
			end
		]=],

	},
	data = {
		ai = {
			precise = true,
		},
	},
}
