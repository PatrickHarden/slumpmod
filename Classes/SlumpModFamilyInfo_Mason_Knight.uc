class SlumpModFamilyInfo_Mason_Knight extends AOCFamilyInfo_Mason_Knight;

DefaultProperties
{

	NewPrimaryWeapons.empty;
	NewPrimaryWeapons(0)=(CWeapon=class'SlumpModWeapon_DoubleAxe')
	NewPrimaryWeapons(1)=(CWeapon=class'SlumpModWeapon_PoleAxe')
	NewPrimaryWeapons(2)=(CWeapon=class'SlumpModWeapon_Bearded')
	NewPrimaryWeapons(3)=(CWeapon=class'SlumpModWeapon_WarHammer')
	NewPrimaryWeapons(4)=(CWeapon=class'SlumpModWeapon_Maul')
	NewPrimaryWeapons(5)=(CWeapon=class'SlumpModWeapon_GrandMace')
	NewPrimaryWeapons(6)=(CWeapon=class'SlumpModWeapon_Longsword')
	NewPrimaryWeapons(7)=(CWeapon=class'SlumpModWeapon_SwordOfWar')
	NewPrimaryWeapons(8)=(CWeapon=class'SlumpModWeapon_Messer')
	


	NewSecondaryWeapons.empty;
	NewSecondaryWeapons(0)=(CWeapon=class'SlumpModWeapon_Mace')
	NewSecondaryWeapons(1)=(CWeapon=class'SlumpModWeapon_MorningStar')
	NewSecondaryWeapons(2)=(CWeapon=class'SlumpModWeapon_HolyWaterSprinkler')
	NewSecondaryWeapons(3)=(CWeapon=class'SlumpModWeapon_Saber')
	NewSecondaryWeapons(4)=(CWeapon=class'SlumpModWeapon_Falchion')
	NewSecondaryWeapons(5)=(CWeapon=class'SlumpModWeapon_Hatchet')
	NewSecondaryWeapons(6)=(CWeapon=class'SlumpModWeapon_WarAxe')
	NewSecondaryWeapons(7)=(CWeapon=class'SlumpModWeapon_Dane')
	NewSecondaryWeapons(8)=(CWeapon=class'SlumpModWeapon_Cudgel')

	NewTertiaryWeapons.empty;
	NewTertiaryWeapons(0)=(CWeapon=class'SlumpModWeapon_HuntingKnife',CorrespondingDuelProp=EDUEL_HuntingKnifeUse)
	NewTertiaryWeapons(1)=(CWeapon=class'SlumpModWeapon_Heater_Mason',bEnabledDefault=true)
	NewTertiaryWeapons(2)=(CWeapon=class'SlumpModWeapon_Kite_Mason',bEnabledDefault=true)
	NewTertiaryWeapons(3)=(CWeapon=class'SlumpModWeapon_Buckler_Mason',bEnabledDefault=true)
	NewTertiaryWeapons(4)=(CWeapon=class'SlumpModWeapon_TowerShield_Mason',bEnabledDefault=true)
	


	ProjectileLocationModifiers(EHIT_Head) = 1.5
	ProjectileLocationModifiers(EHIT_Torso) = 1
	ProjectileLocationModifiers(EHIT_Arm) = 1


	CrossbowLocationModifiers(EHIT_Head) = 2
	CrossbowLocationModifiers(EHIT_Torso) = 1.2
	CrossbowLocationModifiers(EHIT_Arm) = 1.2


}
