class SlumpModFamilyInfo_Mason_Archer extends AOCFamilyInfo_Mason_Archer;

DefaultProperties
{
	NewPrimaryWeapons.empty;
	NewPrimaryWeapons(0)=(CWeapon=class'SlumpModWeapon_Brandistock',CorrespondingDuelProp=EDUEL_BrandistockUse)
	NewPrimaryWeapons(1)=(CWeapon=class'SlumpModWeapon_Spear',CorrespondingDuelProp=EDUEL_SpearUse)
	NewPrimaryWeapons(2)=(CWeapon=class'SlumpModWeapon_Fork',CorrespondingDuelProp=EDUEL_ForkUse)
	NewPrimaryWeapons(3)=(CWeapon=class'SlumpModWeapon_Longbow',CForceTertiary=(class'AOCWeapon_ProjBodkin', class'AOCWeapon_ProjBroadhead'))
	NewPrimaryWeapons(4)=(CWeapon=class'SlumpModWeapon_Shortbow',CForceTertiary=(class'AOCWeapon_ProjBodkin', class'AOCWeapon_ProjBroadhead'))
	NewPrimaryWeapons(5)=(CWeapon=class'SlumpModWeapon_Warbow',CForceTertiary=(class'AOCWeapon_ProjBodkin', class'AOCWeapon_ProjBroadhead'))

	NewSecondaryWeapons.empty;
	NewSecondaryWeapons(0)=(CWeapon=class'SlumpModWeapon_Saber')
	NewSecondaryWeapons(1)=(CWeapon=class'SlumpModWeapon_Cudgel')
	NewSecondaryWeapons(2)=(CWeapon=class'SlumpModWeapon_Hatchet')
	NewSecondaryWeapons(3)=(CWeapon=class'SlumpModWeapon_Dagesse')


	NewTertiaryWeapons.empty;
	NewTertiaryWeapons(0)=(CWeapon=class'AOCWeapon_ProjBodkin'bEnabledDefault=false)
	NewTertiaryWeapons(1)=(CWeapon=class'AOCWeapon_ProjBroadhead'bEnabledDefault=false)
	


	ProjectileLocationModifiers(EHIT_Head) = 2.5
	ProjectileLocationModifiers(EHIT_Torso) = 2.0
	ProjectileLocationModifiers(EHIT_Arm) = 2.0
	CrossbowLocationModifiers(EHIT_Head) = 2.5
	CrossbowLocationModifiers(EHIT_Torso) = 2.25
	CrossbowLocationModifiers(EHIT_Arm) = 2.25


	DamageResistances(EDMG_Swing) = 0.85
	DamageResistances(EDMG_Pierce) = 0.85
	DamageResistances(EDMG_Blunt) = 0.65

	AirSpeed=440.0
	WaterSpeed=220.0
	AirControl=0.35
	GroundSpeed=190.0
	AccelRate=500.0
	SprintAccelRate=100.0
	JumpZ=380.0
	SprintModifier=1.65
	SprintTime=10.0
	DodgeSpeed=400.0
	DodgeSpeedZ=200.0
	Health=100
	BACK_MODIFY=0.8
	STRAFE_MODIFY=0.85
	FORWARD_MODIFY=1.0
	CROUCH_MODIFY=0.65
	MaxSprintSpeedTime=3.5
	bCanDodge=false
	iKickCost=25
	iDodgeCost=40
	fComboAggressionBonus=1.0
	fBackstabModifier=1.0
	iMissMeleeStrikePenalty=10
	iMissMeleeStrikePenaltyBonus=0
	bCanSprintAttack=false
	fStandingSpread=0.05f
	fCrouchingSpread=0.0f
	fWalkingSpread=0.1
	fSprintingSpread=0.25
	fFallingSpread=0.25
	fSpreadPenaltyPerSecond=0.5
	fSpreadRecoveryPerSecond=0.3


}
