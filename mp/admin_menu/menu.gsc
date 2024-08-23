#include scripts\mp\admin_menu\utility;
#include scripts\mp\admin_menu\structure;

#include scripts\mp\admin_menu\function\basic;
#include scripts\mp\admin_menu\function\fun;
#include scripts\mp\admin_menu\function\testing;

menu_option( menu ) {
    if( self has_permission() ) {
        switch( menu ) {
            case "Welcome Menu":
                self menu( menu, menu );

                self option(1, "Self Menu", ::new_menu, "Self Menu" );
                self option(1, "Weapons Menu", ::new_menu, "Weapons Menu" );
                self option(1, "Administration Menu", ::new_menu, "Administration Menu"  );
                self option(2, "Fun Menu", ::new_menu, "Fun Menu"  );
                self option(3, "Testing", ::new_menu, "Testing" );
                self option(0, "Session Players", ::new_menu, "Session Players" );

                if( self ishost() )
                    self option( "Session Players", ::new_menu, "Session Players" );
                
                break;
            case "Self Menu":
                self menu( menu, menu );

                self multiple_choice_option( 2, "Damage Multiplier Override", ::damage_multiplier_override_changed, level.damage_multiplier_override_increments );
                self toggle( 2, "Infinite Equipment", ::infinite_equipment, self.infinite_equipment );
                self option( 1, "Swap To Third Person", ::ThirdPerson, "Swap To Third Person" );

                self option( 2, "Kill Aura", ::new_menu, "Kill Aura" );
                self option( 2, "Noclip", ::new_menu, "Noclip" );
                break;
            case "Fun Menu":
                self menu( menu, menu );

                self option( 1, "Spawn Bot", ::spawn_bot, "Spawn Bot" );
                self multiple_choice_option( 1, "Change Player Model", ::ChangeModel, ["HAZMAT", "INFECTED"] );
                self option( 3, "Clone Yourself", ::CloneYourself, "Clone Yourself" );
                self option( 3, "Jet Pack", ::doJetPack, "Jet Pack" );

                self option( 3, "Teleport ALL Players To Crosshair", ::BringAll, "Teleport Players To Center" );
                self multiple_choice_option( 2, "Set Bot Difficulty", ::change_bot_difficulty, ["Recruit", "Regular", "Hardened", "Veteran"] );
                break;
            case "Weapons Menu":
                self menu( menu, menu );
                
                self toggle( 2, "Infinite Ammo", ::infinite_ammo, self.infinite_ammo, [ "Reload", "Constant" ] );
                self toggle( 2, "Explosive Bullets", ::ExplosiveBullets, self.explosive_bullets, ["25 MM", "40 MM", "105 MM", "PREDATOR", "HARRIER", "JAVELIN", "RPG-7"] );
                self option( 1, "Give Weapons", ::new_menu, "Give Weapons" );
                break;
            case "Give Weapons":
                self menu( menu, menu );
                self option( 1, "Primary Weapons", ::new_menu, "Primary Weapons" );
                self option( 1, "Secondary Weapons", ::new_menu, "Secondary Weapons" );
                self option( 2, "Misc Weapons", ::new_menu, "Misc Weapons" );
                break;
            case "Primary Weapons":
                self menu( menu, menu );
                self multiple_choice_option( 1, "Assault Rifles", ::Admin_GiveWeapon, ["M4A1", "FAMAS", "SCAR-H", "TAR-21", "FAL", "M16A4", "ACR", "F2000", "AK47"] );
                self multiple_choice_option( 1, "Sub Machine Guns", ::Admin_GiveWeapon, ["MP5K", "UMP-45", "VECTOR", "P90", "MINI UZI", "AK-74U"] );
                self multiple_choice_option( 1, "Sniper Rifles", ::Admin_GiveWeapon, ["INVERVENTION", "BARRET .50 CAL", "WA2000", "M21", "M40A3"] );
                self multiple_choice_option( 1,"Light Machine Guns", ::Admin_GiveWeapon, ["L86 LSW", "RPD", "MG4", "AUG HBAR", "M240"] );
                break;
            case "Secondary Weapons":
                self menu( menu, menu );
                self multiple_choice_option( 1, "Machine Pistols", ::Admin_GiveWeapon, ["PP-2000", "GLOCK 18", "M93 RAFFICA", "TMP"] );
                self multiple_choice_option( 1, "Shotguns", ::Admin_GiveWeapon, ["SPAS-12", "AA-12", "STRIKER", "RANGER", "W1200", "M1014", "MODEL1887"] );
                self multiple_choice_option( 1, "Handguns", ::Admin_GiveWeapon, ["USP .45", ".44 MAGNUM", "M9", "M1911", "DESERT EAGLE"] );
                self multiple_choice_option( 1, "Launchers", ::Admin_GiveWeapon, ["AT4", "THUMPER", "FIM-92 STINGER", "FGM-148 JAVELIN", "RPG-7"] );
                self multiple_choice_option(  1,"Melee Weapons", ::Admin_GiveWeapon, ["HATCHET", "SICKLE", "SHOVEL", "ICEPICK", "KARAMBIT", "BRAAAINS"]);
                break;
            case "Misc Weapons":
                self menu( menu, menu );
                self multiple_choice_option( 1, "GameMode Weapons Misc", ::Admin_GiveWeapon, ["O.M.A BAG", "Defuse Briefcase", "Bomb Briefcase"] );
                self option( 2, "Kill Streak Weapons", ::new_menu, "Kill Streak Weapons" );
                break;
            case "Kill Streaks Menu":
                self menu( menu, menu );

                self multiple_choice_option( 2, "Give Kill Streak", ::GiveKillstreak, level.killstreaks["names"] );
                self option( 2, "Fake Nuke", ::FakeNuke, "Fake Nuke" );

                break;

            case "Kill Streak Weapons":
                self menu( menu, menu );

                self multiple_choice_option( 3, "AC-130", ::AdminGiveAC130, ["25 MM","40 MM","105 MM"] );
                break;
            case "Administration Menu":
                self menu( menu, menu );

                self option( 2, "Gamemode Options", ::new_menu, "Gamemode Options" );
                self option( 1, "Switch Team", ::ChangeTeam, "Switch Team" );
                self option( 1, "Restart Map", ::restart_map, "Restart Map" );
                self multiple_choice_option( 3, "Set XP Multiplier", ::SetXPMultiplier, [1,2,3,4,5,10,25,50,100] );
                self multiple_choice_option( 1, "Option", ::change_map, ["Ambush", "Backlot", "Bog", "Crash", "Crossfire", "District", "Downpour", "Overgrown", "Shipment", "Vacant", "Broadcast", "Chinatown", "Countdown", "Bloc", "Creek", "Killhouse", "Pipeline", "Strike", "Showdown", "Wet Work", "Winter Crash", "Day Break", "Beach Bog", "Airport", "Blizzard", "Contingency", "DC Burning", "Gulag", "Safehouse", "Whiskey Hotel", "Afghan", "Derail", "Estate", "Favela", "Highrise", "Invasion", "Karachi", "Quarry", "Rust", "Scrapyard", "Skidrow", "Sub Base", "Terminal", "Underpass", "Wasteland", "Bailout", "Salvage", "Storm", "Carnival", "Fuel", "Trailer Park", "COMING SOON"] );

                break;
            case "Gamemode Options":
                self menu( menu, menu );
                self option( 2, "Team Death Match", ::new_menu, "Team Death Match"  );
                self option( 2, "Search & Destroy", ::new_menu, "Search & Destroy"  );
                self option( 2, "Demolition Options", ::new_menu, "Demolition Options"  );
                self option( 2, "Capture The Flag", ::new_menu, "Capture The Flag"  );
                self option( 2, "Sabotage", ::new_menu, "Sabotage"  );
                self option( 2, "Common Gamemode Settings", ::new_menu, "Common Gamemode Settings"  );
                break;
            case "Team Death Match":
                self menu( menu, menu );
                // TODO


                break;
            case "Search & Destroy":
                self menu( menu, menu );
                // TODO


                break;
            case "Common Gamemode Settings":
                self menu( menu, menu );
                self multiple_choice_option( "Change Team Score", ::ChangeTeamScore, ["RED", "BLUE"] );
                self multiple_choice_option( "Change Max Team Score", ::ChangeMaxTeamScore, ["5","10","25","30","60","3600","9999999999999"] );
                self multiple_choice_option( "Change Time Limit", ::ChangeTimeLimit, ["0.1", "1","5","10","25","30","60","3600","9999999999999"] );
                self multiple_choice_option( "Allow Changing Team", ::EnableTeamSwapping, ["TRUE", "FALSE"] );
                self multiple_choice_option( "Change Gamemode", ::ChangeGamemode, ["SD","CTF","WAR"] );


                break;
            case "Demolition Options":
                self menu( menu, menu );
                // TODO

                break;
            case "Capture The Flag":
                self menu( menu, menu );
                // TODO


                break;
            case "Sabotage":
                self menu( menu, menu );
                // TODO

                break;
            case "Kill Aura":
                self menu( menu, menu );

                self toggle( 0, "Kill Aura", ::kill_aura, self.kill_aura );
                self slider( 0, "Max Aura", undefined, 75, 2250, 75, 225 );

                break;
            case "Noclip":
                self menu( menu, menu );

                self toggle( 0, "Noclip", ::noclip_adjustable, self.noclip_adjustable );
                self slider( 0, "Noclip Speed", undefined, 15, 450, 15, 30 );

                break;
            case "Testing":
                self menu( menu, menu );

                self option( 3, "Rank Icons", ::new_menu, "Rank Icons" );
                self option( 3, "Prestige Icons", ::new_menu, "Prestige Icons" );

                break;
            case "Rank Icons":
                self menu( menu, menu, true );

                for( a = 0; a < level.shader_list[ "rank" ].size; a++ )
                    self option( 0, level.shader_list[ "rank" ][ a ], ::print_test, level.shader_list[ "rank" ][ a ], 16, 16 );

                break;
            case "Prestige Icons":
                self menu( menu, menu, true );

                for( a = 0; a < level.shader_list[ "prestige" ].size; a++ )
                    self option( 0, level.shader_list[ "prestige" ][ a ], ::print_test, level.shader_list[ "prestige" ][ a ], 16, 16 );

                break;
            case "Session Players":
                self menu( menu, menu );

                foreach( player in level.players ) {
                    self option( 0, player get_name(), ::new_menu, "Options" );
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
            
            self option( 1, "Check Players Rank", ::GetUserRank, player );
            self option( 1, "Get Player's XUID", ::PrintXUID, player);
            self option( 1, "Kill Player", ::KillPlayer, player);
            self option( 2, "Teleport Player To Crosshair", ::Bring, player );
            self option( 1, "Teleport To Player", ::Goto, player );
            self option( 2, "Kick Player", ::KickPlayer, player );
            self option( 2, "Ban Player", ::BanPlayer, player );
            break;
        default:
            empty = true;

            if( empty ) {
                self menu( menu, menu );

                self option( 0, "Currently No Options To Display" );
            }

            break;
    }
}