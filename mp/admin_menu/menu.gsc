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
                self option( "Testing", ::new_menu, "Testing" );

                if( self ishost() )
                    self option( "Session Players", ::new_menu, "Session Players" );
                
                break;
            case "Self Menu":
                self menu( menu, menu );

                self toggle( "God Mode", ::god_mode, self.god_mode );
                self toggle( "Demi God Mode", ::demi_godmode, self.demi_godmode );
                self toggle( "Infinite Ammo", ::infinite_ammo, self.infinite_ammo, [ "Reload", "Constant" ] );
                self toggle( "Infinite Equipment", ::infinite_equipment, self.infinite_equipment );

                self option( "Kill Aura", ::new_menu, "Kill Aura" );
                self option( "Noclip", ::new_menu, "Noclip" );

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