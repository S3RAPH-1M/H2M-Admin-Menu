// https://www.se7ensins.com/forums/threads/massive-gsc-thread.1665232/
// Fun Features are either written by me or nabbed from SevenSins. 

CloneYourself()
{
    self cloneplayer(1);
}


doJetPack()
{
    if( self.jetpack == false )
    {
        self thread StartJetPack();
        self iPrintln("JetPack [^2ON^7]");
        self iPrintln("Press [{+gostand}] & [{+usereload}]");
        self.jetpack = true;
    }
    else if(self.jetpack == true)
    {
        self.jetpack = false;
        self notify("jetpack_off");
        self iPrintln("JetPack [^1OFF^7]");
    }
}

StartJetPack()
{
    self endon("death");
    self endon("jetpack_off");
    self.jetboots= 100;
    self attach("projectile_javelin_missile","tag_stowed_back");
    level._effect[ "flak20_fire_fx" ] = loadfx( "weapon/tracer/fx_tracer_flak_single_noExp" );
    for(i=0;;i++)
    {
        if(self usebuttonpressed() && self.jetboots>0)
        {
            self playsound( "predator_drone_missile" );
            playFX( level._effect[ "flak20_fire_fx" ], self getTagOrigin( "J_Ankle_RI" ) );
            playFx( level._effect[ "flak20_fire_fx" ], self getTagOrigin( "J_Ankle_LE" ) );
            earthquake(.15,.2,self gettagorigin("j_spine4"),50);
            self.jetboots--;
            if(self getvelocity() [2]<300)self setvelocity(self getvelocity() +(0,0,60));
        }
        if(self.jetboots<100 &&!self usebuttonpressed() )self.jetboots++;
        wait .05;
    }
}