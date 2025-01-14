/**
* Copyright 2010-2012, Torn Banner Studios, All rights reserved
* 
* Original Author: Michael Bao
* 
* Weapon Attachment: Throwing Knife.
*/
class SlumpModWeaponAttachment_ThrowingKnife extends AOCWeaponAttachment_ThrowingKnife;

DefaultProperties
{
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'WP_throw_knife.wep_throwingKnife'
	End Object

	Begin Object Name=SkeletalMeshComponent2
		SkeletalMesh=SkeletalMesh'WP_throw_knife.wep_throwingKnife'
	End Object

	WeaponID=EWEP_ThrownKnife
	WeaponSocket=wepThrowKPoint
	WeaponClass=class'AOCWeapon_ThrowingKnife'

	WeaponStaticMeshScale=1

	AttackTypeInfo(0)=(fBaseDamage=20.0, fForce=22500, cDamageType="AOC.AOCDmgType_Generic", iWorldHitLenience=6)
	AttackTypeInfo(1)=(fBaseDamage=20.0, fForce=22500, cDamageType="AOC.AOCDmgType_Generic", iWorldHitLenience=6)
	AttackTypeInfo(2)=(fBaseDamage=20.0, fForce=22500, cDamageType="AOC.AOCDmgType_Generic", iWorldHitLenience=6)
	AttackTypeInfo(3)=(fBaseDamage=20.0, fForce=22500, cDamageType="AOC.AOCDmgType_Generic", iWorldHitLenience=6)
	AttackTypeInfo(4)=(fBaseDamage=1.0, fForce=22500, cDamageType="AOC.AOCDmgType_Generic", iWorldHitLenience=6)
	AttackTypeInfo(5)=(fBaseDamage=5.0, fForce=45500.0, cDamageType="AOC.AOCDmgType_Shove", iWorldHitLenience=12)

	Skins(0)={(
		SkeletalMeshPath="WP_throw_knife.wep_throwingKnife",
		StaticMeshPath="WP_throw_knife.ThrowingKnife_3rdP",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="UI_CustWeaponImages_SWF.skin_throwingKnife_png"
		)};
	Skins(1)={(
		SkeletalMeshPath="WP_throw_knife_Variation_01.wep_throwingKnife",
		StaticMeshPath="wp_throw_knife_variation_01.wep_throwingKnife_LOD2",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="UI_CustWeaponImages_SWF.skin_hedgetrimmer_blade_png"
		)};
}
