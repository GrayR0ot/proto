package com.ankamagames.dofus.logic.game.fight.frames
{
   import com.ankama.dofus.enums.ActionIds;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.atouin.types.GraphicCell;
   import com.ankamagames.atouin.types.sequences.AddWorldEntityStep;
   import com.ankamagames.atouin.types.sequences.ParableGfxMovementStep;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.dofus.datacenter.effects.Effect;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceDice;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.SpellInventoryManagementFrame;
   import com.ankamagames.dofus.logic.game.common.managers.EntitiesLooksManager;
   import com.ankamagames.dofus.logic.game.common.managers.MapMovementAdapter;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.SpeakingItemManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.common.misc.ISpellCastProvider;
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.logic.game.fight.managers.MarkedCellsManager;
   import com.ankamagames.dofus.logic.game.fight.messages.GameActionFightLeaveMessage;
   import com.ankamagames.dofus.logic.game.fight.miscs.ActionIdProtocol;
   import com.ankamagames.dofus.logic.game.fight.miscs.SpellScriptBuffer;
   import com.ankamagames.dofus.logic.game.fight.miscs.TackleUtil;
   import com.ankamagames.dofus.logic.game.fight.steps.FightActionPointsLossDodgeStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightActionPointsVariationStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightCarryCharacterStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightChangeLookStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightChangeVisibilityStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightCloseCombatStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightDeathStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightDispellEffectStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightDispellSpellStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightDispellStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightDisplayBuffStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightEnteringStateStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightEntityMovementStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightEntitySlideStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightExchangePositionsStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightFighterStatsListStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightInvisibleTemporarilyDetectedStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightKillStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightLeavingStateStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightLifeVariationStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightLossAnimStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightMarkActivateStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightMarkCellsStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightMarkTriggeredStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightModifyEffectsDurationStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightMovementPointsLossDodgeStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightMovementPointsVariationStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightPlaySpellScriptStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightReducedDamagesStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightReflectedDamagesStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightReflectedSpellStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightRefreshFighterStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightShieldPointsVariationStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightSpellCastStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightSpellCooldownVariationStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightSpellImmunityStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightStealingKamasStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightSummonStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightTackledStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightTeleportStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightTemporaryBoostStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightThrowCharacterStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightTurnListStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightUnmarkCellsStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightUpdateStatStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightVanishStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightVisibilityStep;
   import com.ankamagames.dofus.logic.game.fight.steps.IFightStep;
   import com.ankamagames.dofus.logic.game.fight.types.BasicBuff;
   import com.ankamagames.dofus.logic.game.fight.types.CastingSpell;
   import com.ankamagames.dofus.logic.game.fight.types.MarkInstance;
   import com.ankamagames.dofus.logic.game.fight.types.SpellCastInFightManager;
   import com.ankamagames.dofus.logic.game.fight.types.StatBuff;
   import com.ankamagames.dofus.logic.game.fight.types.StateBuff;
   import com.ankamagames.dofus.logic.game.fight.types.castSpellManager.SpellManager;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.misc.lists.TriggerHookList;
   import com.ankamagames.dofus.misc.utils.GameDebugManager;
   import com.ankamagames.dofus.network.enums.FightSpellCastCriticalEnum;
   import com.ankamagames.dofus.network.messages.game.actions.AbstractGameActionMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightActivateGlyphTrapMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightCarryCharacterMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightChangeLookMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightCloseCombatMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDeathMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDispellEffectMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDispellMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDispellSpellMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDispellableEffectMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDodgePointLossMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDropCharacterMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightExchangePositionsMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightInvisibilityMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightInvisibleDetectedMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightKillMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightLifeAndShieldPointsLostMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightLifePointsGainMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightLifePointsLostMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightMarkCellsMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightModifyEffectsDurationMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightMultipleSummonMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightPointsVariationMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightReduceDamagesMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightReflectDamagesMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightReflectSpellMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightSlideMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightSpellCastMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightSpellCooldownVariationMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightSpellImmunityMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightStealKamaMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightSummonMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightTackledMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightTeleportOnSameMapMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightThrowCharacterMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightTriggerEffectMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightTriggerGlyphTrapMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightUnmarkCellsMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightVanishMessage;
   import com.ankamagames.dofus.network.messages.game.actions.sequence.SequenceEndMessage;
   import com.ankamagames.dofus.network.messages.game.actions.sequence.SequenceStartMessage;
   import com.ankamagames.dofus.network.messages.game.character.stats.FighterStatsListMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameMapMovementMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightSynchronizeMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightTurnListMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.RefreshCharacterStatsMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.character.GameFightRefreshFighterMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.character.GameFightShowFighterMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.character.GameFightShowFighterRandomStaticPoseMessage;
   import com.ankamagames.dofus.network.types.game.actions.fight.AbstractFightDispellableEffect;
   import com.ankamagames.dofus.network.types.game.actions.fight.FightTemporaryBoostEffect;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameContextBasicSpawnInformation;
   import com.ankamagames.dofus.network.types.game.context.fight.GameContextSummonsInformation;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightEntityInformation;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterNamedInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightSpellCooldown;
   import com.ankamagames.dofus.network.types.game.context.fight.SpawnCharacterInformation;
   import com.ankamagames.dofus.network.types.game.context.fight.SpawnCompanionInformation;
   import com.ankamagames.dofus.network.types.game.context.fight.SpawnMonsterInformation;
   import com.ankamagames.dofus.network.types.game.context.fight.SpawnScaledMonsterInformation;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.dofus.types.sequences.AddGfxEntityStep;
   import com.ankamagames.dofus.types.sequences.AddGfxInLineStep;
   import com.ankamagames.dofus.types.sequences.AddGlyphGfxStep;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.jerakine.sequencer.CallbackStep;
   import com.ankamagames.jerakine.sequencer.ISequencable;
   import com.ankamagames.jerakine.sequencer.ISequencer;
   import com.ankamagames.jerakine.sequencer.ParallelStartSequenceStep;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.types.events.SequencerEvent;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.positions.MovementPath;
   import com.ankamagames.jerakine.utils.display.spellZone.SpellShapeEnum;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.sequence.PlayAnimationStep;
   import com.ankamagames.tiphon.sequence.WaitAnimationEventStep;
   import com.ankamagames.tiphon.types.TiphonUtility;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import tools.ActionIdHelper;
   import tools.enumeration.ElementEnum;
   import tools.enumeration.GameActionMarkTypeEnum;
   
   public class FightSequenceFrame implements Frame, ISpellCastProvider
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FightSequenceFrame));
      
      private static var _lastCastingSpell:CastingSpell;
      
      private static var _currentInstanceId:uint;
      
      public static const FIGHT_SEQUENCERS_CATEGORY:String = "FightSequencer";
       
      
      private var _castingSpell:CastingSpell;
      
      private var _castingSpells:Vector.<CastingSpell>;
      
      private var _stepsBuffer:Vector.<ISequencable>;
      
      public var mustAck:Boolean;
      
      public var ackIdent:int;
      
      private var _sequenceEndCallback:Function;
      
      private var _subSequenceWaitingCount:uint = 0;
      
      private var _scriptInit:Boolean;
      
      private var _sequencer:SerialSequencer;
      
      private var _parent:FightSequenceFrame;
      
      private var _fightBattleFrame:FightBattleFrame;
      
      private var _fightEntitiesFrame:FightEntitiesFrame;
      
      private var _instanceId:uint;
      
      private var _teleportThroughPortal:Boolean;
      
      private var _updateMovementAreaAtSequenceEnd:Boolean;
      
      private var _playSpellScriptStep:FightPlaySpellScriptStep;
      
      private var _spellScriptTemporaryBuffer:SpellScriptBuffer;
      
      private var _permanentTooltipsCallback:Callback;
      
      public function FightSequenceFrame(pFightBattleFrame:FightBattleFrame, parent:FightSequenceFrame = null)
      {
         super();
         this._instanceId = _currentInstanceId++;
         this._fightBattleFrame = pFightBattleFrame;
         this._parent = parent;
         this.clearBuffer();
      }
      
      public static function get lastCastingSpell() : CastingSpell
      {
         return _lastCastingSpell;
      }
      
      public static function get currentInstanceId() : uint
      {
         return _currentInstanceId;
      }
      
      private static function deleteTooltip(fighterId:Number) : void
      {
         var fightContextFrame:FightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         if(FightContextFrame.fighterEntityTooltipId == fighterId && FightContextFrame.fighterEntityTooltipId != fightContextFrame.timelineOverEntityId)
         {
            if(fightContextFrame)
            {
               fightContextFrame.outEntity(fighterId);
            }
         }
      }
      
      public function get priority() : int
      {
         return Priority.HIGHEST;
      }
      
      public function get castingSpell() : CastingSpell
      {
         if(this._castingSpells && this._castingSpells.length > 1)
         {
            return this._castingSpells[this._castingSpells.length - 1];
         }
         return this._castingSpell;
      }
      
      public function get stepsBuffer() : Vector.<ISequencable>
      {
         return this._stepsBuffer;
      }
      
      public function get parent() : FightSequenceFrame
      {
         return this._parent;
      }
      
      public function get isWaiting() : Boolean
      {
         return this._subSequenceWaitingCount != 0 || !this._scriptInit;
      }
      
      public function get instanceId() : uint
      {
         return this._instanceId;
      }
      
      public function pushed() : Boolean
      {
         this._scriptInit = false;
         return true;
      }
      
      public function pulled() : Boolean
      {
         this._stepsBuffer = null;
         this._castingSpell = null;
         this._castingSpells = null;
         _lastCastingSpell = null;
         this._sequenceEndCallback = null;
         this._parent = null;
         this._fightBattleFrame = null;
         this._fightEntitiesFrame = null;
         this._sequencer.clear();
         return true;
      }
      
      public function get fightEntitiesFrame() : FightEntitiesFrame
      {
         if(!this._fightEntitiesFrame)
         {
            this._fightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         }
         return this._fightEntitiesFrame;
      }
      
      public function addSubSequence(sequence:ISequencer) : void
      {
         ++this._subSequenceWaitingCount;
         this._stepsBuffer.push(new ParallelStartSequenceStep([sequence],false));
      }
      
      public function process(msg:Message) : Boolean
      {
         /*
          * Erreur de décompilation
          * Le délais dattente de ({0}) est expiré
          * Nb d'instructions : 3320
          */
         throw new flash.errors.IllegalOperationError("Non décompilé car le délais d'attente a été atteint");
      }
      
      public function execute(callback:Function = null) : void
      {
         this._sequencer = new SerialSequencer(FIGHT_SEQUENCERS_CATEGORY);
         this._sequencer.addEventListener(SequencerEvent.SEQUENCE_STEP_FINISH,this.onStepEnd);
         if(this._parent)
         {
            _log.info("Process sub sequence");
            this._parent.addSubSequence(this._sequencer);
         }
         else
         {
            _log.info("Execute sequence");
         }
         this.executeBuffer(callback);
      }
      
      private function fighterHasBeenKilled(gafdmsg:GameActionFightDeathMessage) : void
      {
         var actorInfo:GameFightFighterInformations = null;
         var gcai:GameContextActorInformations = null;
         var playerId:Number = NaN;
         var sourceInfos:GameFightFighterInformations = null;
         var targetInfos:GameFightFighterInformations = null;
         var playerInfos:GameFightFighterInformations = null;
         var summonDestroyedWithSummoner:Boolean = false;
         var summonerIsMe:Boolean = false;
         var step:ISequencable = null;
         var summonerInfos:GameFightFighterInformations = null;
         var summonedEntityInfos:GameFightMonsterInformations = null;
         var monster:Monster = null;
         var fighterInfos:GameFightFighterInformations = null;
         var entitiesDictionnary:Dictionary = FightEntitiesFrame.getCurrentInstance().getEntitiesDictionnary();
         for each(gcai in entitiesDictionnary)
         {
            if(gcai is GameFightFighterInformations)
            {
               actorInfo = gcai as GameFightFighterInformations;
               if(actorInfo.spawnInfo.alive && actorInfo.stats.summoner == gafdmsg.targetId)
               {
                  this.pushStep(new FightDeathStep(gcai.contextualId));
               }
            }
         }
         playerId = PlayedCharacterManager.getInstance().id;
         sourceInfos = this.fightEntitiesFrame.getEntityInfos(gafdmsg.sourceId) as GameFightFighterInformations;
         targetInfos = this.fightEntitiesFrame.getEntityInfos(gafdmsg.targetId) as GameFightFighterInformations;
         playerInfos = this.fightEntitiesFrame.getEntityInfos(playerId) as GameFightFighterInformations;
         summonDestroyedWithSummoner = false;
         summonerIsMe = true;
         if(targetInfos.stats.summoned && !(targetInfos is GameFightFighterNamedInformations) && !(targetInfos is GameFightEntityInformation))
         {
            summonerInfos = this.fightEntitiesFrame.getEntityInfos(targetInfos.stats.summoner) as GameFightFighterInformations;
            summonDestroyedWithSummoner = summonerInfos == null || !summonerInfos.spawnInfo.alive;
            summonerIsMe = summonerInfos != null && summonerInfos == playerInfos;
         }
         if(!summonDestroyedWithSummoner && summonerIsMe)
         {
            this.fightEntitiesFrame.addLastKilledAlly(targetInfos);
         }
         if(gafdmsg.targetId != this._fightBattleFrame.currentPlayerId && (this._fightBattleFrame.slaveId == gafdmsg.targetId || this._fightBattleFrame.masterId == gafdmsg.targetId))
         {
            this._fightBattleFrame.prepareNextPlayableCharacter(gafdmsg.targetId);
         }
         var speakingItemManager:SpeakingItemManager = SpeakingItemManager.getInstance();
         if(gafdmsg.targetId == playerId)
         {
            if(gafdmsg.sourceId == gafdmsg.targetId)
            {
               speakingItemManager.triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_KILLED_HIMSELF);
            }
            else if(sourceInfos.spawnInfo.teamId != playerInfos.spawnInfo.teamId)
            {
               speakingItemManager.triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_KILLED_BY_ENEMY);
            }
            else
            {
               speakingItemManager.triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_KILLED_BY_ENEMY);
            }
         }
         else if(gafdmsg.sourceId == playerId)
         {
            if(targetInfos)
            {
               if(targetInfos.spawnInfo.teamId != playerInfos.spawnInfo.teamId)
               {
                  speakingItemManager.triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_KILL_ENEMY);
               }
               else
               {
                  speakingItemManager.triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_KILL_ALLY);
               }
            }
         }
         var entityDeathStepAlreadyInBuffer:Boolean = false;
         for each(step in this._stepsBuffer)
         {
            if(step is FightDeathStep && (step as FightDeathStep).entityId == gafdmsg.targetId)
            {
               entityDeathStepAlreadyInBuffer = true;
            }
         }
         if(!entityDeathStepAlreadyInBuffer)
         {
            this.pushStep(new FightDeathStep(gafdmsg.targetId));
         }
         var entityInfos:GameContextActorInformations = FightEntitiesFrame.getCurrentInstance().getEntityInfos(gafdmsg.targetId);
         var ftf:FightTurnFrame = Kernel.getWorker().getFrame(FightTurnFrame) as FightTurnFrame;
         var updatePath:Boolean = ftf && ftf.myTurn && gafdmsg.targetId != playerId && TackleUtil.isTackling(playerInfos,targetInfos,ftf.lastPath);
         var currentPlayedFighterManager:CurrentPlayedFighterManager = CurrentPlayedFighterManager.getInstance();
         if(entityInfos is GameFightMonsterInformations)
         {
            summonedEntityInfos = entityInfos as GameFightMonsterInformations;
            summonedEntityInfos.spawnInfo.alive = false;
            if(currentPlayedFighterManager.checkPlayableEntity(summonedEntityInfos.stats.summoner))
            {
               monster = Monster.getMonsterById(summonedEntityInfos.creatureGenericId);
               if(monster.useSummonSlot)
               {
                  currentPlayedFighterManager.removeSummonedCreature(summonedEntityInfos.stats.summoner);
               }
               if(monster.useBombSlot)
               {
                  currentPlayedFighterManager.removeSummonedBomb(summonedEntityInfos.stats.summoner);
               }
               SpellWrapper.refreshAllPlayerSpellHolder(summonedEntityInfos.stats.summoner);
            }
         }
         else if(entityInfos is GameFightFighterInformations)
         {
            fighterInfos = entityInfos as GameFightFighterInformations;
            fighterInfos.spawnInfo.alive = false;
            if(fighterInfos.stats.summoner != 0)
            {
               if(currentPlayedFighterManager.checkPlayableEntity(fighterInfos.stats.summoner))
               {
                  currentPlayedFighterManager.removeSummonedCreature(fighterInfos.stats.summoner);
                  SpellWrapper.refreshAllPlayerSpellHolder(fighterInfos.stats.summoner);
               }
            }
         }
         var fightContextFrame:FightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         if(fightContextFrame)
         {
            fightContextFrame.outEntity(gafdmsg.targetId);
         }
         FightEntitiesFrame.getCurrentInstance().updateRemovedEntity(gafdmsg.targetId);
         if(updatePath)
         {
            ftf.updatePath();
         }
      }
      
      private function fighterHasLeftBattle(gaflmsg:GameActionFightLeaveMessage) : void
      {
         var gcaiL:GameContextActorInformations = null;
         var entityInfosL:GameContextActorInformations = null;
         var summonerIdL:Number = NaN;
         var summonedEntityInfosL:GameFightMonsterInformations = null;
         var currentPlayedFighterManager:CurrentPlayedFighterManager = null;
         var monster:Monster = null;
         var fightEntityFrame_gaflmsg:FightEntitiesFrame = FightEntitiesFrame.getCurrentInstance();
         var entitiesL:Dictionary = fightEntityFrame_gaflmsg.getEntitiesDictionnary();
         for each(gcaiL in entitiesL)
         {
            if(gcaiL is GameFightFighterInformations)
            {
               summonerIdL = (gcaiL as GameFightFighterInformations).stats.summoner;
               if(summonerIdL == gaflmsg.targetId)
               {
                  this.pushStep(new FightDeathStep(gcaiL.contextualId));
               }
            }
         }
         this.pushStep(new FightDeathStep(gaflmsg.targetId,false));
         entityInfosL = fightEntityFrame_gaflmsg.getEntityInfos(gaflmsg.targetId);
         if(entityInfosL is GameFightMonsterInformations)
         {
            summonedEntityInfosL = entityInfosL as GameFightMonsterInformations;
            currentPlayedFighterManager = CurrentPlayedFighterManager.getInstance();
            if(currentPlayedFighterManager.checkPlayableEntity(summonedEntityInfosL.stats.summoner))
            {
               monster = Monster.getMonsterById(summonedEntityInfosL.creatureGenericId);
               if(monster.useSummonSlot)
               {
                  currentPlayedFighterManager.removeSummonedCreature(summonedEntityInfosL.stats.summoner);
               }
               if(monster.useBombSlot)
               {
                  currentPlayedFighterManager.removeSummonedBomb(summonedEntityInfosL.stats.summoner);
               }
            }
         }
         if(entityInfosL && entityInfosL is GameFightFighterInformations)
         {
            fightEntityFrame_gaflmsg.removeSpecificKilledAlly(entityInfosL as GameFightFighterInformations);
         }
      }
      
      private function cellsHasBeenMarked(gafmcmsg:GameActionFightMarkCellsMessage) : void
      {
         var spellGrade:uint = 0;
         var tmpSpell:Spell = null;
         var spellLevel:SpellLevel = null;
         var effect:EffectInstanceDice = null;
         var spellId:uint = gafmcmsg.mark.markSpellId;
         if(this._castingSpell && this._castingSpell.spell && this._castingSpell.spell.id != 1750)
         {
            this._castingSpell.markId = gafmcmsg.mark.markId;
            this._castingSpell.markType = gafmcmsg.mark.markType;
            this._castingSpell.casterId = gafmcmsg.sourceId;
            spellGrade = gafmcmsg.mark.markSpellLevel;
         }
         else
         {
            tmpSpell = Spell.getSpellById(spellId);
            spellLevel = tmpSpell.getSpellLevel(gafmcmsg.mark.markSpellLevel);
            for each(effect in spellLevel.effects)
            {
               if(effect.effectId == ActionIds.ACTION_FIGHT_ADD_TRAP_CASTING_SPELL || effect.effectId == ActionIds.ACTION_FIGHT_ADD_GLYPH_CASTING_SPELL || effect.effectId == ActionIds.ACTION_FIGHT_ADD_GLYPH_CASTING_SPELL_ENDTURN)
               {
                  spellId = effect.parameter0 as uint;
                  spellGrade = Spell.getSpellById(spellId).getSpellLevel(effect.parameter1 as uint).grade;
                  break;
               }
            }
         }
         this.pushStep(new FightMarkCellsStep(gafmcmsg.mark.markId,gafmcmsg.mark.markType,gafmcmsg.mark.cells,spellId,spellGrade,gafmcmsg.mark.markTeamId,gafmcmsg.mark.markimpactCell,gafmcmsg.sourceId));
      }
      
      private function fighterSummonMultipleEntities(gafmsmsg:GameActionFightMultipleSummonMessage, gffinfos:GameFightFighterInformations) : GameFightFighterInformations
      {
         var summons:GameContextSummonsInformation = null;
         var sum:GameContextBasicSpawnInformation = null;
         var gffninfos:GameFightFighterNamedInformations = null;
         var gfeinfos:GameFightEntityInformation = null;
         var gfminfos:GameFightMonsterInformations = null;
         var gfsminfos:GameFightMonsterInformations = null;
         for each(summons in gafmsmsg.summons)
         {
            for each(sum in summons.summons)
            {
               switch(true)
               {
                  case summons.spawnInformation is SpawnCharacterInformation:
                     gffninfos = new GameFightFighterNamedInformations();
                     gffninfos.initGameFightFighterNamedInformations(sum.informations.contextualId,sum.informations.disposition,summons.look,sum,summons.wave,summons.stats,null,(summons.spawnInformation as SpawnCharacterInformation).name);
                     gffinfos = gffninfos;
                     break;
                  case summons.spawnInformation is SpawnCompanionInformation:
                     gfeinfos = new GameFightEntityInformation();
                     gfeinfos.initGameFightEntityInformation(sum.informations.contextualId,sum.informations.disposition,summons.look,sum,summons.wave,summons.stats,null,(summons.spawnInformation as SpawnCompanionInformation).modelId,(summons.spawnInformation as SpawnCompanionInformation).level,(summons.spawnInformation as SpawnCompanionInformation).ownerId);
                     gffinfos = gfeinfos;
                     break;
                  case summons.spawnInformation is SpawnMonsterInformation:
                     gfminfos = new GameFightMonsterInformations();
                     gfminfos.initGameFightMonsterInformations(sum.informations.contextualId,sum.informations.disposition,summons.look,sum,summons.wave,summons.stats,null,(summons.spawnInformation as SpawnMonsterInformation).creatureGenericId,(summons.spawnInformation as SpawnMonsterInformation).creatureGrade);
                     gffinfos = gfminfos;
                     break;
                  case summons.spawnInformation is SpawnScaledMonsterInformation:
                     gfsminfos = new GameFightMonsterInformations();
                     gfsminfos.initGameFightMonsterInformations(sum.informations.contextualId,sum.informations.disposition,summons.look,sum,summons.wave,summons.stats,null,(summons.spawnInformation as SpawnScaledMonsterInformation).creatureGenericId,0,(summons.spawnInformation as SpawnScaledMonsterInformation).creatureLevel);
                     gffinfos = gfsminfos;
                     break;
                  default:
                     gffinfos = new GameFightFighterInformations();
                     gffinfos.initGameFightFighterInformations(sum.informations.contextualId,sum.informations.disposition,summons.look,sum,summons.wave,summons.stats);
                     break;
               }
               this.summonEntity(gffinfos,gafmsmsg.sourceId,gafmsmsg.actionId);
            }
         }
         return gffinfos;
      }
      
      private function fighterSummonEntity(gafsnmsg:GameActionFightSummonMessage) : void
      {
         var summon:GameFightFighterInformations = null;
         var fightEntities:Dictionary = null;
         var fighterId:* = undefined;
         var gfsfrsmsg:GameFightShowFighterRandomStaticPoseMessage = null;
         var illusionCreature:Sprite = null;
         var infos:GameFightFighterInformations = null;
         for each(summon in gafsnmsg.summons)
         {
            if(gafsnmsg.actionId == ActionIds.ACTION_CHARACTER_ADD_ILLUSION_RANDOM || gafsnmsg.actionId == ActionIds.ACTION_CHARACTER_ADD_ILLUSION_MIRROR)
            {
               fightEntities = this.fightEntitiesFrame.getEntitiesDictionnary();
               for(fighterId in fightEntities)
               {
                  infos = this.fightEntitiesFrame.getEntityInfos(fighterId) as GameFightFighterInformations;
                  if(!this.fightEntitiesFrame.entityIsIllusion(fighterId) && infos.hasOwnProperty("name") && summon.hasOwnProperty("name") && infos["name"] == summon["name"])
                  {
                     summon.stats.summoner = infos.contextualId;
                     break;
                  }
               }
               gfsfrsmsg = new GameFightShowFighterRandomStaticPoseMessage();
               gfsfrsmsg.initGameFightShowFighterRandomStaticPoseMessage(summon);
               Kernel.getWorker().getFrame(FightEntitiesFrame).process(gfsfrsmsg);
               illusionCreature = DofusEntities.getEntity(summon.contextualId) as Sprite;
               if(illusionCreature)
               {
                  illusionCreature.visible = false;
               }
               this.pushStep(new FightVisibilityStep(summon.contextualId,true));
            }
            else
            {
               this.summonEntity(summon,gafsnmsg.sourceId,gafsnmsg.actionId);
            }
         }
      }
      
      private function fightersExchangedPositions(gafepmsg:GameActionFightExchangePositionsMessage) : void
      {
         var fightContextFrame:FightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         if(!this.isSpellTeleportingToPreviousPosition())
         {
            fightContextFrame.saveFighterPosition(gafepmsg.sourceId,gafepmsg.targetCellId);
         }
         else
         {
            fightContextFrame.deleteFighterPreviousPosition(gafepmsg.sourceId);
         }
         fightContextFrame.saveFighterPosition(gafepmsg.targetId,gafepmsg.targetCellId);
         this._stepsBuffer.push(new CallbackStep(new Callback(deleteTooltip,gafepmsg.targetId)));
         this._stepsBuffer.push(new CallbackStep(new Callback(deleteTooltip,gafepmsg.targetCellId)));
         this.pushStep(new FightExchangePositionsStep(gafepmsg.sourceId,gafepmsg.casterCellId,gafepmsg.targetId,gafepmsg.targetCellId));
      }
      
      private function fighterHasBeenTeleported(gaftosmmsg:GameActionFightTeleportOnSameMapMessage) : void
      {
         var fightContextFrame:FightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         if(!this.isSpellTeleportingToPreviousPosition())
         {
            if(!this._teleportThroughPortal)
            {
               fightContextFrame.saveFighterPosition(gaftosmmsg.targetId,gaftosmmsg.cellId);
            }
            else
            {
               fightContextFrame.saveFighterPosition(gaftosmmsg.targetId,gaftosmmsg.cellId);
            }
         }
         else if(fightContextFrame.getFighterPreviousPosition(gaftosmmsg.targetId) == gaftosmmsg.cellId)
         {
            fightContextFrame.deleteFighterPreviousPosition(gaftosmmsg.targetId);
         }
         this.pushTeleportStep(gaftosmmsg.targetId,gaftosmmsg.cellId);
         this._teleportThroughPortal = false;
      }
      
      private function fighterHasMoved(gmmmsg:GameMapMovementMessage) : void
      {
         var i:int = 0;
         var carriedEntity:AnimatedCharacter = null;
         if(gmmmsg.actorId == CurrentPlayedFighterManager.getInstance().currentFighterId)
         {
            KernelEventsManager.getInstance().processCallback(TriggerHookList.PlayerFightMove);
         }
         var movementPath:MovementPath = MapMovementAdapter.getClientMovement(gmmmsg.keyMovements);
         var movementPathCells:Vector.<uint> = movementPath.getCells();
         var fightContextFrame:FightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         var nbCells:int = movementPathCells.length;
         var movingEntity:TiphonSprite = DofusEntities.getEntity(gmmmsg.actorId) as TiphonSprite;
         for(i = 1; i < nbCells; i++)
         {
            fightContextFrame.saveFighterPosition(gmmmsg.actorId,movementPathCells[i]);
            carriedEntity = movingEntity.carriedEntity as AnimatedCharacter;
            while(carriedEntity)
            {
               fightContextFrame.saveFighterPosition(carriedEntity.id,movementPathCells[i]);
               carriedEntity = carriedEntity.carriedEntity as AnimatedCharacter;
            }
         }
         var fscf:FightSpellCastFrame = Kernel.getWorker().getFrame(FightSpellCastFrame) as FightSpellCastFrame;
         if(fscf)
         {
            fscf.entityMovement(gmmmsg.actorId);
         }
         this._stepsBuffer.push(new CallbackStep(new Callback(deleteTooltip,gmmmsg.actorId)));
         this.pushStep(new FightEntityMovementStep(gmmmsg.actorId,movementPath));
      }
      
      private function fighterHasTriggeredGlyphOrTrap(gaftgtmsg:GameActionFightTriggerGlyphTrapMessage) : void
      {
         var triggeredSpellId:int = 0;
         var eid:EffectInstanceDice = null;
         this.pushStep(new FightMarkTriggeredStep(gaftgtmsg.triggeringCharacterId,gaftgtmsg.sourceId,gaftgtmsg.markId));
         this._castingSpell = new CastingSpell();
         this._castingSpell.casterId = gaftgtmsg.sourceId;
         var triggeringCharacterInfos:GameFightFighterInformations = FightEntitiesFrame.getCurrentInstance().getEntityInfos(gaftgtmsg.triggeringCharacterId) as GameFightFighterInformations;
         var triggeredCellId:int = !!triggeringCharacterInfos ? int(triggeringCharacterInfos.disposition.cellId) : -1;
         var mark:MarkInstance = MarkedCellsManager.getInstance().getMarkDatas(gaftgtmsg.markId);
         if(triggeredCellId != -1)
         {
            if(mark)
            {
               for each(eid in mark.associatedSpellLevel.effects)
               {
                  if(mark.markType == GameActionMarkTypeEnum.GLYPH && eid.effectId == ActionIds.ACTION_FIGHT_ADD_GLYPH_CASTING_SPELL || mark.markType == GameActionMarkTypeEnum.TRAP && eid.effectId == ActionIds.ACTION_FIGHT_ADD_TRAP_CASTING_SPELL)
                  {
                     triggeredSpellId = eid.parameter0 as int;
                     break;
                  }
               }
               if(triggeredSpellId)
               {
                  this._castingSpell.spell = Spell.getSpellById(triggeredSpellId);
                  this._castingSpell.spellRank = this._castingSpell.spell.getSpellLevel(mark.associatedSpellLevel.grade);
                  this._castingSpell.targetedCell = MapPoint.fromCellId(gaftgtmsg.markImpactCell);
                  if(mark.markType == GameActionMarkTypeEnum.GLYPH)
                  {
                     this._castingSpell.defaultTargetGfxId = 1016;
                  }
                  else if(mark.markType == GameActionMarkTypeEnum.TRAP)
                  {
                     this._castingSpell.defaultTargetGfxId = 1017;
                  }
                  this.pushPlaySpellScriptStep(1,gaftgtmsg.sourceId,triggeredCellId,this._castingSpell.spell.id,this._castingSpell.spellRank.grade);
               }
            }
         }
         if(mark && mark.markType == GameActionMarkTypeEnum.PORTAL)
         {
            this._teleportThroughPortal = true;
         }
      }
      
      private function fighterHasBeenBuffed(gaftbmsg:GameActionFightDispellableEffectMessage) : void
      {
         var myCastingSpell:CastingSpell = null;
         var castedSpell:CastingSpell = null;
         var e:Effect = null;
         var description:String = null;
         var sb:StateBuff = null;
         var step:AbstractSequencable = null;
         var actionId:int = 0;
         if(GameDebugManager.getInstance().buffsDebugActivated)
         {
            e = Effect.getEffectById(gaftbmsg.actionId);
            description = "";
            if(e != null)
            {
               description = e.description;
            }
            _log.debug("\r[BUFFS DEBUG] Message de nouveau buff \'" + description + "\' (" + gaftbmsg.actionId + ") lancé par " + gaftbmsg.sourceId + " sur " + gaftbmsg.effect.targetId + " (uid " + gaftbmsg.effect.uid + ", sort " + gaftbmsg.effect.spellId + ", durée " + gaftbmsg.effect.turnDuration + ", desenvoutable " + gaftbmsg.effect.dispelable + ", buff parent " + gaftbmsg.effect.parentBoostUid + ")");
         }
         for each(castedSpell in this._castingSpells)
         {
            if(castedSpell.spell.id == gaftbmsg.effect.spellId && castedSpell.casterId == gaftbmsg.sourceId)
            {
               myCastingSpell = castedSpell;
               break;
            }
         }
         if(!myCastingSpell)
         {
            if(gaftbmsg.actionId == ActionIdProtocol.ACTION_CHARACTER_UPDATE_BOOST)
            {
               myCastingSpell = new CastingSpell(false);
            }
            else
            {
               myCastingSpell = new CastingSpell(this._castingSpell == null);
            }
            if(this._castingSpell)
            {
               myCastingSpell.castingSpellId = this._castingSpell.castingSpellId;
               if(this._castingSpell.spell && this._castingSpell.spell.id == gaftbmsg.effect.spellId)
               {
                  myCastingSpell.spellRank = this._castingSpell.spellRank;
               }
            }
            myCastingSpell.spell = Spell.getSpellById(gaftbmsg.effect.spellId);
            myCastingSpell.casterId = gaftbmsg.sourceId;
         }
         var buffEffect:AbstractFightDispellableEffect = gaftbmsg.effect;
         var buff:BasicBuff = BuffManager.makeBuffFromEffect(buffEffect,myCastingSpell,gaftbmsg.actionId);
         if(buff is StateBuff)
         {
            sb = buff as StateBuff;
            if(sb.actionId == ActionIds.ACTION_FIGHT_DISABLE_STATE)
            {
               step = new FightLeavingStateStep(sb.targetId,sb.stateId,buff);
            }
            else
            {
               step = new FightEnteringStateStep(sb.targetId,sb.stateId,sb.effect.durationString,buff);
            }
            if(myCastingSpell != null)
            {
               step.castingSpellId = myCastingSpell.castingSpellId;
            }
            this._stepsBuffer.push(step);
         }
         if(buff is StatBuff)
         {
            (buff as StatBuff).isRecent = true;
         }
         if(buffEffect is FightTemporaryBoostEffect)
         {
            actionId = gaftbmsg.actionId;
            if(actionId != ActionIds.ACTION_CHARACTER_MAKE_INVISIBLE && actionId != ActionIdProtocol.ACTION_CHARACTER_UPDATE_BOOST && actionId != ActionIds.ACTION_CHARACTER_CHANGE_LOOK && actionId != ActionIds.ACTION_CHARACTER_CHANGE_COLOR && actionId != ActionIds.ACTION_CHARACTER_ADD_APPEARANCE && actionId != ActionIds.ACTION_FIGHT_SET_STATE)
            {
               if(GameDebugManager.getInstance().detailedFightLog_showEverything)
               {
                  buff.effect.visibleInFightLog = true;
               }
               if(GameDebugManager.getInstance().detailedFightLog_showBuffsInUi)
               {
                  buff.effect.visibleInBuffUi = true;
               }
               this.pushStep(new FightTemporaryBoostStep(gaftbmsg.effect.targetId,buff.effect.description,buff.effect.duration,buff.effect.durationString,buff.effect.visibleInFightLog,buff));
            }
            if(actionId == ActionIds.ACTION_CHARACTER_BOOST_SHIELD)
            {
               this.pushStep(new FightShieldPointsVariationStep(gaftbmsg.effect.targetId,(buff as StatBuff).delta,ElementEnum.ELEMENT_NONE));
            }
         }
         this.pushStep(new FightDisplayBuffStep(buff));
      }
      
      private function executeBuffer(callback:Function) : void
      {
         var step:ISequencable = null;
         var allowHitAnim:Boolean = false;
         var allowSpellEffects:Boolean = false;
         var startStep:Array = null;
         var endStep:Array = null;
         var removed:Boolean = false;
         var entityAttaqueAnimWait:Dictionary = null;
         var lifeLoseSum:Dictionary = null;
         var lifeLoseLastStep:Dictionary = null;
         var shieldLoseSum:Dictionary = null;
         var shieldLoseLastStep:Dictionary = null;
         var deathNumber:int = 0;
         var i:int = 0;
         var b:* = undefined;
         var index:* = undefined;
         var waitStep:WaitAnimationEventStep = null;
         var animStep:PlayAnimationStep = null;
         var deathStep:FightDeathStep = null;
         var deadEntityIndex:int = 0;
         var fapvs:FightActionPointsVariationStep = null;
         var fspvs:FightShieldPointsVariationStep = null;
         var fspvsTarget:IEntity = null;
         var flvs:FightLifeVariationStep = null;
         var flvsTarget:IEntity = null;
         var idx:int = 0;
         var idx2:int = 0;
         var loseLifeTarget:* = undefined;
         var j:uint = 0;
         var cleanedBuffer:Array = [];
         var deathStepRef:Dictionary = new Dictionary(true);
         var hitStep:Vector.<TiphonSprite> = new Vector.<TiphonSprite>();
         var loseLifeStep:Dictionary = new Dictionary(true);
         var waitHitEnd:Boolean = false;
         for each(step in this._stepsBuffer)
         {
            if(step is FightMarkTriggeredStep)
            {
               waitHitEnd = true;
            }
         }
         allowHitAnim = OptionManager.getOptionManager("dofus").getOption("allowHitAnim");
         allowSpellEffects = OptionManager.getOptionManager("dofus").getOption("allowSpellEffects");
         startStep = [];
         endStep = [];
         entityAttaqueAnimWait = new Dictionary();
         lifeLoseSum = new Dictionary(true);
         lifeLoseLastStep = new Dictionary(true);
         shieldLoseSum = new Dictionary(true);
         shieldLoseLastStep = new Dictionary(true);
         deathNumber = 0;
         for(i = this._stepsBuffer.length; --i >= 0; )
         {
            if(removed && step)
            {
               step.clear();
            }
            removed = true;
            step = this._stepsBuffer[i];
            switch(true)
            {
               case step is PlayAnimationStep:
                  animStep = step as PlayAnimationStep;
                  if(animStep.animation.indexOf(AnimationEnum.ANIM_HIT) != -1)
                  {
                     if(!allowHitAnim)
                     {
                        continue;
                     }
                     animStep.waitEvent = waitHitEnd;
                     if(animStep.target == null || deathStepRef[EntitiesManager.getInstance().getEntityID(animStep.target as IEntity)] || hitStep.indexOf(animStep.target))
                     {
                        continue;
                     }
                     if(animStep.animation != AnimationEnum.ANIM_HIT && animStep.animation != AnimationEnum.ANIM_HIT_CARRYING && !animStep.target.hasAnimation(animStep.animation,1))
                     {
                        animStep.animation = AnimationEnum.ANIM_HIT;
                     }
                     hitStep.push(animStep.target);
                  }
                  if(this._castingSpell && this._castingSpell.casterId < 0)
                  {
                     if(entityAttaqueAnimWait[animStep.target])
                     {
                        cleanedBuffer.unshift(entityAttaqueAnimWait[animStep.target]);
                        delete entityAttaqueAnimWait[animStep.target];
                     }
                     if(animStep.animation.indexOf(AnimationEnum.ANIM_ATTAQUE_BASE) != -1)
                     {
                        entityAttaqueAnimWait[animStep.target] = new WaitAnimationEventStep(animStep);
                     }
                  }
                  break;
               case step is FightDeathStep:
                  deathStep = step as FightDeathStep;
                  deathStepRef[deathStep.entityId] = true;
                  deadEntityIndex = this._fightBattleFrame.targetedEntities.indexOf(deathStep.entityId);
                  if(deadEntityIndex != -1)
                  {
                     this._fightBattleFrame.targetedEntities.splice(deadEntityIndex,1);
                     TooltipManager.hide("tooltipOverEntity_" + deathStep.entityId);
                  }
                  deathNumber++;
                  break;
               case step is FightActionPointsVariationStep:
                  fapvs = step as FightActionPointsVariationStep;
                  if(!fapvs.voluntarlyUsed)
                  {
                     break;
                  }
                  startStep.push(fapvs);
                  removed = false;
                  continue;
               case step is FightShieldPointsVariationStep:
                  fspvs = step as FightShieldPointsVariationStep;
                  fspvsTarget = fspvs.target;
                  if(fspvsTarget == null)
                  {
                     break;
                  }
                  if(fspvs.value < 0)
                  {
                     fspvs.virtual = true;
                     if(shieldLoseSum[fspvsTarget] == null)
                     {
                        shieldLoseSum[fspvsTarget] = 0;
                     }
                     shieldLoseSum[fspvsTarget] += fspvs.value;
                     shieldLoseLastStep[fspvsTarget] = fspvs;
                  }
                  break;
               case step is FightLifeVariationStep:
                  flvs = step as FightLifeVariationStep;
                  flvsTarget = flvs.target;
                  if(flvsTarget == null)
                  {
                     break;
                  }
                  if(flvs.delta < 0)
                  {
                     loseLifeStep[flvsTarget] = flvs;
                  }
                  if(lifeLoseSum[flvsTarget] == null)
                  {
                     lifeLoseSum[flvsTarget] = 0;
                  }
                  lifeLoseSum[flvsTarget] += flvs.delta;
                  lifeLoseLastStep[flvsTarget] = flvs;
                  break;
               case step is AddGfxEntityStep:
               case step is AddGfxInLineStep:
               case step is AddGlyphGfxStep:
               case step is ParableGfxMovementStep:
               case step is AddWorldEntityStep:
                  if(!(!allowSpellEffects && PlayedCharacterManager.getInstance().isFighting))
                  {
                     break;
                  }
                  continue;
            }
            removed = false;
            cleanedBuffer.unshift(step);
         }
         this._fightBattleFrame.deathPlayingNumber = deathNumber;
         for each(b in cleanedBuffer)
         {
            if(b is FightLifeVariationStep && lifeLoseSum[b.target] == 0 && shieldLoseSum[b.target] != null)
            {
               b.skipTextEvent = true;
            }
         }
         for(index in lifeLoseSum)
         {
            if(index != "null" && lifeLoseSum[index] != 0)
            {
               idx = cleanedBuffer.indexOf(lifeLoseLastStep[index]);
               cleanedBuffer.splice(idx,0,new FightLossAnimStep(index,lifeLoseSum[index],FightLifeVariationStep.COLOR));
            }
            lifeLoseLastStep[index] = -1;
            lifeLoseSum[index] = 0;
         }
         for(index in shieldLoseSum)
         {
            if(index != "null" && shieldLoseSum[index] != 0)
            {
               idx2 = cleanedBuffer.indexOf(shieldLoseLastStep[index]);
               cleanedBuffer.splice(idx2,0,new FightLossAnimStep(index,shieldLoseSum[index],FightShieldPointsVariationStep.COLOR));
            }
            shieldLoseLastStep[index] = -1;
            shieldLoseSum[index] = 0;
         }
         for each(waitStep in entityAttaqueAnimWait)
         {
            endStep.push(waitStep);
         }
         if(allowHitAnim)
         {
            for(loseLifeTarget in loseLifeStep)
            {
               if(hitStep.indexOf(loseLifeTarget) == -1)
               {
                  for(j = 0; j < cleanedBuffer.length; j++)
                  {
                     if(cleanedBuffer[j] == loseLifeStep[loseLifeTarget])
                     {
                        cleanedBuffer.splice(j,0,new PlayAnimationStep(loseLifeTarget as TiphonSprite,AnimationEnum.ANIM_HIT,true,false));
                        break;
                     }
                  }
               }
            }
         }
         cleanedBuffer = startStep.concat(cleanedBuffer).concat(endStep);
         for each(step in cleanedBuffer)
         {
            this._sequencer.addStep(step);
         }
         this.clearBuffer();
         if(callback != null && !this._parent)
         {
            this._sequenceEndCallback = callback;
            this._permanentTooltipsCallback = new Callback(this.showPermanentTooltips,cleanedBuffer);
            this._sequencer.addEventListener(SequencerEvent.SEQUENCE_END,this.onSequenceEnd);
         }
         _lastCastingSpell = this._castingSpell;
         this._scriptInit = true;
         if(!this._parent)
         {
            if(!this._subSequenceWaitingCount)
            {
               this._sequencer.start();
            }
            else
            {
               _log.warn("Waiting sub sequence init end (" + this._subSequenceWaitingCount + " seq)");
            }
         }
         else
         {
            if(callback != null)
            {
               callback();
            }
            this._parent.subSequenceInitDone();
         }
      }
      
      private function onSequenceEnd(e:SequencerEvent) : void
      {
         this._sequencer.removeEventListener(SequencerEvent.SEQUENCE_END,this.onSequenceEnd);
         if(this._permanentTooltipsCallback)
         {
            this._permanentTooltipsCallback.exec();
         }
         this._sequenceEndCallback();
         this.updateMovementArea();
      }
      
      private function onStepEnd(e:SequencerEvent, isEnd:Boolean = true) : void
      {
         this._sequencer.removeEventListener(SequencerEvent.SEQUENCE_STEP_FINISH,this.onStepEnd);
      }
      
      private function subSequenceInitDone() : void
      {
         --this._subSequenceWaitingCount;
         if(!this.isWaiting && this._sequencer && !this._sequencer.running)
         {
            _log.warn("Sub sequence init end -- Run main sequence");
            this._sequencer.start();
         }
      }
      
      private function pushTeleportStep(fighterId:Number, destinationCell:int) : void
      {
         var step:FightTeleportStep = null;
         this._stepsBuffer.push(new CallbackStep(new Callback(deleteTooltip,fighterId)));
         if(destinationCell != -1)
         {
            step = new FightTeleportStep(fighterId,MapPoint.fromCellId(destinationCell));
            if(this.castingSpell != null)
            {
               step.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(step);
         }
      }
      
      private function pushSlideStep(fighterId:Number, startCell:int, endCell:int) : void
      {
         if(startCell < 0 || endCell < 0)
         {
            return;
         }
         this._stepsBuffer.push(new CallbackStep(new Callback(deleteTooltip,fighterId)));
         var step:FightEntitySlideStep = new FightEntitySlideStep(fighterId,MapPoint.fromCellId(startCell),MapPoint.fromCellId(endCell));
         if(this.castingSpell != null)
         {
            step.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(step);
      }
      
      private function pushPointsVariationStep(fighterId:Number, actionId:uint, delta:int) : void
      {
         var step:IFightStep = null;
         switch(actionId)
         {
            case ActionIdProtocol.ACTION_CHARACTER_ACTION_POINTS_USE:
               step = new FightActionPointsVariationStep(fighterId,delta,true);
               break;
            case ActionIds.ACTION_CHARACTER_ACTION_POINTS_LOST:
            case ActionIds.ACTION_CHARACTER_ACTION_POINTS_WIN:
               step = new FightActionPointsVariationStep(fighterId,delta,false);
               break;
            case ActionIdProtocol.ACTION_CHARACTER_MOVEMENT_POINTS_USE:
               step = new FightMovementPointsVariationStep(fighterId,delta,true);
               break;
            case ActionIds.ACTION_CHARACTER_MOVEMENT_POINTS_LOST:
            case ActionIds.ACTION_CHARACTER_MOVEMENT_POINTS_WIN:
               step = new FightMovementPointsVariationStep(fighterId,delta,false);
               break;
            default:
               _log.warn("Points variation with unsupported action (" + actionId + "), skipping.");
               return;
         }
         if(this.castingSpell != null)
         {
            step.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(step);
      }
      
      private function pushStep(step:AbstractSequencable) : void
      {
         if(this.castingSpell != null)
         {
            step.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(step);
      }
      
      private function pushPointsLossDodgeStep(fighterId:Number, actionId:uint, amount:int) : void
      {
         var step:IFightStep = null;
         switch(actionId)
         {
            case ActionIdProtocol.ACTION_FIGHT_SPELL_DODGED_PA:
               step = new FightActionPointsLossDodgeStep(fighterId,amount);
               break;
            case ActionIdProtocol.ACTION_FIGHT_SPELL_DODGED_PM:
               step = new FightMovementPointsLossDodgeStep(fighterId,amount);
               break;
            default:
               _log.warn("Points dodge with unsupported action (" + actionId + "), skipping.");
               return;
         }
         if(this.castingSpell != null)
         {
            step.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(step);
      }
      
      private function pushPlaySpellScriptStep(fxScriptId:int, fighterId:Number, cellId:int, spellId:int, spellRank:uint, stepBuff:SpellScriptBuffer = null) : FightPlaySpellScriptStep
      {
         var step:FightPlaySpellScriptStep = new FightPlaySpellScriptStep(fxScriptId,fighterId,cellId,spellId,spellRank,!!stepBuff ? stepBuff : this);
         if(this.castingSpell != null)
         {
            step.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(step);
         return step;
      }
      
      private function pushThrowCharacterStep(fighterId:Number, carriedId:Number, cellId:int) : void
      {
         var step:FightThrowCharacterStep = new FightThrowCharacterStep(fighterId,carriedId,cellId);
         if(this.castingSpell != null)
         {
            step.castingSpellId = this.castingSpell.castingSpellId;
            step.portals = this.castingSpell.portalMapPoints;
            step.portalIds = this.castingSpell.portalIds;
         }
         this._stepsBuffer.push(step);
      }
      
      private function clearBuffer() : void
      {
         this._stepsBuffer = new Vector.<ISequencable>(0,false);
      }
      
      private function keepInMindToUpdateMovementArea() : void
      {
         if(this._updateMovementAreaAtSequenceEnd)
         {
            return;
         }
         var fightTurnFrame:FightTurnFrame = Kernel.getWorker().getFrame(FightTurnFrame) as FightTurnFrame;
         if(fightTurnFrame && fightTurnFrame.myTurn)
         {
            this._updateMovementAreaAtSequenceEnd = true;
         }
      }
      
      private function updateMovementArea() : void
      {
         if(!this._updateMovementAreaAtSequenceEnd)
         {
            return;
         }
         var fightTurnFrame:FightTurnFrame = Kernel.getWorker().getFrame(FightTurnFrame) as FightTurnFrame;
         if(fightTurnFrame && fightTurnFrame.myTurn)
         {
            fightTurnFrame.drawMovementArea();
            this._updateMovementAreaAtSequenceEnd = false;
         }
      }
      
      private function showTargetTooltip(pEntityId:Number) : void
      {
         var fcf:FightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         var entityInfos:GameFightFighterInformations = this.fightEntitiesFrame.getEntityInfos(pEntityId) as GameFightFighterInformations;
         if(entityInfos.spawnInfo.alive && this._castingSpell && (this._castingSpell.casterId == PlayedCharacterManager.getInstance().id || fcf.battleFrame.playingSlaveEntity) && pEntityId != this.castingSpell.casterId && this._fightBattleFrame.targetedEntities.indexOf(pEntityId) == -1 && fcf.hiddenEntites.indexOf(pEntityId) == -1)
         {
            this._fightBattleFrame.targetedEntities.push(pEntityId);
            if(OptionManager.getOptionManager("dofus").getOption("showPermanentTargetsTooltips") == true)
            {
               fcf.displayEntityTooltip(pEntityId);
            }
         }
      }
      
      private function isSpellTeleportingToPreviousPosition() : Boolean
      {
         var spellEffect:EffectInstanceDice = null;
         if(this.castingSpell && this.castingSpell.spellRank)
         {
            for each(spellEffect in this.castingSpell.spellRank.effects)
            {
               if(spellEffect.effectId == ActionIds.ACTION_FIGHT_ROLLBACK_PREVIOUS_POSITION)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function showPermanentTooltips(pSteps:Array) : void
      {
         var step:AbstractSequencable = null;
         var targetId:Number = NaN;
         if(!this.fightEntitiesFrame)
         {
            return;
         }
         var targetInfo:GameContextActorInformations = null;
         for each(step in pSteps)
         {
            if(step is IFightStep && !(step is FightTurnListStep))
            {
               for each(targetId in (step as IFightStep).targets)
               {
                  if(this.fightEntitiesFrame.hasEntity(targetId))
                  {
                     targetInfo = this.fightEntitiesFrame.getEntityInfos(targetId);
                     if(targetInfo && targetInfo.disposition.cellId != -1)
                     {
                        this.showTargetTooltip(targetId);
                     }
                  }
               }
            }
         }
      }
      
      private function summonEntity(entity:GameFightFighterInformations, sourceId:Number, actionId:uint) : void
      {
         var isBomb:Boolean = false;
         var isCreature:Boolean = false;
         var entityInfosS:GameContextActorInformations = null;
         var summonedEntityInfosS:GameFightMonsterInformations = null;
         var monsterS:Monster = null;
         var summonedCharacterInfoS:GameFightCharacterInformations = null;
         var gfsgmsg:GameFightShowFighterMessage = new GameFightShowFighterMessage();
         gfsgmsg.initGameFightShowFighterMessage(entity);
         Kernel.getWorker().getFrame(FightEntitiesFrame).process(gfsgmsg);
         if(ActionIdHelper.isRevive(actionId))
         {
            this.fightEntitiesFrame.removeLastKilledAlly(entity.spawnInfo.teamId);
         }
         var summonedCreature:Sprite = DofusEntities.getEntity(entity.contextualId) as Sprite;
         if(summonedCreature)
         {
            summonedCreature.visible = false;
         }
         this.pushStep(new FightSummonStep(sourceId,entity));
         if(sourceId == CurrentPlayedFighterManager.getInstance().currentFighterId)
         {
            isBomb = false;
            isCreature = false;
            if(actionId == ActionIds.ACTION_SUMMON_BOMB)
            {
               isBomb = true;
            }
            else
            {
               entityInfosS = FightEntitiesFrame.getCurrentInstance().getEntityInfos(entity.contextualId);
               isBomb = false;
               summonedEntityInfosS = entityInfosS as GameFightMonsterInformations;
               if(summonedEntityInfosS)
               {
                  monsterS = Monster.getMonsterById(summonedEntityInfosS.creatureGenericId);
                  if(monsterS && monsterS.useBombSlot)
                  {
                     isBomb = true;
                  }
                  if(monsterS && monsterS.useSummonSlot)
                  {
                     isCreature = true;
                  }
               }
               else
               {
                  summonedCharacterInfoS = entityInfosS as GameFightCharacterInformations;
               }
            }
            if(isCreature || summonedCharacterInfoS)
            {
               CurrentPlayedFighterManager.getInstance().addSummonedCreature();
            }
            else if(isBomb)
            {
               CurrentPlayedFighterManager.getInstance().addSummonedBomb();
            }
         }
         var nextPlayableCharacterId:Number = this._fightBattleFrame.getNextPlayableCharacterId();
         if(this._fightBattleFrame.currentPlayerId != CurrentPlayedFighterManager.getInstance().currentFighterId && nextPlayableCharacterId != CurrentPlayedFighterManager.getInstance().currentFighterId && nextPlayableCharacterId == entity.contextualId)
         {
            this._fightBattleFrame.prepareNextPlayableCharacter();
         }
      }
   }
}
