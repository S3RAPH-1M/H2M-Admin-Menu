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

                self toggle( "Explosive Bullets", ::god_mode, self.explosive_bullets );
                self option( "Give Weapons", ::new_menu, "Give Weapons" );
                break;
            case "Give Weapons":
                self menu( menu, menu );

                self option( "Assault Rifles", ::new_menu, "Assault Rifles" );
                self option( "Sub Machine Guns", ::new_menu, "Sub Machine Guns" );
                self option( "Sniper Rifles", ::new_menu, "Sniper Rifles" );
                self option( "Light Machine Guns", ::new_menu, "Light Machine Guns" );
                self option( "Machine Pistols", ::new_menu, "Machine Pistols" );
                self option( "Shotguns", ::new_menu, "Shotguns" );
                self option( "Handguns", ::new_menu, "Handguns" );
                self option( "Launchers", ::new_menu, "Launchers" );
                self option( "Melee Weapons", ::new_menu, "Melee Weapons");
                self option( "GameMode Weapons / Misc", ::new_menu, "GameMode Weapons / Misc" );
                break;
            case "Kill Streaks Menu":
                self menu( menu, menu );

                self toggle( "Give Kill Streak", ::GiveKillstreak, self.give_killstreak, ["UAV","Counter UAV","Care Package","Sentry Gun","Predator Missile","Air Strike","Helicopter","Harrier Strike","Emergency Air Drop","Pave Low","Stealth Bomber","Chopper Gunner","AC-130","EMP","Tactical Nuke"] );
                self option( "Fake Nuke", ::FakeNuke, "Fake Nuke" );
                self option( "Real Nuke", ::RealNuke, "Real Nuke" );

                break;
            case "Assault Rifles":
                self menu( menu, menu );

                self option( "AK-47", ::AdminGiveWeapon, "AK-47" );
                break;
            case "Administration Menu":
                self menu( menu, menu );

                self option( "Restart Map", ::restart_map, "Restart Map" );
                self toggle( "Change Map", ::change_map, self.change_map, ["Afghan", "Airport", "Backlot", "Bailout", "Beach Bog", "Blizzard", "Bloc", "Broadcast", "Carnival", "Chinatown", "Contingency", "Crash", "Creek", "Crossfire", "Day Break", "DC Burning", "Derail", "District", "Downpour", "Estate", "Favela", "Fuel", "Gulag", "Highrise", "Invasion", "Karachi", "Killhouse", "Pipeline", "Quarry", "Rust", "Salvage", "Safehouse", "Scrapyard", "Shipment", "Showdown", "Skidrow", "Storm", "Sub Base", "Terminal", "Trailer Park", "Underpass", "Vacant", "Wasteland", "Wet Work", "Whiskey Hotel", "Winter Crash"]);

                break;

            case "Kill Aura":
                self menu( menu, menu );

                self toggle( "Kill Aura", ::kill_aura, self.kill_aura );
                self slider( "Aura Range", undefined, 75, 2250, 75, 225 );

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