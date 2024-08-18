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
                self toggle( "Infinite Ammo", ::infinite_ammo, self.infinite_ammo, [ "Reload", "Constant" ] );
                self toggle( "Infinite Equipment", ::infinite_equipment, self.infinite_equipment );

                self option( "Kill Aura", ::new_menu, "Kill Aura" );
                self option( "Noclip", ::new_menu, "Noclip" );

                break;
            case "Weapons Menu":
                self menu( menu, menu );

                self toggle( "Explosive Bullets", ::god_mode, self.explosive_bullets );

                break;
            case "Administration Menu":
                self menu( menu, menu );

                self option( "Restart Map", ::restart_map, "Restart Map" );
                self toggle( "Change Map", ::change_map, self.change_map, ["Ambush", "Backlot", "Bog", "Crash", "Crossfire", "District", "Downpour", "Overgrown", "Shipment", "Vacant", "Broadcast", "Chinatown", "Countdown", "Bloc", "Creek", "Killhouse", "Pipeline", "Strike", "Showdown", "Wet Work", "Winter Crash", "Day Break", "Beach Bog", "Airport", "Blizzard", "Contingency", "DC Burning", "Gulag", "Safehouse", "Whiskey Hotel", "Afghan", "Derail", "Estate", "Favela", "Highrise", "Invasion", "Karachi", "Quarry", "Rust", "Scrapyard", "Skidrow", "Sub Base", "Terminal", "Underpass", "Wasteland", "Bailout", "Salvage", "Storm", "Carnival", "Fuel", "Trailer Park", "COMING SOON"] );


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