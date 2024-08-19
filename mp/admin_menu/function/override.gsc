hk_callback_player_damage( inflictor, attacker, damage, flag, cause, weapon, point, direction, bone_index, hit_loc ) {
    if (isdefined(self.damage_override_value)) {
        damage *= self.damage_override_value;
    }

    return [[ level.ocallbackplayerdamage ]]( inflictor, attacker, damage, flag, cause, weapon, point, direction, bone_index, hit_loc );
}