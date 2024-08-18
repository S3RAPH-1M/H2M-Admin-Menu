damage_override( inflictor, attacker, damage, flag, cause, weapon, point, direction, bone_index, hit_loc ) {
    if( isdefined( self.god_mode ) )
    {
        return;
    }
    if(isdefined(self.demi_godmode))
    {
        return [[ level.damage_override ]]( inflictor, attacker, damage * 0.02, flag, cause, weapon, point, direction, bone_index, hit_loc );
    }
    
    return [[ level.damage_override ]]( inflictor, attacker, damage, flag, cause, weapon, point, direction, bone_index, hit_loc );
}