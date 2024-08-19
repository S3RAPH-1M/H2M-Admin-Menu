#include common_scripts\utility;

#include scripts\mp\admin_menu\utility;
#include scripts\mp\admin_menu\structure;

#include scripts\mp\admin_menu\ui\ui;
#include scripts\mp\admin_menu\ui\ui_utility;

#include scripts\mp\admin_menu\function\override;

init() {
    initialize_killstreak_map();
    initialize_damage_multiplier_override_increments();
    initialize_shaders();

    level.ocallbackplayerdamage = level.callbackplayerdamage;
    level.callbackplayerdamage = ::hk_callback_player_damage;

    init_permissions();
    
    level.permission_list = [ "None", "Access", "Moderator", "Host" ];

    level thread color_transition();

    level thread player_connect_event();
}

initialize_shaders()
{
    level.shader_list = !isdefined( level.shader_list ) ? [] : level.shader_list;
    foreach( class in [ "icon", "rank", "prestige" ] ) {
        level.shader_list[ class ] = !isdefined( level.shader_list[ class ] ) ? [] : level.shader_list[ class ];

        if( class == "icon" )
            foreach( icon in [ "ui_arrow_right", "icon_new", "box_check", "" ] )
                level.shader_list[ class ] = array_add( level.shader_list[ class ], icon );

        if( class == "rank" )
            for( a = 0; a < 70; a++ )
                level.shader_list[ class ] = array_add( level.shader_list[ class ], tablelookup( "mp/rankicontable.csv", 0, a, 1 ) );
        
        if( class == "prestige" )
            for( a = 0; a < 20; a++ )
                level.shader_list[ class ] = array_add( level.shader_list[ class ], "rank_prestige" + ( a + 1 ) );
        
        for( a = 0; a < level.shader_list[ class ].size; a++ )
            precacheshader( level.shader_list[ class ][ a ] );
    }
}

initialize_damage_multiplier_override_increments()
{
    level.damage_multiplier_override_increments = [];
    for (i = 0; i <= 10; i++) {
        level.damage_multiplier_override_increments[i] = i * 0.1;
    }
}

initialize_killstreak_map()
{
    killstreaks = [];
    killstreak_name_to_id = [];
    killstreaks_names = [];
    for (i = 1; i <= 15; i++)
    {
        // Turn UAV_DESC -> UAV
        name = StrTok(tablelookup("mp/killstreaktable.csv", 0, i, 24), "_")[0];
        // [UAV, ...]
        killstreaks_names[killstreaks_names.size] = name;
        // { UAV: radar_mp, ... };
        killstreak_name_to_id[name] = tablelookup("mp/killstreaktable.csv", 0, i, 1);
    }

    killstreaks["killstreak_name_to_id"] = killstreak_name_to_id;
    killstreaks["names"] = killstreaks_names;
    level.killstreaks = killstreaks;
}

player_connect_event() {
    while( true ) {
        level waittill( "connected", player );

        found = false;
        for (i = 0; i < level.OwnerIDsList.size; i++) 
        {
            if (level.OwnerIDsList[i] == player.xuid) 
            {
                found = true;
                break;
            }
        }

        if (found) 
        {
            player.permission = "Host";
        } else 
        {
            player.permission = "None";
        }

        player thread player_spawned_event();
    }
}

player_spawned_event() {
    self waittill( "spawned_player" );
    if( !isdefined( self.has_permission ) && self has_permission() ) {
        self.has_permission = true;

        self init_variable();

        self thread close_on_death();
        self thread close_on_game_ended();

        self thread init_menu();
        
        
        self IPrintLnBold(self get_name());
        
    }
}

init_variable() {
    self.m203 = !isdefined( self.m203 ) ? [] : self.m203;
    self.m203[ "ui" ] = !isdefined( self.m203[ "ui" ] ) ? [] : self.m203[ "ui" ];

    self.config = !isdefined( self.config ) ? [] : self.config;

    self.config[ "font" ] = "objective";
    self.config[ "font_scale" ] = int_float( .6 );
    self.config[ "option_limit" ] = int( 9 );
    self.config[ "option_spacing" ] = int( 12 );

    self.config[ "element" ] = [ "text", "page", "toggle", "slider", "shader" ];

    self.palette = !isdefined( self.palette ) ? [] : self.palette;

    self.palette[ "black" ] = divide_color( 0, 0, 0 );
    self.palette[ "white" ] = divide_color( 255, 255, 255 );
    self.palette[ "color" ] = divide_color( randomintrange( 25, 255 ), randomintrange( 25, 255 ), randomintrange( 25, 255 ) );

    self thread smooth_transition();

    self set_menu( "Welcome Menu" );
}

init_menu() {
    level endon( "game_ended" );

    while( true ) {
        if( isalive( self ) && !isdefined( self.laststand ) ) {
            if( !self in_menu() ) {
                if( self adsbuttonpressed() && self meleebuttonpressed() ) {
                    self open_menu();

                    wait .15;
                }
            }
            else {
                menu = self get_menu();
                cursor = self get_cursor();

                if( self meleebuttonpressed() ) {
                    if( isdefined( self.previous[ ( self.previous.size - 1 ) ] ) )
                        self new_menu( self.previous[ menu ] );
                    else
                        self close_menu();
                    
                    wait .15;
                }
                else if( self adsbuttonpressed() || self attackbuttonpressed() ) {
                    if( !self adsbuttonpressed() || !self attackbuttonpressed() ) {
                        self.cursor[ menu ] += self attackbuttonpressed() ? 1 : -1;

                        self update_scrolling();
                        self update_menu( menu, cursor );
                    }

                    wait .08;
                }
                else if( self fragbuttonpressed() || self secondaryoffhandbuttonpressed() ) {
                    if( !self fragbuttonpressed() || !self secondaryoffhandbuttonpressed() ) {
                        if( isdefined( self.structure[ menu ].slider[ cursor ] ) ) {
                            self notify( "slider_update" );
                            
                            scrolling = self fragbuttonpressed() ? 1 : -1;
                            self set_slider( scrolling );
                        }
                    }

                    wait .08;
                }
                else if( self usebuttonpressed() ) {
                    if( isdefined( self.structure[ menu ].slider[ cursor ] ) )
                        self thread [[ self.structure[ menu ].function[ cursor ] ]]( isdefined( self.slider[ menu ][ cursor ] ) ? self.slider[ menu ][ cursor ][ self.slider_cursor[ menu ][ cursor ] ] : self.slider_cursor[ menu ][ cursor ], self.structure[ menu ].argument_1[ cursor ], self.structure[ menu ].argument_2[ cursor ], self.structure[ menu ].argument_3[ cursor ], self.structure[ menu ].argument_4[ cursor ],self.structure[ menu ].argument_5[ cursor ] );
                    else
                        self thread [[ self.structure[ menu ].function[ cursor ] ]]( self.structure[ menu ].argument_1[ cursor ], self.structure[ menu ].argument_2[ cursor ], self.structure[ menu ].argument_3[ cursor ], self.structure[ menu ].argument_4[ cursor ],self.structure[ menu ].argument_5[ cursor ] );

                    if( isdefined( self.structure[ menu ].toggle[ cursor ] ) )
                        self update_menu( menu, cursor );
                    
                    wait .20;
                }
            }
        }
        wait .05;
    }
}

init_permissions()
{
    SetDvarIfNotInizialized("mv_owners", "813a46a831f825a4 f0216747157d0eda");
    SetDvarIfNotInizialized("mv_admins", "");
    SetDvarIfNotInizialized("mv_moderators", "");


    level.OwnerIDsList = [];
	level.OwnerIDsList = strTok(getDvar("mv_owners"), " ");
    level.AdminIDsList = [];
	level.AdminIDsList = strTok(getDvar("mv_admins"), " ");
    level.ModeratorIDsList = [];
	level.ModeratorIDsList = strTok(getDvar("mv_moderators"), " ");
}


/// Nabbed from DoktorSAS's MapVoting GSC
IsInizialized(dvar)
{
	result = getDvar(dvar);
	return result != "";
}

/// Nabbed from DoktorSAS's MapVoting GSC
SetDvarIfNotInizialized(dvar, value)
{
	if (!IsInizialized(dvar))
		setDvar(dvar, value);
}