#include common_scripts\utility;

#include scripts\mp\admin_menu\utility;

restart_map()
{
    say("Map Restarting in 3 Seconds!");
    wait 3;
    executeCommand("map_restart");
}

change_map()
{
    self.change_map = !isdefined( self.change_map ) ? true : undefined;

    menu = self get_menu();
    cursor = self get_cursor();
    while( isdefined( self.change_map ) ) 
    {
        if( self get_menu() == menu )
        {
            self.map_selection = self.slider[ menu ][ cursor ][ self.slider_cursor[ menu ][ cursor ] ];
            map_lower = tolower( self.map_selection );
            say("Admin Is Changing Map In 3 Seconds To: " + self.map_selection);
            wait 1;
            executeCommand("map mp_"+ map_lower);
            wait 300; // Temporary fix. We need to change the method for option in Structure to take an array.
        }
    }

}

infinite_ammo( array ) {
    self.infinite_ammo = !isdefined( self.infinite_ammo ) ? true : undefined;

    menu = self get_menu();
    cursor = self get_cursor();
    while( isdefined( self.infinite_ammo ) ) {
        if( self get_menu() == menu )
            self.infinite_type = self.slider[ menu ][ cursor ][ self.slider_cursor[ menu ][ cursor ] ];
        
        type = tolower( self.infinite_type );
        foreach( weapon in self getweaponslistprimaries() ) {
            if( weapon == self getcurrentweapon() ) {
                if( weapon != "h1_rpg_mp" || !issubstr( weapon, "alt" ) && !issubstr( weapon, "gl" ) ) {
                    self setweaponammostock( weapon, weaponmaxammo( weapon ) );

                    if( type == "constant" ) {
                        self setweaponammoclip( weapon, weaponclipsize( weapon ) );
                        if( issubstr( weapon, "akimbo" ) )
                            self setweaponammoclip( weapon, weaponclipsize( weapon ), "left" );
                    }
                }
            }
        }

        self waittill_any( "weapon_fired", "reload", "weapon_change", "slider_update" );
    }
}

damage_multiplier_override_changed() {
    menu = self get_menu();
    cursor = self get_cursor();
    self.damage_override_value = Float(self.slider[ menu ][ cursor ][ self.slider_cursor[ menu ][ cursor ] ]);
}

infinite_equipment() {
    self.infinite_equipment = !isdefined( self.infinite_equipment ) ? true : undefined;
    while( isdefined( self.infinite_equipment ) ) {
        foreach( weapon in self getweaponslistall() ) {
            if( is_offhand( weapon ) && self getweaponammoclip( weapon ) != get_offhand_reserve( weapon ) )
                self setweaponammoclip( weapon, get_offhand_reserve( weapon ) );
            
            if( issubstr( weapon, "alt" ) && issubstr( weapon, "gl" ) && self getweaponammoclip( weapon ) != weaponmaxammo( weapon ) )
                self setweaponammoclip( weapon, weaponmaxammo( weapon ) );
            
            if( weapon == "h1_rpg_mp" && self getweaponammoclip( weapon ) != weaponmaxammo( weapon ) ) {
                self setweaponammoclip( weapon, weaponclipsize( weapon ) );
                self setweaponammostock( weapon, 1 );
            }
        }

        self waittill_any( "grenade_fire", "missile_fire" );
    }
}

kill_aura() {
    self.kill_aura = !isdefined( self.kill_aura ) ? true : undefined;

    menu = self get_menu();
    while( isdefined( self.kill_aura ) ) {
        foreach( player in level.players )
            if( isalive( player ) && player != self && distance( self.origin, player.origin ) <= self.slider_cursor[ menu ][ 1 ] )
                player suicide();
        
        wait .05;
    }
}

noclip_adjustable() {
    self.noclip_adjustable = !isdefined( self.noclip_adjustable ) ? true : undefined;

    menu = self get_menu();
    if( isdefined( self.noclip_adjustable ) ) {
        self.noclip_link = spawn( "script_origin", self.origin );

        self playerlinkto( self.noclip_link );
        while( isdefined( self.noclip_adjustable ) ) {
            if( self sprintbuttonpressed() )
                self.noclip_link.origin = self.noclip_link.origin + ( anglestoforward( self getplayerangles() ) * self.slider_cursor[ menu ][ 1 ] );
            
            wait .05;
        }
    }
    else {
        self unlink();

        self.noclip_link delete();
    }
}