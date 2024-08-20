#include common_scripts\utility;
#include scripts\utility;

#include maps\mp\gametypes\_gamescore;
#include maps\mp\gametypes\_hardpoints;
#include maps\mp\h2_killstreaks\_nuke;
#include maps\mp\h2_killstreaks\_airdrop;
#include maps\mp\_utility;
#include scripts\mp\admin_menu\utility;

restart_map()
{
    say("Map Restarting in 3 Seconds!");
    wait 3;
    executeCommand("map_restart");
}

change_map(selected_map)
{
    map_lower = tolower( selected_map );
    say("Admin Is Changing Map In 3 Seconds To: " + selected_map);
    wait 1;
    executeCommand("map mp_"+ map_lower);
    wait 300; // Temporary fix. We need to change the method for option in Structure to take an array.
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
    self iPrintLnBold("Damage Multiplier Set To: " + self.damage_override_value);
    self iPrintLn("Damage Multiplier Set To: " + self.damage_override_value);
    self iPrintLnBold("Damage Multiplier Set To:");

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

spawn_bot()
{
    executeCommand("SpawnBot");
}

change_bot_difficulty(bot_difficulty) 
{
    difficulty_lower = tolower( bot_difficulty );
    if (difficulty_lower == "recruit") {
        executeCommand("set bot_DifficultyDefault 1");
    } 
    else if (difficulty_lower == "regular") {
        executeCommand("set bot_DifficultyDefault 2");
    }
    else if (difficulty_lower == "hardened") {
        executeCommand("set bot_DifficultyDefault 3");
    }
    else if (difficulty_lower == "veteran") {
        executeCommand("set bot_DifficultyDefault 4");
    }
    else {
        executeCommand("set bot_DifficultyDefault 3"); // Default to Hardened if unknown difficulty
    }
    
    say("Admin has set the Bot Difficulty To: " + bot_difficulty);
}

AdminGiveAC130(ac130_type)
{
    weapon_variant = tolower( ac130_type );
    if (weapon_variant == "25 mm") {
        self GiveWeapon("ac130_25mm_mp");
        self SwitchToWeapon("ac130_25mm_mp");
    }
    else if (weapon_variant == "40 mm") {
        self GiveWeapon("ac130_40mm_mp");  
        self SwitchToWeapon("ac130_40mm_mp");
    }
    else if (weapon_variant == "105 mm") {
        self GiveWeapon("ac130_105mm_mp");
        self SwitchToWeapon("ac130_105mm_mp");
    }
    else {
        self iprintlnbold("How did you do that?");
    }
}

Admin_GiveWeapon(weapon)
{
    // Crt bot difficulty to lower case
    weapon_2_id = tolower(weapon);
    
    // Map weapon_2_id to the corresponding weapon ID
        switch (weapon_2_id) {
            case "m4a1":
                weapon_id = "h2_m4_mp";
                break;
            case "famas":
                weapon_id = "h2_famas_mp";
                break;
            case "scar-h":
                weapon_id = "h2_scar_mp";
                break;
            case "tar-21":
                weapon_id = "h2_tavor_mp";
                break;
            case "fal":
                weapon_id = "h2_fal_mp";
                break;
            case "m16a4":
                weapon_id = "h2_m16_mp";
                break;
            case "acr":
                weapon_id = "h2_masada_mp";
                break;
            case "f2000":
                weapon_id = "h2_fn2000_mp";
                break;
            case "ak47":
                weapon_id = "h2_ak47_mp";
                break;
            case "mp5k":
                weapon_id = "h2_mp5k_mp";
                break;
            case "ump-45":
                weapon_id = "h2_ump45_mp";
                break;
            case "vector":
                weapon_id = "h2_kriss_mp";
                break;
            case "p90":
                weapon_id = "h2_p90_mp";
                break;
            case "mini uzi":
                weapon_id = "h2_uzi_mp";
                break;
            case "ak-74u":
                weapon_id = "h2_ak74u_mp";
                break;
            case "invervention":
                weapon_id = "h2_cheytac_mp";
                break;
            case "barret .50 cal":
                weapon_id = "h2_barrett_mp";
                break;
            case "wa2000":
                weapon_id = "h2_wa2000_mp";
                break;
            case "m21":
                weapon_id = "h2_m21_mp";
                break;
            case "m40a3":
                weapon_id = "h1_m40a3";
                break;
            case "l86 lsw":
                weapon_id = "h2_sa80_mp";
                break;
            case "rpd":
                weapon_id = "h2_rpd_mp";
                break;
            case "mg4":
                weapon_id = "h2_mg4_mp";
                break;
            case "aug hbar":
                weapon_id = "h2_aug_hbar_mp";
                break;
            case "m240":
                weapon_id = "h2_m240_mp";
                break;
            case "pp-2000":
                weapon_id = "h2_pp2000_mp";
                break;
            case "glock 18":
                weapon_id = "h2_glock_mp";
                break;
            case "m93 raffica":
                weapon_id = "h2_beretta393_mp";
                break;
            case "tmp":
                weapon_id = "h2_tmp_mp";
                break;
            case "spas-12":
                weapon_id = "h2_spas12_mp";
                break;
            case "aa-12":
                weapon_id = "h2_aa12_mp";
                break;
            case "striker":
                weapon_id = "h2_striker_mp";
                break;
            case "ranger":
                weapon_id = "h2_ranger_mp";
                break;
            case "w1200":
                weapon_id = "h2_winchester1200_mp";
                break;
            case "m1014":
                weapon_id = "h2_m1014_mp";
                break;
            case "model1887":
                weapon_id = "h2_model1887_mp";
                break;
            case "usp .45":
                weapon_id = "h2_usp_mp";
                break;
            case ".44 magnum":
                weapon_id = "h2_coltanaconda_mp";
                break;
            case "m9":
                weapon_id = "h2_m9_mp";
                break;
            case "m1911":
                weapon_id = "h2_colt45_mp";
                break;
            case "desert eagle":
                weapon_id = "h2_deserteagle_mp";
                break;
            case "at4":
                weapon_id = "at4_mp";
                break;
            case "thumper":
                weapon_id = "h2_m79_mp";
                break;
            case "fim-92 stinger":
                weapon_id = "stinger_mp";
                break;
            case "fgm-148 javelin":
                weapon_id = "javelin_mp";
                break;
            case "rpg-7":
                weapon_id = "h2_rpg_mp";
                break;
            case "hatchet":
                weapon_id = "h2_hatchet_mp";
                break;
            case "sickle":
                weapon_id = "h2_sickle_mp";
                break;
            case "shovel":
                weapon_id = "h2_shovel_mp";
                break;
            case "icepick":
                weapon_id = "h2_icepick_mp";
                break;
            case "karambit":
                weapon_id = "h2_karambit_mp";
                break;
            case "braaains":
                weapon_id = "h2_infect_mp";
                break;
            case "o.m.a bag":
                weapon_id = "onemanarmy_mp";
                break;
            case "defuse briefcase":
                weapon_id = "briefcase_bomb_defuse";
                break;
            case "bomb briefcase":
                weapon_id = "briefcase_bomb";
                break;
            default:
                weapon_id = "briefcase_bomb"; // Default weapon or handle as needed
                self IPrintLnBold("What the Ligma? The gun isnt found!");
                break;
        }

    self GiveWeapon(weapon_id);
    self SwitchToWeapon(weapon_id);
}

GiveKillstreak(killstreak)
{
    streak_id = level.killstreaks["killstreak_name_to_id"][killstreak];
    if (isdefined(streak_id)) {
        self givehardpoint(streak_id, 0); // This is giving us the actual ks
    }
    else {
        self IPrintLnBold("^1Killstreak not found: " + killstreak);
    }
}

FakeNuke()
{
    self h2_nukeCountdown();
    level thread teamPlayerCardSplash( "callout_used_nuke", self, self.team );
    self notify( "used_nuke" );
    wait 10;
    self cancelNukeOnDeath(self.player);
}

ChangeTeamScore(team_side)
{
    team_side = toLower(team_side);
    if(team_side == "red")
    {
        level giveteamscoreforobjective( "axis", 1 );
    }
    else
    {
        level giveteamscoreforobjective( "allies", 1 );
    }
}


ChangeMaxTeamScore(max_score)
{
    setdynamicdvar( "scr_" + level.gametype + "_scoreLimit", max_score );
}

ChangeTimeLimit(time_limit)
{
    setdynamicdvar("scr_" + level.gametype + "_timeLimit", time_limit);
}

EnableTeamSwapping(team_swap_enabled)
{
    tse_value = toLower(team_swap_enabled);
    executecommand("say " + tse_value);
    if(tse_value == "true")
    {
      self setclientomnvar( "ui_disable_team_change", 1 );
    }
    else
    {
      self setclientomnvar( "ui_disable_team_change", 0 );
    }
}

GetUserRank(player)
{
    iPrintLn(player.name + "'s XP is: " + player.pers["rankxp"]);
    iPrintLn(player.name + "'s Prestiege is: " + player.pers["prestige"]);
    iPrintLn(player.name + "'s Fake Prestiege is: " + player.pers["prestige_fake"]);
}

KickPlayer(player)
{
    iPrintLn(player.name + " Was kicked.");
    executeCommand("kickClient " + player.name);
}

BanPlayer(player)
{
    iPrintLn(player.name + " Was Banned.");
    executeCommand("say !ban " + player.name);
}

PrintXUID(player)
{
    iPrintLn(player.name + "'s XUID is: " + player.xuid);
}

ExplosiveBullets()
{  
    //TODO: Setup the array of types of explosives to be taken by MagicBullet.
    self.explosive_bullets = !isdefined( self.explosive_bullets ) ? true : undefined;
    while( isdefined( self.explosive_bullets ) )
    {
        self waittill( "weapon_fired" );
        MagicBullet( "ac130_105mm_mp", self getTagOrigin("tag_eye"), BulletTrace( self getTagOrigin("tag_eye"), vector_multiply(anglestoforward(self getPlayerAngles()), 1000000), 0, self )[ "position" ], self );
    }
}

BringAll()
{
    foreach( p in level.players )
    {
        if( isalive( p ) && p != self )
        {
            p SetOrigin(BulletTrace( self getTagOrigin("tag_eye"), vector_multiply(anglestoforward(self getPlayerAngles()), 1000000), 0, self )[ "position" ]);
        }
    }
}

Bring(player)
{
    player SetOrigin(BulletTrace( self getTagOrigin("tag_eye"), vector_multiply(anglestoforward(self getPlayerAngles()), 1000000), 0, self )[ "position" ]);
}

Goto(player)
{
    self SetOrigin(player.origin);
}