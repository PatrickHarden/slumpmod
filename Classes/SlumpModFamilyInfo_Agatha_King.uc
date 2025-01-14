/**
* Copyright 2010-2012, Torn Banner Studios, All rights reserved
*
* Original Author: Michael Bao
*
* King Class. For Assassination Objective.
*/
class SlumpModFamilyInfo_Agatha_King extends AOCFamilyInfo_Agatha_King;

DefaultProperties
{
	FamilyID="King"
	Health=1000
	bCanHealthRegen = false;
	ProjectileLocationModifiers(EHIT_Head) = 1.0

	KillBonus = 75
	AssistBonus = 15
	ClassReference=ECLASS_King
}
