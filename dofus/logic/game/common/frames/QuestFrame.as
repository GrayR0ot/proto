package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankama.dofus.enums.ActionIds;
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.managers.FrustumManager;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.monsters.Companion;
   import com.ankamagames.dofus.datacenter.quest.Achievement;
   import com.ankamagames.dofus.datacenter.quest.AchievementCategory;
   import com.ankamagames.dofus.datacenter.quest.AchievementReward;
   import com.ankamagames.dofus.datacenter.quest.Quest;
   import com.ankamagames.dofus.datacenter.quest.QuestObjective;
   import com.ankamagames.dofus.datacenter.quest.QuestStep;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.internalDatacenter.DataEnum;
   import com.ankamagames.dofus.internalDatacenter.appearance.OrnamentWrapper;
   import com.ankamagames.dofus.internalDatacenter.appearance.TitleWrapper;
   import com.ankamagames.dofus.internalDatacenter.communication.EmoteWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.quest.TreasureHuntStepWrapper;
   import com.ankamagames.dofus.internalDatacenter.quest.TreasureHuntWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.common.actions.AuthorizedCommandAction;
   import com.ankamagames.dofus.logic.common.managers.AccountManager;
   import com.ankamagames.dofus.logic.common.managers.FeatureManager;
   import com.ankamagames.dofus.logic.common.managers.NotificationManager;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.logic.game.common.actions.FollowQuestAction;
   import com.ankamagames.dofus.logic.game.common.actions.NotificationResetAction;
   import com.ankamagames.dofus.logic.game.common.actions.NotificationUpdateFlagAction;
   import com.ankamagames.dofus.logic.game.common.actions.RefreshFollowedQuestsOrderAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.AchievementAlmostFinishedDetailedListRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.AchievementDetailedListRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.AchievementDetailsRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.AchievementRewardRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.GuidedModeQuitRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.GuidedModeReturnRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.QuestInfosRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.QuestListRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.QuestObjectiveValidationAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.QuestStartRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.WatchQuestInfosRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.treasureHunt.TreasureHuntDigRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.treasureHunt.TreasureHuntFlagRemoveRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.treasureHunt.TreasureHuntFlagRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.treasureHunt.TreasureHuntGiveUpRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.treasureHunt.TreasureHuntLegendaryRequestAction;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.logic.game.fight.miscs.ActionIdProtocol;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.lists.QuestHookList;
   import com.ankamagames.dofus.misc.utils.ParamsDecoder;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.enums.CompassTypeEnum;
   import com.ankamagames.dofus.network.enums.GameServerTypeEnum;
   import com.ankamagames.dofus.network.enums.TreasureHuntDigRequestEnum;
   import com.ankamagames.dofus.network.enums.TreasureHuntFlagRequestEnum;
   import com.ankamagames.dofus.network.enums.TreasureHuntFlagStateEnum;
   import com.ankamagames.dofus.network.enums.TreasureHuntRequestEnum;
   import com.ankamagames.dofus.network.enums.TreasureHuntTypeEnum;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementAlmostFinishedDetailedListMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementAlmostFinishedDetailedListRequestMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementDetailedListMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementDetailedListRequestMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementDetailsMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementDetailsRequestMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementFinishedInformationMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementFinishedMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementListMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementRewardErrorMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementRewardRequestMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementRewardSuccessMessage;
   import com.ankamagames.dofus.network.messages.game.context.notification.NotificationResetMessage;
   import com.ankamagames.dofus.network.messages.game.context.notification.NotificationUpdateFlagMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.FollowQuestObjectiveRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.FollowedQuestsMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.GuidedModeQuitRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.GuidedModeReturnRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestListMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestListRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestObjectiveValidatedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestObjectiveValidationMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStartRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStartedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStepInfoMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStepInfoRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStepStartedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStepValidatedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestValidatedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.RefreshFollowedQuestsOrderRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.UnfollowQuestObjectiveRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.WatchQuestListMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.WatchQuestStepInfoMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.WatchQuestStepInfoRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntAvailableRetryCountUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntDigRequestAnswerFailedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntDigRequestAnswerMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntDigRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntFinishedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntFlagRemoveRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntFlagRequestAnswerMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntFlagRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntGiveUpRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntLegendaryRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntRequestAnswerMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntShowLegendaryUIMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectAddedMessage;
   import com.ankamagames.dofus.network.types.game.achievement.AchievementAchieved;
   import com.ankamagames.dofus.network.types.game.achievement.AchievementAchievedRewardable;
   import com.ankamagames.dofus.network.types.game.context.roleplay.quest.QuestActiveDetailedInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.quest.QuestActiveInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.quest.QuestObjectiveInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.quest.QuestObjectiveInformationsWithCompletion;
   import com.ankamagames.dofus.network.types.game.context.roleplay.treasureHunt.TreasureHuntFlag;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffect;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffectInteger;
   import com.ankamagames.dofus.types.enums.NotificationTypeEnum;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.QuestApi;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.jerakine.types.DataStoreType;
   import com.ankamagames.jerakine.types.enums.DataStoreEnum;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.misc.DictionaryUtils;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class QuestFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(QuestFrame));
      
      protected static const FIRST_TEMPORIS_REWARD_ACHIEVEMENT_ID:int = 2903;
      
      protected static const FIRST_TEMPORIS_COMPANION_REWARD_ACHIEVEMENT_ID:int = 2906;
      
      private static const TEMPORIS_CATEGORY:uint = 107;
      
      private static const STORAGE_NEW_TEMPORIS_REWARD:String = "storageNewTemporisReward";
      
      public static var notificationList:Array;
       
      
      private var _nbAllAchievements:int;
      
      private var _activeQuests:Vector.<QuestActiveInformations>;
      
      private var _completedQuests:Vector.<uint>;
      
      private var _reinitDoneQuests:Vector.<uint>;
      
      private var _followedQuests:Vector.<uint>;
      
      private var _questsInformations:Dictionary;
      
      private var _finishedAchievements:Vector.<AchievementAchieved>;
      
      private var _activeObjectives:Vector.<uint>;
      
      private var _completedObjectives:Vector.<uint>;
      
      private var _finishedAccountAchievementIds:Array;
      
      private var _finishedCharacterAchievementIds:Array;
      
      private var _rewardableAchievements:Vector.<AchievementAchievedRewardable>;
      
      private var _rewardableAchievementsVisible:Boolean;
      
      private var _treasureHunts:Dictionary;
      
      private var _flagColors:Array;
      
      private var _followedQuestsCallback:Callback;
      
      private var _achievementsFinishedCache:Array = null;
      
      private var _achievementsList:AchievementListMessage;
      
      private var _achievementsListProcessed:Boolean = false;
      
      public function QuestFrame()
      {
         this._followedQuests = new Vector.<uint>();
         this._questsInformations = new Dictionary();
         this._activeObjectives = new Vector.<uint>();
         this._completedObjectives = new Vector.<uint>();
         this._treasureHunts = new Dictionary();
         this._flagColors = new Array();
         super();
      }
      
      private static function displayFinishedAchievementInChat(finishedAchievement:Achievement) : void
      {
         var itemAwardIndex:uint = 0;
         var itemQuantity:uint = 0;
         var itemId:uint = 0;
         var spellId:uint = 0;
         var emoteId:uint = 0;
         var ornamentId:uint = 0;
         var titleId:uint = 0;
         if(finishedAchievement === null)
         {
            return;
         }
         var chatMessage:String = null;
         var currentAchievementReward:AchievementReward = null;
         var currentItemAward:ItemWrapper = null;
         var currentEmoteAward:EmoteWrapper = null;
         var currentOrnamentAward:OrnamentWrapper = null;
         var currentSpellAward:SpellWrapper = null;
         var currentTitleAward:TitleWrapper = null;
         for(var jndex:uint = 0; jndex < finishedAchievement.rewardIds.length; jndex++)
         {
            currentAchievementReward = AchievementReward.getAchievementRewardById(finishedAchievement.rewardIds[jndex]);
            if(currentAchievementReward !== null)
            {
               itemAwardIndex = 0;
               itemQuantity = 0;
               for each(itemId in currentAchievementReward.itemsReward)
               {
                  itemQuantity = currentAchievementReward.itemsQuantityReward.length > itemAwardIndex ? uint(currentAchievementReward.itemsQuantityReward[itemAwardIndex]) : uint(1);
                  currentItemAward = ItemWrapper.create(0,0,itemId,itemQuantity,new Vector.<ObjectEffect>(),false);
                  if(currentItemAward !== null)
                  {
                     chatMessage = I18n.getUiText("ui.temporis.rewardObtained",["{item," + currentItemAward.id + "::" + currentItemAward.name + "}","{openTemporisQuestTab::" + I18n.getUiText("ui.temporis.getReward") + "}"]);
                     KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,chatMessage,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
                  }
               }
               for each(spellId in currentAchievementReward.spellsReward)
               {
                  currentSpellAward = SpellWrapper.create(spellId,1,false,0,false);
                  if(currentSpellAward !== null)
                  {
                     chatMessage = I18n.getUiText("ui.temporis.rewardObtained",["{spell," + currentSpellAward.id + "," + currentSpellAward.spellLevel + "}","{openTemporisQuestTab::" + I18n.getUiText("ui.temporis.getReward") + "}"]);
                     KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,chatMessage,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
                  }
               }
               for each(emoteId in currentAchievementReward.emotesReward)
               {
                  currentEmoteAward = EmoteWrapper.create(emoteId,0);
                  if(currentEmoteAward !== null)
                  {
                     chatMessage = I18n.getUiText("ui.temporis.rewardObtained",["{showEmote," + currentEmoteAward.id + "::" + currentEmoteAward.emote.name + "}","{openTemporisQuestTab::" + I18n.getUiText("ui.temporis.getReward") + "}","{openTemporisQuestTab::" + I18n.getUiText("ui.temporis.getReward") + "}"]);
                     KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,chatMessage,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
                  }
               }
               for each(ornamentId in currentAchievementReward.ornamentsReward)
               {
                  currentOrnamentAward = OrnamentWrapper.create(ornamentId);
                  if(currentOrnamentAward !== null)
                  {
                     chatMessage = ParamsDecoder.applyParams(I18n.getUiText("ui.temporis.rewardObtained",["$ornament%1","{openTemporisQuestTab::" + I18n.getUiText("ui.temporis.getReward") + "}"]),[currentOrnamentAward.id]);
                     KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,chatMessage,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
                  }
               }
               for each(titleId in currentAchievementReward.titlesReward)
               {
                  currentTitleAward = TitleWrapper.create(titleId);
                  if(currentTitleAward !== null)
                  {
                     chatMessage = ParamsDecoder.applyParams(I18n.getUiText("ui.temporis.rewardObtained",["$title%1","{openTemporisQuestTab::" + I18n.getUiText("ui.temporis.getReward") + "}"]),[currentTitleAward.id]);
                     KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,chatMessage,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
                  }
               }
            }
         }
      }
      
      private static function displayRewardedAchievementInChat(rewardedAchievement:Achievement) : void
      {
         var itemAwardIndex:uint = 0;
         var itemQuantity:uint = 0;
         var itemId:uint = 0;
         var spellId:uint = 0;
         var emoteId:uint = 0;
         var ornamentId:uint = 0;
         var titleId:uint = 0;
         if(rewardedAchievement === null)
         {
            return;
         }
         var chatMessage:String = null;
         var currentAchievementReward:AchievementReward = null;
         var currentItemAward:ItemWrapper = null;
         var currentEmoteAward:EmoteWrapper = null;
         var currentOrnamentAward:OrnamentWrapper = null;
         var currentSpellAward:SpellWrapper = null;
         var currentTitleAward:TitleWrapper = null;
         for(var jndex:uint = 0; jndex < rewardedAchievement.rewardIds.length; jndex++)
         {
            currentAchievementReward = AchievementReward.getAchievementRewardById(rewardedAchievement.rewardIds[jndex]);
            if(currentAchievementReward !== null)
            {
               itemAwardIndex = 0;
               itemQuantity = 0;
               for each(itemId in currentAchievementReward.itemsReward)
               {
                  itemQuantity = currentAchievementReward.itemsQuantityReward.length > itemAwardIndex ? uint(currentAchievementReward.itemsQuantityReward[itemAwardIndex]) : uint(1);
                  currentItemAward = ItemWrapper.create(0,0,itemId,itemQuantity,new Vector.<ObjectEffect>(),false);
                  if(currentItemAward !== null)
                  {
                     chatMessage = I18n.getUiText("ui.temporis.rewardSuccess",["{item," + currentItemAward.id + "::" + currentItemAward.name + "}"]);
                     KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,chatMessage,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
                  }
               }
               for each(spellId in currentAchievementReward.spellsReward)
               {
                  currentSpellAward = SpellWrapper.create(spellId,1,false,0,false);
                  if(currentSpellAward !== null)
                  {
                     chatMessage = I18n.getUiText("ui.temporis.rewardSuccess",["{spell," + currentSpellAward.id + "," + currentSpellAward.spellLevel + "}"]);
                     KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,chatMessage,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
                  }
               }
               for each(emoteId in currentAchievementReward.emotesReward)
               {
                  currentEmoteAward = EmoteWrapper.create(emoteId,0);
                  if(currentEmoteAward !== null)
                  {
                     chatMessage = I18n.getUiText("ui.temporis.rewardSuccess",["{showEmote," + currentEmoteAward.id + "::" + currentEmoteAward.emote.name + "}"]);
                     KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,chatMessage,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
                  }
               }
               for each(ornamentId in currentAchievementReward.ornamentsReward)
               {
                  currentOrnamentAward = OrnamentWrapper.create(ornamentId);
                  if(currentOrnamentAward !== null)
                  {
                     chatMessage = ParamsDecoder.applyParams(I18n.getUiText("ui.temporis.rewardSuccess",["$ornament%1"]),[currentOrnamentAward.id]);
                     KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,chatMessage,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
                  }
               }
               for each(titleId in currentAchievementReward.titlesReward)
               {
                  currentTitleAward = TitleWrapper.create(titleId);
                  if(currentTitleAward !== null)
                  {
                     chatMessage = ParamsDecoder.applyParams(I18n.getUiText("ui.temporis.rewardSuccess",["$title%1"]),[currentTitleAward.id]);
                     KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,chatMessage,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
                  }
               }
            }
         }
      }
      
      public function get achievmentsList() : AchievementListMessage
      {
         return this._achievementsList;
      }
      
      public function get achievmentsListProcessed() : Boolean
      {
         return this._achievementsListProcessed;
      }
      
      public function get followedQuestsCallback() : Callback
      {
         return this._followedQuestsCallback;
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get finishedAchievements() : Vector.<AchievementAchieved>
      {
         return this._finishedAchievements;
      }
      
      public function get finishedAccountAchievementIds() : Array
      {
         return this._finishedAccountAchievementIds;
      }
      
      public function get finishedCharacterAchievementIds() : Array
      {
         return this._finishedCharacterAchievementIds;
      }
      
      public function getActiveQuests() : Vector.<QuestActiveInformations>
      {
         return this._activeQuests;
      }
      
      public function getCompletedQuests() : Vector.<uint>
      {
         return this._completedQuests;
      }
      
      public function getReinitDoneQuests() : Vector.<uint>
      {
         return this._reinitDoneQuests;
      }
      
      public function getFollowedQuests() : Vector.<uint>
      {
         return this._followedQuests;
      }
      
      public function getQuestInformations(questId:uint) : Object
      {
         return this._questsInformations[questId];
      }
      
      public function getActiveObjectives() : Vector.<uint>
      {
         return this._activeObjectives;
      }
      
      public function getCompletedObjectives() : Vector.<uint>
      {
         return this._completedObjectives;
      }
      
      public function get rewardableAchievements() : Vector.<AchievementAchievedRewardable>
      {
         return this._rewardableAchievements;
      }
      
      public function getTreasureHuntById(typeId:uint) : TreasureHuntWrapper
      {
         return this._treasureHunts[typeId];
      }
      
      public function pushed() : Boolean
      {
         this._rewardableAchievements = new Vector.<AchievementAchievedRewardable>();
         this._finishedAchievements = new Vector.<AchievementAchieved>();
         this._finishedAccountAchievementIds = new Array();
         this._finishedCharacterAchievementIds = new Array();
         this._treasureHunts = new Dictionary();
         this._nbAllAchievements = Achievement.getAchievements().length;
         this._achievementsList = new AchievementListMessage();
         this._achievementsList.initAchievementListMessage(new Vector.<AchievementAchieved>());
         this._flagColors[TreasureHuntFlagStateEnum.TREASURE_HUNT_FLAG_STATE_UNKNOWN] = XmlConfig.getInstance().getEntry("colors.flag.unknown");
         this._flagColors[TreasureHuntFlagStateEnum.TREASURE_HUNT_FLAG_STATE_OK] = XmlConfig.getInstance().getEntry("colors.flag.right");
         this._flagColors[TreasureHuntFlagStateEnum.TREASURE_HUNT_FLAG_STATE_WRONG] = XmlConfig.getInstance().getEntry("colors.flag.wrong");
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         /*
          * Erreur de décompilation
          * Le délais dattente de ({0}) est expiré
          * Nb d'instructions : 4466
          */
         throw new flash.errors.IllegalOperationError("Non décompilé car le délais d'attente a été atteint");
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      private function hasTreasureHunt() : Boolean
      {
         var key:* = undefined;
         for(key in this._treasureHunts)
         {
            if(key != null)
            {
               return true;
            }
         }
         return false;
      }
      
      public function processAchievements(resetRewards:Boolean = false) : void
      {
         var ach:Achievement = null;
         var achievedAchievement:AchievementAchieved = null;
         var rewardsUiNeedOpening:Boolean = false;
         var playerAchievementsCount:int = 0;
         var accountAchievementsCount:int = 0;
         var playerPoints:int = 0;
         var accountPoints:int = 0;
         var achievementDone:Dictionary = new Dictionary();
         this._finishedAchievements = new Vector.<AchievementAchieved>();
         this._finishedCharacterAchievementIds = [];
         if(resetRewards)
         {
            this._rewardableAchievements = new Vector.<AchievementAchievedRewardable>();
         }
         for each(achievedAchievement in this._achievementsList.finishedAchievements)
         {
            ach = Achievement.getAchievementById(achievedAchievement.id);
            if(ach != null && ach && ach.category && ach.category.visible)
            {
               if(achievedAchievement is AchievementAchievedRewardable && this._rewardableAchievements.indexOf(achievedAchievement) === -1)
               {
                  this._rewardableAchievements.push(achievedAchievement);
               }
               if(this._finishedAchievements.indexOf(achievedAchievement) === -1)
               {
                  this._finishedAchievements.push(achievedAchievement);
               }
               accountPoints += ach.points;
               accountAchievementsCount++;
               if(this._finishedAccountAchievementIds.indexOf(ach.id) == -1)
               {
                  this._finishedAccountAchievementIds.push(ach.id);
               }
               if(achievedAchievement.achievedBy == PlayedCharacterManager.getInstance().id)
               {
                  playerPoints += ach.points;
                  playerAchievementsCount++;
                  this._finishedCharacterAchievementIds.push(ach.id);
               }
               achievementDone[achievedAchievement.id] = true;
            }
            else if(ach == null)
            {
               _log.warn("Succés " + achievedAchievement.id + " non exporté");
            }
         }
         PlayedCharacterManager.getInstance().achievementPercent = Math.floor(playerAchievementsCount / this._nbAllAchievements * 100);
         PlayedCharacterManager.getInstance().achievementPoints = playerPoints;
         AccountManager.getInstance().achievementPercent = Math.floor(accountAchievementsCount / this._nbAllAchievements * 100);
         AccountManager.getInstance().achievementPoints = accountPoints;
         KernelEventsManager.getInstance().processCallback(QuestHookList.AchievementList);
         rewardsUiNeedOpening = this.doesRewardsUiNeedOpening();
         if(!this._rewardableAchievementsVisible && rewardsUiNeedOpening)
         {
            this._rewardableAchievementsVisible = true;
            KernelEventsManager.getInstance().processCallback(QuestHookList.RewardableAchievementsVisible,this._rewardableAchievementsVisible);
         }
         if(this._rewardableAchievementsVisible && !rewardsUiNeedOpening)
         {
            this._rewardableAchievementsVisible = false;
            KernelEventsManager.getInstance().processCallback(QuestHookList.RewardableAchievementsVisible,this._rewardableAchievementsVisible);
         }
         this._achievementsListProcessed = true;
      }
      
      private function getCompanion(achievement:Achievement) : Companion
      {
         var rewardId:int = 0;
         var reward:AchievementReward = null;
         var itemRewardIndex:int = 0;
         var itemQuantity:int = 0;
         var currentItemReward:Item = null;
         var itemId:int = 0;
         var compId:int = 0;
         var ei:EffectInstance = null;
         var companion:Companion = null;
         loop0:
         for each(rewardId in achievement.rewardIds)
         {
            reward = AchievementReward.getAchievementRewardById(rewardId);
            if(reward != null)
            {
               itemRewardIndex = 0;
               itemQuantity = 0;
               var _loc13_:int = 0;
               var _loc14_:* = reward.itemsReward;
               loop1:
               while(true)
               {
                  for each(itemId in _loc14_)
                  {
                     itemQuantity = reward.itemsQuantityReward.length > itemRewardIndex ? int(reward.itemsQuantityReward[itemRewardIndex]) : 1;
                     currentItemReward = Item.getItemById(itemId);
                     itemRewardIndex++;
                     if(currentItemReward.typeId == DataEnum.ITEM_TYPE_COMPANION)
                     {
                        for each(ei in currentItemReward.possibleEffects)
                        {
                           if(ei.effectId == ActionIds.ACTION_SET_COMPANION)
                           {
                              compId = int(ei.parameter2);
                              break;
                           }
                        }
                        if(compId > 0)
                        {
                           break loop1;
                        }
                     }
                  }
                  continue loop0;
               }
               return Companion.getCompanionById(compId);
            }
         }
         return null;
      }
      
      private function doesRewardsUiNeedOpening() : Boolean
      {
         var rewardable:AchievementAchievedRewardable = null;
         var achievement:Achievement = null;
         var category:AchievementCategory = null;
         for each(rewardable in this._rewardableAchievements)
         {
            if(rewardable !== null)
            {
               achievement = Achievement.getAchievementById(rewardable.id);
               if(achievement !== null)
               {
                  category = achievement.category;
                  if(category !== null && category.id !== TEMPORIS_CATEGORY)
                  {
                     return true;
                  }
               }
            }
         }
         return false;
      }
   }
}
