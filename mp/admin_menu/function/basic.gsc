#include common_scripts\utility;

#include scripts\mp\admin_menu\utility;


god_mode() {
    self.god_mode = !isdefined( self.god_mode ) ? true : undefined;
}

restart_map()
{
    say("Map Restarting in 3 Seconds!");
    wait 3;
    executeCommand("map_restart");
}

change_map()
{
    self.change_map = !isdefined( self.change_map ) ? true : undefined;

    menu = self get_menu();
    cursor = self get_cursor();
    while( isdefined( self.change_map ) ) 
    {
        if( self get_menu() == menu )
        {
            self.map_selection = self.slider[ menu ][ cursor ][ self.slider_cursor[ menu ][ cursor ] ];
            map_lower = tolower( self.map_selection );
            say("Admin Is Changing Map In 3 Seconds To: " + self.map_selection);
            wait 1;
            executeCommand("map mp_"+ map_lower);
            wait 300; // Temporary fix. We need to change the method for option in Structure to take an array.
        }
    }

}

infinite_ammo( array ) {
    self.infinite_ammo = !isdefined( self.infinite_ammo ) ? true : undefined;

    menu = self get_menu();
    cursor = self get_cursor();
    while( isdefined( self.infinite_ammo ) ) {
        if( self get_menu() == menu )
            self.infinite_type = self.slider[ menu ][ cursor ][ self.slider_cursor[ menu ][ cursor ] ];
        
        type = tolower( self.infinite_type );
        foreach( weapon in self getweaponslistprimaries() ) {
            if( weapon == self getcurrentweapon() ) {
                if( weapon != "h1_rpg_mp" || !issubstr( weapon, "alt" ) && !issubstr( weapon, "gl" ) ) {
                    self setweaponammostock( weapon, weaponmaxammo( weapon ) );

                    if( type == "constant" ) {
                        self setweaponammoclip( weapon, weaponclipsize( weapon ) );
                        if( issubstr( weapon, "akimbo" ) )
                            self setweaponammoclip( weapon, weaponclipsize( weapon ), "left" );
                    }
                }
            }
        }

        self waittill_any( "weapon_fired", "reload", "weapon_change", "slider_update" );
    }
}

damage_multiplier_override_changed() {
    menu = self get_menu();
    cursor = self get_cursor();
    self.damage_override_value = Float(self.slider[ menu ][ cursor ][ self.slider_cursor[ menu ][ cursor ] ]);
}

infinite_equipment() {
    self.infinite_equipment = !isdefined( self.infinite_equipment ) ? true : undefined;
    while( isdefined( self.infinite_equipment ) ) {
        foreach( weapon in self getweaponslistall() ) {
            if( is_offhand( weapon ) && self getweaponammoclip( weapon ) != get_offhand_reserve( weapon ) )
                self setweaponammoclip( weapon, get_offhand_reserve( weapon ) );
            
            if( issubstr( weapon, "alt" ) && issubstr( weapon, "gl" ) && self getweaponammoclip( weapon ) != weaponmaxammo( weapon ) )
                self setweaponammoclip( weapon, weaponmaxammo( weapon ) );
            
            if( weapon == "h1_rpg_mp" && self getweaponammoclip( weapon ) != weaponmaxammo( weapon ) ) {
                self setweaponammoclip( weapon, weaponclipsize( weapon ) );
                self setweaponammostock( weapon, 1 );
            }
        }

        self waittill_any( "grenade_fire", "missile_fire" );
    }
}

kill_aura() {
    self.kill_aura = !isdefined( self.kill_aura ) ? true : undefined;

    menu = self get_menu();
    while( isdefined( self.kill_aura ) ) {
        foreach( player in level.players )
            if( isalive( player ) && player != self && distance( self.origin, player.origin ) <= self.slider_cursor[ menu ][ 1 ] )
                player suicide();
        
        wait .05;
    }
}

noclip_adjustable() {
    self.noclip_adjustable = !isdefined( self.noclip_adjustable ) ? true : undefined;

    menu = self get_menu();
    if( isdefined( self.noclip_adjustable ) ) {
        self.noclip_link = spawn( "script_origin", self.origin );

        self playerlinkto( self.noclip_link );
        while( isdefined( self.noclip_adjustable ) ) {
            if( self sprintbuttonpressed() )
                self.noclip_link.origin = self.noclip_link.origin + ( anglestoforward( self getplayerangles() ) * self.slider_cursor[ menu ][ 1 ] );
            
            wait .05;
        }
    }
    else {
        self unlink();

        self.noclip_link delete();
    }
}

spawn_bot()
{
    executeCommand("SpawnBot");
}

change_bot_difficulty() 
{
    self.bot_difficulty = !isdefined( self.bot_difficulty ) ? true : undefined;

    menu = self get_menu();
    cursor = self get_cursor();
    while( isdefined( self.bot_difficulty ) ) 
    {
        if( self get_menu() == menu )
        {
            self.bot_difficulty = self.slider[ menu ][ cursor ][ self.slider_cursor[ menu ][ cursor ] ];
            difficulty_lower = tolower( self.bot_difficulty );
            if (difficulty_lower == "recruit") {
                executeCommand("set bot_DifficultyDefault 1");
            } else if (difficulty_lower == "regular") {
                executeCommand("set bot_DifficultyDefault 2");
            } else if (difficulty_lower == "hardened") {
                executeCommand("set bot_DifficultyDefault 3");
            } else if (difficulty_lower == "veteran") {
                executeCommand("set bot_DifficultyDefault 4");
            } else {
                executeCommand("set bot_DifficultyDefault 3"); // Default to Hardened if unknown difficulty
            }
            say("Admin has set the Bot Difficulty To: " + self.bot_difficulty);
            wait 300; // Temporary fix. We need to change the method for option in Structure to take an array.
        }
    }


}

AdminGiveAC130()
{
    self.give_ac130 = !isdefined( self.give_ac130 ) ? true : undefined;

    menu = self get_menu();
    cursor = self get_cursor();
    while( isdefined( self.give_ac130 ) ) 
    {
        if( self get_menu() == menu )
        {
            self.ac130_type = self.slider[ menu ][ cursor ][ self.slider_cursor[ menu ][ cursor ] ];
            weapon_variant = tolower( self.ac130_type );
            if (weapon_variant == "25 mm") {
                self GiveWeapon("ac130_25mm_mp");
            } else if (weapon_variant == "40 mm") {
            self GiveWeapon("ac130_40mm_mp");  
            } else if (weapon_variant == "105 mm") {
                self GiveWeapon("ac130_105mm_mp");
            } else {
                self iprintlnbold("How did you do that?");
            }
            wait 3600; // Temporary fix. We need to change the method for option in Structure to take an array.
        }
    }
}

Admin_GiveWeapon()
{
    self.Admin_GiveWeapon = !isdefined( self.Admin_GiveWeapon ) ? true : undefined;

    menu = self get_menu();
    cursor = self get_cursor();
    while( isdefined( self.Admin_GiveWeapon ) ) 
    {
        if( self get_menu() == menu )
        {
        // Get the weapon from the slider array
        self.SelectedWeapon = self.slider[menu][cursor][self.slider_cursor[menu][cursor]];
        
        // Convert bot difficulty to lower case
        weapon_2_id = tolower(self.SelectedWeapon);
        
        // Map weapon_2_id to the corresponding weapon ID
        switch (weapon_2_id) {
            case "m4a1":
                weapon_id = "h2_m4_mp";
                break;
            case "famas":
                weapon_id = "h2_famas_mp";
                break;
            case "scar-h":
                weapon_id = "h2_scar_mp";
                break;
            case "tar-21":
                weapon_id = "h2_tavor_mp";
                break;
            case "fal":
                weapon_id = "h2_fal_mp";
                break;
            case "m16a4":
                weapon_id = "h2_m16_mp";
                break;
            case "acr":
                weapon_id = "h2_masada_mp";
                break;
            case "f2000":
                weapon_id = "h2_fn2000_mp";
                break;
            case "ak47":
                weapon_id = "h2_ak47_mp";
                break;
            case "mp5k":
                weapon_id = "h2_mp5k_mp";
                break;
            case "ump-45":
                weapon_id = "h2_ump45_mp";
                break;
            case "vector":
                weapon_id = "h2_kriss_mp";
                break;
            case "p90":
                weapon_id = "h2_p90_mp";
                break;
            case "mini uzi":
                weapon_id = "h2_uzi_mp";
                break;
            case "ak-74u":
                weapon_id = "h1_ak74u";
                break;
            case "invervention":
                weapon_id = "h2_cheytac_mp";
                break;
            case "barret .50 cal":
                weapon_id = "h2_barrett_mp";
                break;
            case "wa2000":
                weapon_id = "h2_wa2000_mp";
                break;
            case "m21":
                weapon_id = "h2_m21_mp";
                break;
            case "m40a3":
                weapon_id = "h1_m40a3";
                break;
            case "l86 lsw":
                weapon_id = "h2_sa80_mp";
                break;
            case "rpd":
                weapon_id = "h2_rpd_mp";
                break;
            case "mg4":
                weapon_id = "h2_mg4_mp";
                break;
            case "aug hbar":
                weapon_id = "h2_aug_hbar_mp";
                break;
            case "m240":
                weapon_id = "h2_m240_mp";
                break;
            case "pp-2000":
                weapon_id = "h2_pp2000_mp";
                break;
            case "glock 18":
                weapon_id = "h2_glock_mp";
                break;
            case "m93 raffica":
                weapon_id = "h2_beretta393_mp";
                break;
            case "tmp":
                weapon_id = "h2_tmp_mp";
                break;
            case "spas-12":
                weapon_id = "h2_spas12_mp";
                break;
            case "aa-12":
                weapon_id = "h2_aa12_mp";
                break;
            case "striker":
                weapon_id = "h2_striker_mp";
                break;
            case "ranger":
                weapon_id = "h2_ranger_mp";
                break;
            case "w1200":
                weapon_id = "h1_winchester1200";
                break;
            case "m1014":
                weapon_id = "h2_m1014_mp";
                break;
            case "model1887":
                weapon_id = "h2_model1887_mp";
                break;
            case "usp .45":
                weapon_id = "h2_colt45_mp";
                break;
            case ".44 magnum":
                weapon_id = "h2_coltanaconda_mp";
                break;
            case "m9":
                weapon_id = "h2_m9_mp";
                break;
            case "m1911":
                weapon_id = "h2_colt45_mp";
                break;
            case "desert eagle":
                weapon_id = "h2_deserteagle_mp";
                break;
            case "at4":
                weapon_id = "at4_mp";
                break;
            case "thumper":
                weapon_id = "h2_m79_mp";
                break;
            case "fim-92 stinger":
                weapon_id = "stinger_mp";
                break;
            case "fgm-148 javelin":
                weapon_id = "javelin_mp";
                break;
            case "rpg-7":
                weapon_id = "h2_rpg_mp";
                break;
            case "hatchet":
                weapon_id = "h1_meleehatchet";
                break;
            case "sickle":
                weapon_id = "h1_meleesickle";
                break;
            case "shovel":
                weapon_id = "h1_shovel";
                break;
            case "icepick":
                weapon_id = "h1_meleeicepick";
                break;
            case "karambit":
                weapon_id = "h2_karambit_mp";
                break;
            case "braaains":
                weapon_id = "h2_braaains_mp";
                break;
            case "o.m.a bag":
                weapon_id = "onemanarmy_mp";
                break;
            case "defuse briefcase":
                weapon_id = "briefcase_bomb_defuse";
                break;
            case "bomb briefcase":
                weapon_id = "briefcase_bomb";
                break;
            default:
                weapon_id = "briefcase_bomb"; // Default weapon or handle as needed
                self IPrintLnBold("What the Ligma? The gun isnt found!");
                break;
        }

        self GiveWeapon(weapon_id);
        wait 300; // Temporary fix. We need to change the method for option in Structure to take an array.
        }
    }


}

GiveKillstreak()
{
    self.give_killstreak = !isdefined( self.give_killstreak ) ? true : undefined;

    menu = self get_menu();
    cursor = self get_cursor();
    while( isdefined( self.give_killstreak ) ) 
    {
        if( self get_menu() == menu )
        {
            self.killstreak = self.slider[ menu ][ cursor ][ self.slider_cursor[ menu ][ cursor ] ];
            streak_lower = tolower( self.killstreak );
            
            switch(streak_lower)
            {
                case "uav":
                    streak_id = "radar_mp";
                    break;
                case "counter uav":
                    streak_id = "counter_radar_mp";
                    break;
                case "care package":
                    streak_id = "airdrop_marker_mp";
                    break;
                case "sentry gun":
                    streak_id = "sentry_mp";
                    break;
                case "predator missile":
                    streak_id = "predator_mp";
                    break;
                case "air strike":
                    streak_id = "airstrike_mp";
                    break;
                case "helicopter":
                    streak_id = "helicopter_mp";
                    break;
                case "harrier strike":
                    streak_id = "harrier_airstrike_mp";
                    break;
                case "emergency air drop":
                    streak_id = "airdrop_mega_marker_mp";
                    break;
                case "pave low":
                    streak_id = "pavelow_mp";
                    break;
                case "stealth bomber":
                    streak_id = "stealth_airstrike_mp";
                    break;
                case "chopper gunner":
                    streak_id = "chopper_gunner_mp";
                    break;
                case "ac-130":
                    streak_id = "ac130_mp";
                    break;
                case "emp":
                    streak_id = "emp_mp";
                    break;
                case "tactical nuke":
                    streak_id = "nuke_mp";
                    break;
                default:
                    streak_id = "radar_mp";
                    break;
            }
            
            self maps\mp\gametypes\_hardpoints::givehardpoint(streak_id, 0); // This is giving us the actual ks
            wait 1000; // Temporary fix. We need to change the method for option in Structure to take an array.
        }
    }
}


FakeNuke()
{
    self maps\mp\h2_killstreaks\_nuke::h2_nukeCountdown();
    level thread maps\mp\_utility::teamPlayerCardSplash( "callout_used_nuke", self, self.team );
    self notify( "used_nuke" );
    wait 10;
    self maps\mp\h2_killstreaks\_nuke::cancelNukeOnDeath(self.player);
}