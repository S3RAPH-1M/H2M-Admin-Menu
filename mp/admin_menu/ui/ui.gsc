#include scripts\mp\admin_menu\utility;
#include scripts\mp\admin_menu\structure;

#include scripts\mp\admin_menu\ui\ui_utility;

#include scripts\mp\admin_menu\menu;

open_menu( menu ) {
    if( !isdefined( menu ) )
        menu = isdefined( self.menu ) && self.menu != "Welcome Menu" ? self.menu : "Welcome Menu";
    
    if( !isdefined( self.cursor[ menu ] ) )
        self.cursor[ menu ] = 0;
    
    self.admin_menu[ "ui" ][ "color" ] = self shape( "CENTER", "CENTER", -310, -70, 180, 16, self.palette[ "color" ], 1, 2, "white" );
    self.admin_menu[ "ui" ][ "icon" ] = self text( "SERVPH's Admin Menu", self.config[ "font" ], self.config[ "font_scale" ], "LEFT", "CENTER", -345, -70, self.palette[ "white" ], 1, 10 );
    self.admin_menu[ "ui" ][ "header" ] = self shape( "CENTER", "CENTER", -310, -56, 180, 12, self.palette[ "black" ], 1, 4, "white" );
    self.admin_menu[ "ui" ][ "background" ] = self shape( "CENTER", "CENTER", -310, -32, 180, 12, self.palette[ "black" ], .8, 5, "white" );
    self.admin_menu[ "ui" ][ "scrollbar" ] = self shape( "CENTER", "CENTER", -310, -44, 180, 12, self.palette[ "white" ], 1, 7, "white" );

    self.admin_menu[ "ui" ][ "subtitle" ] = self text( "", self.config[ "font" ], self.config[ "font_scale" ], "LEFT", "CENTER", -397, -56, self.palette[ "white" ], 1, 10 );
    self.admin_menu[ "ui" ][ "counter" ] = self text( "", self.config[ "font" ], self.config[ "font_scale" ], "RIGHT", "CENTER", -223, -56, self.palette[ "white" ], 1, 10 );

    self store_option();
    self disableoffhandweapons();

    self.admin_menu[ "init" ] = true;
}

close_menu() {
    self notify( "close_menu" );

    self clear_option();
    self clear_all( self.admin_menu[ "ui" ] );
    self enableoffhandweapons();

    self.admin_menu[ "init" ] = undefined;
}

close_on_death() {
    while( true ) {
        self waittill( "death" );

        if( self in_menu() )
            self close_menu();
    }
}

close_on_game_ended() {
    level waittill( "game_ended" );
    self clear_all( self.admin_menu[ "ui" ] );
}

store_title( title ) {
    self.admin_menu[ "ui" ][ "subtitle" ] set_text( isdefined( title ) ? title : self.structure[ self get_menu() ].title );
}

store_option() {
    self endon( "close_menu" );

    self clear_option();
    self menu_option( self get_menu() );
    self store_title();

    option = self get_option();
    if( !isdefined( option ) || !option.size ) {
        self option( self get_menu() == "Session Players" ? "Currently No Players In Session" : "Currently No Options To Display" );

        option = self get_option();
    }

    self resize_menu();
    if( !isdefined( self.cursor[ self get_menu() ] ) )
        self.cursor[ self get_menu() ] = 0;
    
    start = 0;
    if( self get_cursor() > int( ( self.config[ "option_limit" ] - 1 ) / 2 ) && self get_cursor() < ( option.size - int( ( self.config[ "option_limit" ] + 1 ) / 2 ) ) && option.size > self.config[ "option_limit" ] )
        start = ( self get_cursor() - int( ( self.config[ "option_limit" ] - 1 ) / 2 ) );
    
    if( self get_cursor() > ( option.size - ( int( ( self.config[ "option_limit" ] + 1 ) / 2 ) + 1 ) ) && option.size > self.config[ "option_limit" ] )
        start = option.size - self.config[ "option_limit" ];
    
    if( isdefined( option ) && option.size ) {
        size = option.size;

        if( size >= self.config[ "option_limit" ] )
            size = self.config[ "option_limit" ];
        
        for( a = 0; a < size; a++ ) {
            color = ( size <= 1 ) ? ( self get_cursor() == ( a + start ) ) ? self.palette[ "white" ] : self.palette[ "black" ] : ( self get_cursor() == ( a + start ) ) ? self.palette[ "black" ] : self.palette[ "white" ];
            text = isdefined( self.slider_cursor[ self get_menu() ][ ( a + start ) ] ) ? self get_option()[ ( a + start ) ] + ":" : self get_option()[ ( a + start ) ];
            slider = isdefined( self.slider[ self get_menu() ][ ( a + start ) ] ) ? self.slider[ self get_menu() ][ ( a + start ) ][ self.slider_cursor[ self get_menu() ][ ( a + start ) ] ] : self.slider_cursor[ self get_menu() ][ ( a + start ) ];

            if( isdefined( self.structure[ self get_menu() ].toggle[ ( a + start ) ] ) )
                self.admin_menu[ "ui" ][ "toggle" ][ ( a + start ) ] = self shape( "RIGHT", "CENTER", -223, ( a * self.config[ "option_spacing" ] ) - 44, 4, 4, self.palette[ "white" ], 1, 10, isdefined( self.toggle[ self get_menu() ][ ( a + start ) ] ) && self.toggle[ self get_menu() ][ ( a + start ) ] ? level.shader_list[ "icon" ][ 2 ] : level.shader_list[ "icon" ][ 1 ] );
            
            if( isdefined( self.structure[ self get_menu() ].slider[ ( a + start ) ] ) )
                self.admin_menu[ "ui" ][ "slider" ][ ( a + start ) ] = self text( slider, self.config[ "font" ], self.config[ "font_scale" ], "RIGHT", "CENTER", isdefined( self.structure[ self get_menu() ].toggle[ ( a + start ) ] ) ? -230 : -223, ( a * self.config[ "option_spacing" ] ) - 44, color, 1, 10 );
            
            if( isdefined( self.structure[ self get_menu() ].function[ ( a + start ) ] ) && self.structure[ self get_menu() ].function[ ( a + start ) ] == ::new_menu )
                self.admin_menu[ "ui" ][ "page" ][ ( a + start ) ] = self shape( "RIGHT", "CENTER", -223, ( a * self.config[ "option_spacing" ] ) - 44, 3, 3, color, 1, 10, level.shader_list[ "icon" ][ 0 ] );
            
            if( isdefined( self.structure[ self get_menu() ].shader ) )
                self.admin_menu[ "ui" ][ "text" ][ ( a + start ) ] = self shape( "CENTER", "CENTER", ( a * 20 ) + -390, -38, self get_cursor() == ( a + start ) ? self get_argument( 2 )[ ( a + start ) ] : 10, self get_cursor() == ( a + start ) ? self get_argument( 3 )[ ( a + start ) ] : 10, isdefined( self.structure[ self get_menu() ].argument_4[ ( a + start ) ] ) ? self get_argument( 4 )[ ( a + start ) ] : self.palette[ "white" ], self get_cursor() == ( a + start ) ? 1 : .2, 10, self get_option()[ ( a + start ) ] );
            else
                self.admin_menu[ "ui" ][ "text" ][ ( a + start ) ] = self text( text, self.config[ "font" ], self.config[ "font_scale" ], "LEFT", "CENTER", -397, ( a * self.config[ "option_spacing" ] ) - 44, color, 1, 10 );
        }

        if( !isdefined( self.admin_menu[ "ui" ][ "text" ][ self get_cursor() ] ) )
            self.cursor[ self get_menu() ] = ( option.size - 1 );
        
        if( isdefined( self.admin_menu[ "ui" ][ "scrollbar" ] ) )
            self.admin_menu[ "ui" ][ "scrollbar" ].y = self.admin_menu[ "ui" ][ "text" ][ self get_cursor() ].y;
    }
}

update_scrolling() {
    menu = self get_menu();
    option = self get_option();

    if( self.cursor[ menu ] >= ( int( self.config[ "option_limit" ] / 2 ) - 1 ) && self.cursor[ menu ] <= ( ( option.size - 1 ) - int( self.config[ "option_limit" ] / 2 ) ) || self.cursor[ menu ] >= option.size || self.cursor[ menu ] < 0 ) {
        if( self.cursor[ menu ] >= option.size || self.cursor[ menu ] < 0 )
            self.cursor[ menu ] = ( self.cursor[ menu ] >= option.size ) ? 0 : ( option.size - 1 );
        
        self store_option();
    }

    if( isdefined( self.admin_menu[ "ui" ][ "scrollbar" ] ) && isdefined( self.admin_menu[ "ui" ][ "text" ][ self.cursor[ menu ] ] ) )
        self.admin_menu[ "ui" ][ "scrollbar" ].y = self.admin_menu[ "ui" ][ "text" ][ self get_cursor() ].y;
    
    self resize_menu();
}

resize_menu() {
    height = ( ( self get_option().size >= self.config[ "option_limit" ] ) ? self.config[ "option_limit" ] : self get_option().size ) * self.config[ "option_spacing" ];
    size = ( self get_option().size >= self.config[ "option_limit" ] ) ? self.config[ "option_limit" ] : self get_option().size;
    alpha = ( size == 1 ) ? ( isdefined( self.structure[ self get_menu() ].shader ) ) ? 1 : 0 : ( isdefined( self.structure[ self get_menu() ].shader ) ) ? 0 : 1;

    if( isdefined( self.admin_menu[ "ui" ][ "counter" ] ) )
        self.admin_menu[ "ui" ][ "counter" ] set_text( "[" + ( self get_cursor() + 1 ) + "/" + self get_option().size + "]" );
    
    self.admin_menu[ "ui" ][ "background" ] set_shader( self.admin_menu[ "hud" ][ "background" ].shader, self.admin_menu[ "hud" ][ "background" ].width, isdefined( self.structure[ self get_menu() ].shader ) ? 24 : height );
    self.admin_menu[ "ui" ][ "background" ].y = isdefined( self.structure[ self get_menu() ].shader ) ? -38 : ( ( size * 6 ) - 50 );

    self.admin_menu[ "ui" ][ "scrollbar" ].alpha = alpha;
}

update_menu( menu, cursor ) {
    if( isdefined( menu ) && !isdefined( cursor ) || !isdefined( menu ) && isdefined( cursor ) )
        return;
    
    if( isdefined( menu ) && isdefined( cursor ) ) {
        foreach( player in level.players ) {
            if( !isdefined( player ) || !player has_permission() || !player in_menu() )
                continue;
            
            if( player get_menu() == menu || self != player && player check_option( self, menu, cursor ) )
                if( isdefined( player.admin_menu[ "ui" ][ "text" ][ cursor ] ) || player == self && player get_menu() == menu && isdefined( player.admin_menu[ "ui" ][ "text" ][ cursor ] ) || self != player && player check_option( self, menu, cursor ) )
                    player thread store_option();
        }
    }
    else
        if( isdefined( self ) && self has_permission() && self in_menu() )
            self thread store_option();
}

check_option( player, menu, cursor ) {
    option = player get_option()[ cursor ];

    if( self.structure[ self get_menu() ].option.size )
        for( a = 0; a < self.structure[ self get_menu() ].option.size; a++ )
            if( option == self.structure[ self get_menu() ].option[ a ] && issubstr( player get_menu(), " " + self getentitynumber() ) || issubstr( self get_menu(), " " + player getentitynumber() ) )
                return true;
    
    return false;
}

clear_option() {
    for( a = 0; a < self.config[ "element" ].size; a++ ) {
        clear_all( self.admin_menu[ "ui" ][ self.config[ "element" ][ a ] ] );

        self.admin_menu[ "ui" ][ self.config[ "element" ][ a ] ] = [];
    }
}