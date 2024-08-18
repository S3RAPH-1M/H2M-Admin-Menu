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

AdminGiveWeapon()
{
   self GiveWeapon("cobra_player_minigun_mp");
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

RealNuke()
{
    self maps\mp\h2_killstreaks\_nuke::tryUseNuke(self.lifeid, false);
}



