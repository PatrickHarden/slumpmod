/**
* Copyright 2010-2012, Torn Banner Studios, All rights reserved
* 
* Original Author: Michael Bao
* 
* The base weapon class for melee weapons.
*/
class SlumpModMeleeWeapon extends AOCMeleeWeapon
	dependson(AOCPawn)
	abstract;

var float altRiposteExtraWindup;
var float fFlinchStateStartTime;
var int MissCount;

simulated function float GetStaminaLossForMiss()
{
	local float StaminaLoss;
	if (!bTwoHander)
		StaminaLoss = AOCOwner.PawnFamily.iMissMeleeStrikePenaltyBonus;
	else
		StaminaLoss = AOCOwner.PawnFamily.iMissMeleeStrikePenaltyBonus + 5;
	return StaminaLoss;
}

simulated state Release
{
	simulated function ActivateHitAnim(EDirection Direction, bool bSameTeam)
	{
		if (!bSameTeam)
		{
			// Disallow comboing when hit
			ClientSetHit(true);
		}
		super.ActivateHitAnim(Direction, bSameTeam);
	}

	reliable client function ClientSetHit(bool bInRelease)
	{
		bIsInCombo = false;
		eNextAttack = Attack_Null;
		bWasHit = true;
		ServerSetHit();
	}

	reliable server function ServerSetHit()
	{
		bIsInCombo = false;
		eNextAttack = Attack_Null;
		global.ServerSetHit();
	}

	/** When finished with windup go to the next state */
	simulated function OnStateAnimationEnd()
	{
		//`log("RELEASE STATE ANIMATION END"@bWantsToCombo@bIsInCombo);
		// record what attack we just performed - mainly used for combo
		ePreviousAttack = EAttack(CurrentFireMode);

		// handle combo started from windup right before we start
		if (bWantsToCombo)
		{
			bWantsToCombo = false;
			HandleCombo(eNextAttack);
		}

		if (bPlayNoComboGrunt)
		{
			AOCOwner.PlayLowStaminaGrunt();
			bPlayNoComboGrunt = false;
		}

		if (bIsInCombo)
		{
			//`log("GO TO STATE TRANSITION");
			GotoState('Transition'); // each combo has a transition animation
		}
		else
			super.OnStateAnimationEnd(); // default when not comboing
	}

	/** When ending state clear weapon attachment state */
	simulated function EndState( name NextStateName )
	{
		local float CurrentStamina;
		local float StaminaLoss;

		CurrentStamina = AOCOwner.Stamina;

		if (AOCOwner.IsLocallyControlled() || AOCOwner.bIsBot)
		{
			if (bHitPawn)
			{
				//Inform Pawn that the attack was successful
				if(CurrentFireMode >= Attack_Slash && CurrentFireMode <= Attack_Sprint)
				{
					AOCOwner.OnActionSucceeded(EPlayerAction(CurrentFireMode + EACT_AttackSlash));
				}
				else if(CurrentFireMode == Attack_Shove)
				{
					if(AOCOwner.StateVariables.bShieldEquipped)
					{
						AOCOwner.OnActionSucceeded(EACT_ShieldBash);
					}
					else
					{
						AOCOwner.OnActionSucceeded(EACT_Kick);
					}
				}
				ComboHitCount++;

				AOCowner.NotifyScoreHit();
			}
			else
			{
				//Inform Pawn that the attack failed
				if(CurrentFireMode >= Attack_Slash && CurrentFireMode <= Attack_Sprint)
				{
					AOCOwner.OnActionFailed(EPlayerAction(CurrentFireMode + EACT_AttackSlash));
				}
				else if(CurrentFireMode == Attack_Shove)
				{
					if(AOCOwner.StateVariables.bShieldEquipped)
					{
						AOCOwner.OnActionFailed(EACT_ShieldBash);
					}
					else
					{
						AOCOwner.OnActionFailed(EACT_Kick);
					}
				}
			
				if (CurrentFireMode != Attack_Parry && NextStateName != 'Flinch' && CurrentFireMode != Attack_Shove && !AOCWepAttachment.bHitDestructibleObject)
				{
					MissCount++;
					AOCOwner.RemoveDebuff(EDEBF_ATTACK);

					StaminaLoss = GetStaminaLossForMiss();

					AOCOwner.S_ConsumeStamina(StaminaLoss);
					CurrentStamina -= StaminaLoss;

				}

				ComboHitCount = 0;
			}
		}
		else
		{
			if (!bHitPawn && bIsInCombo)
			{
				// Calculate stamina loss on server, if it hasn't been updated yet
				StaminaLoss = GetStaminaLossForMiss();

				CurrentStamina = min(CurrentStamina, BeginAttackStamina - StaminaLoss);
			}
		}

		AOCOwner.FinishSprintAttack();
		AOCWepAttachment.GotoState('');
		bParryHitCounter = false;
		super.EndState(NextStateName);

		// put weapon out of attack state
		AOCWepAttachment.bUseAlternativeTracers = false;

		// Check if we still have enough stamina to perform combo
		if (bIsInCombo && CurrentStamina - ComboStaminaCost < 0 || MissCount >= 2)
		{
			MissCount = 0;
			GotoState('Recovery');
		}
	}

	/** Play Release animation */
	simulated function PlayStateAnimation()
	{
		local AnimationInfo Info;
		//`log("RELEASE PLAY STATE ANIMATION");
		if (bIsInCombo)
		{
			// add to number of combos performed
			iComboCount++;
			AOCOwner.OnComboIncreased();

			// pass this information down to the weapon attachment
			AOCWepAttachment.ComboCount = iComboCount;
			AOCWepAttachment.HitComboCount = ComboHitCount;

			if (CurrentFireMode != Attack_Sprint && !AOCOwner.bIsCrouching && AOCOwner.Physics != PHYS_Falling)
			{		
				if (AOCOwner.PawnState != ESTATE_DODGE)
				{
					if (VSize(AOCOwner.Velocity) > 2.0f && !Info.bUseRMM)
						AOCOwner.Lunge(,,true);
					else if (VSize(AOCOwner.Velocity) <= 2.f && !Info.bUseRMM)
						Info.bFullBody = false;
				}
				else
					Info.bFullBody = false;
			}   

			// pass in proper animation, let pawn determine which node to use on the AnimTree
			if (((CurrentFireMode != ePreviousAttack && !bJustPlayedCombo) || (CurrentFireMode == ePreviousAttack && bJustPlayedCombo)))
			{
				// odd sequential attacks should be the normal attack animation
				Info = ReleaseAnimations[CurrentFireMode];
				Info.bFullBody = (!bIsInCombo && !AOCOwner.bIsCrouching);
				AOCWepAttachment.bJustPlayComboAnim = false;
				// Double Check if we're sprinting: First attack in sprint isn't full body
				if (AOCOwner.StateVariables.bIsSprinting && !AOCOwner.bFirstAttackInSprint)
				{
					Info.bFullBody = false;
					AOCOwner.bFirstAttackInSprint= true;
				}

				// Double check dodge
				if (AOCOwner.PawnState == ESTATE_DODGE)
					Info.bFullBody = false;

				Info.bForceSameIndex = bParryHitCounter;
				Info.bUseSlotSystem = false;
				TimeLeftInRelease = GetRealAnimLength(Info);
				AOCOwner.ReplicateCompressedAnimation(Info, EWST_Release, CurrentFireMode);
				bJustPlayedCombo = false;

				// Play Camera Animation
				if ((CurrentFireMode == Attack_Slash || CurrentFireMode == Attack_Overhead) && (AOCOwner.Role < ROLE_Authority || WorldInfo.NetMode == NM_Standalone || (Worldinfo.NetMode == NM_ListenServer && AOCOwner.IsLocallyControlled())) && !AOCOwner.bIsBot)
					AOCPlayerController(AOCOwner.Controller).PlayCustomCamAnim(eNextAttack == Attack_Slash ? PrimaryAttackCam : SecondaryAttackCam);
			}
			else
			{
				// even sequential attacks should be the combo attack animation
				Info = ReleaseAnimations[CurrentFireMode];
				//`log(bEquipShield@"GOING TO PLAY"@Info.AnimationName);
				Info.bCombo = true;
				AOCWepAttachment.bJustPlayComboAnim = true;
				Info.bFullBody = false;
				Info.bForceSameIndex = bParryHitCounter;
				Info.bUseSlotSystem = false;
				TimeLeftInRelease = GetRealAnimLength(Info);
				AOCOwner.ReplicateCompressedAnimation(Info, EWST_Release, CurrentFireMode);
				bJustPlayedCombo = true;	

				if ((CurrentFireMode == Attack_Slash || CurrentFireMode == Attack_Overhead) && (AOCOwner.Role < ROLE_Authority || WorldInfo.NetMode == NM_Standalone || (Worldinfo.NetMode == NM_ListenServer && AOCOwner.IsLocallyControlled())) && !AOCOwner.bIsBot)
					AOCPlayerController(AOCOwner.Controller).PlayCustomCamAnim(eNextAttack == Attack_Slash ? ComboPrimaryAttackCam : ComboSecondaryAttackCam);
			}
		}
		else
		{
			Info = ReleaseAnimations[CurrentFireMode];
			Info.bFullBody = (!bIsInCombo && !AOCOwner.bIsCrouching);
			Info.bCombo = bWindupStartAlternateSide;

			if (bWindupStartAlternateSide)
			{
				bJustPlayedCombo = true;
				bWindupStartAlternateSide = false;
				AOCWepAttachment.bJustPlayComboAnim = true;
			}
			else
			{
				AOCWepAttachment.bJustPlayComboAnim = false;
			}

			// Double Check if we're sprinting: First attack in sprint isn't full body
			if (AOCOwner.StateVariables.bIsSprinting && !AOCOwner.bFirstAttackInSprint)
			{
				Info.bFullBody = false;
				AOCOwner.bFirstAttackInSprint= true;
			}
			Info.bForceFullBody = CurrentFireMode == Attack_Shove || CurrentFireMode == Attack_Sprint;
			Info.bForceSameIndex = bParryHitCounter;
			if (CurrentFireMode == Attack_Shove)
				Info.bUseRMM = true;
			// Double check dodge
			if (AOCOwner.PawnState == ESTATE_DODGE)
				Info.bFullBody = false;
			else
			{
				if (CurrentFireMode != Attack_Sprint && !bIsInCombo && !AOCOwner.bIsCrouching)
				{				
					if (AOCOwner.Physics != PHYS_Falling)
					{
						if (VSize(AOCOwner.Velocity) > 2.0f && !Info.bUseRMM)
						{
							AOCOwner.Lunge();
						}
						else if (VSize(AOCOwner.Velocity) <= 2.f && !Info.bUseRMM)
							Info.bFullBody = false;
					}
				}   
				
				else if (CurrentFireMode == Attack_Sprint)
				{
					AOCOwner.DisableSprint();
					if (!Info.bUseRMM)
					{
						AOCOwner.Lunge();
					}
				}
			}

			// Adjust animation length for quick kick/shove
			if (CurrentFireMode == Attack_Shove && bIsQuickKick)
			{
				Info.fAnimationLength -= 0.05f;
			}

			// Play Camera Animation
			if ((CurrentFireMode == Attack_Slash || CurrentFireMode == Attack_Overhead) && (AOCOwner.Role < ROLE_Authority || WorldInfo.NetMode == NM_Standalone || (Worldinfo.NetMode == NM_ListenServer && AOCOwner.IsLocallyControlled())) && !AOCOwner.bIsBot)
				AOCPlayerController(AOCOwner.Controller).PlayCustomCamAnim(CurrentFireMode == Attack_Slash ? PrimaryAttackCam : SecondaryAttackCam);

			TimeLeftInRelease = GetRealAnimLength(Info);

			AOCOwner.ReplicateCompressedAnimation(Info, EWST_Release, CurrentFireMode);

		}

	}

	/** If we decide to do an attack during the release animation, perform a combo - a parry or shield raise will end the combo */
	simulated function BeginFire(byte FireModeNum)
	{
		super.BeginFire(FireModeNum);
		if (FireModeNum == Attack_Parry && AOCOwner.StateVariables.bCanParry)
			AttackQueue = EAttack(FireModeNum);
		else if (EAttack(FireModeNum) != Attack_Shove && CurrentFireMode != Attack_Sprint)
			HandleCombo(EAttack(FireModeNum));
	}

	/** Handle the eNextAttack if it is set from within windup */
	simulated function HandleCombo(EAttack ComboAttack)
	{
		local bool bHasEnoughStamina;
		
		if (CurrentFireMode == Attack_Shove || CurrentFireMode == Attack_Parry || CurrentFireMode == Attack_Sprint || (CurrentFireMode == Attack_Stab && ComboAttack == Attack_Stab))
			return;

		if (!bCanCombo)
			return;

		if (ComboAttack == Attack_Parry)
			return;

		if (ComboAttack == Attack_AltOverhead)
			ComboAttack = Attack_Overhead;
		else if (ComboAttack == Attack_AltSlash)
			ComboAttack = Attack_Slash;

		if(ComboAttack == CurrentFireMode && iIdenticalCombo >= 3)
		{
			return;
		}

		if (bWasHit)
			return;

		// notify that we're in a combo now if we're not aborting the attack -- double check we're allowed to combo
		if (iComboCount < MaxComboCount)
		{
			bHasEnoughStamina = AOCPawn(Owner).HasEnoughStamina(ComboStaminaCost);
			if (bHasEnoughStamina)
			{
				bIsInCombo = true;
				// record next attack
				eNextAttack = ComboAttack;

				AOCOwner.PlayerHUDStartCombo();
				
				if(iComboCount == 1)
				{
					AOCOwner.OnComboStarted();
				}
			}
			else
			{
				bPlayNoComboGrunt = true;
			}
		}
		else
		{
			bIsInCombo = false;
		}
	}

	/** The user released the mouse button and we should clear shield parry combo */
	simulated function LowerShield()
	{
		if (bIsInCombo && eNextAttack == Attack_Parry) 
		{
			bIsInCombo = false;
			eNextAttack = Attack_Null;
		}

		if (AttackQueue == Attack_Parry && bEquipShield)
		{
			bWantToLowerShield = true;
		}
	}

	/** Check what attack gets funneled into this - if parry go into parry state */
	simulated event BeginState(Name PreviousStateName)
	{
		
		TimeStartRelease = WorldInfo.TimeSeconds;
		if (CurrentFireMode == Attack_Parry)
		{
			if (Role == ROLE_Authority)
				AOCOwner.PauseHealthRegeneration();

			// go into parry
			ActivateParry();
		}
		else
		{
			// weapon attachment into release state
			if (AOCOwner.StateVariables.bShieldEquipped && CurrentFireMode == Attack_Shove)
				AOCWepAttachment.bUseAlternativeTracers = true;
			AOCWepAttachment.SetAttack(EAttack(CurrentFireMode));
			AOCWepAttachment.GotoState('Release');
			super.BeginState(PreviousStateName);
		}

		// set bIsInCombo for reference
		bIsInCombo = false;

		BeginAttackStamina = AOCOwner.Stamina;

		// no more dodge
		AOCOwner.bDodging = false;
		AOCOwner.StateVariables.bIsAttacking = true;

		if (ePreviousAttack == CurrentFireMode)
			iIdenticalCombo++;
		else
			iIdenticalCombo = 1;

		//Inform Pawn that the attack itself has begun
		if(CurrentFireMode >= Attack_Slash && CurrentFireMode <= Attack_Sprint)
		{
			AOCOwner.OnActionInitiated(EPlayerAction(CurrentFireMode + EACT_AttackSlash));
		}
	}
}

DefaultProperties
{
	bCanParry = true;
	bCanCombo = true;
	bJustPlayedCombo = false;
	bWantsToCombo = false
	bIsInCombo = false;
	iComboCount = 1;
	iIdenticalCombo = 1;
	ePreviousAttack = Attack_Null
	iParryCameFromTransition = -1

	FiringStatesArray(0)=Windup
	FiringStatesArray(1)=Windup
	FiringStatesArray(2)=Windup
	FiringStatesArray(3)=Windup
	FiringStatesArray(4)=Release
	FiringStatesArray(5)=Windup

	WeaponFireTypes(0)=EWFT_Custom
	WeaponFireTypes(1)=EWFT_Custom
	WeaponFireTypes(2)=EWFT_Custom
	WeaponFireTypes(3)=EWFT_Custom
	WeaponFireTypes(4)=EWFT_Custom
	WeaponFireTypes(5)=EWFT_Custom

	ShotCost(0)=0
	ShotCost(1)=0
	ShotCost(2)=0
	ShotCost(3)=0
	ShotCost(4)=0
	ShotCost(5)=0

	ImpactBloodTemplates(0)=ParticleSystem'CHV_PlayerParticles.Character.P_BloodSlash'
	ImpactBloodTemplates(1)=ParticleSystem'CHV_PlayerParticles.Character.P_BloodSlash'
	ImpactBloodTemplates(2)=ParticleSystem'CHV_PlayerParticles.Character.P_BloodSlash'

	BloodSprayTemplates(0)=ParticleSystem'CHV_PlayerParticles.Character.P_BloodSlash'
	BloodSprayTemplates(1)=ParticleSystem'CHV_PlayerParticles.Character.P_BloodSlash'
	BloodSprayTemplates(2)=ParticleSystem'CHV_PlayerParticles.Character.P_BloodSlash'

	AttackQueue=Attack_Null
	bAllowedToParry=true

	SprintAttackLunge=500.0f
	SprintAttackLungeZ=250.0f
	bAttachShieldDefault=true
	bParryAttackQueueNoMore=false
	TimeLeftInRelease=0.f
	TimeStartRelease=0.f
	bManualAllowQueue=false
	bAllowAttackOutOfShield=false
	bCanParryHitCounter=true

	PrimaryAttackCam=none
	SecondaryAttackCam=none
	TertiaryAttackCam=none
	ComboPrimaryAttackCam=none
	ComboSecondaryAttackCam=none
	ComboTertiaryAttackCAm=none

	PrimaryAttackCamWindup=none
	SecondaryAttackCamWindup=none
	TertiaryAttackCamWindup=none

	ComboPrimaryAttackCamWindup=none
	ComboSecondaryAttackCamWindup=none
	ComboTertiaryAttackCAmWindup=none

	bIgnoreAlternate=false
	bWasHit=false
	bPlayNoComboGrunt=false
	bCanPanicParry=false

	ComboToParryStaminaCost = 5
	ComboToParryBlendTime = 0.15f;
	
	altRiposteExtraWindup = 0.89;
	
	NetUpdateFrequency=200
}
