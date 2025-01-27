/**
* Copyright 2010-2012, Torn Banner Studios, All rights reserved
* 
* Original Author: Michael Bao
* 
* The weapon that is replicated to all clients: Maul
*/
class SlumpModWeaponAttachment_Maul extends AOCWeaponAttachment_Maul;

simulated function float GetHandleTracerPercent(int i)
{
    local vector vStart, vMid, vEnd;
    local float HandleLength, WeaponLength;

    if (Mesh.GetSocketByName('TraceMid') == None)
    {
        return 0.0f;
    }
    Mesh.GetSocketWorldLocationAndRotation('TraceStart', vStart);
    Mesh.GetSocketWorldLocationAndRotation('TraceMid', vMid);
    Mesh.GetSocketWorldLocationAndRotation('TraceEnd', vEnd);

    WeaponLength = VSize(vEnd - vStart);
    HandleLength = VSize(vMid - vStart);

    return (HandleLength / WeaponLength)/2;
}


DefaultProperties
{

KickOffset=(X=50, Y=0, Z=-65)
	KickSize=20.f

	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'WP_hbl_Maul.WEP_Maul'
		Scale=1.05
	End Object

	Begin Object Name=SkeletalMeshComponent2
		SkeletalMesh=SkeletalMesh'WP_hbl_Maul.WEP_Maul'
		Scale=1.05
	End Object

	WeaponID=EWEP_Maul
	WeaponClass=class'SlumpModWeapon_Maul'

	WeaponSocket=wep2haxepoint
	bUseAlternativeKick=true

	WeaponStaticMeshScale=1

	AttackTypeInfo(0)=(fBaseDamage=100, fForce=32000, cDamageType="AOC.AOCDmgType_Blunt", iWorldHitLenience=6)
	AttackTypeInfo(1)=(fBaseDamage=132.0, fForce=18000, cDamageType="AOC.AOCDmgType_Blunt", iWorldHitLenience=6)
	AttackTypeInfo(2)=(fBaseDamage=45.0, fForce=32000, cDamageType="AOC.AOCDmgType_Blunt", iWorldHitLenience=6)
	AttackTypeInfo(3)=(fBaseDamage=120.0, fForce=22500, cDamageType="AOC.AOCDmgType_Blunt", iWorldHitLenience=6)
	AttackTypeInfo(4)=(fBaseDamage=1.0, fForce=40000, cDamageType="AOC.AOCDmgType_Blunt", iWorldHitLenience=6)
	AttackTypeInfo(5)=(fBaseDamage=5.0, fForce=45500.0, cDamageType="AOC.AOCDmgType_Shove", iWorldHitLenience=12)

	Skins(0)={(
		SkeletalMeshPath="WP_hbl_Maul.WEP_Maul",
		StaticMeshPath="WP_hbl_Maul.SM_Maul",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="UI_CustWeaponImages_SWF.skin_maul_png"
		)};
	Skins(1)={(
		SkeletalMeshPath="WP_hbl_Maul.WEP_Maul",
		StaticMeshPath="WP_hbl_Maul.SM_Maul",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="UI_CustWeaponImages_SWF.skin_avians_rage_maul_png"
		)};
	Skins(2)={(
		SkeletalMeshPath="WP_hbl_Maul.WEP_Maul",
		StaticMeshPath="WP_hbl_Maul.SM_Maul",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="UI_CustWeaponImages_SWF.skin_pulverizer_png"
		)};
	Skins(3)={(
		SkeletalMeshPath="WP_hbl_Maul.WEP_Maul",
		StaticMeshPath="WP_hbl_Maul.SM_Maul",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="UI_CustWeaponImages_SWF.skin_guiltyGavel_png"
		)};
	Skins(4)={(
		SkeletalMeshPath="WP_hbl_Maul_Variant_04.WEP_Maul_Variant",
		StaticMeshPath="WP_hbl_Maul_Variant_04.SM_Maul_Variant",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="UI_CustWeaponImages_SWF.skin_maulverizer_png"
		)};
	Skins(5)={(
		SkeletalMeshPath="WP_hbl_Maul_Variant_05.WEP_SpikedMaul",
		StaticMeshPath="WP_hbl_Maul_Variant_05.SM_SpikedMaul",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="UI_CustWeaponImages_SWF.skin_spiked_maul_png"
		)};
	Skins(6)={(
		SkeletalMeshPath="WP_hbl_Maul.WEP_Maul",
		StaticMeshPath="WP_hbl_Maul.SM_Maul",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="UI_CustWeaponImages_SWF.skin_gothic_maul_png"
		)};

}