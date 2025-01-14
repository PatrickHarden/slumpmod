/**
* Copyright 2010-2012, Torn Banner Studios, All rights reserved
* 
* Original Author: Michael Bao
* 
* The weapon that is replicated to all clients: Sword Of War 1H
*/
class SlumpModWeaponAttachment_SwordOfWar1H extends AOCWeaponAttachment_SwordOfWar1H;

DefaultProperties
{

KickOffset=(X=50, Y=0, Z=-65)
	KickSize=20.f

	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'WP_15hs_Longsword.WEP_Longsword'
	End Object

	Begin Object Name=SkeletalMeshComponent2
		SkeletalMesh=SkeletalMesh'WP_15hs_Longsword.WEP_Longsword'
	End Object

	WeaponID=EWEP_SwordOfWar
	WeaponClass=class'SlumpModWeapon_SwordOfWar1H'
	WeaponSocket=wep1hpoint

	bUseAlternativeKick=true

	WeaponStaticMeshScale=1

	AttackTypeInfo(0)=(fBaseDamage=55.0, fForce=9600, cDamageType="AOC.AOCDmgType_Swing", iWorldHitLenience=6)
	AttackTypeInfo(1)=(fBaseDamage=60.0, fForce=9600, cDamageType="AOC.AOCDmgType_Swing", iWorldHitLenience=6)
	AttackTypeInfo(2)=(fBaseDamage=60.0, fForce=24000, cDamageType="AOC.AOCDmgType_Pierce", iWorldHitLenience=6)
	AttackTypeInfo(3)=(fBaseDamage=0.0, fForce=22500, cDamageType="AOC.AOCDmgType_Swing", iWorldHitLenience=6)
	AttackTypeInfo(4)=(fBaseDamage=0.0, fForce=22500, cDamageType="AOC.AOCDmgType_Swing", iWorldHitLenience=6)
	AttackTypeInfo(5)=(fBaseDamage=5.0, fForce=45500.0, cDamageType="AOC.AOCDmgType_Shove", iWorldHitLenience=12)

	Skins(0)={(
		SkeletalMeshPath="WP_15hs_SwordOfWar.WEP_SwordOfWar",
		StaticMeshPath="WP_15hs_SwordOfWar.swordofwar",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="ui_custweaponimages_swf.skin_sword_of_war_png"
		)};
	Skins(1)={(
		SkeletalMeshPath="WP_15hs_SwordOfWar_Variant_01.WEP_FinalGuardSword",
		StaticMeshPath="WP_15hs_SwordOfWar_Variant_01.SM_FinalGuardSword",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="ui_custweaponimages_swf.skin_final_guard_png"
		)};
	Skins(2)={(
		SkeletalMeshPath="wp_15hs_swordofwar_varaint_02.wep_swordofwar_variant_01",
		StaticMeshPath="wp_15hs_swordofwar_varaint_02.sm_swordofwar_variant_01",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="ui_custweaponimages_swf.skin_winterSoldier_png"
		)};
	Skins(3)={(
		SkeletalMeshPath="WP_15hs_SwordOfWar_Variant_04.wep_wkswordofwar",
		StaticMeshPath="WP_15hs_SwordOfWar_Variant_04.SM_wkswordofwar",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="ui_custweaponimages_swf.skin_whiteKnight_swordofWar_png"
		)};
	Skins(4)={(
		SkeletalMeshPath="WP_15hs_SwordOfWar_Variant_05.WEP_DuererSword",
		StaticMeshPath="WP_15hs_SwordOfWar_Variant_05.SM_DuererSword",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="ui_custweaponimages_swf.skin_durer_sword_png"
		)};
	Skins(5)={(
		SkeletalMeshPath="WP_15hs_SwordOfWar.WEP_SwordOfWar",
		StaticMeshPath="WP_15hs_SwordOfWar.swordofwar",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="ui_custweaponimages_swf.skin_whitewolf_png"
		)};
	Skins(6)={(
		SkeletalMeshPath="Wp_15hs_SwordOfWar_Variant_06.wep_swordofwar_Reva",
		StaticMeshPath="Wp_15hs_SwordOfWar_Variant_06.SM_swordofwar_Reva",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="ui_custweaponimages_swf.skin_revenantsword_png"
		)};
}
