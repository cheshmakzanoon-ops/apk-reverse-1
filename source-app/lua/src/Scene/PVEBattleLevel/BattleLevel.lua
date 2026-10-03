local Player = require("Scene.PVEBattleLevel.Player.Player")
local Fog = require("Scene.PVEBattleLevel.Fog")
local CarryResourceUI = require("Scene.PVEBattleLevel.CarryResourceUI")
local PveBuild = require("Scene.PVEBattleLevel.PveBuild")
local Resource = CS.GameEntry.Resource
local Physics = CS.UnityEngine.Physics
local PVEScenePath = "Assets/Main/Prefabs/PVELevel/%s/scene.prefab"
local PVEDecorationPath = "Assets/Main/Prefabs/PVELevel/%s/decoration.bytes"
local PVEResConfigPath = "Assets/Main/Prefabs/PVELevel/%s/res_config.json"
local PVELightMapConfigPath = "Assets/Main/Prefabs/PVELevel/%s/LightMap.json"
local QualitySettings = CS.UnityEngine.QualitySettings
local TouchWrapper = CS.BitBenderGames.TouchWrapper
local EventSystem = CS.UnityEngine.EventSystems.EventSystem
local MobileTouchCamera = CS.BitBenderGames.MobileTouchCamera
local Const = require("Scene.PVEBattleLevel.Const")
local BattlePveConst = require("Scene.BattlePveModule.Const")
local RewardUtil = require("Util.RewardUtil")
local PveModuleConst = require("Scene.BattlePveModule.Const")
local GameObject = CS.UnityEngine.GameObject
local Localization = CS.GameEntry.Localization
local CollectionManager = require("Scene.PVEBattleLevel.CollectionManager")
local PveNpcManager = require("Scene.PVEBattleLevel.PveNpcManager")
local PveDropBuffManager = require("Scene.PVEBattleLevel.PveDropBuffManager")
local PveWaitMoveManager = require("Scene.PVEBattleLevel.PveWaitMoveManager")
local PveYellowArrowManager = require("Scene.PVEBattleLevel.PveYellowArrowManager")
local PveTimeLineManager = require("Scene.PVEBattleLevel.PveTimeLineManager")
local Zombie = require("Scene.PVEBattleLevel.Zombie.Zombie")
local FollowPlayer = require("Scene.PVEBattleLevel.FollowPlayer.FollowPlayer")
local PveFlyResManager = require("Scene.PVEBattleLevel.PveFlyResManager")
local PveResRecordManager = require("Scene.PVEBattleLevel.PveResRecordManager")
local PveDBManager = require("Scene.PVEBattleLevel.PveDBManager")
local TriggerPointManager = require("Scene.PVEBattleLevel.TriggerPointManager")
local PveDropRewardManager = require("Scene.PVEBattleLevel.PveDropReward.PveDropRewardManager")
local PveSelectionManager = require("Scene.PVEBattleLevel.PveSelectionManager")
local PveHeroManager = require("Scene.PVEBattleLevel.PveHeroManager")
local BattleConst = require("Scene.BattlePveModule.Const")
local LevelState = {
  Init = 0,
  RequestInfo = 1,
  Created = 2,
  Destroying = 3,
  Destroyed = 4
}
local TimeLimitState = {
  Normal = 0,
  Win = 1,
  Lose = 2
}

local function GetOffsetZ(height, rotation)
  return height / math.tan(rotation * math.pi / 180)
end

local ExtraManPos = {
  Vector3.New(0, 0, 0),
  Vector3.New(0, 0, -2),
  Vector3.New(-2, 0, 0),
  Vector3.New(2, 0, 0),
  Vector3.New(0, 0, 2),
  Vector3.New(2, 0, 2),
  Vector3.New(-2, 0, 2),
  Vector3.New(2, 0, -2),
  Vector3.New(-2, 0, -2)
}
local InitMovePeopleNum = 6

local function FindRewardFlyPos(rewardType)
  local battle = DataCenter.BattleLevel
  if battle ~= nil and battle.uiPveMain ~= nil then
    local resType = RewardToResType[rewardType]
    if resType ~= nil then
      local pveRes = Const.ResourceTypeToResType[resType]
      if pveRes ~= nil then
        local obj = battle.uiPveMain:GetFlyNode(pveRes)
        if obj then
          return obj.transform.position
        end
      end
    else
      local pos = battle.uiPveMain:GetFlyPosByRewardType(rewardType)
      if pos ~= nil then
        return pos
      end
    end
  end
  local flyPosPath = Const.FlyPosPath[rewardType]
  if flyPosPath then
    local obj = CS.UnityEngine.GameObject.Find(flyPosPath)
    if obj then
      return obj.transform.position
    end
  end
  local obj = GameObject.Find(Const.FlyPosDefaultPath)
  if obj then
    return obj.transform.position
  end
  return Vector3.zero
end

local DiffUpWin = 1
local MaxDiff = 3
local HighViewDuration = 0.4
local CameraPaddingX = 27
local CameraPaddingZ = 17
local BattleLevel = BaseClass("BattleLevel")

function BattleLevel:__init()
  self.nextObjId = 1
  self.sceneObjs = {}
  self.zombies = {}
  self.cameraRot = nil
  self.levelState = LevelState.Init
  self.pveStatus = PveStatus.FirstStart
  self.isBattle = false
  self.triggerReward = {}
  self.specialTriggers = {}
  self.triggerMonsters = {}
  self.frontRewardDict = {}
  self.frontFinishTriggerList = {}
  self.usedTime = 0
  self.isTimeLimited = false
  self.isStarLevel = false
  self.isCheckingTime = false
  self.cheatOk = false
  self.isHighView = false
  self.started = false
  self.isAlreadyOpenEnergyPanel = false
  self.cityPrefabAsset = nil
  self.player = nil
  self.squad = nil
  self.playerGroup = {}
  self.followPlayerGroup = {}
  self.followPlayerQueue = {}
  self.resourceText = nil
  self.levelParamStack = {}
  self.staticMgr = nil
  self.build = {}
  self.buff = {}
  self.playerEffect = {}
  self.collectionMgr = CollectionManager.New()
  self.waitDoGuide = {}
  self.resItem = {}
  self.npcMgr = PveNpcManager.New()
  self.dropBuffMgr = PveDropBuffManager.New()
  self.waitMoveMgr = PveWaitMoveManager.New()
  self.arrowMgr = PveYellowArrowManager.New()
  self.timelineMgr = PveTimeLineManager.New()
  self.dropRewardMgr = PveDropRewardManager.New()
  self.selectionMgr = PveSelectionManager.New()
  self.heroMgr = PveHeroManager.New()
  self.pveTriggerGuide = nil
  self.InitMovePeopleNum = InitMovePeopleNum
  self.followCameraTarget = Vector3.zero
  self.buffEffectDict = {}
  self.guideNoShowTriggerId = {}
  self.flyResMgr = PveFlyResManager.New()
  self.resRecordMgr = PveResRecordManager.New(self)
  self.dbMgr = PveDBManager.New(self)
  self.triggerMgr = TriggerPointManager.New()
  self.isDebug = CS.CommonUtils.IsDebug() and CS.UnityEngine.Application.isEditor
  self.guideHideSkill = false
  self.lvPoint = 0
  self.saveCameraHeight = nil
  
  function self.cameraAfterUpdate()
    self:ClampCamera()
  end
  
  self.teleportBack = nil
  self.speedMulti = 1
end

function BattleLevel:__delete()
  self.player = nil
  self.squad = nil
  self.playerGroup = nil
  self.resourceText = nil
  self.build = nil
  self.buff = nil
  self.playerEffect = nil
  self.waitDoGuide = nil
  self.resItem = nil
  self.npcMgr = nil
  self.dropBuffMgr = nil
  self.dropRewardMgr = nil
  self.waitMoveMgr = nil
  self.arrowMgr = nil
  self.pveTriggerGuide = nil
  self.timelineMgr = nil
  self.InitMovePeopleNum = nil
  self.buffEffectDict = nil
  self.guideNoShowTriggerId = {}
  self.flyResMgr = nil
  self.resRecordMgr = nil
  self.dbMgr = nil
  self.guideHideSkill = false
  self.lvPoint = nil
  self.cameraAfterUpdate = nil
  self.triggerMgr = nil
  self.saveCameraHeight = nil
  self.teleportBack = nil
  self.speedMulti = nil
end

local function AccumulateReward(list, reward)
  if list == nil then
    list = {}
  end
  local found = false
  for i, v in ipairs(list) do
    if v.rewardType == reward.rewardType and v.itemId == reward.itemId and v.count then
      v.count = v.count + (reward.count or 0)
      found = true
    end
  end
  if not found then
    list[#list + 1] = reward
  end
  return list
end

function BattleLevel:OnGetStageMessage(message)
end

function BattleLevel:HandleSpecialEnd(finishTriggerId, callback)
  if self.pveStatus == PveStatus.Finish then
    return false
  end
  if finishTriggerId ~= nil then
    local trigger = self:GetTriggerByTriggerId(finishTriggerId)
    if trigger == nil or trigger:IsSideQuest() then
      return false
    end
  end
  local hasSpecialEnd = false
  local specialEnd
  local triggers = self.triggerMgr:GetTriggers()
  for _, p in pairs(triggers) do
    if p:ISSpecialEnd() and not self:IsFinishTrigger(p:GetTriggerId()) then
      hasSpecialEnd = true
      specialEnd = p
      break
    end
  end
  if not hasSpecialEnd or specialEnd == nil then
    return false
  end
  for _, p in pairs(triggers) do
    if not p:ISSpecialEnd() and not p:IsSideQuest() and not self:IsFinishTrigger(p.triggerId) then
      return false
    end
  end
  UIUtil.ShowMessage(Localization:GetString("134013"), 2, "134012", GameDialogDefine.CANCEL, function()
    self:DoTrigger(specialEnd)
  end, function()
    if callback ~= nil then
      callback()
    end
  end)
  return true
end

function BattleLevel:OnFinishTriggerMessage(message)
  if self.levelState == LevelState.Destroyed or self.levelState == LevelState.Destroying then
    return
  end
  self:SetFinishTrigger(message)
  self:SetSpecialTriggers(message)
  self:SetTriggerMonsters(message)
  local finishTriggerId = self.triggerMgr:GetLastFinishTrigger()
  local triggerPoint = self:GetTriggerByTriggerId(finishTriggerId)
  if triggerPoint == nil then
    self:HandleDropMessage(message)
  else
    self:HandleDropMessage(message, triggerPoint:GetPosition())
  end
  if message.reward then
    self:OnRewardMessage(message.reward, true)
  end
  if message.level ~= nil and message.status ~= nil and message.level == self.levelId and message.status == PveStatus.Finish then
    self.pveStatus = PveStatus.Finish
    if triggerPoint == nil or not triggerPoint:IsTypeRewardBoxUI() and not triggerPoint:IsTypeAdventureSub() then
      self:CheckShowLevelReward()
    end
    self:OnFinish()
  end
  if message.heroExpReward ~= nil then
    local reportReward = PBController.ParsePb1(message.heroExpReward, "protobuf.ReportReward")
    local exps = reportReward.rewardHeroExps
    if self:GetLevelType() == PveLevelType.HeroExpLevel then
      for _, info in ipairs(exps) do
        for _, player in ipairs(self.playerGroup) do
          if player.param.heroUuid == info.heroUuid then
            player:UpdateExpInfo(info)
          end
        end
      end
    elseif self:GetLevelType() == PveLevelType.NormalExpLevel then
      for _, info in ipairs(exps) do
        self.player:ShowAddExp(info.expAdd)
        self.player:FlyExpBall(info)
      end
    end
  end
  if message.armyRecord then
    local oldCount = self.armyRecord and self.armyRecord.aliveCount or 0
    self.armyRecord = PveUtil.ParseArmyRecord(message.armyRecord)
    local newCount = self.armyRecord and self.armyRecord.aliveCount or 0
    DataCenter.BattleLevel:UpdateArmyRecordHpBar(true)
    if triggerPoint:IsTypeHealArmy() then
      UIUtil.ShowSingleTip(Localization:GetString("339005", newCount - oldCount))
    end
  end
end

function BattleLevel:OnBattleMessage(message)
  local pveInfo = message.pveInfo
  if pveInfo == nil then
    return
  end
  local level = pveInfo.level
  local status = pveInfo.status
  self:SetFinishTrigger(pveInfo)
  self:SetSpecialTriggers(pveInfo)
  self:UpdateOneTriggerMonster(message)
  if level ~= nil and status ~= nil and level == self.levelId and status == PveStatus.Finish then
    self.pveStatus = PveStatus.Finish
  end
  if pveInfo.armyRecord then
    self.armyRecord = PveUtil.ParseArmyRecord(pveInfo.armyRecord)
  end
  if message.pveBuffs then
    self:UpdatePveBuffs(message.pveBuffs)
  end
  self.battleRewardMessage = message.reward
  self:HandleDropMessage(message)
end

function BattleLevel:OnStartLevelMessage(message)
  if self.levelState == LevelState.Destroyed or self.levelState == LevelState.Destroying then
    return
  end
  self.isWaitingLevelInfo = false
  if message.errorCode then
    Logger.LogError("BattleLevel, OnStartLevelMessage, errorCode: " .. message.errorCode)
    if self.uiPveLoading then
      self.uiPveLoading:Quit()
    end
    self.levelState = LevelState.Destroyed
    self.levelParamStack = {}
    return
  end
  if message.finishTrigger then
    self:SetFinishTrigger(message)
  end
  if message.specialTriggers then
    self:SetSpecialTriggers(message)
  end
  if message.triggerMonsters then
    self:SetTriggerMonsters(message)
  end
  if message.dropItems ~= nil then
    DataCenter.PveDropRewardInfoManager:DropRewardHandle(message)
  end
  self.resRecordMgr:InitPveRecord(message.pveResRecord)
  if message.selectTrigger then
    self.selectTriggerStr = message.selectTrigger
  end
  if message.rewardInfos then
    local rewardList = {}
    local RewardManager = DataCenter.RewardManager
    for _, triggerReward in pairs(message.rewardInfos) do
      local list = RewardManager:ReturnRewardParamForMessage(triggerReward.reward)
      if list then
        for _, reward in ipairs(list) do
          AccumulateReward(rewardList, reward)
        end
      end
    end
    self.rewardList = rewardList
  end
  self.heroMgr:UpdateCurHeroesFromMessage(message)
  local resource = message.resource
  if resource then
    LuaEntry.Resource:UpdateResource(resource)
  end
  if message.accPoint ~= nil then
    DataCenter.AllianceBaseDataManager:UpdateAccPoint(message.accPoint)
  end
  self.frontRewardDict = {}
  if message.allRewards then
    for _, v in ipairs(message.allRewards) do
      self.frontRewardDict[v.id] = v.reward
    end
  end
  if message.pveRandom then
    self.pveRandom = message.pveRandom
  end
  self.armyRecord = nil
  if message.armyRecord then
    self.armyRecord = PveUtil.ParseArmyRecord(message.armyRecord)
  end
  self.pveBuffs = {}
  self.heroMgr:ClearHiredHeroes()
  if message.pveBuffs then
    self:UpdatePveBuffs(message.pveBuffs)
  end
  DataCenter.GuideManager:SendLogMessage(self.levelId, StatTTType.CreateLevelStart, "")
  self:CreateLevel()
end

function BattleLevel:OnRewardMessage(reward, flyReward, triggerId)
  DataCenter.RewardManager:AddRewards(reward)
  local rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(reward)
  if rewardList then
    if flyReward then
      local finishTriggerId = triggerId or self.triggerMgr:GetLastFinishTrigger()
      if finishTriggerId ~= nil then
        do
          local triggerPoint = self:GetTriggerByTriggerId(finishTriggerId)
          if triggerPoint and triggerPoint:GetTilePos() then
            if triggerPoint:IsTypeRewardBoxUI() then
              triggerPoint:PlayRewardBoxOpen(function()
                self:ShowBoxReward(finishTriggerId, rewardList)
              end)
            else
              local srcPos = self:WorldToScreenPoint(SceneUtils.TileToWorld(triggerPoint:GetTilePos()))
              local delay = 0
              for _, v in ipairs(rewardList) do
                if v.rewardType ~= RewardType.HERO then
                  local targetPos = FindRewardFlyPos(v.rewardType)
                  local pic = RewardUtil.GetPic(v.rewardType, v.itemId)
                  local notShowNum = v.rewardType == RewardType.PVE_STAMINA or v.rewardType == RewardType.FORMATION_STAMINA
                  local tmp = DataCenter.RewardManager:GetRewardNumsInPveScene(v.count, notShowNum, v.rewardType)
                  local delayTime, totalTime = UIUtil.DoJumpFly(pic, tmp, srcPos, targetPos, delay)
                  if v.rewardType == RewardType.PVE_STAMINA or v.rewardType == RewardType.FORMATION_STAMINA then
                    local param = {}
                    param.delayTime = delayTime
                    param.totalTime = totalTime
                    EventManager:GetInstance():Broadcast(EventId.DelayRefreshPVEStamina, param)
                  end
                  delay = delay + 0.3
                end
              end
            end
          end
        end
      end
    end
    for _, v in ipairs(rewardList) do
      AccumulateReward(self.rewardList, v)
    end
  end
end

function BattleLevel:SendFinishTrigger(triggerId)
  self.resRecordMgr:SyncPveResource()
  self.triggerMgr:AddOneFinishTrigger(triggerId)
  if self.isDebug then
    Logger.Log("FinishTrigger  ---------------------  " .. triggerId)
  end
  local trigger = DataCenter.BattleLevel:GetTriggerByTriggerId(triggerId)
  local triggerType = trigger:GetTriggerType()
  if triggerType ~= Const.TriggerType.BuffBox and triggerType ~= Const.TriggerType.GainBuff and triggerType ~= Const.TriggerType.AdventureSub and triggerType ~= Const.TriggerType.HireHero then
    local param = {}
    param.level = self.levelId
    param.trigger = triggerId
    param.x, param.y = self:GetOnePveDropRewardPosition(trigger:GetPosition())
    SFSNetwork.SendMessage(MsgDefines.UserFinishPVETrigger, param)
  end
end

function BattleLevel:SendFinishLevel(rewardIndex, isSuccess)
  DataCenter.GuideManager:SendLogMessage(self.levelId, StatTTType.FinishLevel, "")
  SFSNetwork.SendMessage(MsgDefines.UserFinishPVELevel, self.levelId, rewardIndex, isSuccess)
end

function BattleLevel:OnFinishLevelMessage(message)
  if self.isSuccess then
    if self.isTimeLimited then
      if message.level == self.levelId and message.status == PveStatus.Finish then
        self.pveStatus = PveStatus.Finish
      end
      if message.heroExpReward ~= nil then
        local reportReward = PBController.ParsePb1(message.heroExpReward, "protobuf.ReportReward")
        local exps = reportReward.rewardHeroExps
        EventManager:GetInstance():Broadcast(EventId.RefreshExpFromMessage, exps)
      end
    end
    self:OnFinish()
  else
  end
end

function BattleLevel:SetFinishTrigger(message)
  self.triggerMgr:SetFinishTrigger(message)
end

function BattleLevel:SetSpecialTriggers(message)
  local specialTriggers = message.specialTriggers
  if specialTriggers ~= nil then
    self.specialTriggers = {}
    for k, v in ipairs(specialTriggers) do
      self:AddOneSpecialTriggers(v)
    end
  end
end

function BattleLevel:OnUpgradeTriggerBuildingHandler(message)
  local level = message.level
  local triggerInfo = message.triggerInfo
  if level == self.levelId and triggerInfo ~= nil then
    local find = self:HaveSpecialTriggers(triggerInfo.id)
    self:AddOneSpecialTriggers(triggerInfo)
    if not find then
      local factoryData = DataCenter.FactoryDataManager:GetFactoryDataByBUuid(triggerInfo.uuid)
      if factoryData == nil then
        SFSNetwork.SendMessage(MsgDefines.SynFoodFactory, triggerInfo.uuid)
      end
    else
      DataCenter.FactoryDataManager:ResetPveFactoryFormula(triggerInfo.id)
    end
    EventManager:GetInstance():Broadcast(EventId.PVEBuildingUpgradeBack)
  end
end

function BattleLevel:GetPveTriggerBuildingInfo(triggerId)
  return self:GetSpecialTriggerInfo(triggerId)
end

function BattleLevel:GetPveTriggerBuildingInfoByUUid(uuid)
  for _, v in pairs(self.specialTriggers) do
    if v.uuid == uuid then
      return v
    end
  end
  return nil
end

function BattleLevel:OnClearPVETriggerRewardCDHandler(message)
  local level = message.level
  local triggerInfo = message.triggerInfo
  if level == self.levelId and triggerInfo ~= nil then
    self:AddOneSpecialTriggers(triggerInfo)
    local trigger = self:GetTriggerByTriggerId(triggerInfo.id)
    if trigger ~= nil then
      trigger:RefreshRewardState()
    end
  end
  if message.gold ~= nil then
    LuaEntry.Player.gold = message.gold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
end

function BattleLevel:OnReceivePveTriggerRewardHandler(message)
  local triggerId, triggerPos
  local level = message.level
  local triggerInfo = message.triggerInfo
  if level == self.levelId and triggerInfo ~= nil then
    self:AddOneSpecialTriggers(triggerInfo)
    triggerId = triggerInfo.id
    local trigger = self:GetTriggerByTriggerId(triggerId)
    if trigger ~= nil then
      triggerPos = trigger:GetPosition()
      if trigger:ISCollectRewardMoreThanOneTimeAllComplete() then
        self:DoTrigger(trigger)
      else
        trigger:RefreshRewardState()
      end
    end
  end
  if message.reward ~= nil then
    self:OnRewardMessage(message.reward, true, triggerId)
  end
  self:HandleDropMessage(message, triggerPos)
end

function BattleLevel:GetMoreThanOneRewardInfo(triggerId)
  local info = self:GetSpecialTriggerInfo(triggerId)
  if info ~= nil then
    return info.lrt, info.ct
  end
  return 0, 0
end

function BattleLevel:OnPayTriggerResItemHandler(message)
  local level = message.level
  local triggerInfo = message.triggerInfo
  if level == self.levelId and triggerInfo ~= nil then
    self:AddOneSpecialTriggers(triggerInfo)
    local trigger = self:GetTriggerByTriggerId(triggerInfo.id)
    if trigger ~= nil then
      trigger:RefreshComplete()
    end
  end
  if message.gold ~= nil then
    LuaEntry.Player.gold = message.gold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
  EventManager:GetInstance():Broadcast(EventId.PayTriggerResItemBack)
end

function BattleLevel:IsItemSubmit(triggerId, index)
  local info = self:GetSpecialTriggerInfo(triggerId)
  if info ~= nil and info.payArr ~= nil then
    for k, v in ipairs(info.payArr) do
      if v == index then
        return true
      end
    end
  end
  return false
end

function BattleLevel:CreateLevel()
  self.nextObjId = 1
  self.isWaitingLevelInfo = false
  self.sceneObjs = {}
  self.spawnPos = nil
  self.isBattle = false
  self.isHighView = false
  self.resourceText = nil
  self.rewardList = {}
  self:LoadScene()
  if self.pveTemplate.type == PveLevelType.BarrageLevel then
  else
    self:CreatePlayer()
  end
  self:CreateFog()
  self:InitCamera()
  self:AddUpdateTimer()
  self.selectionMgr:Create()
  self.heroMgr:ClearBanHeroIds()
  EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, false)
  self.levelState = LevelState.Created
  self:AddListeners()
end

function BattleLevel:Destroy(exceptScene)
  Logger.Log("BattleLevel:Destroy begin")
  PveActorMgr:GetInstance():Destroy()
  if self.resourceText ~= nil then
    self.resourceText:Destroy()
    self.resourceText = nil
  end
  for _, o in pairs(self.zombies) do
    o:Destroy()
  end
  self.zombies = {}
  for _, o in pairs(self.followPlayerGroup) do
    o:Destroy()
  end
  self.followPlayerGroup = {}
  self.followPlayerQueue = {}
  Logger.Log("BattleLevel:Destroy ClearPlayer")
  self:ClearPlayer()
  Logger.Log("BattleLevel:Destroy ClearBuild")
  self:ClearBuild()
  self.sceneObjs = nil
  if not exceptScene and self.levelInst then
    self.levelInst:Destroy()
    self.levelInst = nil
  end
  if self.fog then
    self.fog:RemoveAll()
    self.fog = nil
  end
  if self.showRewardTimer then
    self.showRewardTimer:Stop()
    self.showRewardTimer = nil
  end
  Logger.Log("BattleLevel:Destroy UnInitCamera")
  self:UnInitCamera()
  self:RemoveUpdateTimer()
  if self.staticMgr then
    self.staticMgr:UnInit()
    self.staticMgr = nil
  end
  Logger.Log("BattleLevel:Destroy collectionMgr")
  self.collectionMgr:Destroy()
  self.triggerMgr:Destroy()
  self.npcMgr:RemoveAll()
  self.dropBuffMgr:RemoveAll()
  self.dropRewardMgr:RemoveAll()
  self.waitMoveMgr:RemoveAll()
  self.arrowMgr:RemoveAll()
  self.timelineMgr:RemoveAll()
  self.flyResMgr:RemoveAll()
  self.selectionMgr:Destroy()
  self.pveTemplate = nil
  if self.cityPrefabAsset then
    self.cityPrefabAsset:Release()
    self.cityPrefabAsset = nil
  end
  if self.teleportBack then
    self.teleportBack:Destroy()
  end
  self:RemoveListeners()
  self.levelState = LevelState.Destroyed
  self.selectTriggerStr = nil
  Logger.Log("BattleLevel:Destroy end")
end

function BattleLevel:AddListeners()
  if self.onOpenUI == nil then
    function self.onOpenUI(name)
      self:OnOpenUI(name)
    end
    
    EventManager:GetInstance():AddListener(EventId.OpenUI, self.onOpenUI)
  end
  if self.pveStaminaUpdateSignal == nil then
    function self.pveStaminaUpdateSignal()
      self:PveStaminaUpdateSignal()
    end
    
    EventManager:GetInstance():AddListener(EventId.FormationStaminaUpdate, self.pveStaminaUpdateSignal)
  end
  if self.refreshResourceItemSignal == nil then
    function self.refreshResourceItemSignal()
      self:RefreshResourceItemSignal()
    end
    
    EventManager:GetInstance():AddListener(EventId.RefreshResourceItem, self.refreshResourceItemSignal)
    EventManager:GetInstance():AddListener(EventId.SoldResourceItem, self.refreshResourceItemSignal)
  end
  if self.updateItemSignal == nil then
    function self.updateItemSignal()
      self:UpdateItemSignal()
    end
    
    EventManager:GetInstance():AddListener(EventId.RefreshItems, self.updateItemSignal)
  end
  if self.resourceUpdatedSignal == nil then
    function self.resourceUpdatedSignal()
      self:ResourceUpdatedSignal()
    end
    
    EventManager:GetInstance():AddListener(EventId.ResourceUpdated, self.resourceUpdatedSignal)
  end
  if self.factoryItemSignal == nil then
    function self.factoryItemSignal()
      self:FactoryItemSignal()
    end
    
    EventManager:GetInstance():AddListener(EventId.GatherFactoryItem, self.factoryItemSignal)
    EventManager:GetInstance():AddListener(EventId.AddFactoryProduct, self.factoryItemSignal)
    EventManager:GetInstance():AddListener(EventId.GetFactoryData, self.factoryItemSignal)
  end
  if self.pveDropRewardAddSignal == nil then
    function self.pveDropRewardAddSignal(uuid)
      self:PveDropRewardAddSignal(uuid)
    end
    
    EventManager:GetInstance():AddListener(EventId.PveDropRewardAdd, self.pveDropRewardAddSignal)
  end
  if self.pveDropRewardRemoveSignal == nil then
    function self.pveDropRewardRemoveSignal(uuid)
      self:PveDropRewardRemoveSignal(uuid)
    end
    
    EventManager:GetInstance():AddListener(EventId.PveDropRewardRemove, self.pveDropRewardRemoveSignal)
  end
  EventManager:GetInstance():AddListener(EventId.RefreshGuide, self.RefreshGuideSignal)
end

function BattleLevel:RemoveListeners()
  if self.onOpenUI ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.OpenUI, self.onOpenUI)
    self.onOpenUI = nil
  end
  if self.pveStaminaUpdateSignal ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.FormationStaminaUpdate, self.pveStaminaUpdateSignal)
    self.pveStaminaUpdateSignal = nil
  end
  if self.refreshResourceItemSignal ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.RefreshResourceItem, self.refreshResourceItemSignal)
    EventManager:GetInstance():RemoveListener(EventId.SoldResourceItem, self.refreshResourceItemSignal)
    self.refreshResourceItemSignal = nil
  end
  if self.updateItemSignal ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.RefreshItems, self.updateItemSignal)
    self.updateItemSignal = nil
  end
  if self.resourceUpdatedSignal ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.ResourceUpdated, self.resourceUpdatedSignal)
    self.resourceUpdatedSignal = nil
  end
  if self.factoryItemSignal ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.GatherFactoryItem, self.factoryItemSignal)
    EventManager:GetInstance():RemoveListener(EventId.AddFactoryProduct, self.factoryItemSignal)
    EventManager:GetInstance():RemoveListener(EventId.GetFactoryData, self.factoryItemSignal)
    self.factoryItemSignal = nil
  end
  if self.pveDropRewardAddSignal ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.PveDropRewardAdd, self.pveDropRewardAddSignal)
    self.pveDropRewardAddSignal = nil
  end
  if self.pveDropRewardRemoveSignal ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.PveDropRewardRemove, self.pveDropRewardRemoveSignal)
    self.pveDropRewardRemoveSignal = nil
  end
  EventManager:GetInstance():RemoveListener(EventId.RefreshGuide, self.RefreshGuideSignal)
end

function BattleLevel:RefreshGuideSignal()
  local player = DataCenter.BattleLevel:GetPlayer()
  if player ~= nil and not player:IsMoveTo() and not player:IsInInteract() then
    player:ResetState()
  end
  if not DataCenter.GuideManager:InGuide() then
    DataCenter.BattleLevel:ResetGuideMaxHeight()
  end
end

function BattleLevel:GetNextObjId()
  local nextObjId = self.nextObjId
  self.nextObjId = nextObjId + 1
  return nextObjId
end

function BattleLevel:GetObj(id)
  return self.sceneObjs[id]
end

function BattleLevel:AddObj(id, obj)
  self.sceneObjs[id] = obj
end

function BattleLevel:RemoveObj(id)
  self.sceneObjs[id] = nil
end

function BattleLevel:IsCheatOk()
  return self.cheatOk
end

function BattleLevel:ToggleCheat()
  self.cheatOk = not self.cheatOk
end

function BattleLevel:GetLevelType()
  return self.pveTemplate and self.pveTemplate.type or PveLevelType.FightLevel
end

function BattleLevel:GetEntranceType()
  return self.curEntranceType
end

function BattleLevel:GetHeroSize()
  return self.pveTemplate.heroSize or 1
end

function BattleLevel:GetTriggerExpSize()
  return self.pveTemplate.triggerExpSize
end

function BattleLevel:GetCameraParam()
  return self.pveTemplate.camera
end

function BattleLevel:GetWeaponDefaultSize()
  return self.pveTemplate.axeSize or 1
end

function BattleLevel:GetMaxHeroCount()
  return self.pveTemplate.maxHeroCount
end

function BattleLevel:GetMaxHeroLevel()
  return self.pveTemplate.maxHeroLevel or IntMaxValue
end

function BattleLevel:GetZombiePath(zombieId)
  return self.pveTemplate.zombiePath[zombieId]
end

function BattleLevel:GetPlayerInitRotation()
  return Quaternion.Euler(0, self.pveTemplate.spawnRot, 0)
end

function BattleLevel:IsShowCarry()
  return self:GetCarryMaxNum() > 0
end

function BattleLevel:GetCarryMaxNum()
  return self.pveTemplate:GetCarryMaxNum()
end

function BattleLevel:GetCarryRow()
  return self.pveTemplate:GetCarryRow()
end

function BattleLevel:GetCarryPerRowCount()
  return self.pveTemplate:GetCarryPerRowCount()
end

function BattleLevel:LoadScene()
  local scene = self.pveTemplate.scene
  if not string.IsNullOrEmpty(scene) then
    if self.levelInst then
      self.levelInst:Destroy()
    end
    self.levelInst = Resource:InstantiateAsync(string.format(PVEScenePath, scene))
    self.levelInst:completed("+", function()
      self.sceneRoot = self.levelInst.gameObject.transform
      self.sceneRoot:Set_position(0, 0, 0)
      self:OnSceneLoaded()
    end)
  end
end

function BattleLevel:OnSceneLoaded()
  if self.onCreateComplete then
    self.onCreateComplete()
    self.onCreateComplete = nil
  end
  local scene = self.pveTemplate.scene
  self.staticMgr = CS.PVEStaticManager()
  if self.staticMgr.InitLightMapConfig ~= nil then
    self.staticMgr:InitLightMapConfig(string.format(PVELightMapConfigPath, scene))
  end
  self.staticMgr:Init(string.format(PVEDecorationPath, scene), 10, 10)
  self:InitLevelCameraParams()
  self.collectionMgr:Init(self, string.format(PVEResConfigPath, scene))
  self:InitTrigger()
  self.fog:InitFog()
  self:InitZombie()
  DataCenter.TaskManager:EnterPveCheckPveTask(self.levelId)
  if self.player then
    self.player:SetPosition(self.spawnPos)
    self.player:StartCameraFollow(self.spawnPos)
    self.player:InitHandFlag(self.playerHandFlag)
  end
  if self.squad then
    self.squad:SetPosition(self.spawnPos)
    self.squad:StartCameraFollow(self.spawnPos)
  end
  self:InitMapEdge()
  self.dropRewardMgr:InitDropReward()
  if self.pveTemplate.type == PveLevelType.BarrageLevel then
    self:SelectPlayer()
  end
end

function BattleLevel:GetSceneRoot()
  return self.sceneRoot
end

function BattleLevel:SelectPlayer()
  self:EnterBattleCamera(self.pveTemplate.spawnPos)
  for k, v in ipairs(self.playerGroup) do
    v:StopWalk()
    v:SetVisible(false)
  end
  PveActorMgr:GetInstance():EnterBarrage(self, self.pveTemplate.spawnPos, self.levelId, self.levelParam)
end

function BattleLevel:CreateSquad()
  local modelList = PveActorMgr:GetInstance():GetModelListByCamp(BattleConst.CampType.Player)
  for _, v in pairs(modelList) do
    local position = v:GetTransform().position
    local name = v:GetModelResName()
    self:CreateMember(position, name)
  end
  local squad = Squad.New(self, self.playerGroup)
  self.squad = squad
  PveActorMgr:GetInstance():Leave()
  self:DisableJoystick()
end

function BattleLevel:CreateMember(worldPos, model)
  local objId = self:GetNextObjId()
  local param = {}
  param.isMain = false
  param.pos = worldPos
  param.playerName = model
  param.objId = objId
  param.index = 1
  param.originalPos = param.pos
  param.isNoGain = false
  param.isTriggerGet = false
  param.extraPos = self:GetExtraPos(1)
  param.rot = self:GetPlayerInitRotation()
  param.useRandomAttack = self:UseRandomAttack(param.playerName)
  if self.pveTemplate.player_model == Const.DefinePlayerName then
    param.skinName = self.pveTemplate.benSkin
  else
    param.skinName = ""
  end
  local isHero = self:IsHeroPrefab(param.playerName)
  local req = Resource:InstantiateAsync(self:GetPlayerModelPath(param.playerName))
  local player = Player.New(self, objId, req, param, isHero, isHero)
  table.insert(self.playerGroup, player)
  self:AddToFollowQueue(player)
  req:completed("+", function(request)
    if request.isError then
      return
    end
    player:OnCreate()
    player:ReInit()
  end)
  player:PauseCameraFollow()
end

function BattleLevel:CreatePlayer()
  local objId = self:GetNextObjId()
  local param = {}
  param.isMain = true
  param.pos = self.spawnPos
  param.playerName = self.pveTemplate.player_model
  param.objId = objId
  param.index = 1
  param.originalPos = param.pos
  param.isNoGain = false
  param.isTriggerGet = false
  param.extraPos = self:GetExtraPos(1)
  param.rot = self:GetPlayerInitRotation()
  param.useRandomAttack = self:UseRandomAttack(param.playerName)
  if self.pveTemplate.player_model == Const.DefinePlayerName then
    param.skinName = self.pveTemplate.benSkin
  else
    param.skinName = ""
  end
  local isHero = self:IsHeroPrefab(param.playerName)
  local req = Resource:InstantiateAsync(self:GetPlayerModelPath(param.playerName))
  local player = Player.New(self, objId, req, param, isHero, isHero)
  self.player = player
  table.insert(self.playerGroup, player)
  self:AddToFollowQueue(player)
  req:completed("+", function(request)
    if request.isError then
      return
    end
    player:OnCreate()
    player:ReInit()
    if self.pveTemplate.type == PveLevelType.AdventureLevel then
      DataCenter.AdventureManager:UpdatePlayerHpBar()
    elseif self.pveTemplate.type == PveLevelType.ArmyLevel then
      self:UpdateArmyRecordHpBar(false)
    end
  end)
end

function BattleLevel:GetPlayer()
  return self.player
end

function BattleLevel:InitTrigger()
  self.triggerMgr:Init(self, self.pveTemplate.triggerList)
  self.triggerMgr:InitTrigger(self.pveTemplate.progressType)
  local lastFinishTriggers = self.triggerMgr:GetLastFinishTriggers()
  local lastSaveTriggerId = self.dbMgr:GetLastFinishTriggerId()
  local savePos, saveRotation = self.dbMgr:GetSavePos()
  local lastFinishTrigger
  for k, v in ipairs(lastFinishTriggers) do
    lastFinishTrigger = v
  end
  if lastFinishTrigger ~= nil then
    local lastPos = lastFinishTrigger:GetPosition()
    if lastPos.x <= 0 and 0 >= lastPos.z then
      lastFinishTrigger = nil
    end
  end
  if lastFinishTrigger ~= nil and lastSaveTriggerId == lastFinishTrigger:GetTriggerId() and savePos ~= nil then
    self.spawnPos = savePos
  elseif lastFinishTrigger == nil then
    if savePos ~= nil and lastSaveTriggerId == nil then
      self.spawnPos = savePos
    else
      self.spawnPos = SceneUtils.TileToWorld(self.pveTemplate.spawnPos)
    end
  else
    self.spawnPos = lastFinishTrigger:GetPosition()
    self.dbMgr:SaveLastFinishTriggerId(lastFinishTrigger:GetTriggerId())
  end
  if not self.fog:IsUnlock(self.spawnPos) then
    self.spawnPos = SceneUtils.TileToWorld(self.pveTemplate.spawnPos)
  end
  self:DoInitTrigger()
  self.selectBattleBuffList = {}
  if not string.IsNullOrEmpty(self.selectTriggerStr) then
    local strs = string.split(self.selectTriggerStr, ";")
    for _, str in ipairs(strs) do
      local spls = string.split(str, ",")
      if 0 < #spls then
        local triggerId = tonumber(spls[1])
        local trigger = self:GetTriggerByTriggerId(triggerId)
        if trigger:IsTypeDiffMonster() then
          local info = {
            triggerId = triggerId,
            monsterGroupIndex = tonumber(spls[2]) + 1,
            winCount = tonumber(spls[3])
          }
          if 0 < info.winCount then
            self:MonsterDiffWin(info.monsterGroupIndex)
          end
        elseif trigger:IsTypeBuffBox() then
          local info = {
            triggerId = triggerId,
            buffGroupId = tonumber(spls[2]),
            buffId = tonumber(spls[3])
          }
          table.insert(self.selectBattleBuffList, info)
        end
      end
    end
  end
end

function BattleLevel:DoInitTrigger()
  local initTriggerList = self.pveTemplate.initTriggerList
  local triggers = self.pveTemplate.triggerList
  if 0 < #initTriggerList then
    for _, v in ipairs(initTriggerList) do
      if not self:IsFinishTrigger(v) and table.hasvalue(triggers, v) then
        self:DoTrigger(self:GetTriggerByTriggerId(v))
      end
    end
  elseif 0 < #triggers then
    self:DoTrigger(self:GetTriggerByTriggerId(triggers[1]))
  end
end

function BattleLevel:InitZombie()
  if self.pveTemplate and self.pveTemplate.zombiePath then
    for tempId, _ in pairs(self.pveTemplate.zombiePath) do
      local objId = Const.ZombieIdMin + self:GetNextObjId()
      if objId > Const.ZombieIdMax then
        Logger.LogError("objId > Const.ZombieIdMax")
      end
      local zombie = Zombie.New(self, objId, tempId)
      zombie:Create()
      self:AddObj(objId, zombie)
      self.zombies[objId] = zombie
    end
  end
end

function BattleLevel:InitMapEdge()
  self.mapEdge = nil
  local groundTf = self.levelInst.gameObject.transform:Find("Ground")
  if groundTf ~= nil then
    local renderer = groundTf:GetComponentInChildren(typeof(CS.UnityEngine.MeshRenderer))
    if renderer ~= nil then
      self.mapEdge = {
        xMin = renderer.bounds.min.x,
        zMin = renderer.bounds.min.z,
        xMax = renderer.bounds.max.x,
        zMax = renderer.bounds.max.z
      }
    end
  end
end

function BattleLevel:OnOpenUI(name)
  if name == UIWindowNames.UIPVEMain then
    local totalNum = self.triggerMgr:GetTriggerProgressTotal()
    if self.pveTemplate.progressType ~= nil and num > 0 then
      self:SetSliderVisible(true)
      local param = {}
      param.curNum = self.triggerMgr:GetTriggerProgressCount()
      param.allNum = totalNum
      param.icon = self.pveTemplate.progressIcon
      self:SetSliderData(param)
    else
      self:SetSliderVisible(false)
    end
    EventManager:GetInstance():RemoveListener(EventId.OpenUI, self.onOpenUI)
    self.onOpenUI = nil
  end
end

function BattleLevel:GetTriggersByTilePos(tilePos)
  return self.triggerMgr:GetTriggersByTilePos(tilePos)
end

function BattleLevel:GetTriggerByTriggerId(triggerId)
  return self.triggerMgr:GetTriggerByTriggerId(triggerId)
end

function BattleLevel:GetConfigTriggers()
  return self.pveTemplate.triggerList
end

function BattleLevel:GetConfigInitTriggers()
  return self.pveTemplate.initTriggerList
end

function BattleLevel:CreateFog()
  self.fog = Fog.New(self)
end

function BattleLevel:InitCamera()
  self.cameraTween = nil
  self.camera = CS.UnityEngine.Camera.main
  self.touchCamera = self.camera:GetComponent(typeof(MobileTouchCamera))
  self.hudCamera = self.camera.transform:Find("HudCamera"):GetComponent(typeof(CS.UnityEngine.Camera))
  self.touchCamera.CanMoveing = false
  self.saveCameraParam = {}
  self.saveCameraParam.fieldOfView = self.camera.fieldOfView
  local touchInput = self.touchCamera.touchInput
  
  function self.onFingerDown(pos)
    self:OnFingerDown(pos)
  end
  
  function self.onFingerUp()
    self:OnFingerUp()
  end
  
  touchInput:OnFingerDown("+", self.onFingerDown)
  touchInput:OnFingerUp("+", self.onFingerUp)
end

function BattleLevel:OnFingerDown(pos)
  if self.joystick and self.joystick:GetEnabled() and not self:IsFingerOnUI() and not self.isBattle and not self.freeCamera and not self.isHighView then
    self.isFingerDown = true
    
    local function Raycast()
      local ray = self.touchCamera:ScreenPointToRay(pos)
      local hits = Physics.RaycastAll(ray, SceneTouchDistance, LayerMask.GetMask("UIObject3D"))
      local clickOnItem = false
      if hits ~= nil then
        for i = 0, hits.Length - 1 do
          local touchObj = hits[i].collider:GetComponent(typeof(CS.UIEventTrigger))
          if touchObj ~= nil and touchObj.onPointerClick ~= nil then
            touchObj.onPointerClick()
            clickOnItem = true
          end
        end
      end
      if not clickOnItem then
        local hits = Physics.RaycastAll(ray, SceneTouchDistance, LayerMask.GetMask("Default"))
        if hits ~= nil then
          for i = 0, hits.Length - 1 do
            local hitInfo = hits[i]
            local obj = hitInfo.transform.gameObject
            if string.contains(obj.name, "Model") then
              obj = obj.parent.gameObject
            end
            local objIds = string.split(obj.name, "_")
            if objIds ~= nil and table.count(objIds) == 2 and objIds[1] == "Trigger" then
              local triggerId = toInt(objIds[2])
              local trigger = self:GetTriggerByTriggerId(triggerId)
              if trigger ~= nil then
                trigger:DoWhenClickOnTrigger()
                break
              end
            end
            local touchObj = hitInfo.collider:GetComponent(typeof(CS.UIEventTrigger))
            if touchObj ~= nil and touchObj.onPointerClick ~= nil then
              touchObj.onPointerClick()
              break
            end
          end
        end
      end
    end
    
    if pos.y < Screen.height * 0.8 then
      self.isWalk = true
      self.touchCamera.CanMoveing = false
      self.joystick:OnFingerDown(pos)
    else
      Raycast()
    end
  end
end

function BattleLevel:OnFingerUp()
  if self.isFingerDown and not self.isHighView then
    self.isFingerDown = false
    self.isWalk = false
    self.joystick:OnFingerUp()
    if self.player ~= nil then
      self.player:StopWalk()
    end
  end
end

function BattleLevel:SetJoystick(joystick)
  self.joystick = joystick
end

function BattleLevel:DisableJoystick()
  if self.isFingerDown then
    self.isFingerDown = false
    self.isWalk = false
    self.joystick:Clear()
    if self.player ~= nil then
      self.player:StopWalk()
    end
  end
  self.joystick:SetEnabled(false)
end

function BattleLevel:EnableJoystick()
  self.joystick:SetEnabled(true)
end

function BattleLevel:SetCameraZoomParam(param)
  for i, p in pairs(param) do
    self.touchCamera:SetZoomParams(i, p.height, GetOffsetZ(p.height, p.rotation), p.sen)
  end
  if param[2] then
    self.touchCamera.CamZoomMax = param[2].height
  else
    self.touchCamera.CamZoomMax = Const.CameraZoomMax
  end
  if param[0] then
    self.touchCamera.CamZoomMin = param[0].height
  else
    self.touchCamera.CamZoomMin = Const.CameraZoomMin
  end
  local cameraParam = self:GetCameraParam()
  if cameraParam then
    local height = cameraParam.height or param[1].height
    local offsetZ = GetOffsetZ(height, cameraParam.rotation or param[1].rotation)
    self.touchCamera:SetZoomParams(1, height, offsetZ, param[1].sen)
  end
end

function BattleLevel:InitLevelCameraParams()
  local cameraParam = self:GetCameraParam()
  if self:GetLevelType() == PveLevelType.HeroExpLevel then
    local height = cameraParam and cameraParam.height and cameraParam.height or Const.CameraParam.HeroExp[1].height
    local fov = cameraParam and cameraParam.fov and cameraParam.fov or Const.FieldOfView
    self.touchCamera.CamZoom = height
    self.touchCamera.LodLevel = 1
    self.camera.fieldOfView = fov
    self.hudCamera.fieldOfView = fov
    self:SetCameraZoomParam(Const.CameraParam.HeroExp)
  else
    local height = cameraParam and cameraParam.height and cameraParam.height or Const.CameraParam.Level[1].height
    local fov = cameraParam and cameraParam.fov and cameraParam.fov or Const.FieldOfView
    self.touchCamera.CamZoom = height
    self.touchCamera.LodLevel = 1
    self.camera.fieldOfView = fov
    self.hudCamera.fieldOfView = fov
    self:SetCameraZoomParam(Const.CameraParam.Level)
  end
end

function BattleLevel:GetParamZoomHeight(index)
  if index == 1 then
    local cameraParam = self:GetCameraParam()
    if cameraParam and cameraParam.height then
      return cameraParam.height
    end
  end
  if self:GetLevelType() == PveLevelType.HeroExpLevel then
    return Const.CameraParam.HeroExp[index].height
  else
    return Const.CameraParam.Level[index].height
  end
end

function BattleLevel:GetCameraRotation()
  return self.cameraRot
end

function BattleLevel:ToggleCameraFree()
  self:SetCameraFree(not self.freeCamera)
end

function BattleLevel:SetCameraFree(free)
  self.freeCamera = free
  self.touchCamera.CanMoveing = free
  if free then
    self.player:PauseCameraFollow()
  else
    self.player:ResumeCameraFollow()
  end
end

function BattleLevel:IsFingerOnUI()
  if TouchWrapper.TouchCount > 0 then
    local touches = TouchWrapper.Touches
    local touchCount = touches.Count
    for i = 0, touchCount - 1 do
      local t = touches[i]
      if EventSystem.current:IsPointerOverGameObject(t.FingerId) then
        return true
      end
    end
  end
  return false
end

function BattleLevel:UnInitCamera()
  self.cameraTween = nil
  if self.touchCamera then
    self.touchCamera.CanMoveing = true
    local touchInput = self.touchCamera.touchInput
    if self.onFingerDown then
      touchInput:OnFingerDown("-", self.onFingerDown)
    end
    if self.onFingerUp then
      touchInput:OnFingerUp("-", self.onFingerUp)
    end
    self.camera.fieldOfView = self.saveCameraParam.fieldOfView
    self.hudCamera.fieldOfView = self.saveCameraParam.fieldOfView
    for i, p in pairs(Const.CameraParam.World) do
      self.touchCamera:SetZoomParams(i, p.height, GetOffsetZ(p.height, p.rotation), p.sen)
    end
    self.touchCamera = nil
  end
end

function BattleLevel:EnterBattleCamera(lookTilePos)
  local lookat = SceneUtils.TileToWorld(lookTilePos)
  local param = Const.CameraParam.Battle
  self.camera.fieldOfView = Const.FieldOfView
  self.hudCamera.fieldOfView = Const.FieldOfView
  for i, p in pairs(param) do
    self.touchCamera:SetZoomParams(i, p.height, GetOffsetZ(p.height, p.rotation), p.sen)
  end
  if self.pveTemplate.type == PveLevelType.FightLevel or self.pveTemplate.type == PveLevelType.RadarExpLevel then
    if #self.pveTemplate.initTriggerList > 0 then
      self:Lookat(lookat)
      self.touchCamera.CamZoom = param[1].height + 60
      self:AutoZoom(param[1].height, 0.6)
    end
  else
    self:AutoLookat(lookat, param[1].height, 0.4)
  end
end

function BattleLevel:RestoreLevelCamera(lookTilePos)
  local cameraParam = self:GetCameraParam()
  if self:GetLevelType() == PveLevelType.HeroExpLevel then
    local height = cameraParam and cameraParam.height and cameraParam.height or Const.CameraParam.HeroExp[1].height
    local fov = cameraParam and cameraParam.fov and cameraParam.fov or Const.FieldOfView
    self.camera.fieldOfView = fov
    self.hudCamera.fieldOfView = fov
    self:SetCameraZoomParam(Const.CameraParam.HeroExp)
    self:AutoLookat(SceneUtils.TileToWorld(lookTilePos), height, 0.4)
  else
    local height = cameraParam and cameraParam.height and cameraParam.height or Const.CameraParam.Level[1].height
    local fov = cameraParam and cameraParam.fov and cameraParam.fov or Const.FieldOfView
    self.camera.fieldOfView = fov
    self.hudCamera.fieldOfView = fov
    self:SetCameraZoomParam(Const.CameraParam.Level)
    self:AutoLookat(SceneUtils.TileToWorld(lookTilePos), height, 0.4)
  end
end

function BattleLevel:GetCameraTarget()
  if self.touchCamera ~= nil then
    return self.touchCamera:GetCameraTargetPos()
  end
end

function BattleLevel:Lookat(lookWorldPosition)
  self.followCameraTarget = Vector3.New(lookWorldPosition.x, lookWorldPosition.y, lookWorldPosition.z)
  self.touchCamera:LookAt(lookWorldPosition)
end

function BattleLevel:GetFollowCameraTarget()
  return self.followCameraTarget
end

function BattleLevel:CameraFollowLookat(targetPos)
  local transform = self.touchCamera.transform
  local x, y, z = transform:Get_position()
  local offset = targetPos - self.followCameraTarget
  transform:Set_position(x + offset.x, y + offset.y, z + offset.z)
  self.followCameraTarget = Vector3.New(targetPos.x, targetPos.y, targetPos.z)
end

function BattleLevel:WorldToScreenPoint(worldPos)
  return self.camera:WorldToScreenPoint(worldPos)
end

function BattleLevel:ScreenPointToWorld(screenPos)
  return self.camera:ScreenPointToWorld(screenPos)
end

function BattleLevel:AutoLookat(pos, zoom, time)
  self.followCameraTarget = Vector3.New(pos.x, pos.y, pos.z)
  if self.touchCamera ~= nil then
    self.touchCamera:AutoLookat(pos, zoom, time)
  end
end

function BattleLevel:AutoZoom(zoom, time)
  if self.touchCamera ~= nil then
    self.touchCamera:AutoZoom(zoom, time)
  end
end

function BattleLevel:GetCameraZoom()
  if self.touchCamera ~= nil then
    return self.touchCamera.CamZoom
  end
end

function BattleLevel:OnClickBtnCollect()
  self.selectionMgr:Do()
end

function BattleLevel:AddUpdateTimer()
  if self.updateTimer == nil then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
  if self.updateSecTimer == nil then
    self.updateSecTimer = TimerManager:GetInstance():GetTimer(1, self.OnUpdateSec, self, false, false, false)
    self.updateSecTimer:Start()
  end
end

function BattleLevel:RemoveUpdateTimer()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
  if self.updateSecTimer then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
end

function BattleLevel:ShowSelectDiff(trigger)
  if not self.isShowingSelectDiff and not self.isBattle then
    self.isShowingSelectDiff = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVESelectDiff, {anim = true}, trigger.config.triggerId, trigger.config.monsterGroupList)
  end
end

function BattleLevel:ShowAdventureSub(trigger)
  if trigger:IsTriggerOK() or self.isBattle or not DataCenter.AdventureManager:CanShowSubWindow() then
    return
  end
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPVESelectAdventureSub) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVESelectAdventureSub, {anim = true}, trigger)
  end
end

function BattleLevel:DoTrigger(trigger, isGuideFinish)
  if trigger == nil or (trigger:IsTriggerOK() or not trigger:IsPreTriggerOK()) and not isGuideFinish then
    return
  end
  local triggerId = trigger:GetTriggerId()
  if trigger:IsTypeMonster() or trigger:IsTypeDiffMonster() or trigger:IsTypeDiffMonsterEasy() or trigger:IsTypeLevelLimitMonster() or trigger:IsMonsterWithHp() then
    self:EnterBattle(trigger)
  elseif trigger:ISPVEFactory() then
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIFactory) then
      trigger:DoWhenClickOnTrigger()
    end
  elseif trigger:IsTypeGotoOtherPve() then
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UICommonMessageTip) then
      trigger:DoWhenClickOnTrigger()
    end
  else
    if self.curEntranceType ~= PveEntrance.MineCave and self.curEntranceType ~= PveEntrance.ArenaSetting and self.curEntranceType ~= PveEntrance.ArenaBattle and self.curEntranceType ~= PveEntrance.BattlePlayBack and self.curEntranceType ~= PveEntrance.AdventureSetting then
      local triggerType = trigger:GetTriggerType()
      if triggerType == Const.TriggerType.RewardBox or triggerType == Const.TriggerType.BuffBox then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_pve_box_get, false)
      end
      if triggerType == Const.TriggerType.AttackBox then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_pve_box_get, false)
      end
      trigger:SubmitAllIndexFinish()
      self:SendFinishTrigger(triggerId)
      if not table.hasvalue(self.frontFinishTriggerList, triggerId) then
        table.insert(self.frontFinishTriggerList, triggerId)
        local exp = trigger:GetExpReward()
        if 0 < exp then
          self:AddFrontReward(RewardType.HERO_EXP, nil, exp)
          if 0 < #self.playerGroup then
          end
        end
        if self.isTimeLimited then
          DataCenter.GuideManager:SendLogMessage(triggerId, StatTTType.FinishTrigger, "")
          if self.isCheckingTime then
            local star, rewardIndex = self:GetCurTimeStar()
            if 0 < star then
              local win = true
              for _, tid in ipairs(self.pveTemplate.triggerList) do
                local t = self:GetTriggerByTriggerId(tid)
                if not t:IsSideQuest() and not table.hasvalue(self.frontFinishTriggerList, tid) then
                  win = false
                  break
                end
              end
              if win then
                self.timeLimitState = TimeLimitState.Win
                self.rewardIndex = rewardIndex
                self.isSuccess = true
                self.isCheckingTime = false
                self:ShowLevelReward(star)
              end
            end
          end
        end
      end
    end
    trigger:TriggerOK()
    local doSound = self.fog:UnlockAreaFog(triggerId)
    if doSound then
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_trigger_finish, false)
    end
    if trigger:HasType(Const.UnlockToResType[Const.CommitType.Flag]) then
      self.player:WaveFlag()
    end
    local handFlag = false
    local triggers = self.triggerMgr:GetTriggers()
    for _, t in pairs(triggers) do
      if t:IsPreTriggerOK() and not t:IsTriggerOK() then
        t:OnPreTriggerOK()
        handFlag = handFlag or t:HasType(Const.UnlockToResType[Const.CommitType.Flag])
        if t:IsTypeTimeline() then
          self:DoTrigger(t)
        end
      end
      if t.config.endTriggerId == triggerId and (t:IsTypeBombArea() or t:IsTypePortal()) then
        self:DoTrigger(t)
      end
    end
    if handFlag then
      self.player:HandFlag()
    end
    if self.pveTemplate.progressType ~= nil and trigger:GetTriggerType() == self.pveTemplate.progressType then
      self.triggerMgr:AddTriggerProgressCount(1)
      local param = {}
      param.curNum = self.triggerMgr:GetTriggerProgressCount()
      param.allNum = self.triggerMgr:GetTriggerProgressTotal()
      param.icon = self.pveTemplate.progressIcon
      self:SetSliderData(param)
    end
    if trigger:IsMainQuest() and 0 < trigger.config.order then
      local canSave = false
      local lastTriggerId = self.dbMgr:GetLastFinishTriggerId()
      if lastTriggerId ~= nil then
        local lastTrigger = self:GetTriggerByTriggerId(lastTriggerId)
        if lastTrigger ~= nil and lastTrigger.config.order < trigger.config.order then
          canSave = true
        end
      else
        canSave = true
      end
      if canSave then
        self.dbMgr:SaveLastFinishTriggerId(trigger:GetTriggerId())
      end
    end
    self.selectionMgr:Remove(PveSelectionType.Trigger, trigger:GetTriggerId())
    self.selectionMgr:Refresh()
    EventManager:GetInstance():Broadcast(EventId.PveFinishOneTrigger, triggerId)
  end
end

function BattleLevel:Pause()
  Time.timeScale = 0
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEPause, {
    anim = false,
    UIMainAnim = UIMainAnimType.AllHide
  })
end

function BattleLevel:Resume()
  Time.timeScale = 1
end

function BattleLevel:IsPaused()
  return Time.timeScale == 0
end

function BattleLevel:EnterBattle(trigger, notAdjustCamera)
  self.isBattle = true
  if self.levelId ~= TestPveBattleLevelId and (trigger.config.type == Const.TriggerType.Monster or trigger.config.type == Const.TriggerType.DiffMonster or trigger.config.type == Const.TriggerType.DiffMonsterEasy or trigger.config.type == Const.TriggerType.LevelLimitMonster or trigger.config.type == Const.TriggerType.MonsterWithHp) then
    trigger:SetVisible(false)
  end
  local triggerTilePos = trigger:GetTilePos()
  if notAdjustCamera == true then
  else
    self:EnterBattleCamera(triggerTilePos)
  end
  for k, v in ipairs(self.playerGroup) do
    v:StopWalk()
    v:SetVisible(false)
  end
  self:SetArrowVisibleByPos(SceneUtils.TileToWorld(triggerTilePos), false)
  if self.pveTemplate.type == PveLevelType.AdventureLevel then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEAdventure)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVESelectAdventureSub)
  end
  PveActorMgr:GetInstance():Enter(self, triggerTilePos, self.levelId, trigger:GetTriggerId(), trigger:GetRotation(), self.levelParam)
end

function BattleLevel:LeaveBattle(triggerId, battleResult)
  self.isBattle = false
  local trigger = self:GetTriggerByTriggerId(triggerId)
  if trigger then
    local triggerTilePos = trigger:GetTilePos()
    if battleResult == PveModuleConst.Result.Win then
      trigger:TriggerOK()
      self.fog:UnlockAreaFog(trigger:GetTriggerId())
      local handFlag = false
      local triggers = self.triggerMgr:GetTriggers()
      for _, t in pairs(triggers) do
        if t:IsPreTriggerOK() and not t:IsTriggerOK() then
          t:OnPreTriggerOK()
          handFlag = handFlag or t:HasType(Const.UnlockToResType[Const.CommitType.Flag])
          if t:IsTypeTimeline() then
            self:DoTrigger(t)
          end
        end
        if t.config.endTriggerId == triggerId and (t:IsTypeBombArea() or t:IsTypePortal()) then
          self:DoTrigger(t)
        end
      end
      if handFlag then
        self.player:HandFlag()
      end
      self:RemoveOneArrowByPos(SceneUtils.TileToWorld(triggerTilePos))
      if trigger:IsTypeDiffMonster() then
        self:MonsterDiffWin(self.diffParam.selectDiff)
      end
    elseif battleResult == PveModuleConst.Result.Fail then
      trigger:SetVisible(true)
      self:SetArrowVisibleByPos(SceneUtils.TileToWorld(triggerTilePos), true)
      if trigger:IsTypeDiffMonster() then
        UIUtil.ShowTipsId(400062)
      end
    else
      trigger:SetVisible(true)
      self:SetArrowVisibleByPos(SceneUtils.TileToWorld(triggerTilePos), true)
    end
    self:RestoreLevelCamera(triggerTilePos)
    local playerPos = self:GetPlayerLeavePos(trigger)
    for k, v in ipairs(self.playerGroup) do
      v:SetVisible(true)
    end
    self.player:SetPosition(playerPos)
    self.player:Idle()
  else
    self:RestoreLevelCamera(self.pveTemplate.spawnPos)
    Logger.LogError(string.format("LeaveBattle trigger nil, id %s ", tostring(trigger)))
  end
  if self.pveTemplate.type == PveLevelType.AdventureLevel then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEAdventure)
  end
  self:CheckBattleReward()
  self:CheckShowLevelReward()
  self:CheckLose()
end

function BattleLevel:CheckBattleReward()
  if self.battleRewardMessage then
    self:OnRewardMessage(self.battleRewardMessage, false)
    self.battleRewardMessage = nil
  end
end

function BattleLevel:GetPlayerLeavePos(triggerPoint)
  local triggerTilePos = triggerPoint:GetTilePos()
  if triggerPoint:IsMonsterWithHp() or triggerPoint:IsTypeMonster() or triggerPoint:IsTypeGotoOtherPve() then
    local rotation = -(triggerPoint:GetRotation() - 270) / 180 * Mathf.PI
    local dx = Mathf.Cos(rotation)
    local dy = Mathf.Sin(rotation)
    return SceneUtils.TileToWorld(Vector2.New(triggerTilePos.x + dx, triggerTilePos.y + dy))
  end
  return SceneUtils.TileToWorld(Vector2.New(triggerTilePos.x, triggerTilePos.y - 1))
end

function BattleLevel:OnUpdateSec()
end

function BattleLevel:OnUpdate()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.camera ~= nil then
    local camTrans = self.camera.transform
    if camTrans ~= nil then
      local cameraRot = camTrans.rotation
      if cameraRot ~= self.cameraRot then
        self.cameraRot = cameraRot
        self:RefreshCameraRotation()
      end
    end
  end
  local viewTile = SceneUtils.WorldToTile(self.touchCamera:GetCameraTargetPos())
  if self.isWalk and self.player ~= nil and self.joystick ~= nil then
    local vx, vz = self.joystick:OnUpdate()
    self.player:Walk(vx, vz)
  end
  if self.isWalk and self.squad ~= nil and self.joystick ~= nil then
    local vx, vz = self.joystick:OnUpdate()
    self.squad:Walk(vx, vz)
  end
  local deltaTime = Time.deltaTime
  if self.squad ~= nil then
    self.squad:OnUpdate()
  else
    for k, v in pairs(self.playerGroup) do
      v:OnUpdate()
    end
  end
  for k, v in pairs(self.followPlayerGroup) do
    v:OnUpdate(deltaTime)
  end
  if self.zombies then
    for _, v in pairs(self.zombies) do
      v:OnUpdate(deltaTime)
    end
  end
  if self.resourceText ~= nil then
    self.resourceText:RefreshRotation()
  end
  for _, player in ipairs(self.playerGroup) do
    player:TopFaceToCamera()
  end
  if self.staticMgr ~= nil then
    self.staticMgr:OnUpdate(viewTile.x, viewTile.y)
  end
  self.collectionMgr:OnUpdate(viewTile.x, viewTile.y)
  self.npcMgr:OnUpdate()
  self.waitMoveMgr:OnUpdate()
  self.flyResMgr:OnUpdate(curTime)
  self.triggerMgr:OnUpdate(viewTile.x, viewTile.y, deltaTime)
  self.selectionMgr:OnUpdate()
  for i = table.count(self.buff), 1, -1 do
    if self.buff[i].time_type == PveBuffTimeType.Time then
      if self:IsPaused() then
        self.buff[i].endTime = self.buff[i].endTime + Time.unscaledDeltaTime * 1000
      end
      local leftTime = self.buff[i].endTime - curTime
      if leftTime <= 0 then
        self:RemoveBuffById(self.buff[i].id)
      end
    end
  end
  if self.isTimeLimited and self.isCheckingTime then
    self.usedTime = self.usedTime + Time.deltaTime * 1000
    local star, index = self:GetCurTimeStar()
    if star == 0 then
      self.timeLimitState = TimeLimitState.Lose
      self.isCheckingTime = false
      self.isSuccess = false
      self:ShowLose()
    end
    self.uiPveMain:SetUsedTime(self.usedTime)
  end
end

function BattleLevel:ShowLevelReward(star)
  if self.pveTemplate.type == PveLevelType.AdventureLevel and DataCenter.AdventureManager:IsFinalLevel() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEResult, BattlePveConst.Result.Win, {showBtn = true})
  elseif self.pveTemplate.resultShowType == PveResultShowType.Normal then
    local param = {}
    param.levelId = self.levelId
    param.rewardList = self.rewardList
    
    function param.onExitClick()
      self:Exit()
    end
    
    function param.onRestartClick()
      self:Restart(true)
    end
    
    function param.onConfirmClick()
      self:ConfirmReward()
    end
    
    param.star = star
    param.isTimeLimited = self.isTimeLimited
    param.totalExp = self.frontTotalExp
    param.rewardIndex = self.rewardIndex
    param.heroes = self.heroMgr:GetCurHeroes()
    self.showRewardTimer = TimerManager:GetInstance():GetTimer(2, function()
      self.showRewardTimer = nil
      if not DataCenter.GuideManager:InGuide() then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_pve_finish, false)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVELevelReward, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        }, param)
      end
    end, nil, true, false, false)
    self.showRewardTimer:Start()
  else
    self:Exit()
  end
end

function BattleLevel:ShowBoxReward(triggerId, rewardList)
  local param = {}
  param.levelId = self.levelId
  param.rewardList = rewardList
  
  function param.onExitClick()
  end
  
  function param.onRestartClick()
  end
  
  function param.onConfirmClick()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVELevelReward, {anim = false})
    local triggerPoint = self:GetTriggerByTriggerId(triggerId)
    if triggerPoint then
      local srcPos = self:WorldToScreenPoint(SceneUtils.TileToWorld(triggerPoint:GetTilePos()))
      for _, v in ipairs(rewardList) do
        local targetPos = FindRewardFlyPos(v.rewardType)
        local pic = RewardUtil.GetPic(v.rewardType, v.itemId)
        UIUtil.DoFly(v.rewardType, math.min(v.count, 3), pic, srcPos, targetPos)
      end
      triggerPoint:SetVisible(false)
      self.player:ResumeCameraFollow()
    end
    self:CheckShowLevelReward()
  end
  
  param.rewardBox = true
  param.star = nil
  param.isTimeLimited = 0
  param.totalExp = 0
  param.rewardIndex = nil
  param.heroes = {}
  if not DataCenter.GuideManager:InGuide() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVELevelReward, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, param)
  end
end

function BattleLevel:CheckLose()
  local lost = false
  if self.pveTemplate.type == PveLevelType.ArmyLevel and (self.armyRecord == nil or self.armyRecord.aliveCount == 0) then
    lost = true
  end
  if lost then
    self:ShowLose()
  end
end

function BattleLevel:ShowLose()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVELose, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, function()
    self:Exit()
  end, function()
    self:Restart(false)
  end)
end

function BattleLevel:Enter(param)
  assert(param ~= nil)
  assert(param.pveEntrance ~= nil)
  assert(param.levelId ~= nil)
  self.guideHideSkill = false
  self.buff = {}
  self.resItem = {}
  self.guideNoShowTriggerId = {}
  if self.isWaitingLevelInfo then
    return
  end
  if self.levelState == LevelState.RequestInfo or self.levelState == LevelState.Destroying then
    return
  end
  if self.levelState == LevelState.Created then
    if self.levelParam ~= nil and not param.abandon then
      table.insert(self.levelParamStack, 1, self.levelParam)
    end
    self.levelParam.isStart = false
    self:Change(param)
    return
  end
  self.levelParam = param
  self.isWaitingLevelInfo = true
  self.curEntranceType = param.pveEntrance
  
  function self.onCreateComplete()
    self:RequestCallback()
  end
  
  self.levelId = param.levelId
  self.levelState = LevelState.RequestInfo
  self.pveTemplate = DataCenter.PveLevelTemplateManager:GetTemplate(self.levelId)
  if self.pveTemplate == nil then
    Logger.LogError("pveLevel is not exist" .. self.levelId)
    return
  end
  self.isTimeLimited = self.pveTemplate:IsTimeLimited()
  self.isStarLevel = self.pveTemplate:IsStarLevel()
  self.isCheckingTime = false
  self.frontFinishTriggerList = {}
  self.specialTriggers = {}
  self.triggerMonsters = {}
  self.isAlreadyOpenEnergyPanel = false
  self.triggerReward = {}
  self.frontRewardGotList = {}
  self.frontTotalExp = 0
  self.saveCameraHeight = nil
  self.pveStatus = PveStatus.FirstStart
  self.started = false
  self.diffParam = {
    curDiff = 1,
    curDiffWin = 0,
    selectDiff = 0
  }
  self.buffEffectDict = {}
  if self.isTimeLimited then
    self.timeLimitState = TimeLimitState.Normal
  end
  
  local function SendMessage()
    GoToUtil.CloseAllWindows()
    self:CloseUIWindows()
    if param.pveEntrance == PveEntrance.Test then
      SFSNetwork.SendMessage(MsgDefines.UserStartPVETest, param.levelId, param.isStart, param.armyDict)
    elseif param.pveEntrance == PveEntrance.LandLock then
      SFSNetwork.SendMessage(MsgDefines.StartLandLockPVE, param.id)
    elseif param.pveEntrance == PveEntrance.Monument then
    elseif param.pveEntrance == PveEntrance.DetectEventPve then
      DataCenter.RadarCenterDataManager:StartDetectEventPve(param.uid)
    elseif param.pveEntrance == PveEntrance.MonsterLock then
      SFSNetwork.SendMessage(MsgDefines.StartPveMonster, param.id)
    elseif param.pveEntrance == PveEntrance.MineCave then
      local locMsg = {
        finishTime = 0,
        finishTrigger = "",
        status = 1,
        levelId = self.levelId
      }
      DataCenter.BattleLevel:OnStartLevelMessage(locMsg)
    elseif param.pveEntrance == PveEntrance.ArenaBattle then
      local locMsg = {
        finishTime = 0,
        finishTrigger = "",
        status = 1,
        levelId = self.levelId
      }
      DataCenter.BattleLevel:OnStartLevelMessage(locMsg)
    elseif param.pveEntrance == PveEntrance.ArenaSetting then
      local locMsg = {
        finishTime = 0,
        finishTrigger = "",
        status = 1,
        levelId = self.levelId
      }
      DataCenter.BattleLevel:OnStartLevelMessage(locMsg)
    elseif param.pveEntrance == PveEntrance.BattlePlayBack then
      local locMsg = {
        finishTime = 0,
        finishTrigger = "",
        status = 1,
        levelId = self.levelId
      }
      DataCenter.BattleLevel:OnStartLevelMessage(locMsg)
    elseif param.pveEntrance == PveEntrance.Adventure then
      DataCenter.AdventureManager:StartPveLevel()
    elseif param.pveEntrance == PveEntrance.AdventureSetting then
      local locMsg = {
        finishTime = 0,
        finishTrigger = "",
        status = 1,
        levelId = self.levelId
      }
      DataCenter.BattleLevel:OnStartLevelMessage(locMsg)
    elseif param.pveEntrance == PveEntrance.LevelExplore then
      SFSNetwork.SendMessage(MsgDefines.LevelExploreStart, param.id, param.armyDict)
    elseif param.pveEntrance == PveEntrance.PveAct then
      DataCenter.PveActManager:StartPve(param.actId, self.levelId)
    end
  end
  
  DataCenter.CityNpcManager:SetNpcVisible(false)
  if param.isStart then
    self.dbMgr:ClearDB()
  end
  self.dbMgr:InitDB()
  if self.pveTemplate.type == PveLevelType.NormalLevel or self.pveTemplate.type == PveLevelType.HeroExpLevel or self.pveTemplate.type == PveLevelType.NormalExpLevel or self.pveTemplate.type == PveLevelType.FightLevel or self.pveTemplate.type == PveLevelType.BattleExpLevel or self.pveTemplate.type == PveLevelType.BattlePlayBackLevel or self.pveTemplate.type == PveLevelType.RadarExpLevel or self.pveTemplate.type == PveLevelType.AdventureLevel or self.pveTemplate.type == PveLevelType.SkillLevel or self.pveTemplate.type == PveLevelType.BarrageLevel or self.pveTemplate.type == PveLevelType.ArmyLevel then
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPVELoading) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVELoading)
      self.uiPveLoading = UIManager:GetInstance():GetWindow(UIWindowNames.UIPVELoading).View
      self.uiPveLoading:SetOnEntered(SendMessage)
    else
      SendMessage()
    end
    if self.pveTemplate.type ~= PveLevelType.FightLevel and self.pveTemplate.type ~= PveLevelType.RadarExpLevel and self.pveTemplate.type ~= PveLevelType.BattlePlayBackLevel and param.focusWorldPos then
      GoToUtil.GotoPos(param.focusWorldPos, 1, 0.5)
      param.focusWorldPos = nil
    end
  elseif param.pveEntrance == PveEntrance.MineCave or param.pveEntrance == PveEntrance.ArenaSetting or param.pveEntrance == PveEntrance.AdventureSetting then
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPVELoading) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVELoading)
      self.uiPveLoading = UIManager:GetInstance():GetWindow(UIWindowNames.UIPVELoading).View
      self.uiPveLoading:SetOnEntered(SendMessage)
    else
      SendMessage()
    end
  else
    self.uiPveLoading = nil
    SendMessage()
  end
  self.pveTriggerGuide = DataCenter.GuideManager:GetPveTriggerGuide(self.levelId)
  self:CheckPlaySound()
  self:SetHighView(false, false)
end

function BattleLevel:CheckPlaySound()
  CommonUtil.ClearGameBgMusicData()
end

function BattleLevel:RequestCallback()
  DataCenter.BuildBubbleManager:ClearAll()
  DataCenter.WorldBuildBubbleManager:ClearAll()
  DataCenter.RoadBubbleManager:ClearAll()
  DataCenter.AllianceCityTipManager:RemoveAllAllianceCityTip()
  DataCenter.SurpriseBuildingTipManager:RemoveAllSurpriseBuildingTip()
  DataCenter.WarningBallManager:DeleteTimer()
  DataCenter.WorldFavoDataManager:ClearAll()
  DataCenter.CityPioneerManager:DoPrologueUnInit()
  if CS.SceneManager.IsInCity() then
    if self.cityPrefabAsset ~= nil then
      self.cityPrefabAsset:Release()
    end
    self.cityPrefabAsset = Resource:LoadAssetAsync(Const.CityPrefabPath, typeof(CS.UnityEngine.GameObject))
  end
  if CS.SceneManager.IsInWorld() then
    SFSNetwork.SendMessage(MsgDefines.LeaveWorld)
  end
  CrossServerUtil.OnEnterPve()
  CS.SceneManager.DestroyCurScene()
  DataCenter.LWSceneStateManager:ChangeScene(SceneType.None)
  pcall(function()
    CS.SceneManager.CurrSceneID = SceneManagerSceneID.PVE
  end)
  DataCenter.LWSceneStateManager:ChangeScene(SceneType.PVE)
  self.touchCamera.AfterUpdate = self.cameraAfterUpdate
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIMain) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIMain)
  end
  if self.pveTemplate.type == PveLevelType.NormalExpLevel then
    self.heroMgr:UseDefaultHeroes()
  end
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPVEMain) then
    local param = {}
    param.levelId = self.levelId
    param.heroes = self.heroMgr:GetCurHeroes()
    local saveSkillNum = self.dbMgr:GetSkillSliderNum()
    if saveSkillNum ~= nil then
      param.initSkillNum = saveSkillNum
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, param)
    self.uiPveMain = UIManager:GetInstance():GetWindow(UIWindowNames.UIPVEMain).View
    self.uiPveMain:SetOnHeroChanged(function(i, heroUuid, isAdd)
      self:OnHeroChanged(i, heroUuid, isAdd)
    end)
  end
  if self.pveTemplate.type == PveLevelType.NormalLevel or self.pveTemplate.type == PveLevelType.NormalExpLevel or self.pveTemplate.type == PveLevelType.BattleExpLevel or self.pveTemplate.type == PveLevelType.SkillLevel or self.pveTemplate.type == PveLevelType.ArmyLevel then
    self:GoStart()
  elseif self.pveTemplate.type == PveLevelType.HeroExpLevel then
    if self.heroMgr:HaveHeroesFromMessage() then
      local heroes = self.heroMgr:GetCurHeroes()
      for i, heroUuid in ipairs(heroes) do
        local heroData = self:GetPveHeroData(heroUuid)
        if heroData ~= nil then
          local model = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "prefab_low_exp")
          self:AddOnePlayer(model, i, nil, nil, nil, heroData.level, nil, heroUuid)
        end
      end
      PveActorMgr:GetInstance():SetHeros(heroes)
      self.player:SetVisible(true)
    else
      PveActorMgr:GetInstance():SetHeros({})
      self.player:SetVisible(false)
    end
    self.player:StopWalk()
    self:SetLvPoint(self:LoadLvPoint())
  elseif self.pveTemplate.type == PveLevelType.AdventureLevel then
    local heroes = DataCenter.AdventureManager:GetHeroUuidList()
    if not table.IsNullOrEmpty(heroes) then
      local sortedHeroes = HeroUtils.SortHeroUuidsByRarityLevelPower(heroes)
      local heroUuid = sortedHeroes[1]
      local heroData = DataCenter.BattleLevel:GetPveHeroData(heroUuid)
      local model = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "prefab_low_exp")
      self:AddOnePlayer(model, 1, nil, nil, nil, heroData.level, nil, heroUuid)
    end
    self.heroMgr:SetCurHeroes(heroes)
    PveActorMgr:GetInstance():SetHeros(heroes)
    self:GoStart()
  end
  self.uiPveMain:OnPveEnter(self.pveTemplate.type)
  if self.uiPveLoading then
    self.uiPveLoading:Quit()
  end
  EventManager:GetInstance():Broadcast(EventId.PveLevelEnter, self.levelId)
  DataCenter.GuideManager:SendLogMessage(self.levelId, StatTTType.CreateLevelComplete, "")
  DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.EnterPve, tostring(self.levelId))
end

function BattleLevel:GoStart()
  if self.pveTemplate.type == PveLevelType.HeroExpLevel or self.pveTemplate.type == PveLevelType.NormalExpLevel then
    local heroes = self.heroMgr:GetCurHeroes()
    PveActorMgr:GetInstance():SetHeros(heroes)
    SFSNetwork.SendMessage(MsgDefines.UserResetPVEHero, self.levelId, heroes)
    self:SetLvPoint(self:LoadLvPoint())
  else
    self:Start()
  end
end

function BattleLevel:Start()
  self.started = true
  self.player:SetVisible(true)
  self.player:Idle()
  self.uiPveMain:OnPveStart(self.pveTemplate.type)
  self.usedTime = 0
  self.uiPveMain:SetUsedTime(self.usedTime)
  if self.isTimeLimited then
    self.isCheckingTime = true
  end
end

function BattleLevel:Change(param)
  print("beef BattleLevel, Change: " .. param.levelId)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEMain, {anim = false})
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVELevelReward, {anim = false})
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVELose, {anim = false})
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEPause, {anim = false})
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEAdventure, {anim = false})
  self:Destroy(true)
  self.uiPveMain = nil
  self:Enter(param)
end

function BattleLevel:Exit(ExitAction, exitType)
  self:SetHighView(false, false)
  self.resRecordMgr:Clear()
  self.resRecordMgr:SyncPveResource()
  if self.dbMgr ~= nil then
    self.dbMgr:SaveSkillSliderNum(self:GetSkillNum())
  end
  self:SaveDB()
  local guideBgmName = DataCenter.GuideManager:GetGuideBgmName()
  if guideBgmName == nil or guideBgmName == "" then
    CommonUtil.PlayGameBgMusic()
  end
  if self.levelState == LevelState.Destroyed or self.levelState == LevelState.Destroying then
    return
  end
  print("beef BattleLevel, Exit: " .. self.levelParam.levelId)
  self.buff = {}
  self:ClearPlayerEffect()
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPVESelectBuff) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVESelectBuff)
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPVEShop) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEShop)
  end
  DataCenter.TaskManager:ClearFelledTree()
  if table.count(self.levelParamStack) > 0 then
    local param = table.remove(self.levelParamStack, 1)
    self:Change(param)
    return
  end
  if self.pveTemplate.type == PveLevelType.AdventureLevel and self.pveStatus == PveStatus.Finish then
    DataCenter.AdventureManager:OnLevelExit()
    return
  end
  if self.showRewardTimer then
    self.showRewardTimer:Stop()
    self.showRewardTimer = nil
  end
  if not CS.SceneManager.IsInCity() and not CS.SceneManager.IsInWorld() then
    self.levelState = LevelState.Destroying
    self.touchCamera.AfterUpdate = nil
    local action = ExitAction
    
    local function onSceneCreated()
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEMain, {anim = false})
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVELevelReward, {anim = false})
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVELose, {anim = false})
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEPause, {anim = false})
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEAdventure, {anim = false})
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVESelectAdventureSub, {anim = false})
      self:Destroy()
      Logger.Log("Destroy pve level")
      DataCenter.WarningBallManager:AddTimer()
      EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
      EventManager:GetInstance():Broadcast(EventId.PveLevelExit, self.levelId)
      if self.levelId == MineCavePveLevelId then
        DataCenter.MineCaveManager:SetEnemyPlayerPower()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIDailyActivity, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        }, 5)
        DataCenter.MineCaveManager:TryShowReward()
      elseif self.levelId == ArenaBattleLevelId then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIDailyActivity, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        }, 8)
        DataCenter.ArenaManager:TryOpenCacheUI()
      elseif self.levelId == ArenaSetTeamLevelId then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIDailyActivity, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        }, 8)
      end
      if self.levelParam.isBackToWorld ~= true then
        DataCenter.CityPioneerManager:DoPrologueInit()
        EventManager:GetInstance():Broadcast(EventId.OnEnterCity)
      else
        EventManager:GetInstance():Broadcast(EventId.OnEnterWorld)
      end
      DataCenter.CityNpcManager:SetNpcVisible(true)
      if self.pveStatus == PveStatus.Finish then
        DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.FinishBattleLevel, tostring(self.levelId))
      end
      local guideType = DataCenter.GuideManager:GetGuideType()
      if guideType == GuideType.WaitBackCity then
        DataCenter.GuideManager:DoNext()
      end
      self.uiPveMain = nil
      if action ~= nil then
        action()
      end
      DataCenter.GuideManager:DoWaitTriggerAfterBack()
    end
    
    if self.levelId == ArenaSetTeamLevelId then
      if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPVELoading) then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVELoading)
      end
      local pveLoading = UIManager:GetInstance():GetWindow(UIWindowNames.UIPVELoading).View
      pveLoading:Enter()
      TimerManager:GetInstance():DelayInvoke(function()
        if pveLoading then
          pveLoading:Quit()
        end
      end, 2)
    end
    if self.levelParam.isBackToWorld == true then
      SceneUtils.CreateWorld()
    else
      SceneUtils.CreateCity()
    end
    Logger.Log("CreateScene when exit pve")
    CS.SceneManager.World:CreateScene(onSceneCreated)
  end
end

function BattleLevel:Restart(needConfirm)
  local function ConfirmRestart()
    print("beef BattleLevel, Restart: " .. self.levelParam.levelId)
    
    if self.pveTemplate.type == PveLevelType.HeroExpLevel then
      self:SaveLvPoint(0)
    end
    local param = DeepCopy(self.levelParam)
    param.abandon = true
    param.isStart = false
    self:Enter(param)
  end
  
  if needConfirm then
    UIUtil.ShowMessage(Localization:GetString("400051"), 2, "400050", GameDialogDefine.CANCEL, function()
      ConfirmRestart()
    end, nil, nil)
  else
    ConfirmRestart()
  end
end

function BattleLevel:ConfirmReward()
  self:SendFinishLevel(self.rewardIndex, true)
end

function BattleLevel:RemoveOnePlayerByIndex(index)
  local changeMainIndex = 0
  local pos = self:GetPosition()
  if index == 1 then
    changeMainIndex = 2
    self.player = nil
  end
  local needRemove = 0
  for k, v in ipairs(self.playerGroup) do
    if not v.param.isTriggerGet then
      if v.param.index == index then
        needRemove = k
      elseif v.param.index == changeMainIndex then
        self.player = v
        v.param.isMain = true
        v.param.index = 1
        v.param.pos = pos
        v.param.extraPos = self:GetExtraPos(v.param.index)
        v:RefreshMain()
      elseif index < v.param.index then
        v.param.index = v.param.index - 1
        v.param.pos = pos
        v.param.extraPos = self:GetExtraPos(v.param.index)
        v:ChangeSubPlayerToFollow()
      end
    end
  end
  if 0 < needRemove then
    local temp = table.remove(self.playerGroup, needRemove)
    temp:Destroy()
    self:RefreshTriggerPlayerPos()
    self:RefreshCarryResourceTextUI()
  end
end

function BattleLevel:RemoveOneTriggerPlayerByPrefabName(prefabName)
  local count = table.count(self.playerGroup)
  for i = count, 1, -1 do
    if self.playerGroup[i].param.isTriggerGet and self.playerGroup[i].param.playerName == prefabName then
      local temp = table.remove(self.playerGroup, i)
      temp:Destroy()
      self:RefreshTriggerPlayerPos()
      self:RefreshCarryResourceTextUI()
      return
    end
  end
end

function BattleLevel:AddOnePlayer(playerName, index, pos, isNoGain, isTriggerGet, level, dialogId, heroUuid)
  if not isTriggerGet then
    self:RemoveOnePlayerByIndex(index)
  end
  local objId = self:GetNextObjId()
  local param = {}
  param.isMain = index == 1
  param.pos = pos
  param.originalPos = pos
  param.playerName = playerName
  param.objId = objId
  param.index = index
  param.isNoGain = isNoGain
  param.isTriggerGet = isTriggerGet
  param.level = level
  param.dialogId = dialogId
  param.heroUuid = heroUuid
  if self.player ~= nil then
    param.rot = self.player:GetRotation()
  end
  if isTriggerGet then
    param.extraPos = self:GetExtraPos(1)
  else
    param.extraPos = self:GetExtraPos(index)
  end
  local isHero = self:IsHeroPrefab(param.playerName)
  local req = Resource:InstantiateAsync(self:GetPlayerModelPath(param.playerName))
  local player = Player.New(self, objId, req, param, isHero, isHero)
  if index == 1 then
    self.player = player
    if self.spawnPos ~= nil then
      self.player:SetPosition(self.spawnPos)
    end
  end
  table.insert(self.playerGroup, player)
  req:completed("+", function(request)
    if request.isError then
      return
    end
    player:OnCreate()
    player:ReInit()
  end)
  self:RefreshTriggerPlayerPos()
  self:RefreshCarryResourceTextUI()
end

function BattleLevel:ClearPlayer()
  for k, v in ipairs(self.playerGroup) do
    v:Destroy()
  end
  self.playerGroup = {}
  self.player = nil
end

function BattleLevel:CarryOneObject(res)
  if self.player ~= nil then
    self.player:CarryOneObject(res)
  end
end

function BattleLevel:AddOneFollowPlayer(pos, attack, maxBlood, attackRadius)
  local objId = self:GetNextObjId()
  local followPlayer = FollowPlayer.New(self, objId)
  followPlayer:Create(attack, maxBlood, attackRadius)
  followPlayer:SetPosition(pos)
  followPlayer:SetRotation(Quaternion.LookRotation(Vector3.back))
  self:AddObj(objId, followPlayer)
  table.insert(self.followPlayerGroup, followPlayer)
  return objId
end

function BattleLevel:AddToFollowQueue(followPlayer)
  for i, v in ipairs(self.followPlayerQueue) do
    if v == followPlayer then
      return i
    end
  end
  table.insert(self.followPlayerQueue, followPlayer)
  return #self.followPlayerQueue
end

function BattleLevel:GetFollowPlayerInQueue(queueIndex)
  return self.followPlayerQueue[queueIndex]
end

function BattleLevel:GetPosition()
  if self.player == nil then
    return self.spawnPos
  end
  return self.player:GetPosition()
end

function BattleLevel:SetPosition(pos, withFollowers)
  if self.player == nil then
    self.spawnPos = pos
  else
    self.player:SetPosition(pos)
  end
  if withFollowers then
    for _, player in ipairs(self.playerGroup) do
      if not player.param.isMain and not player.param.isNoGain then
        player:SetPosition(pos)
      end
    end
  end
end

function BattleLevel:GetRotation()
  if self.player == nil then
    return Quaternion.LookRotation(Vector3.back)
  end
  return self.player:GetRotation()
end

function BattleLevel:SetRotation(angle)
  if self.player ~= nil then
    self.player:SetRotation(Quaternion.Euler(0, angle, 0))
  end
end

function BattleLevel:ChangeSubPlayerToFollow(playerName, pos)
  local isHave = false
  for k, v in ipairs(self.playerGroup) do
    if v.param.isTriggerGet and v.param.originalPos ~= nil and v.param.originalPos.x == pos.x and v.param.originalPos.y == pos.y and v.param.originalPos.z == pos.z and v.param.playerName == playerName then
      isHave = true
      v:PlaySaveAnim()
      self:ShowOneGetPlayerEffect(v.param.originalPos)
      TimerManager:DelayInvoke(function()
        v.param.isNoGain = false
        self:RefreshTriggerPlayerPos()
      end, 2)
    end
  end
end

function BattleLevel:IsFinishTrigger(id)
  return self.triggerMgr:IsFinishTrigger(id)
end

function BattleLevel:IsHasSubPlayer()
  for k, v in ipairs(self.playerGroup) do
    if not v.param.isNoGain and not v.param.isMain then
      return true
    end
  end
  return false
end

function BattleLevel:GetExtraPos(index)
  local posCount = table.count(ExtraManPos)
  if index <= posCount then
    return ExtraManPos[index]
  else
    return Vector3.New(-0.7 * (index - posCount), 0, -2)
  end
end

function BattleLevel:RefreshTriggerPlayerPos()
  local index = 0
  for k, v in ipairs(self.playerGroup) do
    if not v.param.isTriggerGet then
      index = index + 1
    end
  end
  for k, v in ipairs(self.playerGroup) do
    if v.param.isTriggerGet and not v.param.isNoGain then
      index = index + 1
      v.param.index = index
      v.param.extraPos = self:GetExtraPos(index)
      v:ChangeSubPlayerToFollow()
    end
  end
  local subPlayerCount = 0
  for k, v in ipairs(self.playerGroup) do
    if not v.param.isMain and not v.param.isNoGain then
      subPlayerCount = subPlayerCount + 1
    end
  end
  if 0 < subPlayerCount then
    if self.player and not self.player:HasHeadTag() then
      self.player:CreateHeadTag()
    end
  elseif self.player and self.player:HasHeadTag() then
    self.player:DestroyHeadTag()
  end
end

function BattleLevel:OnHeroChanged(i, heroUuid, isAdd)
  print("beef OnHeroChanged i: " .. i .. ", heroUuid: " .. heroUuid .. ", isAdd: " .. (isAdd and "true" or "false"))
  if isAdd then
    local heroData = self:GetPveHeroData(heroUuid)
    if heroData ~= nil then
      local model = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "prefab_low_exp")
      self:AddOnePlayer(model, i, nil, nil, nil, heroData.level, nil, heroUuid)
    end
  else
    self:RemoveOnePlayerByIndex(i)
  end
end

function BattleLevel:RefreshCarryResourceText()
  if self.uiPveMain ~= nil then
    self.uiPveMain:RefreshCarryResource()
  end
  self:RefreshCarryResourceTextUI()
end

function BattleLevel:RefreshCarryResourceTextUI()
  if self.player ~= nil and (not self:IsShowCarry() or self.player:GetCarryCnt() > self:GetCarryMaxNum()) then
    if self.resourceText == nil then
      self.resourceText = CarryResourceUI.New(self)
      self.resourceText:Create()
    end
    self.resourceText:SetVisible(true)
    self.resourceText:RefreshText()
  elseif self.resourceText ~= nil then
    self.resourceText:SetVisible(false)
  end
end

function BattleLevel:GetAllCarryResList(result)
  if self.player ~= nil then
    return self.player:GetAllCarryResList(result)
  end
  return result
end

function BattleLevel:SetSliderVisible(visible)
  if self.uiPveMain ~= nil then
    self.uiPveMain:SetSliderVisible(visible)
  end
end

function BattleLevel:SetSliderData(param)
  if self.uiPveMain ~= nil then
    self.uiPveMain:SetSliderData(param)
  end
end

function BattleLevel:IsInBattleLevel()
  return self.levelState == LevelState.Created or self.levelState == LevelState.RequestInfo
end

function BattleLevel:CloseUIWindows()
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldTileUI)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldPoint)
end

function BattleLevel:RemoveOneBuild(pos)
  local id = self:GetPosId(pos)
  if self.build[id] ~= nil then
    self.build[id]:Destroy()
    self.build[id] = nil
  end
end

function BattleLevel:AddOneBuild(pos, buildName, animName, buffTriggerList, triggerDirection, triggerId, rot)
  local param = {}
  param.pos = pos
  param.rot = rot or Vector3.zero
  param.buildName = buildName
  param.animName = animName
  param.buffTriggerList = buffTriggerList
  param.id = self:GetPosId(pos)
  param.triggerDirection = triggerDirection
  param.triggerId = triggerId
  if self.build[param.id] == nil then
    self.build[param.id] = PveBuild.New(self, param)
  else
    self.build[param.id]:ChangeParam(param)
  end
end

function BattleLevel:ClearBuild()
  for k, v in pairs(self.build) do
    v:Destroy()
  end
  self.build = {}
end

function BattleLevel:HasBuffByType(buffType)
  for k, v in pairs(self.buff) do
    if v.type_buff == buffType then
      return true
    end
  end
  return false
end

function BattleLevel:GetBuffEffectValueByType(buffType)
  local effect = 0
  for k, v in pairs(self.buff) do
    if v.type_buff == buffType then
      if v.time_type == PveBuffTimeType.Time then
        return v.effectValue
      end
      effect = v.effectValue
    end
  end
  return effect
end

function BattleLevel:SetSpeedMulti(speedMulti)
  self.speedMulti = speedMulti
end

function BattleLevel:GetSpeedMulti()
  local sm = self.speedMulti or 1
  if self.pveTemplate.type == PveLevelType.AdventureLevel then
    sm = sm * tonumber(LuaEntry.DataConfig:TryGetStr("explorer_pve", "k4")) or 1
  end
  return sm
end

function BattleLevel:AddBuffById(id)
  local template = DataCenter.PveBuffTemplateManager:GetTemplate(id)
  if template ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local endTime = curTime + template.time * 1000
    local removeId
    for k, v in pairs(self.buff) do
      if v.id == id then
        v.endTime = endTime
        if v.time_type == PveBuffTimeType.Time then
          self.uiPveMain:AddOneBuff(v.id)
        end
        return
      elseif template.type_buff ~= PveBuffType.Player and v.type_buff == template.type_buff and v.time_type == template.time_type then
        removeId = v.id
      end
    end
    local buff = {}
    buff.id = template.id
    buff.type_buff = template.type_buff
    buff.endTime = endTime
    buff.time_type = template.time_type
    buff.effectValue = template:GetBuffEffectValue()
    table.insert(self.buff, buff)
    if buff.time_type == PveBuffTimeType.Time then
      self.uiPveMain:AddOneBuff(buff.id)
    end
    if buff.type_buff == PveBuffType.Player then
      buff.prefabName = template.para
      self:AddOnePlayer(template.para, 0, nil, nil, true)
      self:ShowOneGetPlayerEffect(self:GetLastTriggerPlayerPos())
    end
    if removeId ~= nil then
      self:RemoveBuffById(removeId)
    else
      self:RefreshBuff()
    end
  end
end

function BattleLevel:RemoveBuffById(id)
  for k, v in ipairs(self.buff) do
    if v.id == id then
      table.remove(self.buff, k)
      if v.type_buff == PveBuffType.Player then
        self:RemoveOneTriggerPlayerByPrefabName(v.prefabName)
      end
      self.uiPveMain:RemoveOneBuff(v.id)
      self:RefreshBuff()
      return
    end
  end
end

function BattleLevel:GetAllBuff()
  return self.buff
end

function BattleLevel:RefreshBuff()
  for k, v in ipairs(self.playerGroup) do
    if not v.param.isNoGain then
      v:RefreshBuff()
    end
  end
  if self.uiPveMain ~= nil then
    self.uiPveMain:RefreshBuff()
  end
end

function BattleLevel:GetBuffById(id)
  for k, v in pairs(self.buff) do
    if v.id == id then
      return v
    end
  end
end

function BattleLevel:ShowOneGetPlayerEffect(pos)
  local param = {}
  param.pos = pos
  self.playerEffect[pos] = param
  local request = Resource:InstantiateAsync(string.format(UIAssets.BuildUpgradeCompleteEffect, 1))
  param.request = request
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    request.gameObject.transform.position = pos
  end)
  param.timer = TimerManager:DelayInvoke(function()
    param.timer:Stop()
    self.playerEffect[pos] = nil
    param.request:Destroy()
  end, 5)
end

function BattleLevel:ClearPlayerEffect()
  for k, v in pairs(self.playerEffect) do
    v.timer:Stop()
    v.request:Destroy()
  end
  self.playerEffect = {}
end

function BattleLevel:DoTriggerGuide(guideId)
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPVELoading) then
    if DataCenter.GuideManager:InGuide() then
      DataCenter.GuideManager:SetCurGuideId(GuideEndId)
      DataCenter.GuideManager:DoGuide()
    end
    table.insert(self.waitDoGuide, guideId)
  elseif DataCenter.GuideManager:InGuide() then
  else
    DataCenter.GuideManager:SetCurGuideId(guideId)
    DataCenter.GuideManager:DoGuide()
  end
end

function BattleLevel:AfterLoading()
  if DataCenter.GuideManager:InGuide() and DataCenter.GuideManager:GetGuideType() == GuideType.WaitPveEnterComplete then
    DataCenter.GuideManager:DoNext()
  end
end

function BattleLevel:AfterLoadingDoGuide()
  local count = table.count(self.waitDoGuide)
  if 0 < count then
    local guideId = table.remove(self.waitDoGuide, 1)
    DataCenter.GuideManager:SetGuideEndCallBack(function()
      self:AfterLoadingDoGuide()
    end)
    if not DataCenter.GuideManager:InGuide() then
      DataCenter.GuideManager:SetCurGuideId(guideId)
      DataCenter.GuideManager:DoGuide()
    end
  end
end

function BattleLevel:GetCarryCountByResType(resType)
  if self.player ~= nil then
    return self.player:GetCarryCountByResType(resType)
  end
  return 0
end

function BattleLevel:IsHeroPrefab(prefabName)
  if prefabName == Const.DefinePlayerName or prefabName == "CitySpaceMuchAttackMan" then
    return false
  end
  return true
end

function BattleLevel:UseRandomAttack(prefabName)
  if prefabName == "CitySpaceMuchAttackMan" then
    return true
  end
  return false
end

function BattleLevel:IsUseRandomAttackModelLevel()
  return self:UseRandomAttack(self.pveTemplate.player_model)
end

function BattleLevel:ChangeResItem(resType, num)
  if self.resItem[resType] == nil then
    self.resItem[resType] = num
  else
    self.resItem[resType] = self.resItem[resType] + num
  end
  if self.resItem[resType] <= 0 then
    self.resItem[resType] = nil
  end
  self:RefreshCarryResourceText()
end

function BattleLevel:GetResItemNum(resType)
  if self.resItem[resType] ~= nil then
    return self.resItem[resType]
  end
  return 0
end

function BattleLevel:CheckShowLevelReward()
  if self.pveStatus == PveStatus.Finish and not DataCenter.GuideManager:InGuide() then
    self:ShowLevelReward()
  end
end

function BattleLevel:GuideEnd()
  self:CheckShowLevelReward()
end

function BattleLevel:GetPlayerActionState()
  if self.player ~= nil then
    return self.player:GetCurActionState()
  end
end

function BattleLevel:GetPlayerForward()
  if self.player ~= nil then
    return self.player:GetTransform().forward
  end
end

function BattleLevel:GetAllResItemList(result)
  if result == nil then
    result = {}
  end
  for k, v in ipairs(Const.ResItemOrder) do
    if self.resItem[v] ~= nil then
      table.insert(result, {
        resourceType = Const.UnlockToResType[v],
        num = self.resItem[v]
      })
    end
  end
  return result
end

function BattleLevel:GetAllResourceList(result)
  if result == nil then
    result = {}
  end
  for k, v in ipairs(Const.ResourceOrder) do
    local num = self:GetResTypeCount(v)
    if 0 < num then
      table.insert(result, {resourceType = v, num = num})
    end
  end
  return result
end

function BattleLevel:GetAllResList()
  local result = self:GetAllResourceList()
  result = self:GetAllCarryResList(result)
  return self:GetAllResItemList(result)
end

function BattleLevel:GetAllFrontRewardGot()
  return self.frontRewardGotList
end

function BattleLevel:AddFrontReward(rewardType, itemId, count)
  local found = false
  for _, r in ipairs(self.frontRewardGotList) do
    if r.rewardType == rewardType and r.itemId == itemId then
      r.count = r.count + count
      found = true
      break
    end
  end
  if not found then
    local n = {
      rewardType = rewardType,
      itemId = itemId,
      count = count
    }
    table.insert(self.frontRewardGotList, n)
  end
  self.uiPveMain:RefreshFrontReward()
  if rewardType == RewardType.HERO_EXP then
    self.frontTotalExp = self.frontTotalExp + count
  end
end

function BattleLevel:AddOneNpc(param)
  self.npcMgr:AddOneNpc(param)
end

function BattleLevel:RemoveOneNpc(modelName)
  self.npcMgr:RemoveOneNpc(modelName)
end

function BattleLevel:SetFollowNpc(npcName)
  self.npcMgr:SetFollowNpc(npcName)
end

function BattleLevel:GetNpcPositionByName(npcName)
  self.npcMgr:GetNpcPositionByName(npcName)
end

function BattleLevel:SetNpcDialog(modelName, dialogId)
  self.npcMgr:SetNpcDialog(modelName, dialogId)
end

function BattleLevel:AddOneDropBuff(buffId, position)
  self.dropBuffMgr:AddOneDropBuff(buffId, position)
end

function BattleLevel:RemoveOneDropBuff(id)
  self.dropBuffMgr:RemoveOneDropBuff(id)
end

function BattleLevel:AddOneWaitMove(resType, num, position, id)
  self.waitMoveMgr:AddOneWaitMove(resType, num, position, id)
end

function BattleLevel:RemoveOneWaitMove(id)
  self.waitMoveMgr:RemoveOneWaitMove(id)
end

function BattleLevel:GetTriggerPointByRes(resType)
  return self.triggerMgr:GetTriggerPointByRes(resType)
end

function BattleLevel:AddOneArrow(position, height, showPos)
  self.arrowMgr:AddOneArrow(position, height, showPos)
end

function BattleLevel:RemoveOneArrowById(id)
  self.arrowMgr:RemoveOneArrow(id)
end

function BattleLevel:RemoveOneArrowByPos(pos)
  local id = self:GetPosId(pos)
  self.arrowMgr:RemoveOneArrow(id)
end

function BattleLevel:RemoveAllArrow()
  self.arrowMgr:RemoveAll()
end

function BattleLevel:GetModelPos(pos)
  local id = self:GetPosId(pos)
  if self.build[id] ~= nil then
    return self.build[id]:GetModelPos()
  else
    pos.y = 1
  end
  return pos
end

function BattleLevel:GetPosId(pos)
  return pos.x .. " " .. pos.z
end

function BattleLevel:GetCurTimeStar()
  for i, t in ipairs(self.pveTemplate.timeLimitList) do
    if self.usedTime <= t * 1000 then
      return #self.pveTemplate.timeLimitList + 1 - i, i - 1
    end
  end
  return 0, 0
end

function BattleLevel:CheckResReachGuide()
  if self.pveTriggerGuide ~= nil then
    for k, v in ipairs(self.pveTriggerGuide) do
      if v.triggerType == GuideTriggerType.PveOwnRes then
        local canTrigger = true
        for k2, v2 in ipairs(v.needRes) do
          local resType = Const.UnlockToResType[v2.resType]
          local own = self:GetResTypeCount(resType)
          if own < v2.count then
            canTrigger = false
            break
          end
        end
        if canTrigger and DataCenter.GuideManager:CheckDoTriggerGuide(v.triggerType, v.triggerPara) then
          break
        end
      end
    end
  end
end

function BattleLevel:GetResTypeCount(resType)
  if self:IsCarryType(resType) then
    return self:GetCarryCountByResType(resType)
  elseif self:IsResourceType(resType) then
    return self:GetResourceCountByResType(resType)
  elseif self:IsCarryResourceItemType(resType) then
    return self:GetResourceItemCountByResType(resType)
  else
    return self:GetResItemNum(resType)
  end
end

function BattleLevel:ChangeResTypeCount(resType, num, pos)
  if self:IsCarryType(resType) then
    self:ChangeOneResType(resType, num)
  elseif self:IsResourceType(resType) then
    LuaEntry.Resource:ChangeNum(Const.ResTypeToResourceType[resType], num)
  elseif self:IsCarryResourceItemType(resType) then
    self:ChangeCarryObjectNum(resType, num, pos)
  else
    self:ChangeResItem(resType, num)
  end
end

function BattleLevel:ChangeOneResType(resType, num)
  if self.player ~= nil then
    self.player:ChangeOneResType(resType, num)
  end
end

function BattleLevel:AddMoveManCount(addNum)
  for k, v in pairs(self.build) do
    if v:IsNeedAddMoveMan() then
      v:AddMoveManCount(addNum)
      self.waitMoveMgr:RefreshMoveManCount(k)
    end
  end
end

function BattleLevel:GetMoveManCount(id)
  if self.build[id] ~= nil then
    return self.build[id]:GetMoveManCount()
  end
  return InitMovePeopleNum
end

function BattleLevel:SetArrowVisibleById(id, visible)
  self.arrowMgr:SetArrowVisible(id, visible)
end

function BattleLevel:SetArrowVisibleByPos(pos, visible)
  local id = self:GetPosId(pos)
  self.arrowMgr:SetArrowVisible(id, visible)
end

function BattleLevel:LoadSaveBobScene(pos, state)
  self.timelineMgr:LoadSaveBobScene(pos, state)
end

function BattleLevel:RemoveSaveBobScene()
  self.timelineMgr:RemoveSaveBobScene()
end

function BattleLevel:GotoTime(time)
  self.timelineMgr:GotoTime(time)
end

function BattleLevel:CheckDoNext()
  self.timelineMgr:CheckDoNext()
end

function BattleLevel:IsUseGuideTimelineMarker()
  return self.timelineMgr:IsUseGuideTimelineMarker()
end

function BattleLevel:GetTimeLineModelByType(sceneType)
  return self.timelineMgr:GetTimeLineModelByType(sceneType)
end

function BattleLevel:RefreshCarryUIParent()
  if self.resourceText ~= nil then
    self.resourceText:RefreshParent()
  end
end

function BattleLevel:DebugWin()
  if not CS.CommonUtils.IsDebug() then
    return
  end
  if self.isTimeLimited then
    self.rewardIndex = 0
    self:ShowLevelReward()
  else
    self:ShowLevelReward()
    self:SendFinishLevel(0, true)
  end
end

function BattleLevel:GetHeroSelectHistory()
  local heroArr = {}
  local uid = LuaEntry.Player.uid
  local pveHeroes
  local levelType = self:GetLevelType()
  if self.curEntranceType == PveEntrance.ArenaBattle then
    local str = "ArenaPveCacheHeroes_" .. LuaEntry.Player.uid
    pveHeroes = CS.GameEntry.Setting:GetString(str, "")
  elseif self.curEntranceType == PveEntrance.ArenaSetting then
    local army = DataCenter.ArenaManager:GetDefenseArmy()
    if army and army.heroes then
      for i, v in ipairs(army.heroes) do
        table.insert(heroArr, v.heroUuid)
      end
    end
  elseif self.curEntranceType == PveEntrance.AdventureSetting then
    pveHeroes = Setting:GetPrivateString(SettingKeys.PVE_HEROES_ADVENTURE .. uid, "")
  elseif self.curEntranceType == PveEntrance.MineCave then
  else
    local trigger = PveActorMgr:GetInstance():GetCurTrigger()
    local triggerTypeStr = ""
    if trigger ~= nil and trigger:IsTypeLevelLimitMonster() then
      triggerTypeStr = tostring(Const.TriggerType.LevelLimitMonster)
    end
    pveHeroes = Setting:GetPrivateString(SettingKeys.PVE_HEROES .. uid .. "_" .. tostring(levelType) .. triggerTypeStr, "")
    local needSaveLevel = LuaEntry.DataConfig:TryGetNum("aps_pve_config", "k9")
    local mainLv = DataCenter.BuildManager.MainLv
    if needSaveLevel <= 0 then
      needSaveLevel = 4
    end
    if mainLv <= needSaveLevel then
      pveHeroes = Setting:GetPrivateString(SettingKeys.PVE_HEROES .. uid, "")
    end
  end
  if not string.IsNullOrEmpty(pveHeroes) then
    local heroes = string.split_ss_array(pveHeroes, ";")
    for _, v in ipairs(heroes) do
      local uuid = tonumber(v)
      local heroData = self:GetPveHeroData(uuid)
      if heroData ~= nil and heroData.level <= DataCenter.BattleLevel:GetMaxHeroLevel() and not self.heroMgr:IsHeroBanned(heroData.heroId) then
        heroArr[#heroArr + 1] = uuid
      end
    end
  end
  return heroArr
end

function BattleLevel:RefreshBuildShop(id)
  if self.build[id] ~= nil then
    return self.build[id]:RefreshBuildShop()
  end
  return InitMovePeopleNum
end

function BattleLevel:GetLastTriggerPlayerPos()
  local pos
  for k, v in ipairs(self.playerGroup) do
    if not v.param.isMain and not v.param.isNoGain and v.param.isTriggerGet then
      pos = v:GetPosition()
    end
  end
  return pos
end

function BattleLevel:DoTriggerAnimation(triggerData, index)
  if triggerData ~= nil then
    triggerData:PlayInterActAnim(index)
    return self:PlayInterActAnim(triggerData.config.animation, triggerData.config.animationTime, triggerData:GetTriggerId())
  end
  return Const.PlayerInteractCode.InteractCode_Fail
end

function BattleLevel:MonsterDiffWin(diff)
  local highestDiff = math.min(self.diffParam.curDiff + 2, MaxDiff + 2)
  if diff >= highestDiff then
    local win = self.diffParam.curDiffWin + 1
    if win >= DiffUpWin then
      win = win - DiffUpWin
      self.diffParam.curDiff = math.min(self.diffParam.curDiff + 1, MaxDiff)
    end
    self.diffParam.curDiffWin = win
  end
end

function BattleLevel:OnSelectPveBuffMessage(message)
  if message.selectTrigger then
    self.selectTriggerStr = message.selectTrigger
    self.selectBattleBuffList = {}
    if not string.IsNullOrEmpty(self.selectTriggerStr) then
      local strs = string.split(self.selectTriggerStr, ";")
      for _, str in ipairs(strs) do
        local spls = string.split(str, ",")
        if 0 < #spls then
          local triggerId = tonumber(spls[1])
          local trigger = self:GetTriggerByTriggerId(triggerId)
          if trigger:IsTypeBuffBox() then
            local info = {
              triggerId = triggerId,
              buffGroupId = tonumber(spls[2]),
              buffId = tonumber(spls[3])
            }
            table.insert(self.selectBattleBuffList, info)
          end
        end
      end
    end
    EventManager:GetInstance():Broadcast(EventId.PveBattleBuffRefresh)
  end
end

function BattleLevel:GetCanAddHero()
  local maxHeroCount = DataCenter.BattleLevel:GetMaxHeroCount()
  local heroDataDict = DataCenter.HeroDataManager:GetAllHeroBySort()
  local heroes = self.heroMgr:GetCurHeroes()
  local curHeroCount = 0
  if heroes ~= nil then
    curHeroCount = table.count(heroes)
  end
  if curHeroCount < 5 and maxHeroCount > curHeroCount and curHeroCount < table.count(heroDataDict) then
    return true
  end
  return false
end

function BattleLevel:LoadPirateShowScene()
  self.timelineMgr:LoadPirateShowScene()
end

function BattleLevel:TryFakeExpAndLevel(trigger)
  local triggerDict = {
    [30004] = 302006,
    [30006] = 300206,
    [30009] = 301705,
    [30010] = 301803,
    [40007] = 449020
  }
  local triggerId = triggerDict[self.levelId]
  if triggerId ~= nil then
    local exp = math.random(10, 30)
    self.player:ShowAddExp(exp)
    self.player:ShowLevelUpEffect()
    if tonumber(trigger:GetTriggerId()) == triggerId then
      self.player:ShowLevelUp()
    end
  end
end

function BattleLevel:IsCarryType(resType)
  return resType == Const.CityCutResType.Crystal or resType == Const.CityCutResType.GreenCrystal or resType == Const.CityCutResType.Cactus
end

function BattleLevel:IsResourceType(resType)
  return Const.ResTypeToResourceType[resType] ~= nil
end

function BattleLevel:IsCarryResourceItemType(resType)
  for k, v in ipairs(Const.CarryResourceItemOrder) do
    if v == resType then
      return true
    end
  end
  return false
end

function BattleLevel:GetFlyNode(resType)
  if self.uiPveMain ~= nil then
    return self.uiPveMain:GetFlyNode(resType)
  end
end

function BattleLevel:RefreshCameraRotation()
  self.collectionMgr:RefreshCameraRotation(self.cameraRot)
  for k, v in pairs(self.sceneObjs) do
    if v.RefreshCameraRotation ~= nil then
      v:RefreshCameraRotation(self.cameraRot)
    end
  end
  self.dropRewardMgr:RefreshCameraRotation(self.cameraRot)
end

function BattleLevel:OnCutCollection(num)
  if not self:HasBuffByType(PveBuffType.AttackAnim) then
    self:ChangeSkillNum(num)
  end
end

function BattleLevel:GetBuffEffectDict()
  return self.buffEffectDict
end

function BattleLevel:SetBuffEffectDict(dict)
  self.buffEffectDict = dict
end

function BattleLevel:GetAttack()
  if self.player ~= nil then
    return self.player:GetAttack()
  end
end

function BattleLevel:ShowBuyAttackShop(buffTriggerList)
  if self.uiPveMain ~= nil then
    self.uiPveMain:ShowBuyAttackShop(buffTriggerList)
  end
end

function BattleLevel:GetTriggerByTriggerType(triggerType)
  return self.triggerMgr:GetTriggerByTriggerType(triggerType)
end

function BattleLevel:SetPlayerHpBar(cur, max, showChange)
  if self.player ~= nil then
    self.player:ShowHpBar(true)
    self.player:SetHpBarVal(cur, max, showChange)
  end
end

function BattleLevel:ShakeCamera()
  if self:IsUseRandomAttackModelLevel() and false and self.cameraTween == nil then
    local originalPos = self:GetCameraTarget()
    self.cameraTween = self.camera:DOShakePosition(0.2, Vector3.New(0.05, 0.05, 0))
    if self.cameraTween ~= nil then
      self.cameraTween:OnComplete(function()
        self:Lookat(originalPos)
        self.cameraTween = nil
      end)
    end
  end
end

function BattleLevel:ShakeCameraWithParam(param)
  if self.cameraTween then
    self.cameraTween:Kill()
  end
  local originalPos = self:GetCameraTarget()
  self.cameraTween = self.camera:DOShakePosition(param.duration, param.strength, param.vibrato):OnComplete(function()
    self:Lookat(originalPos)
    self.cameraTween = nil
  end)
end

function BattleLevel:IsPlayingShakeCamera()
  return self.cameraTween ~= nil
end

function BattleLevel:IsSkillLevel()
  return self.pveTemplate.type == PveLevelType.SkillLevel
end

function BattleLevel:GetPlayerModelPath(modelName)
  if self:IsHeroPrefab(modelName) then
    return string.format(LoadPath.DyHero, modelName)
  end
  return string.format(LoadPath.CityScene, modelName)
end

function BattleLevel:SetOneTriggerVisible(triggerId, visible)
  local trigger = self:GetTriggerByTriggerId(triggerId)
  if trigger ~= nil then
    self.guideNoShowTriggerId[triggerId] = visible
    trigger:SetVisible(visible)
  end
end

function BattleLevel:CanShowTrigger(triggerId)
  return self.guideNoShowTriggerId[triggerId] ~= false
end

function BattleLevel:IsLastTrigger(triggerId)
  if table.IsNullOrEmpty(self.pveTemplate.triggerList) then
    return false
  end
  return self.pveTemplate.triggerList[#self.pveTemplate.triggerList] == triggerId
end

function BattleLevel:AddOneFlyRes(resType, num, pos)
  self.flyResMgr:AddOneFlyRes(resType, num, pos)
end

function BattleLevel:RemoveOneFlyRes(id)
  self.flyResMgr:RemoveOneFlyRes(id)
end

function BattleLevel:IsPveStaminaEnough(costNum)
  local cur = LuaEntry.Player:GetCurPveStamina()
  if costNum > cur then
    return false
  end
  return true
end

function BattleLevel:SyncPveResourceHandle(message)
  self.resRecordMgr:SyncPveResourceHandle(message)
end

function BattleLevel:CutOneCollection(id, configId, collectionData, complete)
  local template = DataCenter.PveAtomTemplateManager:GetTemplate(id)
  for _, v in ipairs(template.outResource) do
    self:ResDropAnim(v.resourceType, collectionData:GetPosition())
  end
  for _, v in ipairs(template.outResItem) do
    self:ResDropAnim(v.itemId, collectionData:GetPosition())
  end
  self.resRecordMgr:ChangeCutCount(id, 1)
  if self:CheckDropCut(id) then
    if self:CheckResCanGet(id) then
      self.resRecordMgr:ChangeRecordCount(id, 1, collectionData)
    else
      self.resRecordMgr:TryShowMaxTip(self.levelId, id)
    end
    if self.pveTemplate.type == PveLevelType.HeroExpLevel then
      self:AddLvPoint(collectionData, 1)
    end
  end
  if complete then
    self.dbMgr:AddOneSaveTree(configId)
  end
  self:CheckResReachGuide()
end

function BattleLevel:GetResourceCount(resourceType)
  return self.resRecordMgr:GetResourceCount(resourceType)
end

function BattleLevel:GetResourceCountByResType(resType)
  return self.resRecordMgr:GetResourceCount(Const.ResTypeToResourceType[resType])
end

function BattleLevel:ChangeSubmitResource(resourceType, num)
  self.resRecordMgr:ChangeSubmitResource(resourceType, num)
end

function BattleLevel:PveStaminaUpdateSignal()
  self.triggerMgr:PveStaminaUpdateSignal()
end

function BattleLevel:RefreshResourceItemSignal()
  self.triggerMgr:RefreshResourceItemSignal()
end

function BattleLevel:UpdateItemSignal()
  self.triggerMgr:UpdateItemSignal()
end

function BattleLevel:SaveDB()
  self.dbMgr:SaveDB()
end

function BattleLevel:AddOneSaveTree(id)
  self.dbMgr:AddOneSaveTree(id)
end

function BattleLevel:IsBeRemove(id)
  return self.dbMgr:IsBeRemove(id)
end

function BattleLevel:GetTriggersByPointId(pointId)
  return self.triggerMgr:GetTriggersByPointId(pointId)
end

function BattleLevel:OnPlayerMoveSignal(pos)
  self.triggerMgr:OnPlayerMoveSignal(pos)
  self.dropBuffMgr:OnPlayerMoveSignal(pos)
  self.dropRewardMgr:OnPlayerMoveSignal(pos)
  for k, v in pairs(self.build) do
    v:OnPlayerMoveSignal(pos)
  end
  self.npcMgr:OnPlayerMoveSignal(pos)
  self.selectionMgr:Refresh()
end

function BattleLevel:AddOneFlyBlood(attack, pos)
  self.flyResMgr:AddOneFlyBlood(attack, pos)
end

function BattleLevel:RemoveOneFlyBlood(id)
  self.flyResMgr:RemoveOneFlyBlood(id)
end

function BattleLevel:SetFogVisible(visible)
  if self.fog ~= nil then
    self.fog:SetFogVisible(visible)
  end
end

function BattleLevel:OnGetTriggerRewardHandler(message)
  if message.trigger ~= nil then
    local triggerId = message.trigger
    if self.triggerReward == nil then
      self.triggerReward = {}
    end
    self.triggerReward[triggerId] = DeepCopy(message.reward or {})
    local trigger = self:GetTriggerByTriggerId(triggerId)
    if trigger ~= nil then
      trigger:DoWhenTriggerRewardBack()
    end
  end
end

function BattleLevel:GetTriggerReward(triggerId)
  if self.triggerReward ~= nil then
    return self.triggerReward[triggerId]
  end
  return nil
end

function BattleLevel:CanShowBlood()
  return self.pveTemplate.hp_show == PveShowBloodType.Show
end

function BattleLevel:CheckResCanGet(id)
  local template = DataCenter.PveAtomTemplateManager:GetTemplate(id)
  if template == nil then
    return false
  end
  local maxCount = self.pveTemplate.resCheck[id] or IntMaxValue
  local count = self.resRecordMgr:GetAllRecordCount(id)
  return maxCount > count
end

function BattleLevel:CheckDropCut(id)
  local template = DataCenter.PveAtomTemplateManager:GetTemplate(id)
  if template == nil then
    return false
  end
  local cutCount = self.resRecordMgr:GetCutCount(id)
  return cutCount % template.cutNum == 0
end

function BattleLevel:TaskSyncPveResource()
  self.resRecordMgr:SyncPveResource()
end

function BattleLevel:OnPushPveLevelFinish(message)
  if self.levelState == LevelState.Destroyed or self.levelState == LevelState.Destroying then
    return
  end
  self:SetFinishTrigger(message)
  self:SetSpecialTriggers(message)
  if message.reward then
    self:OnRewardMessage(message.reward, false)
  end
  if message.level ~= nil and message.status ~= nil and message.level == self.levelId and message.status == PveStatus.Finish then
    self.pveStatus = PveStatus.Finish
    self:CheckShowLevelReward()
    self:OnFinish()
  end
  if message.heroExpReward ~= nil then
    local reportReward = PBController.ParsePb1(message.heroExpReward, "protobuf.ReportReward")
    local exps = reportReward.rewardHeroExps
    if self:GetLevelType() == PveLevelType.HeroExpLevel then
      for _, info in ipairs(exps) do
        for _, player in ipairs(self.playerGroup) do
          if player.param.heroUuid == info.heroUuid then
            player:UpdateExpInfo(info)
          end
        end
      end
    elseif self:GetLevelType() == PveLevelType.NormalExpLevel then
      for _, info in ipairs(exps) do
        self.player:ShowAddExp(info.expAdd)
        self.player:FlyExpBall(info)
      end
    end
  end
end

function BattleLevel:CanShowPveSkill()
  return not self.guideHideSkill and self.pveTemplate.showSkill == PveShowSkill.Show and LuaEntry.Effect:GetGameEffect(EffectDefine.PVE_START_ATTACK_SKILL) == 1
end

function BattleLevel:SetHideSkill(active)
  self.guideHideSkill = active
end

function BattleLevel:IsZoomOn()
  return self.pveTemplate and self.pveTemplate.zoomOn == 1 or false
end

function BattleLevel:SetHighView(isHighView, moveCamera)
  if not self:IsZoomOn() then
    return
  end
  self.isHighView = isHighView
  self.isWalk = false
  if self.hvTimer ~= nil then
    self.hvTimer:Stop()
    self.hvTimer = nil
  end
  if self.joystick ~= nil then
    self.joystick:OnHighView(isHighView)
  end
  if self.player ~= nil then
    self.player:StopWalk()
  end
  if self.uiPveMain ~= nil then
    self.uiPveMain.view_option:SetIsOn(isHighView)
  end
  if self.teleportBack ~= nil then
    self.teleportBack:OnSetHighView(isHighView)
  end
  self.triggerMgr:OnSetHighView(isHighView)
  if self.player ~= nil and self.touchCamera ~= nil then
    if isHighView then
      self:SetCameraZoomParam(Const.CameraParam.HighView)
    else
      self:SetCameraZoomParam(Const.CameraParam.Level)
    end
    if moveCamera then
      self:LookAtPlayer()
    else
      self:SetCameraFree(isHighView)
      if not isHighView then
        self.player:StartCameraFollow(self.player:GetPosition())
      end
    end
  end
end

function BattleLevel:LookAtPlayer(callback)
  if self.hvTimer ~= nil then
    self.hvTimer:Stop()
    self.hvTimer = nil
  end
  local targetHeight
  if self.isHighView then
    targetHeight = self:GetParamZoomHeight(2)
  else
    targetHeight = self:GetParamZoomHeight(1)
  end
  self:DisableJoystick()
  self.touchCamera:StopMove()
  self:AutoLookat(self.player:GetPosition(), targetHeight, HighViewDuration)
  self.hvTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:EnableJoystick()
    self:SetCameraFree(self.isHighView)
    if not self.isHighView then
      self.player:StartCameraFollow(self.player:GetPosition())
    end
    if callback then
      callback()
    end
  end, HighViewDuration)
end

function BattleLevel:ClampCamera()
  if not self.isHighView then
    return
  end
  if self.mapEdge == nil or self.touchCamera == nil then
    return
  end
  if self.touchCamera.CurrentState == MobileTouchCamera.State.Focus or self.touchCamera.CurrentState == MobileTouchCamera.State.MoveTo then
    return
  end
  local pos = self:GetCameraTarget()
  local clamped = false
  if pos.x < self.mapEdge.xMin + CameraPaddingX then
    pos.x = self.mapEdge.xMin + CameraPaddingX
    clamped = true
  elseif pos.x > self.mapEdge.xMax - CameraPaddingX then
    pos.x = self.mapEdge.xMax - CameraPaddingX
    clamped = true
  end
  if pos.z < self.mapEdge.zMin + CameraPaddingZ then
    pos.z = self.mapEdge.zMin + CameraPaddingZ
    clamped = true
  elseif pos.z > self.mapEdge.zMax - CameraPaddingZ then
    pos.z = self.mapEdge.zMax - CameraPaddingZ
    clamped = true
  end
  if clamped then
    self.touchCamera:LookAt(pos)
  end
end

function BattleLevel:ResourceUpdatedSignal()
  self.triggerMgr:ResourceUpdatedSignal()
end

function BattleLevel:FactoryItemSignal()
  self.triggerMgr:FactoryItemSignal()
end

function BattleLevel:ResDropAnim(resType, startPos)
  if self.player == nil or self.player.carryRoot == nil then
    return
  end
  local prefabPath = Const.ResDropPrefabPath[resType]
  if prefabPath == nil then
    return
  end
  local delay = math.random() * 0.3
  TimerManager:GetInstance():DelayInvoke(function()
    local req = Resource:InstantiateAsync(prefabPath)
    req:completed("+", function()
      if req.isError or self.player == nil or IsNull(self.player:GetGameObject()) then
        req:Destroy()
        return
      end
      local x = (math.random() - 0.5) * 0.5
      local z = (math.random() - 0.5) * 0.5
      local pos = startPos + Vector3.New(x, 1, z)
      local move = req.gameObject:GetComponent(typeof(CS.RandMove))
      move:StartFly(pos, self.player.carryRoot.gameObject, function()
        req:Destroy()
      end)
    end)
  end, delay)
end

function BattleLevel:ChangeSkillNum(num)
  if self.uiPveMain ~= nil then
    self.uiPveMain:AddSkillSliderNum(num)
  end
end

function BattleLevel:GetTriggerBubble(triggerId)
  local trigger = self:GetTriggerByTriggerId(triggerId)
  if trigger ~= nil then
    return trigger:GetTriggerBubble()
  end
end

function BattleLevel:AutoShowEnergyPanel()
  if self.isAlreadyOpenEnergyPanel then
    return false
  end
  self.isAlreadyOpenEnergyPanel = true
  return true
end

function BattleLevel:GetSkillNum()
  if self.uiPveMain ~= nil then
    return self.uiPveMain:GetSkillSliderNum()
  end
  return 0
end

function BattleLevel:GetRewardFlyPos(rewardType)
  return FindRewardFlyPos(rewardType)
end

function BattleLevel:UnlockAreaFog(triggerId)
  self.fog:UnlockAreaFog(triggerId)
end

function BattleLevel:SetLockAreaFog(triggerId)
  self.fog:SetLockAreaFog(triggerId)
end

function BattleLevel:LoadLvPoint()
  return Setting:GetPrivateInt(SettingKeys.PVE_LV_POINT, 0)
end

function BattleLevel:SaveLvPoint(lvPoint)
  Setting:SetPrivateInt(SettingKeys.PVE_LV_POINT, lvPoint)
end

function BattleLevel:SetLvPoint(lvPoint)
  self.lvPoint = lvPoint
  if self.uiPveMain then
    self.uiPveMain:SetLvPoint(lvPoint)
  end
end

function BattleLevel:GetLvPoint()
  return self.lvPoint
end

function BattleLevel:GetGivenLvPoint()
  local count = 0
  for _, triggerId in ipairs(self.pveTemplate.triggerList) do
    local trigger = self:GetTriggerByTriggerId(triggerId)
    if trigger:IsTypeCommitLvPoint() and not trigger:IsFull() then
      count = count + trigger:GetCurLvPoint()
    end
  end
  return count
end

function BattleLevel:AddLvPoint(collectionData, num)
  self:SetLvPoint(self:GetLvPoint() + num)
  self:SaveLvPoint(self:GetLvPoint() + self:GetGivenLvPoint())
  local obj = collectionData:GetObj()
  if obj then
    local req = Resource:InstantiateAsync(UIAssets.CitySpaceManFlyText)
    req:completed("+", function(_)
      if req.isError then
        return
      end
      local flyNode = obj:GetFlyNode()
      if flyNode then
        local tf = req.gameObject.transform
        tf.position = flyNode.transform.position
        tf.rotation = self:GetCameraRotation()
        local numText = tf:Find("num"):GetComponent(typeof(CS.SuperTextMesh))
        numText.text = "+" .. num
        local spr = tf:Find("num/icon"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
        spr:LoadSprite(Const.LvPointIconPath)
      end
    end)
    TimerManager:GetInstance():DelayInvoke(function()
      req:Destroy()
    end, 0.8)
  end
end

function BattleLevel:SetTriggerMonsters(message)
  if message.triggerMonsters ~= nil then
    self.triggerMonsters = DeepCopy(message.triggerMonsters)
  end
end

function BattleLevel:GetMonsterDataByTriggerId(triggerId)
  for _, v in ipairs(self.triggerMonsters) do
    if v.id == triggerId then
      return v
    end
  end
  return nil
end

function BattleLevel:UpdateOneTriggerMonster(message)
  if message.triggerMonster ~= nil then
    local data = nilstateTxt
    for _, v in ipairs(self.triggerMonsters) do
      if v.id == message.triggerMonster.id then
        v.health = message.triggerMonster.health
        v.count = message.triggerMonster.count
        data = v
        break
      end
    end
    if data == nil then
      data = DeepCopy(message.triggerMonster)
      table.insert(self.triggerMonsters, data)
    end
    local triggerId = toInt(message.triggerMonster.id)
    local trigger = self:GetTriggerByTriggerId(triggerId)
    if trigger ~= nil then
      trigger:RefreshMonsterHp(data.health, data.initHealth)
    end
  end
end

function BattleLevel:GetMonsterEnergyCost(triggerId)
  local staminaStr = GetTableData(TableName.PVETrigger, tonumber(triggerId), "energy_cost")
  local vec = string.split(staminaStr, ";")
  local data = self:GetMonsterDataByTriggerId(triggerId)
  local index = 1
  if data ~= nil then
    index = data.count + 1
  end
  index = math.min(index, table.count(vec))
  return toInt(vec[index])
end

function BattleLevel:GetResetPosition()
  local lastSaveTriggerId = self.dbMgr:GetLastFinishTriggerId()
  if lastSaveTriggerId ~= nil then
    local trigger = self:GetTriggerByTriggerId(lastSaveTriggerId)
    if trigger ~= nil then
      local pos = trigger:GetPosition()
      if pos.x > 0 or 0 < pos.z then
        return pos
      end
    end
  end
  return SceneUtils.TileToWorld(self.pveTemplate.spawnPos)
end

function BattleLevel:SetSceneGameObjectActive(path, active)
  if self.sceneRoot == nil then
    return
  end
  local tf = self.sceneRoot:Find(path)
  if tf ~= nil then
    tf.gameObject:SetActive(active)
  end
end

function BattleLevel:GetSceneGameObject(path)
  if self.sceneRoot == nil then
    return nil
  end
  local tf = self.sceneRoot:Find(path)
  if tf ~= nil then
    return tf.gameObject
  end
  return nil
end

function BattleLevel:SetGuideMaxHeight(maxHeight)
  if self.saveCameraHeight == nil then
    self.saveCameraHeight = self.touchCamera.CamZoomMax
  end
  self.touchCamera.CamZoomMax = maxHeight
end

function BattleLevel:ResetGuideMaxHeight()
  if self.saveCameraHeight ~= nil then
    self.touchCamera.CamZoomMax = self.saveCameraHeight
    self.saveCameraHeight = nil
  end
end

function BattleLevel:DoReceivePVETriggerReward(triggerData)
  if triggerData == nil or not triggerData:ISCollectRewardMoreThanOneTime() then
    return
  end
  local param = {}
  param.trigger = triggerData.triggerId
  param.level = self.levelId
  param.costStamina = false
  param.x, param.y = self:GetOnePveDropRewardPosition(triggerData:GetPosition())
  SFSNetwork.SendMessage(MsgDefines.ReceivePVETriggerReward, param)
end

function BattleLevel:CanShowResetBtn()
  return false
end

function BattleLevel:GetFogType()
  return self.pveTemplate.fog_type
end

function BattleLevel:RemoveOneTriggerPlayerByPrefabNameAndPos(prefabName, pos)
  local count = table.count(self.playerGroup)
  for i = count, 1, -1 do
    if self.playerGroup[i].param.isTriggerGet and self.playerGroup[i].param.isNoGain and self.playerGroup[i].param.playerName == prefabName then
      local playerPos = self.playerGroup[i].param.originalPos
      if playerPos ~= nil and playerPos.x == pos.x and pos.z == playerPos.z then
        local temp = table.remove(self.playerGroup, i)
        temp:Destroy()
        self:RefreshTriggerPlayerPos()
        self:RefreshCarryResourceTextUI()
        return
      end
    end
  end
end

function BattleLevel:CreateTeleportBack(worldPos)
  self:DestroyTeleportBack()
  local req = Resource:InstantiateAsync("Assets/Main/Prefabs/PVELevel/TeleportBack.prefab")
  req:completed("+", function()
    if self.teleportBack == nil or self.teleportBack.request == nil then
      return
    end
    go = req.gameObject
    go:SetActive(true)
    go.name = Const.TeleportBackName
    go.transform.position = worldPos
    self.teleportBack:Create()
  end)
  self.teleportBack = require("Scene.PVEBattleLevel.TriggerPointTeleport").New(req)
end

function BattleLevel:DestroyTeleportBack()
  if self.teleportBack then
    self.teleportBack:Destroy()
  end
end

function BattleLevel:PveDropRewardAddSignal(uuid)
  if self.dropRewardMgr ~= nil then
    self.dropRewardMgr:PveDropRewardAddSignal(uuid)
  end
end

function BattleLevel:PveDropRewardRemoveSignal(uuid)
  if self.dropRewardMgr ~= nil then
    self.dropRewardMgr:PveDropRewardRemoveSignal(uuid)
  end
end

function BattleLevel:GetOnePveDropRewardPosition(pos)
  if self.dropRewardMgr ~= nil then
    return self.dropRewardMgr:GetOnePveDropRewardPosition(pos)
  end
end

function BattleLevel:GetResourceItemCountByResType(resType)
  return self.resRecordMgr:GetResourceItemCount(resType)
end

function BattleLevel:ChangeSubmitResourceItem(resourceType, num)
  self.resRecordMgr:ChangeSubmitResourceItem(resourceType, num)
end

function BattleLevel:ChangeCarryObjectNum(resType, num, pos)
  if self.player ~= nil then
    self.player:ChangeCarryObjectNum(resType, num, pos)
  end
end

function BattleLevel:GetAllCarryResourceItemList(result)
  if result == nil then
    result = {}
  end
  for k, v in ipairs(Const.CarryResourceItemOrder) do
    local num = self:GetResourceItemCountByResType(v)
    if 0 < num then
      table.insert(result, {resourceType = v, num = num})
    end
  end
  return result
end

function BattleLevel:PlayInterActAnim(animName, animTime, triggerId)
  if self.player ~= nil then
    return self.player:PlayInterActAnim(animName, triggerId, animTime)
  end
  return Const.PlayerInteractCode.InteractCode_Fail
end

function BattleLevel:TurnToPos(pos)
  if self.player ~= nil then
    self.player:TurnToPos(pos)
  end
end

function BattleLevel:GetArmyRecord()
  return self.armyRecord
end

function BattleLevel:UpdateArmyRecordHpBar(showChange)
  if self.armyRecord then
    self:SetPlayerHpBar(self.armyRecord.aliveCount, self.armyRecord.totalCount, showChange)
  end
end

function BattleLevel:UpdatePveBuffs(serverDataList)
  for _, serverData in ipairs(serverDataList) do
    local updated = false
    for i, data in ipairs(self.pveBuffs) do
      if data.uuid == serverData.uuid then
        self.pveBuffs[i] = serverData
        updated = true
        break
      end
    end
    if not updated then
      table.insert(self.pveBuffs, serverData)
    end
  end
  self.heroMgr:UpdateHiredHeroes(self.pveBuffs)
  EventManager:GetInstance():Broadcast(EventId.PveBattleBuffRefresh)
end

function BattleLevel:GetPveHeroData(heroUuid)
  local heroData
  heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
  if heroData ~= nil then
    return heroData
  end
  heroData = self.heroMgr:GetHiredHeroByUuid(heroUuid)
  if heroData ~= nil then
    return heroData
  end
  if DataCenter.LWBattleManager.logic and DataCenter.LWBattleManager.logic.GetTeamHeroByUuid then
    heroData = DataCenter.LWBattleManager.logic:GetTeamHeroByUuid(heroUuid)
  end
  return heroData
end

function BattleLevel:HireHeroByTrigger(trigger, heroData)
  local heroName = string.format("<color='%s'>%s</color>", HeroUtils.GetRarityColorStr(heroData.rarity), Localization:GetString(heroData.name))
  UIUtil.ShowSingleTip(Localization:GetString("339004", heroData.level, heroName))
  SFSNetwork.SendMessage(MsgDefines.ChoosePveBuff, self.levelId, trigger.config.triggerId, 1)
  self:DoTrigger(trigger)
end

function BattleLevel:GetBattleBuffById(id)
  for _, v in ipairs(self.pveBuffs) do
    if v.bId == id then
      return v
    end
  end
  return nil
end

function BattleLevel:GetBattleBuffList()
  local list = {}
  for _, v in ipairs(self.selectBattleBuffList) do
    table.insert(list, v)
  end
  for _, v in ipairs(self.pveBuffs) do
    table.insert(list, v)
  end
  return list
end

function BattleLevel:CanHealArmy()
  return self.armyRecord and self.armyRecord.aliveCount < self.armyRecord.totalCount
end

function BattleLevel:TryGainArmyByTrigger(param)
  local cur = DataCenter.ArmyManager:GetTotalArmyNum()
  local max = DataCenter.ArmyManager:GetArmyNumMax()
  if cur >= max then
    local tip = Localization:GetString("140305")
    UIUtil.ShowMessage(tip, 2, GameDialogDefine.GOTO, GameDialogDefine.CANCEL, function()
      self:Exit(function()
        GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_BARRACKS, WorldTileBtnType.City_Upgrade)
      end)
    end)
  elseif max < cur + param.count then
    local tip = Localization:GetString("339011", cur + param.count, max)
    UIUtil.ShowMessage(tip, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.PayTriggerResItem, param)
    end)
  else
    SFSNetwork.SendMessage(MsgDefines.PayTriggerResItem, param)
  end
end

function BattleLevel:HandleDropMessage(message, flyWorldPos)
  local dropItem = message.dropItem
  if dropItem ~= nil then
    local uuid = dropItem.uuid
    if flyWorldPos == nil or uuid == nil then
      DataCenter.PveDropRewardInfoManager:AddOneDropRewardInfo(dropItem, false)
    else
      DataCenter.PveDropRewardInfoManager:AddOneDropRewardInfo(dropItem, true)
      self.dropRewardMgr:FlyDropReward(uuid, flyWorldPos)
    end
  end
end

function BattleLevel:CreateTeleportEffect(pos)
  local req = Resource:InstantiateAsync(UIAssets.PveHeroSummon)
  req:completed("+", function()
    if req.isError or IsNull(req.gameObject) then
      req:Destroy()
      return
    end
    local go = req.gameObject
    go:SetActive(true)
    local tf = go.transform
    tf.position = pos + Vector3.New(0, 3.53, 0)
    TimerManager:GetInstance():DelayInvoke(function()
      if req ~= nil then
        req:Destroy()
      end
    end, 2)
  end)
  return req
end

function BattleLevel:OnFinish()
  if self.pveTemplate.type == PveLevelType.HeroExpLevel then
    self:SaveLvPoint(0)
  elseif self.pveTemplate.type == PveLevelType.AdventureLevel then
    DataCenter.AdventureManager:OnLevelFinish()
  end
  DataCenter.LandLockManager:OnFinishPve(self.levelId)
  self.resRecordMgr:ClearMaxTipTries()
end

function BattleLevel:IsUseMoveY()
  return self.pveTemplate:IsUseMoveY()
end

function BattleLevel:AddOneSpecialTriggers(triggerInfo)
  self.specialTriggers[triggerInfo.id] = triggerInfo
end

function BattleLevel:HaveSpecialTriggers(id)
  return self:GetSpecialTriggerInfo(id) ~= nil
end

function BattleLevel:GetSpecialTriggerInfo(id)
  return self.specialTriggers[id]
end

return BattleLevel
