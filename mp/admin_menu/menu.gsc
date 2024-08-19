#include scripts\mp\admin_menu\utility;
#include scripts\mp\admin_menu\structure;

#include scripts\mp\admin_menu\function\basic;
#include scripts\mp\admin_menu\function\testing;

menu_option( menu ) {
    if( self has_permission() ) {
        switch( menu ) {
            case "Welcome Menu":
                self menu( menu, menu );

                self option( "Self Menu", ::new_menu, "Self Menu" );
                self option( "Weapons Menu", ::new_menu, "Weapons Menu" );
                self option( "Kill Streaks Menu", ::new_menu, "Kill Streaks Menu"  );
                self option( "Administration Menu", ::new_menu, "Administration Menu"  );
                self option( "Fun Menu", ::new_menu, "Fun Menu"  );
                self option( "Testing", ::new_menu, "Testing" );

                if( self ishost() )
                    self option( "Session Players", ::new_menu, "Session Players" );
                
                break;
            case "Self Menu":
                self menu( menu, menu );

                self toggle( "Damage Multiplier Override", ::damage_multiplier_override_changed, undefined, level.damage_multiplier_override_increments );
                self toggle( "Infinite Equipment", ::infinite_equipment, self.infinite_equipment );

                self option( "Kill Aura", ::new_menu, "Kill Aura" );
                self option( "Noclip", ::new_menu, "Noclip" );

                break;
            case "Fun Menu":
                self menu( menu, menu );

                self option( "Spawn Bot", ::spawn_bot, "Spawn Bot" );
                self toggle( "Set Bot Difficulty", ::change_bot_difficulty, self.bot_difficulty, ["Recruit", "Regular", "Hardened", "Veteran"] );
                break;
            case "Weapons Menu":
                self menu( menu, menu );
                
                self toggle( "Infinite Ammo", ::infinite_ammo, self.infinite_ammo, [ "Reload", "Constant" ] );
                self toggle( "Explosive Bullets", ::god_mode, self.explosive_bullets );
                self option( "Give Weapons", ::new_menu, "Give Weapons" );
                break;
            case "Give Weapons":
                self menu( menu, menu );
                self option( "Primary Weapons", ::new_menu, "Primary Weapons" );
                self option( "Secondary Weapons", ::new_menu, "Secondary Weapons" );
                self option( "Misc Weapons", ::new_menu, "Misc Weapons" );
                break;
            case "Primary Weapons":
                self menu( menu, menu );
                self toggle( "Assault Rifles", ::Admin_GiveWeapon, self.Admin_GiveWeapon, ["M4A1", "FAMAS", "SCAR-H", "TAR-21", "FAL", "M16A4", "ACR", "F2000", "AK47"] );
                self toggle( "Sub Machine Guns", ::Admin_GiveWeapon, self.Admin_GiveWeapon, ["MP5K", "UMP-45", "VECTOR", "P90", "MINI UZI", "AK-74U"] );
                self toggle( "Sniper Rifles", ::Admin_GiveWeapon, self.Admin_GiveWeapon, ["INVERVENTION", "BARRET .50 CAL", "WA2000", "M21", "M40A3"] );
                self toggle( "Light Machine Guns", ::Admin_GiveWeapon, self.Admin_GiveWeapon, ["L86 LSW", "RPD", "MG4", "AUG HBAR", "M240"] );
                break;
            case "Secondary Weapons":
                self menu( menu, menu );
                self toggle( "Machine Pistols", ::Admin_GiveWeapon, self.Admin_GiveWeapon, ["PP-2000", "GLOCK 18", "M93 RAFFICA", "TMP"] );
                self toggle( "Shotguns", ::Admin_GiveWeapon, self.Admin_GiveWeapon, ["SPAS-12", "AA-12", "STRIKER", "RANGER", "W1200", "M1014", "MODEL1887"] );
                self toggle( "Handguns", ::Admin_GiveWeapon, self.Admin_GiveWeapon, ["USP .45", ".44 MAGNUM", "M9", "M1911", "DESERT EAGLE"] );
                self toggle( "Launchers", ::Admin_GiveWeapon, self.Admin_GiveWeapon, ["AT4", "THUMPER", "FIM-92 STINGER", "FGM-148 JAVELIN", "RPG-7"] );
                self toggle( "Melee Weapons", ::Admin_GiveWeapon, self.Admin_GiveWeapon, ["HATCHET", "SICKLE", "SHOVEL", "ICEPICK", "KARAMBIT", "BRAAAINS"]);
                break;
            case "Misc Weapons":
                self menu( menu, menu );
                self toggle( "GameMode Weapons Misc", ::Admin_GiveWeapon, self.Admin_GiveWeapon, ["O.M.A BAG", "Defuse Briefcase", "Bomb Briefcase"] );
                self option( "Kill Streak Weapons", ::new_menu, "Kill Streak Weapons" );
                break;
            case "Kill Streaks Menu":
                self menu( menu, menu );

                self toggle( "Give Kill Streak", ::GiveKillstreak, self.give_killstreak, ["UAV","Counter UAV","Care Package","Sentry Gun","Predator Missile","Air Strike","Helicopter","Harrier Strike","Emergency Air Drop","Pave Low","Stealth Bomber","Chopper Gunner","AC-130","EMP","Tactical Nuke"] );
                self option( "Fake Nuke", ::FakeNuke, "Fake Nuke" );

                break;

            case "Kill Streak Weapons":
                self menu( menu, menu );

                self toggle( "AC-130", ::AdminGiveAC130, self.give_ac130, ["25 MM","40 MM","105 MM"] );
                break;
            case "Administration Menu":
                self menu( menu, menu );

                self option( "Restart Map", ::restart_map, "Restart Map" );
                self multiple_choice_option("Option", ::change_map, ["Ambush", "Backlot", "Bog", "Crash", "Crossfire", "District", "Downpour", "Overgrown", "Shipment", "Vacant", "Broadcast", "Chinatown", "Countdown", "Bloc", "Creek", "Killhouse", "Pipeline", "Strike", "Showdown", "Wet Work", "Winter Crash", "Day Break", "Beach Bog", "Airport", "Blizzard", "Contingency", "DC Burning", "Gulag", "Safehouse", "Whiskey Hotel", "Afghan", "Derail", "Estate", "Favela", "Highrise", "Invasion", "Karachi", "Quarry", "Rust", "Scrapyard", "Skidrow", "Sub Base", "Terminal", "Underpass", "Wasteland", "Bailout", "Salvage", "Storm", "Carnival", "Fuel", "Trailer Park", "COMING SOON"] );

                break;

            case "Kill Aura":
                self menu( menu, menu );

                self toggle( "Kill Aura", ::kill_aura, self.kill_aura );
                self slider( "Max Aura", undefined, 75, 2250, 75, 225 );

                break;
            case "Noclip":
                self menu( menu, menu );

                self toggle( "Noclip", ::noclip_adjustable, self.noclip_adjustable );
                self slider( "Noclip Speed", undefined, 15, 450, 15, 30 );

                break;
            case "Testing":
                self menu( menu, menu );

                self option( "Rank Icons", ::new_menu, "Rank Icons" );
                self option( "Prestige Icons", ::new_menu, "Prestige Icons" );

                break;
            case "Rank Icons":
                self menu( menu, menu, true );

                for( a = 0; a < level.shader_list[ "rank" ].size; a++ )
                    self option( level.shader_list[ "rank" ][ a ], ::print_test, level.shader_list[ "rank" ][ a ], 16, 16 );

                break;
            case "Prestige Icons":
                self menu( menu, menu, true );

                for( a = 0; a < level.shader_list[ "prestige" ].size; a++ )
                    self option( level.shader_list[ "prestige" ][ a ], ::print_test, level.shader_list[ "prestige" ][ a ], 16, 16 );

                break;
            case "Session Players":
                self menu( menu, menu );

                foreach( player in level.players ) {
                    if( player ishost() && !self ishost() || player == self )
                        continue;
                    
                    self option( player get_name(), ::new_menu, "Options" );
                }

                break;
            default:
                if( !isdefined( self.selected_player ) )
                    self.selected_player = self;
                
                self menu_option_player( menu, self.selected_player );

                break;
        }
    }
}

menu_option_player( menu, player ) {
    if( !isdefined( player ) || !isplayer( player ) )
        menu = "Empty";
    
    switch( menu ) {
        case "Options":
            self menu( menu, player get_name() );
            
            break;
        default:
            empty = true;

            if( empty ) {
                self menu( menu, menu );

                self option( "Currently No Options To Display" );
            }

            break;
    }
}