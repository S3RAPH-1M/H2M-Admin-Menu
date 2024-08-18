#include user_scripts\mp\m203\utility;

#include user_scripts\mp\m203\ui\ui;

menu_array( menu ) {
    self.cursor = !isdefined( self.cursor ) ? [] : self.cursor;

    self.previous = !isdefined( self.previous ) ? [] : self.previous;

    self.structure = !isdefined( self.structure ) ? [] : self.structure;
    self.structure[ menu ] = !isdefined( self.structure[ menu ] ) ? spawnstruct() : self.structure[ menu ];

    self.structure[ menu ].option = [];
    self.structure[ menu ].function = [];
    self.structure[ menu ].toggle = [];
    self.structure[ menu ].slider = [];
    self.structure[ menu ].argument_1 = [];
    self.structure[ menu ].argument_2 = [];
    self.structure[ menu ].argument_3 = [];
    self.structure[ menu ].argument_4 = [];
    self.structure[ menu ].argument_5 = [];

    self.toggle = !isdefined( self.toggle ) ? [] : self.toggle;
    self.toggle[ menu ] = !isdefined( self.toggle[ menu ] ) ? [] : self.toggle[ menu ];

    self.slider = !isdefined( self.slider ) ? [] : self.slider;
    self.slider[ menu ] = !isdefined( self.slider[ menu ] ) ? [] : self.slider[ menu ];

    self.slider_cursor = !isdefined( self.slider_cursor ) ? [] : self.slider_cursor;
    self.slider_cursor[ menu ] = !isdefined( self.slider_cursor[ menu ] ) ? [] : self.slider_cursor[ menu ];
}

menu( menu, title, shader ) {
    self menu_array( menu );

    if( isdefined( title ) )
        self.structure[ menu ].title = title;
    
    if( isdefined( shader ) )
        self.structure[ menu ].shader = shader;
    
    self.temporary = menu;
}

option( text, function, argument_1, argument_2, argument_3, argument_4, argument_5 ) {
    menu = self.temporary;
    size = self get_option().size;

    self.structure[ menu ].option[ size ] = text;
    self.structure[ menu ].function[ size ] = function;
    self.structure[ menu ].argument_1[ size ] = argument_1;
    self.structure[ menu ].argument_2[ size ] = argument_2;
    self.structure[ menu ].argument_3[ size ] = argument_3;
    self.structure[ menu ].argument_4[ size ] = argument_4;
    self.structure[ menu ].argument_5[ size ] = argument_5;
}

toggle( text, function, toggle, array, argument_1, argument_2, argument_3, argument_4, argument_5 ) {
    menu = self.temporary;
    size = self get_option().size;

    self.structure[ menu ].option[ size ] = text;
    self.structure[ menu ].function[ size ] = function;

    self.structure[ menu ].toggle[ size ] = true;

    if( isdefined( array ) && isarray( array ) )
        self.structure[ menu ].slider[ size ] = true;

    self.structure[ menu ].argument_1[ size ] = argument_1;
    self.structure[ menu ].argument_2[ size ] = argument_2;
    self.structure[ menu ].argument_3[ size ] = argument_3;
    self.structure[ menu ].argument_4[ size ] = argument_4;
    self.structure[ menu ].argument_5[ size ] = argument_5;

    if( isdefined( array ) && isarray( array ) ) {
        self.slider[ menu ][ size ] = array;
        if( !isdefined( self.slider_cursor[ menu ][ size ] ) )
            self.slider_cursor[ menu ][ size ] = 0;
    }

    self.toggle[ menu ][ size ] = isdefined( toggle ) && toggle ? true : undefined;
}

slider( text, function, argument_1, argument_2, argument_3, argument_4, argument_5 ) {
    menu = self.temporary;
    size = self get_option().size;

    self.structure[ menu ].option[ size ] = text;
    self.structure[ menu ].function[ size ] = function;

    self.structure[ menu ].slider[ size ] = true;

    self.structure[ menu ].argument_1[ size ] = argument_1;
    self.structure[ menu ].argument_2[ size ] = argument_2;
    self.structure[ menu ].argument_3[ size ] = argument_3;
    self.structure[ menu ].argument_4[ size ] = argument_4;
    self.structure[ menu ].argument_5[ size ] = argument_5;

    if( isdefined( argument_1 ) && isarray( argument_1 ) )
        self.slider[ menu ][ size ] = argument_1;

    if( !isdefined( self.slider_cursor[ menu ][ size ] ) )
        self.slider_cursor[ menu ][ size ] = isdefined( self.slider[ menu ][ size ] ) ? 0 : argument_4;
}

new_menu( menu ) {
    self endon( "close_menu" );

    if( self get_menu() == "Session Players" && isdefined( menu ) ) {
        player = level.players[ ( self get_cursor() + 1 ) ];
        self.selected_player = player;
    }

    if( !isdefined( menu ) ) {
        menu = self.previous[ ( self.previous.size - 1 ) ];
        self.previous[ ( self.previous.size - 1 ) ] = undefined;
    }
    else {
        self.previous[ self.previous.size ] = self get_menu();
        self menu_array( self.previous[ ( self.previous.size - 1 ) ] );
    }

    self clear_option();
    self set_menu( menu );
    self update_menu();
    self store_option();
    self resize_menu();
}