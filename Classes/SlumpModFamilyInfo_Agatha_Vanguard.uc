class SlumpModFamilyInfo_Agatha_Vanguard extends AOCFamilyInfo_Agatha_Vanguard;

DefaultProperties
{

	NewPrimaryWeapons.empty;
	NewPrimaryWeapons(0)=(CWeapon=class'SlumpModWeapon_Greatsword',CorrespondingDuelProp=EDUEL_GreatswordUse)
	NewPrimaryWeapons(1)=(CWeapon=class'SlumpModWeapon_Claymore',CorrespondingDuelProp=EDUEL_ClaymoreUse)
	NewPrimaryWeapons(2)=(CWeapon=class'SlumpModWeapon_Zweihander',CorrespondingDuelProp=EDUEL_ZweihanderUse)
	NewPrimaryWeapons(3)=(CWeapon=class'SlumpModWeapon_Bardiche',CorrespondingDuelProp=EDUEL_BardicheUse)
	NewPrimaryWeapons(4)=(CWeapon=class'SlumpModWeapon_Bill',CorrespondingDuelProp=EDUEL_BillUse)
	NewPrimaryWeapons(5)=(CWeapon=class'SlumpModWeapon_Halberd',CorrespondingDuelProp=EDUEL_HalberdUse)
	NewPrimaryWeapons(6)=(CWeapon=class'SlumpModWeapon_PoleHammer',CorrespondingDuelProp=EDUEL_PoleHammerUse)
	
	NewSecondaryWeapons.empty;

	NewSecondaryWeapons(0)=(CWeapon=class'SlumpModWeapon_Saber')
	NewSecondaryWeapons(1)=(CWeapon=class'SlumpModWeapon_Cudgel')
	NewSecondaryWeapons(2)=(CWeapon=class'SlumpModWeapon_Hatchet')
	NewSecondaryWeapons(3)=(CWeapon=class'SlumpModWeapon_WarAxe')
	NewSecondaryWeapons(4)=(CWeapon=class'SlumpModWeapon_Dane')
	NewSecondaryWeapons(5)=(CWeapon=class'SlumpModWeapon_Falchion')
	NewSecondaryWeapons(6)=(CWeapon=class'SlumpModWeapon_Dagesse')

	DamageResistances(EDMG_Swing) = 0.6
	DamageResistances(EDMG_Pierce) = 0.8
	DamageResistances(EDMG_Blunt) = 0.7


	NewTertiaryWeapons.empty;
	NewTertiaryWeapons(0)=(CWeapon=class'SlumpModWeapon_HuntingKnife',CorrespondingDuelProp=EDUEL_HuntingKnifeUse)
	NewTertiaryWeapons(1)=(CWeapon=class'SlumpModWeapon_Heater_Agatha',bEnabledDefault=true)
	NewTertiaryWeapons(2)=(CWeapon=class'SlumpModWeapon_Kite_Agatha',bEnabledDefault=true)
	NewTertiaryWeapons(3)=(CWeapon=class'SlumpModWeapon_Buckler_Agatha',bEnabledDefault=true)


	bCanSprintAttack=false

	ProjectileLocationModifiers(EHIT_Head) = 1.5
	ProjectileLocationModifiers(EHIT_Torso) = 1
	ProjectileLocationModifiers(EHIT_Arm) = 1
	CrossbowLocationModifiers(EHIT_Head) = 2
	CrossbowLocationModifiers(EHIT_Torso) = 1
	CrossbowLocationModifiers(EHIT_Arm) = 1


}
