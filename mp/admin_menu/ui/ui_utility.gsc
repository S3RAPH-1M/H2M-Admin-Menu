#include maps\mp\gametypes\_hud;
#include maps\mp\gametypes\_hud_util;

#include scripts\mp\admin_menu\utility;

text( text, font, scale, align, relative, x, y, color, alpha, sort ) {
    textelem = self createfontstring( font, scale );

    textelem.xoffset = 0;
    textelem.yoffset = 0;
    textelem.color = color;
    textelem.alpha = alpha;
    textelem.sort = sort;

    textelem setpoint( align, relative, x, y );

    textelem.hidewheninmenu = true;
    textelem.archived = true;
    textelem.foreground = true;

    if( is_int( text ) || is_float( text ) )
        textelem setvalue( text );
    else
        textelem set_text( text );

    return textelem;
}

set_text( text ) {
    if( !isdefined( self ) || !isdefined( text ) )
        return;
    
    self.text = text;
    self settext( text );
}

set_slider( scrolling ) {
    menu = self get_menu();
    cursor = self get_cursor();

    minimum = !isdefined( self.slider[ menu ][ cursor ] ) ? self get_argument( 1 )[ cursor ] : 0;
    maximum = !isdefined( self.slider[ menu ][ cursor ] ) ? self get_argument( 2 )[ cursor ] : ( self.slider[ menu ][ cursor ].size - 1 );

    value = self get_argument( 3 )[ cursor ];
    if( isdefined( self.slider[ menu ][ cursor ] ) )
        self.slider_cursor[ menu ][ cursor ] += ( scrolling > 0 ) ? 1 : -1;
    else {
        if( self.slider_cursor[ menu ][ cursor ] < maximum && ( self.slider_cursor[ menu ][ cursor ] + value ) > maximum || ( self.slider_cursor[ menu ][ cursor ] > minimum ) && ( self.slider_cursor[ menu ][ cursor ] - value ) < minimum )
            self.slider_cursor[ menu ][ cursor ] = ( ( self.slider_cursor[ menu ][ cursor ] < maximum ) && ( self.slider_cursor[ menu ][ cursor ] + value ) > maximum ) ? maximum : minimum;
        else
            self.slider_cursor[ menu ][ cursor ] += ( scrolling > 0 ) ? value : ( value * -1 );
    }

    if( ( self.slider_cursor[ menu ][ cursor ] > maximum ) || ( self.slider_cursor[ menu ][ cursor ] < minimum ) )
        self.slider_cursor[ menu ][ cursor ] = ( self.slider_cursor[ menu ][ cursor ] > maximum ) ? minimum : maximum;
    
    if( isdefined( self.m203[ "ui" ][ "slider" ][ cursor ] ) ) {
        if( isdefined( self.slider[ menu ][ cursor ] ) )
            self.m203[ "ui" ][ "slider" ][ cursor ] set_text( self.slider[ menu ][ cursor ][ self.slider_cursor[ menu ][ cursor ] ] );
        else
            self.m203[ "ui" ][ "slider" ][ cursor ] setvalue( self.slider_cursor[ menu ][ cursor ] );
    }
}

shape( align, relative, x, y, width, height, color, alpha, sort, shader ) {
    boxelem = newclienthudelem( self );

    boxelem.elemtype = "bar";
    boxelem.children = [];
    boxelem.xoffset = 0;
    boxelem.yoffset = 0;
    boxelem.color = color;
    boxelem.alpha = alpha;
    boxelem.sort = sort;

    boxelem setpoint( align, relative, x, y );
    boxelem set_shader( shader, width, height );
    boxelem setparent( level.uiparent );

    boxelem.hidewheninmenu = true;
    boxelem.foreground = true;
    boxelem.archived = false;
    boxelem.hidden = false;

    return boxelem;
}

set_shader( shader, width, height ) {
    if( !isdefined( shader ) ) {
        if( !isdefined( self.shader) )
            return;
        
        shader = self.shader;
    }

    if( !isdefined( width ) ) {
        if( !isdefined( self.width ) )
            return;
        
        width = self.width;
    }

    if( !isdefined( height ) ) {
        if( !isdefined( self.height ) )
            return;
        
        height = self.height;
    }
    self.shader = shader;
    self.width  = width;
    self.height = height;

    self setshader( shader, width, height );
}

divide_color( r, g, b ) {
    return ( ( r / 255 ), ( g / 255 ), ( b / 255 ) );
}

color_transition() {
    if( isdefined( level.color_transition ) )
        return;
    
    values = [];

    level.color_transition = ( ( randomint( 250 )/ 255 ), 0, 0 );
    while( true ) {
        for( a = 0; a < 3; a++ ) {
            while( ( level.color_transition[ a ] * 255 ) < 255 ) {
                values[ a ] = ( ( level.color_transition[ a ] * 255 ) + 1 );

                for( b = 0; b < 3; b++ )
                    if( b != a )
                        values[ b ] = ( ( level.color_transition[ b ] > 0 ) ? ( ( level.color_transition[ b ] * 255 ) - 1 ) : 0 );
                
                level.color_transition = divide_color( values[ 0 ], values[ 1 ], values[ 2 ] );
                wait .01;
            }
        }
    }
}

smooth_transition() {
    if( isdefined( self.smooth_color ) )
        return;
    
    self.smooth_color = true;

    self endon( "disconnect" );
    self endon( "color_transition" );

    while( isdefined( self.smooth_color ) ) {
        element = [ "color" ];
        for( a = 0; a < element.size; a++ ) {
            if( isdefined( self.m203[ "ui" ][ element[ a ] ] ) ) {
                if( isarray( self.m203[ "ui" ][ element[ a ] ] ) ) {
                    for( b = 0; b < self.m203[ "ui" ][ element[ a ] ].size; b++ )
                        if( isdefined( self.m203[ "ui" ][ element[ a ] ][ b ] ) )
                            self.m203[ "ui" ][ element[ a ] ][ b ].color = level.color_transition;
                }
                else
                    self.m203[ "ui" ][ element[ a ] ].color = level.color_transition;
            }
        }

        self.palette[ "color" ] = level.color_transition;
        wait .01;
    }
}