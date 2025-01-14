/**
* Copyright 2010-2012, Torn Banner Studios, All rights reserved
* 
* Original Author: Michael Bao
* 
* The Weapon Attachment for the Thrown Axe.
*/
class SlumpModWeaponAttachment_ThrownAxe extends AOCWeaponAttachment_ThrownAxe;

DefaultProperties
{
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'WP_throw_axe.wep_throwingAxe'
	End Object

	Begin Object Name=SkeletalMeshComponent2
		SkeletalMesh=SkeletalMesh'WP_throw_axe.wep_throwingAxe'
	End Object

	WeaponID=EWEP_ThrownAxe
	WeaponSocket=wep1hpoint
	WeaponClass=class'AOCWeapon_ThrowingAxe'

	WeaponStaticMeshScale=1

	AttackTypeInfo(0)=(fBaseDamage=20.0, fForce=22500, cDamageType="AOC.AOCDmgType_Generic", iWorldHitLenience=6)
	AttackTypeInfo(1)=(fBaseDamage=20.0, fForce=22500, cDamageType="AOC.AOCDmgType_Generic", iWorldHitLenience=6)
	AttackTypeInfo(2)=(fBaseDamage=20.0, fForce=22500, cDamageType="AOC.AOCDmgType_Generic", iWorldHitLenience=6)
	AttackTypeInfo(3)=(fBaseDamage=20.0, fForce=22500, cDamageType="AOC.AOCDmgType_Generic", iWorldHitLenience=6)
	AttackTypeInfo(4)=(fBaseDamage=1.0, fForce=22500, cDamageType="AOC.AOCDmgType_Generic", iWorldHitLenience=6)
	AttackTypeInfo(5)=(fBaseDamage=5.0, fForce=45500.0, cDamageType="AOC.AOCDmgType_Shove", iWorldHitLenience=12)

	Skins(0)={(
		SkeletalMeshPath="WP_throw_axe.wep_throwingAxe",
		StaticMeshPath="WP_throw_axe.WarAxe",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="UI_CustWeaponImages_SWF.skin_throwingAxe_png"
		)};

	Skins(1)={(
		SkeletalMeshPath="wp_throw_axe_variant_01.Wep_ThrowingAxe_Variant_01", 
		StaticMeshPath="wp_throw_axe_variant_01.sm_throwingAxe_Variant_01",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="UI_CustWeaponImages_SWF.skin_reiver_throwingAxe_png"
		)};
	Skins(2)={(
		SkeletalMeshPath="WP_throw_axe_Variant_02.WEP_Throwingaxe_shaver", 
		StaticMeshPath="WP_throw_axe_Variant_02.SM_Throwingaxe_shaver",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="UI_CustWeaponImages_SWF.skin_shaver_png"
		)};
}
