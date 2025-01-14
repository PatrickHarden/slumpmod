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

/** Default Active/Idle state.
 */ 
simulated state Active
{
	/** Initialize the weapon as being active and ready to go. */
	simulated event BeginState(Name PreviousStateName)
	{
		if (bDebugLogs)
			`log("BEGIN ACTIVE"@Class);

		if (AOCOwner == none)
			CacheWeaponReferences();

		SyncServerToState('Active', 0);

		if (Role < ROLE_Authority || WorldInfo.NetMode == NM_STANDALONE || (Worldinfo.NetMode == NM_ListenServer && AOCOwner.IsLocallyControlled()))
		{
			AOCBaseHUD(AOCPlayerController(AOCOwner.Controller).myHUD).TurnOffCrosshair();
			AOCBaseHUD(AOCPlayerController(AOCOwner.Controller).myHUD).TurnOnMeleeCrosshair();
		}

		AOCWepAttachment.GotoState('');

		//`log("############## ACTIVE"@bAttachShieldDefault@AllowedShieldClass@AOCOwner.StateVariables.bShieldEquipped@PreviousStateName);
		if (bAttachShieldDefault && AllowedShieldClass != none && !AOCOwner.StateVariables.bShieldEquipped && PreviousStateName == 'WeaponEquipping' && Role == ROLE_Authority)
		{
			//`log("ATTACH SHIELD DEFAULT");
			AOCOwner.bSwitchingWeapons = true;
			AOCOwner.EquipShield(false);
			//return;
		}
		else if ((!bAttachShieldDefault || AllowedShieldClass == none) && AOCOwner.StateVariables.bShieldEquipped && PreviousStateName == 'WeaponEquipping' && Role == ROLE_Authority)
		{
			//`log("Unequip SHIELD");
			AOCOwner.bSwitchingWeapons = true;
			AOCOwner.EquipShield(false);
			//return;
		}
		else if (AOCOwner.StateVariables.bShieldEquipped && AllowedShieldClass != none && PreviousStateName == 'WeaponEquipping')
		{
			//`log("Handle SHIELD attach");
			AOCOwner.HandleShieldAttach();
		}

		// clear out combo values
		iComboCount = 1;
		AOCOwner.OnComboEnded();
		MissCount = 0;
		iIdenticalCombo = 1;
		ComboHitCount = 0;
		ePreviousAttack = Attack_Null;
		eNextAttack = Attack_Null;
		bJustPlayedCombo = false;
		bIsInCombo = false;
		bWantsToCombo = false;
		AOCWepAttachment.ComboCount = iComboCount;
		AOCWepAttachment.HitComboCount = ComboHitCount;
		SetTimer(3.f, false, 'DisableCombatWalk');
		AOCOwner.StateVariables.bIsAttacking = false;
		bAllowedToParry = true;
		AOCOwner.StateVariables.bCanJump = true;
		AOCOwner.StateVariables.bCanDodge = true;
		AOCOwner.bSwitchingWeapons = false;		
		bIsQuickKick = false;

		if (CurrentFireMode == Attack_Sprint)
		{
			super.BeginState(PreviousStateName);
			return; // don't know if this is necessary, putting it here to be safe
		}
		if (WorldInfo.NetMode != NM_DedicatedServer)
		{
			if (AttackQueue == Attack_Parry)
			{
				CurrentFireMode = AttackQueue;
				AttackQueue = Attack_Null;
				ActivateParry();
				if(WorldInfo.NetMode != NM_Standalone && (Worldinfo.NetMode != NM_ListenServer || !AOCOwner.IsLocallyControlled()))
				{
					ServerActivateParry();
				}
			}
			else if (AttackQueue != Attack_Null)
			{
				if (bDebugLogs)
					`log("FIRE ATTACK QUEUE");
				if ((AttackQueue != Attack_Shove) || (AttackQueue == Attack_Shove && AOCOwner.HasEnoughStamina(AOCOwner.PawnFamily.iKickCost) && !bShoveCooldown))
				{
					CurrentFireMode = AttackQueue;
					BeginFire(AttackQueue);
					if(WorldInfo.NetMode != NM_Standalone && (Worldinfo.NetMode != NM_ListenServer || !AOCOwner.IsLocallyControlled()))
					{
						ServerStartFire(AttackQueue); // sync with server
					}
				}
				else
					super.BeginState(PreviousStateName);
				AttackQueue = Attack_Null;
			}
			else
				super.BeginState(PreviousStateName);
		}
		else
			super.BeginState(PreviousStateName);
	}

	simulated event EndState(Name NextStateName)
	{
		super.EndState(NextStateName);
		ClearTimer('DisableCombatWalk');
	}

	simulated function BeginFire(byte FireModeNum)
	{
		bPlayAlternateAnimation = false;
		if (FireModeNum == Attack_AltSlash)
		{
			bPlayAlternateAnimation = true;
			FireModeNum = Attack_Slash;
		}
		else if (FireModeNum == Attack_AltOverhead)
		{
			bPlayAlternateAnimation = true;
			FireModeNum = Attack_Overhead;
		}

		super.BeginFire(FireModeNum);
	}
}


/* reliable server function ServerStartFire(byte FireModeNum)
{
	// Make sure this flag gets set on server, so the right animation plays
	if ((FireModeNum == Attack_AltSlash || FireModeNum == Attack_AltOverhead || bUseAlternateSide) || bWindupStartAlternateSide == true)
	{
		bPlayAlternateAnimation = true;
		
		
		//additional
		bIgnoreAlternate=false;
		//bUseAlternateSide=true;
		//test
		
		bWindupStartAlternateSide = true;
	}
	else
	{
		bPlayAlternateAnimation = false;
	}

	super.ServerStartFire(FireModeNum);
} */


//stamina changes
simulated function float GetStaminaLossForMiss()
{
	local float StaminaLoss;
	if (!bTwoHander)
		StaminaLoss = AOCOwner.PawnFamily.iMissMeleeStrikePenalty + AOCOwner.PawnFamily.iMissMeleeStrikePenaltyBonus;
	else
		StaminaLoss = AOCOwner.PawnFamily.iMissMeleeStrikePenalty + AOCOwner.PawnFamily.iMissMeleeStrikePenaltyBonus + 5;
	DrawTextOverHead(string(StaminaLoss));
	return StaminaLoss;
}


function DrawTextOverHead(string DebugText)
{
	local color tcolor;
	tcolor.G = 0;
	FlushDebugStrings();
	DrawDebugString(Vect(0, 0, 85.0), DebugText, AOCOwner, tcolor); //off for now
}

/** Release state. User releasing weapon. Ranged weapon firing state.
 *  This state will handle comboing if it is allowed for.
 */
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
		local float AdditionalStaminaLoss;

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
		if (bIsInCombo && CurrentStamina - ComboStaminaCost < 0)
		{
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
		if (bDebugLogs)
			`log("RELEASE:"@CurrentFireMode);

		//`log("Release begin state"@CurrentFireMode@CurrentFireMode == Attack_Parry);
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



//
//Alt Riposte Addition
//


/*

simulated state ParryRelease
{
	//If we decide to do an attack during the recovery, perform the attack upon going back to active
	simulated function BeginFire(byte FireModeNum)
	{
		bPlayAlternateAnimation = false;
		if (FireModeNum == Attack_AltSlash)
		{
			bPlayAlternateAnimation = true;
			//FireModeNum = Attack_Slash;
		}
		else if (FireModeNum == Attack_AltOverhead)
		{
			bPlayAlternateAnimation = true;
			//FireModeNum = Attack_Overhead;
		}
		//super.BeginFire(FireModeNum);
		// Don't attack queue in this state any longer
		//if (!bSuccessfulParry)
		//	AttackQueue = EAttack(FireModeNum);

		if (AOCOwner.IsLocallyControlled())
		{
			if (bSuccessfulParry && !bParryHitCounter)
			{
				if (FireModeNum == Attack_Parry)
				{
					AttackQueue = EAttack(FireModeNum);
					GotoState('Active');
				}
				// Otherwise go into release after a 0.3 second blend
				else if (FireModeNum != Attack_Parry && FireModeNum != Attack_Shove && bCanParryHitCounter) //ripostes
				{
					PerformParryHitCounter(FireModeNum);
				}
			}
		}

	}

	//Play shield equip animation
	simulated function PlayStateAnimation()
	{
		local AnimationInfo Info;
		local float fLength;

		if (bIsComboToParry)
		{
			Info = ReleaseAnimations[Attack_Parry];
			fLength = GetRealAnimLength(Info);

			Info.fBlendListNodeTime = ComboToParryBlendTime;
			Info.fAnimationLength = fLength;
			AOCOwner.ReplicateCompressedAnimation(Info, EWST_Release, Attack_Parry, true);
			bIsComboToParry = false;
		}
		else
		{
			super.PlayStateAnimation();
		}
	}


	simulated function OnStateAnimationEnd()
	{
      //`log("PARRY RELEASE ATTACK ANIM END"@bParryHitCounter@bSuccessfulParry);
		if (bSuccessfulParry && !bParryHitCounter)
			GotoState('Active');
		else if (!bParryHitCounter)
			GotoState('Recovery');
		else
			GotoState('Release');
	}

	simulated event BeginState(Name PreviousStateName)
	{
		bParryHitCounter = false;
		bSuccessfulParry = false;
		super.BeginState(PreviousStateName);
		if (bParryAttackQueueNoMore)
		{
			bWantParryToDrop = true;
		}
		bParryAttackQueueNoMore = false;
	}

	// Successful parry 
	simulated function SuccessfulParry(EAttack Type, int Dir)
	{
		local AnimationInfo Info;
		local EWeaponState MyState;
		local int Indx;
		if (bSuccessfulParry)
			return;

		AOCOwner.OnActionSucceeded(EACT_Block);
		bParryHitCounter = false;
		bSuccessfulParry = true;
		// Play Parry Hit Animation - Probably will change eventually depending on the direction of the attack but choose randomly for now
		Indx = 0;
		Info = ChooseDirParryHitAnim(Type, Dir, MyState, Indx);
		Info.bUseAltNode = false;
		Info.fBlendListNodeTime = 0.f;
		AOCOwner.ReplicateCompressedAnimation(Info, MyState, Indx);
	}

	simulated function LowerShield()
	{
		super.LowerShield();
		//`log("LOWER SHIELD"@AttackQueue@bParryAttackQueueNoMore);
		if (AttackQueue == Attack_Parry)
			bParryAttackQueueNoMore = true;
	}
}
*/

/*
simulated function PerformParryHitCounter(byte FireModeNum)
{
	if ( Role < ROLE_Authority )
	{
		S_PerformParryHitCounter(FireModeNum);
	}
	
	AttackQueue = Attack_Null; //Null out queue so we don't get a queued attack happening after this attack
	bParryHitCounter = true;
	bIsQuickKick = false;
	
	//controls the side of release
	if ((FireModeNum==Attack_AltOverhead || FireModeNum==Attack_AltSlash) || bPlayAlternateAnimation || bUseAlternateSide)
	{
		//test
		bIgnoreAlternate=false;
		bUseAlternateSide=true;
		bPlayAlternateAnimation=true;
		//test
		
		bWindupStartAlternateSide = true;
		
		//ReplicatedAnimation.bUseAltNode = true; // added
		//Info.AnimationName = Info.AlternateAnimation;
		//Inf.fAnimationLength += 0.1f;
	}
	else
	{
		bWindupStartAlternateSide = false; //false is default
	}
	
	
	
	
	
	AOCOwner.StateVariables.bIsParrying = false;
	ClearTimer('AllowLowerParry');
	AOCOwner.ClearTimer('OnAttackAnimEnd');
	CurrentFireMode = FireModeNum;
	if (CurrentFireMode == Attack_AltSlash)
	{
		CurrentFireMode = Attack_Slash;
		
	}
	else if (CurrentFireMode == Attack_AltOverhead)
	{
		CurrentFireMode = Attack_Overhead;
		
	}
	AOCOwner.NotifyPawnStartAttack();

	// Delay slightly so that it always blends properly
	SetTimer(0.1f, false, 'PlayRiposteAnimation');

	bIsInCombo = false;
	bJustPlayedCombo = false;
}

//idk
simulated function PlayRiposteAnimation()
{
	local AnimationInfo Info;
	
	if (bWindupStartAlternateSide && CurrentFireMode == Attack_Overhead){
		//CurrentFireMode=Attack_AltOverhead;
		}
	if (bWindupStartAlternateSide && CurrentFireMode == Attack_Slash){
		//CurrentFireMode=Attack_AltSlash;
		}
	
	if (CurrentFireMode == Attack_AltOverhead)
	{
		CurrentFireMode = Attack_Overhead;
	}
	
	if (CurrentFireMode == Attack_AltSlash)
	{
		CurrentFireMode = Attack_Slash;
	}
	
	
	Info = ReleaseAnimations[CurrentFireMode];
	
	
	Info.bDoNotPlayInitially = true;
	Info.fBlendListNodeTime = FMin( 0.7f, GetRealAnimLength(class'AOCWeapon'.static.ConvertToShieldAnimation(WindupAnimations[CurrentFireMode], bEquipShield, WeaponIdentifier, AllowedShieldClass.default.ShieldIdentifier, bIgnoreShieldReplacement)));
	Info.fBlendListNodeTime = Info.fBlendListNodeTime - 0.1f;
	
	if (bWindupStartAlternateSide)
	{
		//Info.AnimationName = name("3p_longsword_slash011altdowntoup");
		//3p_longsword_slash01_release
		//3p_longsword_slash011altdowntoup
	}
	//DrawTextOverHead(string(Info.AnimationName));
	
	//AOCOwner.ReplicateCompressedAnimation(Info, EWST_Release, CurrentFireMode,,,false);
	
	
	
	//Info.bUseAltBoneBranch = bWindupStartAlternateSide;
	if (bWindupStartAlternateSide)
	{
		Info.AnimationName = Info.AlternateAnimation;
		//Info.fAnimationLength += altRiposteExtraWindup;
		//Info.fAnimationLength += 1.552;
	}
	//AOCOwner.ReplicateCompressedAnimation(Info, EWST_Release, CurrentFireMode, bWindupStartAlternateSide, false, false, true); //the currentfiremode here controls the WINDUP animation played. it's possible that current fire mode can't be alt
	if (bWindupStartAlternateSide && CurrentFireMode == Attack_Overhead){ //overhead, 7
		AOCOwner.ReplicateCompressedAnimation(Info, EWST_Release, 1, true, false, false, true);
		Info.bUseAltBoneBranch = true;
		}
	else if (bWindupStartAlternateSide && CurrentFireMode == Attack_Slash){ //slash, 6
		AOCOwner.ReplicateCompressedAnimation(Info, EWST_Release, 0, true, false, false, true);
		Info.bUseAltBoneBranch = true;
		}
	else {
		AOCOwner.ReplicateCompressedAnimation(Info, EWST_Release, CurrentFireMode, false, false, false, true);
	}
	//bPlayAlternateAnimation = false; //commented out
	bUseAlternateSide=false;
	//bPlayAlternateAnimation=false;
	
	SetTimer( Info.fBlendListNodeTime , false, 'OnStateAnimationEnd');
}
*/






/*
//
//Complete Trade Removal (Giru)
//
/** Put the pawn into a flinching state */
//Override
//Override
/*
simulated function ActivateFlinch(bool bFullBody, EDirection Direction, bool bGeneric, bool bSpecial, bool bHitFromTwoHander)
{
	CacheWeaponReferences();
	bFullBodyDazed = bFullBody;
	bGenericHit = bGeneric;
	bSpecialDazed = bSpecial;
	bHitWithTwoHander = bHitFromTwoHander;
	if (Direction == EDIR_BOT)
		DirectionDazed = 0;
	else if (Direction == EDIR_LEFT)
		DirectionDazed = 1;
	else if (Direction == EDIR_TOP)
		DirectionDazed = 2;
	else if (Direction == EDIR_RIGHT)
		DirectionDazed = 3;
	else if (Direction == EDIR_BOTLEFT)
		DirectionDazed = 4;
	else if (Direction == EDIR_BOTRIGHT)
		DirectionDazed = 5;
	else if (Direction == EDIR_TOPLEFT)
		DirectionDazed = 6;
	else
		DirectionDazed = 7;

	if (AOCOwner.Role == ROLE_Authority)
	{
		AOCOwner.PauseHealthRegeneration();
	
		ClientActivateFlinch(bFullBodyDazed, DirectionDazed, bGenericHit, bSpecialDazed, bHitFromTwoHander);
		
		//GIRU: Previously the server told the client to play flinch and then the client would
		//request a flinch from the server, completely ridiculous. GOTO flinch on server
		fFlinchStateStartTime = WorldInfo.TimeSeconds;
		
		bSpecialDazed = bSpecial;
		
		GotoState('Flinch',,true);

		if (AOCOwner.bIsBot && AOCAICombatController(AOCOwner.Controller) != none)
		{
			AOCOwner.bCanMove = false;
			AOCOwner.bCanJump = true;
			if (AOCAICombatController(AOCOwner.Controller).IsInState('LongRangeMove'))
				AOCAICombatController(AOCOwner.Controller).PopState();
		}
	}
}

//Override
reliable client function ClientActivateFlinch(bool bFullBody, int Dir, bool bGeneric, bool bSpecial, bool bHitFromTwoHander)
{
    if (bSpecial && bEquipShield && !AOCOwner.StateVariables.bIsActiveShielding)
    {
        bSpecial = false;
    }

    bFullBodyDazed = bFullBody;
    DirectionDazed = Dir;
    bGenericHit = bGeneric;
    bSpecialDazed = bSpecial;
    bHitWithTwoHander = bHitFromTwoHander;
    AOCOwner.PlayFlinchEffects();
    GotoState('Flinch',,true);
    
}

//Override
reliable server function ServerActivateFlinch(bool bSpecial)
{
    //GIRU: Kill this RPC, retarded code
}

*/


//debugging reasons
simulated state Release
{
	Simulated function BeginState(Name PreviousStateName)
	{
		//set last release start time, for debugging purposes
		SlumpModPawn(AOCPlayerController(AOCOwner.Controller).Pawn).Set_fLastReleaseStartTime(WorldInfo.TimeSeconds); //the simple way did not work and this does so don't judge me -quilt
		super.BeginState(PreviousStateName);
	}
}
*/

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
