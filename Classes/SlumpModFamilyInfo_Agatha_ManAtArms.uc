class SlumpModFamilyInfo_Agatha_ManAtArms extends AOCFamilyInfo_Agatha_ManAtArms;

DefaultProperties
{

	NewPrimaryWeapons.empty;
	NewPrimaryWeapons(0)=(CWeapon=class'SlumpModWeapon_Broadsword')
	NewPrimaryWeapons(1)=(CWeapon=class'SlumpModWeapon_NorseSword')
	NewPrimaryWeapons(2)=(CWeapon=class'SlumpModWeapon_Falchion',CorrespondingDuelProp=EDUEL_FalchionUse)
	NewPrimaryWeapons(3)=(CWeapon=class'SlumpModWeapon_WarAxe',CorrespondingDuelProp=EDUEL_WarAxeUse)
	NewPrimaryWeapons(4)=(CWeapon=class'SlumpModWeapon_Dane',CorrespondingDuelProp=EDUEL_DaneUse)
	NewPrimaryWeapons(5)=(CWeapon=class'SlumpModWeapon_Mace',CorrespondingDuelProp=EDUEL_MaceUse)
	NewPrimaryWeapons(6)=(CWeapon=class'SlumpModWeapon_MorningStar',CorrespondingDuelProp=EDUEL_MorningStarUse)
	NewPrimaryWeapons(7)=(CWeapon=class'SlumpModWeapon_HolyWaterSprinkler',CorrespondingDuelProp=EDUEL_HolyWaterSprinklerUse)
	NewPrimaryWeapons(8)=(CWeapon=class'SlumpModWeapon_QuarterStaff',CorrespondingDuelProp=EDUEL_QStaffUse)
	
	
	NewSecondaryWeapons.empty;
	NewSecondaryWeapons(0)=(CWeapon=class'SlumpModWeapon_Saber')
	NewSecondaryWeapons(1)=(CWeapon=class'SlumpModWeapon_Cudgel')
	NewSecondaryWeapons(2)=(CWeapon=class'SlumpModWeapon_Hatchet')
	NewSecondaryWeapons(3)=(CWeapon=class'SlumpModWeapon_Dagesse')

	NewTertiaryWeapons.empty;
	NewTertiaryWeapons(0)=(CWeapon=class'SlumpModWeapon_ThrowingKnife')
	NewTertiaryWeapons(1)=(CWeapon=class'SlumpModWeapon_ThrowingAxe')
	NewTertiaryWeapons(2)=(CWeapon=class'SlumpModWeapon_Heater_Agatha',bEnabledDefault=true)
	NewTertiaryWeapons(3)=(CWeapon=class'SlumpModWeapon_Buckler_Agatha',bEnabledDefault=true)
	bCanDodge=true

	ProjectileLocationModifiers(EHIT_Head) = 1.5
	ProjectileLocationModifiers(EHIT_Torso) = 1
	ProjectileLocationModifiers(EHIT_Arm) = 1
	CrossbowLocationModifiers(EHIT_Head) = 2
	CrossbowLocationModifiers(EHIT_Torso) = 1
	CrossbowLocationModifiers(EHIT_Arm) = 1
	
	// damage modifiers
	DamageResistances(EDMG_Swing) = 0.8
	DamageResistances(EDMG_Pierce) = 0.85
	DamageResistances(EDMG_Blunt) = 0.65
	

	BACK_MODIFY=0.8

	AccelRate=600.0
	iDodgeCost=25

}
