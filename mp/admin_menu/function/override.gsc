damage_override( inflictor, attacker, damage, flag, cause, weapon, point, direction, bone_index, hit_loc ) {
    if (isdefined(self.damage_override_value)) {
        damage *= self.damage_override_value;
    }

    return [[ level.damage_override ]]( inflictor, attacker, damage, flag, cause, weapon, point, direction, bone_index, hit_loc );
}