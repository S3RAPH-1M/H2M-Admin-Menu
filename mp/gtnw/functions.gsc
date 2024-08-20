#include common_scripts\utility;
#include scripts\utility;

#include maps\mp\gametypes\_gamescore;
#include maps\mp\gametypes\_hardpoints;
#include maps\mp\h2_killstreaks\_nuke;
#include maps\mp\h2_killstreaks\_airdrop;
#include maps\mp\_utility;
#include scripts\mp\admin_menu\utility;

init(){
    addCrateType( "nuke_drop",		"nuke_mp", 					getDvarInt( "scr_airdrop_mega_nuke", 0 ),		::nukeCrateThink );
}

SpawnNukeCrate()
{
	//			  Drop Type			Type						Weight		                                    Function					
    iPrintLnBold("Tactical Nuke Is Being Airdropped in by a C-130. INTERCEPT IT!");
    iPrintLn("X Position is: " + self.origin[0]);
    iPrintLn("Y Position is: " + self.origin[1]);
    iPrintLn("Z Position is: " + self.origin[2]);
    dropNuke(self.origin, self, "nuke_drop");
}


dropNuke( dropSite, owner, dropType )
{
	level endon("shutdownGame_called");

	planeHalfDistance = 24000;
	planeFlySpeed = 2000;
	yaw = RandomInt( 360 );

	direction = ( 0, yaw, 0 );

	flyHeight = self getFlyHeightOffset( dropSite );

	pathStart = dropSite + vector_multiply( anglestoforward( direction ), -1 * planeHalfDistance );
	pathStart = pathStart * ( 1, 1, 0 ) + ( 0, 0, flyHeight );

	pathEnd = dropSite + vector_multiply( anglestoforward( direction ), planeHalfDistance );
	pathEnd = pathEnd * ( 1, 1, 0 ) + ( 0, 0, flyHeight );

	d = length( pathStart - pathEnd );
	flyTime = ( d / planeFlySpeed );

	c130 = c130Setup( owner, pathStart, pathEnd );
	c130.veh_speed = planeFlySpeed;
	c130.dropType = dropType;
	c130 playloopsound( "veh_ac130_dist_loop" );

	c130.angles = direction;
	forward = anglesToForward( direction );
	c130 moveTo( pathEnd, flyTime, 0, 0 ); 

	// TODO: fix this... it's bad.  if we miss our distance (which could happen if plane speed is changed in the future) we stick in this thread forever
	boomPlayed = false;
	minDist = distance2D( c130.origin, dropSite );
	for(;;)
	{
		dist = distance2D( c130.origin, dropSite );

		// handle missing our target
		if ( dist < minDist )
			minDist = dist;
		else if ( dist > minDist )
			break;

		if ( dist < 256 )
		{
			break;
		}
		else if ( dist < 768 )
		{
			earthquake( 0.15, 1.5, dropSite, 1500 );
			if ( !boomPlayed )
			{
				c130 playSound( "veh_ac130_sonic_boom" );
				//c130 thread stopLoopAfter( 0.5 );
				boomPlayed = true;
			}
		}	

		wait ( .05 );	
	}	

	c130 thread dropTheCrate( dropSite, dropType, flyHeight, false, "nuke_mp", pathStart );
	wait ( 0.05 );
	c130 notify ( "drop_crate" );

	wait ( 4 );
	c130 delete();
}

Fixed_getCrateTypeForDropType( dropType )
{
	switch	( dropType )
	{
		//case "airdrop_sentry_minigun":
		//	return "sentry";
		//case "airdrop_predator_missile":
		//	return "predator_missile";
	case "airdrop_marker_mp":
		return getRandomCrateType( "airdrop_marker_mp" );
	case "airdrop_mega_marker_mp":
		return getRandomCrateType( "airdrop_mega_marker_mp" );
	case "nuke_drop":
		return "nuke_mp";
	default:
		return getRandomCrateType( "airdrop_marker_mp" );

	}
}

nukeCrateThink( dropType )
{
    self endon ( "death" );
    level endon("game_ended");

    crateSetupForUse( &"PLATFORM_CALL_NUKE", "nukeDrop", getKillstreakCrateIcon( self.crateType ) );

    self thread nukeCaptureThink();

    for ( ;; )
    {
        self waittill ( "captured", player );

        player thread [[ level.killstreakFuncs[ self.crateType ] ]]( level.gtnw );
        level notify( "nukeCaptured", player );

        if ( isDefined( level.gtnw ) && level.gtnw )
        player.capturedNuke = 1;

        player playLocalSound( "ammo_crate_use" );
        self deleteCrate();
    }
}

nukeCaptureThink()
{
	while ( isDefined( self ) )
	{
		self waittill ( "trigger", player );

		//if ( !player isOnGround() )
		//	continue;

		if ( !useHoldThink( player, 50000 ) )
			continue;

		self notify ( "captured", player );
	}
}