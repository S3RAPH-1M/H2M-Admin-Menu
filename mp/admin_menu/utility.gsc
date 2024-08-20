#include common_scripts\utility;
#include maps\mp\_utility;

#include scripts\mp\admin_menu\structure;

is_int( value ) {
    return isnumber( value ) && !issubstr( value, "." ) ? true : false;
}

is_float( value ) {
    return isnumber( value ) && issubstr( value, "." ) ? true : false;
}

int_float( value ) {
    return is_float( value ) ? float( value ) : int( value );
}

get_menu() {
    return self.menu;
}

get_cursor() {
    return self.cursor[ self get_menu() ];
}

get_option() {
    return self.structure[ self get_menu() ].option;
}

get_function() {
    return self.structure[ self get_menu() ].function;
}

get_argument( index ) {
    switch( index ) {
        case 1 : return self.structure[ self get_menu() ].argument_1;
        case 2 : return self.structure[ self get_menu() ].argument_2;
        case 3 : return self.structure[ self get_menu() ].argument_3;
        case 4 : return self.structure[ self get_menu() ].argument_4;
        case 5 : return self.structure[ self get_menu() ].argument_5;
    }
}

set_menu( menu ) {
    self.menu = menu;
}

set_cursor( cursor ) {
    self.cursor[ self get_menu() ] = cursor;
}

get_name() {
    name = self.name;

    if( name[ 0 ] != "[" )
        return name;
    
    for( a = ( name.size - 1 ); a >= 0; a-- )
        if( name[ a ] == "]" )
            break;
    
    return getsubstr( name, ( a + 1 ) );
}

has_permission() {
    return self.permission != level.permission_list[ 0 ] ? true : false;
}

in_menu() {
    return self has_permission() && isdefined( self.admin_menu[ "init" ] ) ? true : false;
}

is_offhand( item ) {
    equipment = [ "h1_fraggrenade_mp", "h1_c4_mp", "h1_flashgrenade_mp", "h1_concussiongrenade_mp", "h1_smokegrenade_mp" ];

    for( a = 0; a < equipment.size; a++ )
        if( equipment[ a ] == item )
            return true;
    
    return false;
}

get_offhand_reserve( item ) {
    base_value = 0;
    
    if( item == "h1_fraggrenade_mp" )
        base_value = self _hasperk( "specialty_fraggrenade" ) ? 3 : 1;
    
    if( item == "h1_flashgrenade_mp" || item == "h1_concussiongrenade_mp" )
        base_value = self _hasperk( "specialty_specialgrenade" ) ? 3 : 1;
    
    if( item == "h1_smokegrenade_mp" || item == "h1_c4_mp" )
        base_value = ( item == "h1_smokegrenade_mp" ) ? 1 : 2;
    
    return base_value;
}

weapon_check( weapon ) {
    weapon_list = self getweaponslistall();

    for( a = 0; a < weapon_list.size; a++ )
        if( getbaseweaponname( weapon_list[ a ] ) == getbaseweaponname( weapon ) )
            return true;
    
    return false;
}

touching_zone( target ) {
    zone = getentarray( target, "targetname" );

    for( a = 0; a < zone.size; a++ )
        if( self istouching( zone[ a ] ) )
            return true;
    
    return false;
}

in_array( array, item ) {
    for( a = 0; a < array.size; a++ )
        if( array[ a ] == item )
            return true;
    
    return false;
}

array_add( array, item, dupe ) {
    if( isdefined( dupe ) || in_array( array, item ) )
        array[ array.size ] = item;

    return array;
}

array_remove( array, item ) {
    new_array = [];

    for( a = 0; a < array.size; a++ )
        if( array[ a ] != item )
            new_array[ new_array.size ] = array[ a ];
    
    return new_array;
}

array_reverse( array ) {
    new_array = [];

    for( a = ( array.size - 1 ); a >= 0; a-- )
        new_array[ new_array.size ] = array[ a ];
    
    return new_array;
}

string_convert( string, delim, replace ) {
    new_string = "";

    for( a = 0; a < string.size; a++ ) {
        if( string[ a ] == delim )
            new_string += replace;
        else
            new_string += string[ a ];
    }

    return new_string;
}

clear_all( array ) {
    if( !isdefined( array ) )
        return;
    
    keys = getarraykeys( array );

    for( a = 0; a < keys.size; a++ ) {
        if( isarray( array[ keys[ a ] ] ) ) {
            foreach( value in array[ keys[ a ] ] )
                if( isdefined( value ) )
                    value destroy();
        }
        else {
            if( isdefined( array[ keys[ a ] ] ) )
                array[ keys[ a ] ] destroy();
        }
    }
}