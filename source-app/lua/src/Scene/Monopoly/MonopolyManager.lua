local MonopolyManager = BaseClass("MonopolyManager", CEventable)
local BlankObstacle = require("Scene.Monopoly.Obstacle.BlankObstacle")
local EmigratedObstacle = require("Scene.Monopoly.Obstacle.EmigratedObstacle")
local PickBoxObstacle = require("Scene.Monopoly.Obstacle.PickBoxObstacle")
local ParkourObstacle = require("Scene.Monopoly.Obstacle.ParkourObstacle")
local SkyBattleObstacle = require("Scene.Monopoly.Obstacle.SkyBattleObstacle")
local CountMastersObstacle = require("Scene.Monopoly.Obstacle.CountMastersObstacle")
local DigTreasureObstacle = require("Scene.Monopoly.Obstacle.DigTreasureObstacle")
local LandRewardObj = require("Scene.Monopoly.Placeality.LandRewardObject")
local player = require("Scene.Monopoly.Player")
local V2NPC = require("Scene.Monopoly.V2NPC")
local MonopolyMapDataManager = require("Scene.Monopoly.Data.MonopolyMapDataManager")
local MapDecorate = require("Scene.Monopoly.Placeality.MapDecorate")
local MapDecorateEvent = require("Scene.Monopoly.Placeality.MapDecorateEvent")
local RewardUtil = require("Util.RewardUtil")
local effectMgr = require("Scene.Monopoly.Effect.EffectManager")
local Const = require("Scene.Monopoly.Const")
local MonopolyPerformanceManager = require("Scene.Monopoly.Performance.MonopolyPerformanceManager")
local GameObject = CS.UnityEngine.GameObject
local Resource = CS.GameEntry.Resource
local ClassType = {
  [MonopolyEventType.blank] = BlankObstacle,
  [MonopolyEventType.Parkour] = ParkourObstacle,
  [MonopolyEventType.Emigrated] = EmigratedObstacle,
  [MonopolyEventType.PickBox] = PickBoxObstacle,
  [MonopolyEventType.CountMasters] = CountMastersObstacle,
  [MonopolyEventType.DigTreasure] = DigTreasureObstacle,
  [MonopolyEventType.SkyBattle] = SkyBattleObstacle
}
local LookBubbleGuide = 1115

function MonopolyManager:__init()
  self.mapDic = {}
  self.decorateMap = {}
  self.decorateEventMap = {}
  self.delayList = {}
  self.rewardModelList = {}
  self.player = {}
  self.v2npc = {}
  self.player.curId = 0
  self.effectMgr = effectMgr:New()
  self.dataManager = MonopolyMapDataManager:New()
  self.sBattle = CommonUtil.PlayerPrefsGetBool("MonopolySBattle", false)
  self.isUnlockV2 = 0
  self.monopoly_camera_setting = nil
  self.hideBattleEff = nil
  self.performanceManager = MonopolyPerformanceManager.New()
  self:AddListeners()
end

function MonopolyManager:__delete()
  self:DeleteAllModel()
  self.effectMgr:Delete()
  self.dataManager:Delete()
  self.mapDic = nil
  self.obstcleDic = nil
  self.decorateMap = nil
  self.decorateEventMap = nil
  self.delayList = nil
  self.rewardModelList = nil
  self.player = nil
  self.v2npc = nil
  self.parent = nil
  self.sBattle = nil
  self.isUnlockV2 = nil
  if self.delaySBattle then
    self.delaySBattle:Stop()
    self.delaySBattle = nil
  end
  self.monopoly_camera_setting = nil
  self.hideBattleEff = nil
  self:ClearArrowTimer()
  self:ClearArrowEff()
  self:ClearAllDelayTimers()
  self:SetSpontaneousBattle(false)
  self:RemoveListeners()
end

function MonopolyManager:AddListeners()
  EventManager:GetInstance():AddListener(EventId.BeforeReleaseCity, self.BeforeReleaseCity)
  EventManager:GetInstance():AddListener(EventId.PveLevelEnter, self.BeforeReleaseCity)
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.OnEnterCity)
  EventManager:GetInstance():AddListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
  EventManager:GetInstance():AddListener(EventId.PlotViewClosedAbnormally, self.OnPlotGroupDone)
  EventManager:GetInstance():AddListener(EventId.LWBarrageBattleEnd, self.OnBarrageEnd)
  EventManager:GetInstance():AddListener(EventId.ParkourBattleWin, self.ParkourBattleWin)
  EventManager:GetInstance():AddListener(EventId.SkyBattleWin, self.ParkourBattleWin)
  EventManager:GetInstance():AddListener(EventId.GF_guide_done, self.InitPlayer)
  EventManager:GetInstance():AddListener(EventId.GF_count_battle_win, self.OnCountBattleWin)
  EventManager:GetInstance():AddListener(EventId.BuildUpgradeFinish, self.OnBuildUpgradeFinish)
  EventManager:GetInstance():AddListener(EventId.GF_parkour_battle_lose, self.ParkourBattleLose)
  EventManager:GetInstance():AddListener(EventId.GF_count_battle_lose, self.OnCountBattleLose)
  EventManager:GetInstance():AddListener(EventId.GF_pve_battle_exit, self.OnPVEBattleExit)
  EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.BeforeReleaseCity)
  EventManager:GetInstance():AddListener(EventId.MainLvUp, self.OnMainLvUp)
  EventManager:GetInstance():AddListener(EventId.OnRewardGetPanelClose, self.OnRewardGetPanelClose)
end

function MonopolyManager:RemoveListeners()
  EventManager:GetInstance():RemoveListener(EventId.BeforeReleaseCity, self.BeforeReleaseCity)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.OnEnterCity)
  EventManager:GetInstance():RemoveListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
  EventManager:GetInstance():RemoveListener(EventId.PlotViewClosedAbnormally, self.OnPlotGroupDone)
  EventManager:GetInstance():RemoveListener(EventId.LWBarrageBattleEnd, self.OnBarrageEnd)
  EventManager:GetInstance():RemoveListener(EventId.ParkourBattleWin, self.ParkourBattleWin)
  EventManager:GetInstance():RemoveListener(EventId.SkyBattleWin, self.ParkourBattleWin)
  EventManager:GetInstance():RemoveListener(EventId.GF_guide_done, self.InitPlayer)
  EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, self.BeforeReleaseCity)
  EventManager:GetInstance():RemoveListener(EventId.GF_count_battle_win, self.OnCountBattleWin)
  EventManager:GetInstance():RemoveListener(EventId.GF_parkour_battle_lose, self.ParkourBattleLose)
  EventManager:GetInstance():RemoveListener(EventId.GF_count_battle_lose, self.OnCountBattleLose)
  EventManager:GetInstance():RemoveListener(EventId.GF_pve_battle_exit, self.OnPVEBattleExit)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.BeforeReleaseCity)
  EventManager:GetInstance():RemoveListener(EventId.MainLvUp, self.OnMainLvUp)
  EventManager:GetInstance():RemoveListener(EventId.OnRewardGetPanelClose, self.OnRewardGetPanelClose)
end

function MonopolyManager:OnEnterGame()
  if SceneUtils.GetIsInCity() then
    self:TryMoveCameraEnterCity()
    self:TryObstacleVisibleGuide()
    DataCenter.MonopolyManager:CreateArrowEff()
  end
end

function MonopolyManager.OnBarrageEnd(message)
  local self = DataCenter.MonopolyManager
  local data = self.dataManager:GetCurData()
  if data and tonumber(data.type_para) == message.stageId then
    if message.isWin == false then
      self.dataManager:SetIsLose(true)
    else
      self:UnLockCurMonopolyAndSave()
    end
  end
end

function MonopolyManager:UnLockCurMonopolyAndSave()
  local data = self.dataManager:GetCurData()
  if not data then
    return
  end
  local unlockIds = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getSkipUnlockIds(self.player.curId, data.skip_id)
  self:SendMonoPolyRecordMessage(unlockIds)
end

function MonopolyManager.WindowClosed(uiname)
end

function MonopolyManager.InitPlayer(id)
  local self = DataCenter.MonopolyManager
  if id == DataCenter.LWCivilizationSparkExtend:MonopolyManager_getInitPlayerGuideId() then
    local pos = self.mapDic[self.player.curId].obstacle.data:GetCenterWorldPos()
    GoToUtil.GotoPos(pos, CS.SceneManager.World.InitZoom, 0.5, function()
      self:ShowPlayer(true)
      self:ShowObstacleByLandLockId(self.mapDic[self.player.curId].obstacle.data.land_lock, true)
      self:ShowObstacle()
    end)
  end
end

function MonopolyManager.OnGuideCancel(id)
end

function MonopolyManager:CreateArrowEff()
  if self.arrowEffs == nil then
    self.arrowEffs = {}
    self.arrowEffReq = Resource:InstantiateAsync("Assets/_Art_LastWar/Effect/Prefab/dafuw_newbies/Eff_dafuw_dige_jiantou.prefab")
    self.arrowEffReq:completed("+", function(req)
      if req.isError then
        return
      end
      if self.arrowEffs then
        if self.parent then
          req.gameObject.transform:SetParent(self.parent.transform)
        end
        for i = 1, 5 do
          local arrow = CS.UnityEngine.GameObject.Instantiate(req.gameObject)
          if self.parent then
            arrow.gameObject.transform:SetParent(self.parent.transform)
          end
          table.insert(self.arrowEffs, arrow)
        end
        req.gameObject:SetActive(false)
      end
    end)
  end
end

function MonopolyManager:ClearArrowEff()
  if self.arrowEffs then
    for i = 1, #self.arrowEffs do
      CS.UnityEngine.GameObject.Destroy(self.arrowEffs[i].gameObject)
      self.arrowEffs[i] = nil
    end
    self.arrowEffs = nil
  end
  if self.arrowEffReq then
    self.arrowEffReq:Destroy()
    self.arrowEffReq = nil
  end
end

function MonopolyManager:ClearArrowTimer()
  if self.arrowEffTimer then
    self.arrowEffTimer:Stop()
    self.arrowEffTimer = nil
  end
  if self.arrowEffSeq then
    self.arrowEffSeq:Kill()
    self.arrowEffSeq = nil
  end
end

function MonopolyManager:ShowBattleEffect()
end

function MonopolyManager:HideBattleEffect()
end

function MonopolyManager:StartLoopArrowEffs()
  if self.arrowEffTimer ~= nil then
    self.arrowEffTimer:Stop()
    self.arrowEffTimer = nil
  end
  self:PlayArrowEffs()
  self.arrowEffTimer = TimerManager:GetInstance():GetTimer(4.8, function()
    self:PlayArrowEffs()
  end, false, false, false)
  self.arrowEffTimer:Start()
end

function MonopolyManager:PlayArrowEffs()
  if self.mapDic ~= nil then
    local curEffIndex = self.player.curId - 1
    if self.arrowEffSeq then
      self.arrowEffSeq:Kill()
      self.arrowEffSeq = nil
    end
    self.arrowEffSeq = CS.DG.Tweening.DOTween.Sequence()
    for i = curEffIndex, curEffIndex + 20 do
      if i == #self.mapDic then
        break
      end
      local nextPos
      if i < #self.mapDic then
        local next = self.mapDic[i + 1]
        if next and next.obstacle and next.obstacle.placeality then
          nextPos = next.obstacle.placeality.data:GetCenterWorldPos()
        end
      end
      local info = self.mapDic[i]
      if nextPos ~= nil and info and info.obstacle and info.obstacle.placeality then
        self.arrowEffSeq:AppendInterval(0.1)
        self.arrowEffSeq:AppendCallback(function()
          if self.arrowEffs and #self.arrowEffs > 0 then
            local first = table.remove(self.arrowEffs, 1)
            if self.parent and first.transform.parent ~= self.parent.transform then
              first.transform:SetParent(self.parent.transform)
            end
            local pos = info.obstacle.placeality.data:GetCenterWorldPos()
            first.transform:Set_position(pos.x, pos.y, pos.z)
            first.transform:LookAt(nextPos)
            if self.hideBattleEff == nil then
              first.gameObject:SetActive(false)
              first.gameObject:SetActive(true)
            end
            table.insert(self.arrowEffs, first)
          end
        end)
      end
    end
  end
end

function MonopolyManager:ClearUnlockSeq()
  if self.unlockSeq then
    self.unlockSeq:Kill()
    self.unlockSeq = nil
  end
end

function MonopolyManager:TryShowObstacle(id)
  local info = self.mapDic[id]
  if info and info.obstacle then
    info.obstacle:ShowObstacleByType(MonplolyObstacleShowCondition.Every, true, true)
  end
end

function MonopolyManager.OnMainLvUp()
  DataCenter.MonopolyManager:TryShowObstacleByMainLv()
end

function MonopolyManager:TryShowObstacleByMainLv()
  for _, info in pairs(self.mapDic) do
    if info and info.obstacle then
      info.obstacle:ShowObstacleByType(MonplolyObstacleShowCondition.Every, false, false)
    end
  end
end

function MonopolyManager:TryShowObstacleByArriveGrid(monopolyPlacealityId)
  for _, info in pairs(self.mapDic) do
    if info and info.obstacle and info.obstacle.data and info.obstacle.data.show_condition_param == monopolyPlacealityId then
      info.obstacle:ShowObstacleByType(MonplolyObstacleShowCondition.ArriveGrid, false, false, true)
    end
  end
end

function MonopolyManager:TryShowObstacleByPlayerGo(monopolyPlacealityId)
  for _, info in pairs(self.mapDic) do
    if info and info.obstacle and info.obstacle.data and info.obstacle.data.show_condition_param == monopolyPlacealityId then
      info.obstacle:ShowObstacleByType(MonplolyObstacleShowCondition.PlayerGo, false, false, true)
    end
  end
end

function MonopolyManager:TryUnlock()
  self:ShowObstacle(true)
end

function MonopolyManager:ShowObstacle(isShow)
  for i, info in pairs(self.mapDic) do
    if info and info.obstacle then
      info.obstacle:ShowObstacleByType(MonplolyObstacleShowCondition.Every, isShow)
    end
  end
end

function MonopolyManager:SetAllObstableRelatedAppearanceVisible(visible, onlyModel)
  for i, info in pairs(self.mapDic) do
    if info and info.obstacle then
      info.obstacle:SetObstableRelatedAppearanceVisible(visible, onlyModel)
    end
  end
end

function MonopolyManager:SetTargetObstableRelatedAppearanceVisible(monopolyId, visible, onlyModel)
  if self.mapDic[monopolyId] and self.mapDic[monopolyId].obstacle then
    self.mapDic[monopolyId].obstacle:SetObstableRelatedAppearanceVisible(visible, onlyModel)
  end
end

function MonopolyManager.OnPVEBattleExit(para)
  local id = para.id or 0
  local type = para.type
  local self = DataCenter.MonopolyManager
  local data = self.dataManager:GetCurData()
  if data and tonumber(data.type_para) == id and type and (type == "quit" or type == PveExitType.ExitBtn) then
    self.dataManager:SetIsExit(true)
  end
end

function MonopolyManager.ParkourBattleWin(id)
  local self = DataCenter.MonopolyManager
  local data = self.dataManager:GetCurData()
  if data and tonumber(data.type_para) == id then
    local rankStageId = data.rankStageId
    if 0 < rankStageId then
      local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), rankStageId)
      if line then
        local defaultHero = LocalController:instance():getStrValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), id, "default_hero")
        local checkFormation
        if not string.IsNullOrEmpty(defaultHero) then
          checkFormation = false
        end
        SFSNetwork.SendMessage(MsgDefines.PlayerStageInfoMessage, line.group, rankStageId, true, 1, {}, {}, checkFormation)
      end
    end
    self:UnLockCurMonopolyAndSave()
  end
end

function MonopolyManager.ParkourBattleLose(id)
  local self = DataCenter.MonopolyManager
  local data = self.dataManager:GetCurData()
  if data and tonumber(data.type_para) == id then
    self.dataManager:SetIsLose(true)
  end
end

function MonopolyManager.OnCountBattleWin(id)
  local self = DataCenter.MonopolyManager
  local data = self.dataManager:GetCurData()
  if data and tonumber(data.type_para) == id then
    local rankStageId = data.rankStageId
    if 0 < rankStageId then
      local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), rankStageId)
      if line then
        SFSNetwork.SendMessage(MsgDefines.PlayerStageInfoMessage, line.group, rankStageId, true, 1, {}, {})
      end
    end
    self:UnLockCurMonopolyAndSave()
  end
end

function MonopolyManager.OnCountBattleLose(id)
  local self = DataCenter.MonopolyManager
  local data = self.dataManager:GetCurData()
  if data and tonumber(data.type_para) == id then
    self.dataManager:SetIsLose(true)
  end
end

function MonopolyManager.OnBuildUpgradeFinish(bUuid)
  local self = DataCenter.MonopolyManager
  local model
  if self.mapDic[self.player.curId] then
    model = self.mapDic[self.player.curId].obstacle
  end
  if model then
    model:RefreshBubble()
  end
end

function MonopolyManager:OnMonopolyV2UnlockUpdate(isInit)
  local isUnlockV2 = self:GetV2UnlockData() == 1
  if isUnlockV2 then
    if self.v2npc.model then
      self.v2npc.model:Delete()
      self.v2npc.model = nil
    end
    if SceneUtils.GetIsInCity() then
      DataCenter.MonopolyManager:InitMap()
      DataCenter.MonopolyManager:ShowPlayer()
    end
  end
end

function MonopolyManager.OnPlotGroupDone(plotGroupId)
  local self = DataCenter.MonopolyManager
  local v2PlotId = LuaEntry.DataConfig:TryGetNum("city_land_unlock_v2", "k5", 0)
  if plotGroupId == v2PlotId then
    DataCenter.CityZoneMgr.cityZoneFog:UnLockFour()
  end
  if not DataCenter.LWCivilizationSparkExtend:MonopolyManager_curIdIsOpen(self.player.curId) then
    return
  end
  local model
  if self.mapDic[self.player.curId] then
    model = self.mapDic[self.player.curId].obstacle
  end
  if model then
    if model.data.plot_before == plotGroupId then
      model:Fire()
    elseif tonumber(model.data.plot_after) == plotGroupId then
      self:PlayerGo()
    end
  end
end

function MonopolyManager:End()
  local lastId = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getPreId(self.player.curId)
  local lastData = self.mapDic[lastId].obstacle.data
  if lastData then
    if self.player.model then
      self.player.model:Delete()
      self.player.model = nil
      EventManager:GetInstance():Broadcast(EventId.MonopolyPlayerEnd)
    end
    local data = DataCenter.LandLockManager:GetLandLockDataById(lastData.land_lock)
    local pointId = data:GetPointId()
    if pointId then
      self:UnLandlock(lastData.land_lock)
    end
  end
end

function MonopolyManager:PlayerGo()
  local data, isEnd = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getPlacealityData(self.player.curId, self.mapDic)
  self.player.model:OnPlacealityChangeState(data, isEnd)
  self:TryShowObstacleByPlayerGo(data.id)
  self.performanceManager:RunTrigger(MonopolyPerformanceTriggerEvent.MonopolyGoto, data.id)
end

function MonopolyManager:GetNextData()
  local data, isEnd = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getPlacealityData(self.player.curId, self.mapDic)
  return data, isEnd
end

function MonopolyManager:ChangeData()
  local model = self.mapDic[self.player.curId].obstacle
  model.data.state = MonopolyPlacealityType.Occupy
  model:ChangeState(MonopolyPlacealityType.Occupy)
  if self.messageId == nil then
    Logger.LogError("error!! monopoly messageId is null curId = " .. self.player.curId)
    self.messageId = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getNextId(self.player.curId)
  end
  local isArriveOldMonopolyEnd = self.player.curId >= self:GetV1LastMonopolyId() and not self:IsMeetMonopolyV2Conditions()
  if DataCenter.LWCivilizationSparkExtend:MonopolyManager_curGreaterEqualCount(self.player.curId) or isArriveOldMonopolyEnd and self:GetV2UnlockData() == 0 then
    self:End()
    self.player.curId = self.messageId
    return
  end
  self.player.curId = self.messageId
  local curInfo = self.mapDic[self.player.curId]
  local lastId = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getPreId(self.player.curId)
  local lastInfo = self.mapDic[lastId]
  curInfo.obstacle.data.state = MonopolyPlacealityType.Arrive
  curInfo.obstacle:ChangeState(MonopolyPlacealityType.Arrive)
  self.dataManager.curId = self.player.curId
  self:ChangeState(MonopolyPlacealityType.Arrive)
  if lastInfo and lastInfo.obstacle then
    local preId = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getPreId(model.data.id)
    if preId ~= self:GetV1LastMonopolyId() then
      if self.mapDic[preId] == nil or self.mapDic[preId].obstacle == nil then
        Logger.LogError("error!! monopoly lastInfo is null errorId = " .. preId)
      end
      local lastData = self.mapDic[preId].obstacle.data
      if lastData.land_lock ~= model.data.land_lock then
        local data = DataCenter.LandLockManager:GetLandLockDataById(lastData.land_lock)
        if data then
          local pointId = data:GetPointId()
          if pointId then
            self:UnLandlock(lastData.land_lock)
          end
        end
      end
      if lastInfo.obstacle.data.land_lock ~= curInfo.obstacle.data.land_lock then
        self:ShowObstacleByLandLockId(curInfo.obstacle.data.land_lock, false)
      end
    end
  end
  if self.messageId == Const.threeFogId then
    DataCenter.CityZoneMgr.cityZoneFog:UnLockThree()
  end
  if self.messageId == DataCenter.LWMyStationDataManager:GET_TRAIN_FOG_ID() then
    DataCenter.CityZoneMgr.cityZoneFog:UnLockTrain()
    DataCenter.LWMyStationDataManager:TryGetMyStationData()
    DataCenter.LWAllyStationDataManager:TryGetAllyStationData()
  end
  local nextId = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getNextId(DataCenter.ActDispatchTaskDataManager:GetUnlockMonopolyId())
  if self.messageId == nextId then
    DataCenter.CityZoneMgr.cityZoneFog:UnlockDispatchTask()
    DataCenter.ActDispatchTaskDataManager:Unlock()
  end
  EventManager:GetInstance():Broadcast(EventId.GF_monopoly_new_grid_arrived, self.player.curId)
  self:ActiveEffectNode(model.data.land_lock)
  self:TryShowObstacleByArriveGrid(self.player.curId)
  self.performanceManager:RunTrigger(MonopolyPerformanceTriggerEvent.MonopolyArrived, self.player.curId)
  if self.player.curId <= self.maxUnlockEndId then
    self.messageId = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getNextId(self.messageId)
    self:DoCurEventEnd()
  else
    self:ShowReward(lastInfo.obstacle)
    if self.player.model then
      self.player.model:SetPlayerState(MonoPolyPlayerState.Normal)
    end
  end
end

local ExRange = 1

function MonopolyManager:ActiveEffectNode(curLandLock)
  local curLandId = curLandLock
  for i = 0, ExRange do
    if 0 < i then
      curLandId = DataCenter.LWCivilizationSparkExtend:LandLockManager_getNextLandId(curLandId)
    end
    local list = self.dataManager:GetPlacealityIdListByLandlockId(curLandId)
    if list then
      for k, v in pairs(list) do
        local data = self.mapDic[v]
        if data then
          local obs = data.obstacle
          if obs and not IsNull(obs.effectNode) then
            obs.effectNode.gameObject:SetActive(true)
          end
        end
      end
    end
    local decList = self.dataManager:GetDecorateListByLandLockId(curLandId)
    if decList then
      for k, v in pairs(decList) do
        local dec = self.decorateMap[v]
        if dec and not IsNull(dec.effectNode) then
          dec.effectNode.gameObject:SetActive(true)
        end
      end
    end
  end
end

function MonopolyManager:ShowReward(model)
  local reward = self.dataManager:GetRewardById(model.data.id)
  
  local function func()
    self.delaySBattle = nil
    self.delaySBattle = TimerManager:GetInstance():DelayInvoke(function()
      if self.sBattle then
        local curInfo = self.mapDic[self.player.curId]
        if curInfo == nil or curInfo.obstacle == nil then
          Logger.LogError("error!!Sbattle stop! monopoly sBattle curInfo isNull curInfoId = " .. self.player.curId)
        else
          curInfo.obstacle:SBattleFire()
        end
        self.delaySBattle = nil
      end
    end, 1)
    self:TryBornDecorateEventAfterReward()
    if reward then
      EventManager:GetInstance():Broadcast(EventId.GF_monopoly_reward_done, model.data.id)
    end
  end
  
  if reward then
    if self.sBattle then
      self.delaySBattle = TimerManager:GetInstance():DelayInvoke(function()
        UIManager.Instance:DestroyWindow(UIWindowNames.UIGiftPackageRewardGet)
        self.delaySBattle = nil
      end, 1)
    end
    DataCenter.RewardManager:ShowCommonReward({reward = reward}, nil, nil, nil, nil, nil, func)
    DataCenter.RewardManager:AddRewards(reward)
  else
    func()
  end
end

function MonopolyManager:UnLandlock(id)
  local list = self.dataManager:GetPlacealityIdListByLandlockId(id)
  local lastObstacleRotateClipLength = 0
  local time = 0.01
  for i = 1, #list do
    if i ~= 1 then
      time = i - 1
    end
    if i == #list then
      lastObstacleRotateClipLength = self.mapDic[list[i]].obstacle:GetRotateClipLength()
    end
    local delay = TimerManager:GetInstance():DelayInvoke(function()
      if self.mapDic and list and self.mapDic[list[i]] and self.mapDic[list[i]].obstacle and self.mapDic[list[i]].obstacle.data then
        GoToUtil.GotoPos(self.mapDic[list[i]].obstacle.data:GetCenterWorldPos(), CS.SceneManager.World.InitZoom, 0.1)
        self.mapDic[list[i]].obstacle:UnLandLock(nil)
        self:PlayLandUnlockSound()
      end
    end, time * Const.rotatePlacealityDelay)
    table.insert(self.delayList, delay)
  end
  local totalDelayTime = math.max(0.01, (#list - 1) * Const.rotatePlacealityDelay) + lastObstacleRotateClipLength
  table.insert(self.delayList, TimerManager:GetInstance():DelayInvoke(function()
    self:UnLandLockCallBack(id)
  end, totalDelayTime))
end

function MonopolyManager:ShowObstacleByLandLockId(id, bornDecorateEvent)
  local list = self.dataManager:GetPlacealityIdListByLandlockId(id)
  for i = 1, #list do
    if self.mapDic[list[i]] and self.mapDic[list[i]].obstacle then
      self.mapDic[list[i]].obstacle:LandLockObstacleShow()
    end
  end
  if bornDecorateEvent then
    self:BornDecorateEventByLandId(id)
  end
end

function MonopolyManager:TryBornDecorateEventAfterReward()
  if self.mapDic == nil then
    return
  end
  if self.player == nil then
    return
  end
  local data = self.mapDic[self.player.curId]
  if data == nil then
    return
  end
  local model = data.obstacle
  if model == nil then
    return
  end
  local curInfo = self.mapDic[self.player.curId]
  local lastId = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getPreId(self.player.curId)
  local lastInfo = self.mapDic[lastId]
  if lastInfo and lastInfo.obstacle and model.data.id - 1 ~= self:GetV1LastMonopolyId() and lastInfo.obstacle.data.land_lock ~= curInfo.obstacle.data.land_lock then
    self:BornDecorateEventByLandId(curInfo.obstacle.data.land_lock)
  end
end

function MonopolyManager:BornDecorateEventByLandId(id)
  if self.decorateEventMap then
    for _, v in pairs(self.decorateEventMap) do
      v:OnBorn(id)
    end
  end
  DataCenter.CityZoneMgr:RefreshMonopolyLandBaseFog()
end

function MonopolyManager:UnLandLockCallBack(id)
  local list = self.dataManager:GetDecorateListByLandLockId(id)
  if list ~= nil then
    for i = 1, #list do
      if self.decorateMap[list[i]] then
        self.decorateMap[list[i]]:Delete()
      end
    end
  end
  self:CreateLandRewardObj(id)
  self.performanceManager:RunTrigger(MonopolyPerformanceTriggerEvent.UnLandLockBorn, id)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Env_NewArea_Pre, false)
end

function MonopolyManager:CreateLandRewardObj(id)
  local reward = LandRewardObj.New(self)
  reward:Init(id)
  self.rewardModelList[id] = reward
  local list = self.dataManager:GetDecorateListByLandLockId(id)
  if list ~= nil then
    for i = 1, #list do
      if self.decorateEventMap[list[i]] then
        self.decorateEventMap[list[i]]:OnUnLandLock()
      end
    end
  end
  for key, value in pairs(self.decorateEventMap) do
    value:OnBornAfter()
  end
end

function MonopolyManager:GetLandRewardObj(id)
  if self.rewardModelList then
    return self.rewardModelList[id]
  end
  return nil
end

function MonopolyManager:GetMinLandRewardObj()
  local id, obj
  if self.rewardModelList then
    for i, v in pairs(self.rewardModelList) do
      local curOnj = v.gameObject
      if curOnj ~= nil and (id == nil or DataCenter.LWCivilizationSparkExtend:MonopolyManager_getLandLockIdDiff(i, id) < 0) then
        id = i
        obj = curOnj
      end
    end
  end
  return obj
end

function MonopolyManager:DeleteLandDecorateEvent(id)
  local list = self.dataManager:GetDecorateListByLandLockId(id)
  if list ~= nil then
    for i = 1, #list do
      if self.decorateEventMap[list[i]] then
        self.decorateEventMap[list[i]]:Delete()
      end
    end
  end
end

function MonopolyManager:EventEndShow()
  self.mapDic[self.player.curId].obstacle:OnEventEnd()
end

function MonopolyManager:ChangeState(state)
  DataCenter.MonopolyManager.dataManager:ChangeDataState(state)
end

function MonopolyManager:RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.BeforeReleaseCity, self.BeforeReleaseCity)
end

function MonopolyManager.BeforeReleaseCity()
  DataCenter.MonopolyManager:DeleteAllModel()
  DataCenter.MonopolyManager.effectMgr:Destroy()
  DataCenter.MonopolyManager:ClearArrowTimer()
  DataCenter.MonopolyManager:ClearArrowEff()
  DataCenter.MonopolyManager:ClearAllDelayTimers()
end

function MonopolyManager.OnEnterCity()
  DataCenter.MonopolyManager:InitMap()
  if not DataCenter.MonopolyManager:CheckObstacleVisible() then
    return
  end
  DataCenter.MonopolyManager:ShowPlayer()
  DataCenter.MonopolyManager:CreateArrowEff()
end

function MonopolyManager:InitData(message)
  self.dataManager:InitData()
  local isInCity = SceneUtils.GetIsInCity()
  if DataCenter.LWGuideManager:GetCurGuideId() == GuideState.LevelOne then
    return
  end
  if message.monopoly_v2_unlock then
    self:SetV2UnlockData(message, true)
  end
  if message.monopolyStageInfo then
    local nextId = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getNextId(message.monopolyStageInfo.stageId)
    self.player.curId = nextId
    self.dataManager:SetCurId(self.player.curId)
    if isInCity then
      self:InitMap(true)
      if not DataCenter.MonopolyManager:CheckObstacleVisible() then
        return
      end
      self:ShowPlayer(false, true)
    end
  else
    self:SendInitMessage()
    if isInCity then
      self:InitMap()
    end
  end
end

function MonopolyManager:SendInitMessage()
  local isOpen = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_MONOPOLY_FUNCTION_OPEN)
  if 1 <= isOpen then
    local id = self.dataManager:GetInitPlacealityId()
    if id == DataCenter.LWCivilizationSparkExtend:MonopolyManager_getInitPlacealityId() and self.player.curId == 0 then
      self:SendMonoPolyRecordMessage({id})
    end
  end
end

function MonopolyManager:SendMonoPolyRecordMessage(params)
  SFSNetwork.SendMessage(MsgDefines.SaveMonopolyRecord, params)
end

function MonopolyManager:DoCurEventEnd()
  local curId = self.player.curId
  if curId and DataCenter.LWCivilizationSparkExtend:MonopolyManager_getCurFinishCount(curId) > 1 then
    self:ChangeState(MonopolyPlacealityType.EventEnd)
    if self.player.model then
      self.player.model:OnEventEnd()
    end
    local obstacle = self.mapDic[curId] and self.mapDic[curId].obstacle
    local curReward = self.dataManager:GetRewardById(curId)
    if curReward and obstacle and (obstacle.data.eventType == MonopolyEventType.PickBox or obstacle.data.eventType == MonopolyEventType.DigTreasure) then
      local function func()
        EventManager:GetInstance():Broadcast(EventId.GF_monopoly_reward_done, curId)
      end
      
      DataCenter.RewardManager:ShowCommonReward({reward = curReward}, nil, nil, nil, nil, nil, func)
      self.dataManager:SaveReward(curId, nil)
    end
    PostEventLog.Track(PostEventLog.Defines.MonopolyGroundFinish, {ground_id = curId})
    EventManager:GetInstance():Broadcast(EventId.GF_monopoly_stage_done, curId)
    DataCenter.CityZoneMgr:RefreshMonopolyLandBaseFog()
  end
end

function MonopolyManager:UpdateCurId(message)
  if message.id then
    local curEndId = 0
    if message.id == -1 and message.ids then
      local ids = message.ids
      if 0 < #ids then
        local maxId = ids[1]
        local minId = maxId
        for i, id in ipairs(ids) do
          if id > maxId then
            maxId = id
          elseif id < minId then
            minId = id
          end
        end
        curEndId = minId
        self.maxUnlockEndId = maxId
      end
    else
      curEndId = message.id
      self.maxUnlockEndId = curEndId
    end
    if not curEndId or curEndId == 0 then
      return
    end
    if message.reward then
      local obstacle = self.mapDic[curEndId] and self.mapDic[curEndId].obstacle
      local reward
      if obstacle and obstacle.data.eventType == MonopolyEventType.PickBox then
        reward = message.event_reward
      else
        reward = message.reward
      end
      if reward then
        local endId = self.maxUnlockEndId
        self.dataManager:SaveReward(endId, reward)
      end
    end
    local playerCurId = self.player.curId
    local nextId = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getNextId(curEndId)
    if not playerCurId or playerCurId == 0 then
      self.player.curId = nextId
      self.dataManager:SetCurId(nextId)
      EventManager:GetInstance():Broadcast(EventId.GF_monopoly_stage_done, curEndId)
      DataCenter.CityZoneMgr:RefreshMonopolyLandBaseFog()
      self.performanceManager:RunTrigger(MonopolyPerformanceTriggerEvent.MonopolyInit, self.player.curId)
    elseif playerCurId == curEndId then
      local curData = DataCenter.MonopolyManager.dataManager:GetCurData()
      if curData and curData.state == MonopolyPlacealityType.Arrive then
        self.messageId = nextId
        if self.player.model and self.maxUnlockEndId and self.messageId then
          self.player.model:SetPlayerState(self.maxUnlockEndId >= self.messageId and MonoPolyPlayerState.CrossFast or MonoPolyPlayerState.Normal)
        end
        self:DoCurEventEnd()
      end
    end
  end
end

function MonopolyManager:GetObstacleClassByType(type)
  if ClassType[type] then
    return ClassType[type]
  end
end

function MonopolyManager:DeleteAllModel()
  self.performanceManager:Delete()
  for i, model in pairs(self.mapDic) do
    if model.obstacle then
      model.obstacle:Delete()
      model = nil
    end
  end
  for i, model in pairs(self.decorateMap) do
    if model then
      model:Delete()
      model = nil
      self.decorateMap[i] = nil
    end
  end
  for i, model in pairs(self.rewardModelList) do
    if model then
      model:Delete()
      model = nil
    end
  end
  for i, model in pairs(self.decorateEventMap) do
    if model then
      model:Delete()
      model = nil
      self.decorateEventMap[i] = nil
    end
  end
  if self.delayList then
    for i = 1, #self.delayList do
      if self.delayList[i] then
        self.delayList[i]:Stop()
      end
    end
  end
  self.delayList = {}
  if self.player.model then
    self.player.model:Delete()
  end
  if self.v2npc.model then
    self.v2npc.model:Delete()
  end
  self.rewardModelList = {}
  self.player.model = nil
  self.v2npc.model = nil
  self.mapDic = {}
  if self.t ~= nil then
    self.t:Stop()
    self.t = nil
  end
  if self.delaySBattle then
    self.delaySBattle:Stop()
    self.delaySBattle = nil
  end
  if not IsNull(self.parent) then
    GameObject.Destroy(self.parent.gameObject)
  end
end

function MonopolyManager:ShowPlayer(isInit, initMsg)
  if DataCenter.LWCivilizationSparkExtend:MonopolyManager_curGreaterCount(self.player.curId) or self.player.curId == 0 then
    return
  end
  if self.player.model == nil and DataCenter.LWCivilizationSparkExtend:MonopolyManager_curIdIsOpen(self.player.curId) and self.mapDic and 0 < table.count(self.mapDic) then
    self.player.model = player:New()
    if self.maxUnlockEndId and self.messageId then
      self.player.model:SetPlayerState(self.maxUnlockEndId >= self.messageId and MonoPolyPlayerState.CrossFast or MonoPolyPlayerState.Normal)
    end
    self.player.model:CreateModel(self.player.curId, isInit)
    if isInit then
      DataCenter.LWSoundManager:PlaySound(62246, false)
    end
    local info = self.mapDic[self.player.curId]
    if not info or not info.obstacle and not info.obstacle.data then
      return
    end
    if info.obstacle.data.state == MonopolyPlacealityType.EventEnd then
      return
    end
    info.obstacle.data.state = MonopolyPlacealityType.Arrive
    info.obstacle:ChangeState(MonopolyPlacealityType.Arrive)
    self:ChangeState(MonopolyPlacealityType.Arrive)
  elseif initMsg then
    if self.mapDic and 0 < table.count(self.mapDic) then
      local isArriveOldMonopolyEnd = self.player.curId > self:GetV1LastMonopolyId() and not self:IsMeetMonopolyV2Conditions()
      if DataCenter.LWCivilizationSparkExtend:MonopolyManager_curGreaterCount(self.player.curId) or isArriveOldMonopolyEnd and self:GetV2UnlockData() == 0 then
        if self.player and self.player.model then
          self.player.model:Delete()
          self.player.model = nil
          EventManager:GetInstance():Broadcast(EventId.MonopolyPlayerEnd)
        end
      elseif self.player and self.player.model then
        self.player.model:ResetModel(self.player.curId)
      end
    elseif self.player and self.player.model then
      self.player.model:Delete()
      self.player.model = nil
      EventManager:GetInstance():Broadcast(EventId.MonopolyPlayerEnd)
    end
    local info = self.mapDic[self.player.curId]
    if not info or not info.obstacle and not info.obstacle.data then
      return
    end
    if info.obstacle.data.state == MonopolyPlacealityType.EventEnd then
      return
    end
    info.obstacle.data.state = MonopolyPlacealityType.Arrive
    info.obstacle:ChangeState(MonopolyPlacealityType.Arrive)
    self:ChangeState(MonopolyPlacealityType.Arrive)
  end
end

function MonopolyManager:InitMap(initMsg)
  local mapDataDic = self.dataManager:GetMapDataDic()
  if IsNull(self.parent) then
    self.parent = GameObject("Monopoly")
  end
  if initMsg then
    local curId = self.player.curId
    for _, obj in pairs(self.mapDic) do
      local obstacle = obj.obstacle
      if obstacle then
        local data = obstacle.data
        if data and curId > data.id then
          obstacle:ChangeState(MonopolyPlacealityType.Occupy)
        end
      end
    end
  end
  for id, data in pairs(mapDataDic) do
    if not self.dataManager:GetLandIsLeave(data.land_lock) then
      if not DataCenter.LWCivilizationSparkExtend:MonopolyManager_curGreaterCount(self.player.curId) and (self.mapDic[data.id] == nil or self.mapDic[data.id].obstacle == nil) and not data:GetIsUn() then
        if data.id < 10000 then
          if self:IsUnlockV2ById(data.id) then
            self:CreateObstacle(data)
          end
        elseif data.base_land_type == 2 then
          self:CreateDecorateEvent(data)
        else
          self:CreateDecorate(data)
        end
      end
    else
      if not data:GetIsUn() then
        if self.rewardModelList[data.land_lock] == nil then
          self:CreateLandRewardObj(data.land_lock)
        end
        if (self.mapDic[data.id] == nil or self.mapDic[data.id].obstacle == nil) and data.base_land_type == 2 then
          self:CreateDecorateEvent(data)
        end
      end
      if initMsg then
        self:DestroyById(data.id)
        if self.decorateMap then
          local dec = self.decorateMap[data.id]
          if dec then
            dec:Delete()
            self.decorateMap[data.id] = nil
          end
        end
      end
    end
  end
  if DataCenter.LWCivilizationSparkExtend:MonopolyManager_curIdIsOpen(self.player.curId) and not DataCenter.LWCivilizationSparkExtend:MonopolyManager_curGreaterEqualCount(self.player.curId) and mapDataDic[self.player.curId] then
    self:ShowObstacleByLandLockId(mapDataDic[self.player.curId].land_lock)
  end
  self:ShowV2GuideNPC()
  self.performanceManager:InitData()
  self.performanceManager:RunTrigger(MonopolyPerformanceTriggerEvent.MonopolyInit, self.player.curId)
end

function MonopolyManager:CreateObstacle(data)
  local ObstacleClass = self:GetObstacleClassByType(data.eventType)
  if ObstacleClass ~= nil then
    local class = ObstacleClass.New(self)
    class:SetData(data)
    if not self.mapDic then
      self.mapDic = {}
    end
    self.mapDic[data.id] = {}
    self.mapDic[data.id].obstacle = class
  end
end

function MonopolyManager:CreateDecorate(data)
  if self.decorateMap[data.id] then
    return
  end
  local mapDecorate
  mapDecorate = MapDecorate.New(self)
  mapDecorate:SetData(data)
  if not self.decorateMap then
    self.decorateMap = {}
  end
  self.decorateMap[data.id] = mapDecorate
end

function MonopolyManager:CreateDecorateEvent(data)
  if self.decorateEventMap[data.id] then
    return
  end
  local mapDecorateEvent = MapDecorateEvent.New(self)
  mapDecorateEvent:SetData(data)
  if not self.decorateEventMap then
    self.decorateEventMap = {}
  end
  self.decorateEventMap[data.id] = mapDecorateEvent
end

function MonopolyManager:GetDecorateById(id)
  local decorate = self.decorateEventMap[id]
  if decorate == nil then
    decorate = self.decorateMap[id]
  end
  return decorate
end

function MonopolyManager:GetPlacealityDataById(placealityId)
  if self.dataManager then
    return self.dataManager:GetPlacealityById(placealityId)
  end
end

function MonopolyManager:GetCurData()
  if self.dataManager then
    return self.dataManager:GetCurData()
  end
end

function MonopolyManager:UpdatePalceality(id, state)
  local name = "down"
  if state == 1 then
    name = "down"
  else
    name = "up"
  end
  if self.mapDic and self.mapDic[id] and self.mapDic[id].obstacle then
    self.mapDic[id].obstacle:PlayPalcealityAnim(name)
  end
end

function MonopolyManager:DestroyById(id)
  if self.mapDic[id] and self.mapDic[id].obstacle then
    self.mapDic[id].obstacle:Delete()
    self.mapDic[id].obstacle = nil
  end
end

function MonopolyManager:GetOneReward()
  if table.count(self.rewardModelList) < 1 then
    return nil
  end
  local tempId = 9999
  for id, v in pairs(self.rewardModelList) do
    tempId = math.min(tempId, id)
  end
  if tempId ~= 9999 then
    return self.rewardModelList[tempId]
  end
end

function MonopolyManager:LandLockRewardEndById(id)
  if id and self.rewardModelList[id] then
    self.rewardModelList[id]:Delete()
    self.rewardModelList[id] = nil
    if id == self:GetV1LastLandId() then
      TimerManager:GetInstance():DelayInvoke(function()
        self:ShowV2GuideNPC(true)
      end, 2)
    end
    self:DeleteLandDecorateEvent(id)
  end
end

function MonopolyManager:GetIsEnd()
  if self.player.curId >= self:GetV1LastMonopolyId() then
    return true
  end
end

function MonopolyManager:GetIsUnlock35LvMonopolyId()
  if self.player.curId >= self:Get35LvFirstMonopolyId() then
    return true
  end
end

function MonopolyManager:GetCurrentLandLock()
  local data = self.dataManager:GetPlacealityById(self.player.curId)
  if data then
    return data.land_lock
  end
  return 1
end

function MonopolyManager:GetSBattleIsOpen()
  if self.player.curId >= Const.SBattle + 1 then
    return true
  end
end

function MonopolyManager:SetSpontaneousBattle(isOn)
  local last = self:GetSpontaneousBattle()
  CommonUtil.PlayerPrefsSetBool("MonopolySBattle", isOn)
  self.sBattle = isOn
  if not self.sBattle then
    if self.delaySBattle then
      self.delaySBattle:Stop()
      self.delaySBattle = nil
    end
    if self.sBattle ~= last then
      UIUtil.ShowTipsId(801329)
      if self.player.model then
        self.player.model:RefreshSBattleTip()
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.MonopolyUpdateSBattle, isOn)
end

function MonopolyManager:GetSpontaneousBattle()
  return CommonUtil.PlayerPrefsGetBool("MonopolySBattle", false)
end

function MonopolyManager:GetV1LastMonopolyId()
  return LuaEntry.DataConfig:TryGetNum("city_land_unlock_v2", "k6", 0)
end

function MonopolyManager:GetV1LastLandId()
  local id = LuaEntry.DataConfig:TryGetNum("city_land_unlock_v2", "k6", 0)
  local template = self.dataManager:GetTemplate(id)
  if template then
    return template.land_lock
  end
  return nil
end

function MonopolyManager:Get35LvFirstMonopolyId()
  return LuaEntry.DataConfig:TryGetNum("city_land_unlock_v2", "k7", 0)
end

function MonopolyManager:IsMeetMonopolyV2Conditions()
  local isOpen = LuaEntry.DataConfig:TryGetNum("city_land_unlock_v2", "k1", 0)
  local mainLevelCondition = LuaEntry.DataConfig:TryGetNum("city_land_unlock_v2", "k2", 0)
  local serverOpenDaysCondition = LuaEntry.DataConfig:TryGetNum("city_land_unlock_v2", "k3", 0)
  local preMonopolyLevelCondition = self:GetV1LastMonopolyId()
  local selfLevel = DataCenter.BuildManager:GetMainLevel()
  local serverOpenDays = UITimeManager:GetInstance():GetServerOpenDays()
  return isOpen == 1 and mainLevelCondition <= selfLevel and serverOpenDaysCondition <= serverOpenDays and preMonopolyLevelCondition < self.player.curId
end

function MonopolyManager:IsUnlockV2ById(id)
  local preMonopolyLevelCondition = LuaEntry.DataConfig:TryGetNum("city_land_unlock_v2", "k6", 0)
  if id <= preMonopolyLevelCondition then
    return true
  end
  return self:GetV2UnlockData() == 1
end

function MonopolyManager:ShowV2GuideNPC(isContinue)
  if self:GetV2UnlockData() == 0 and self:IsMeetMonopolyV2Conditions() then
    local prefabPath = LuaEntry.DataConfig:TryGetStr("city_land_unlock_v2", "k4", "")
    self.v2npc.model = V2NPC:New()
    self.v2npc.model:CreateModel(prefabPath, self.parent, not isContinue)
    TimerManager:GetInstance():DelayInvoke(function()
      local isInCity = SceneUtils.GetIsInCity()
      if isInCity and DataCenter.CityZoneMgr.cityZoneFog and DataCenter.CityZoneMgr.cityZoneFog.unlockV2MonopolyGuide then
        DataCenter.CityZoneMgr.cityZoneFog:UnlockOneFogEx(1, DataCenter.CityZoneMgr.cityZoneFog.unlockV2MonopolyGuide, 20, 20)
      end
    end, 0.5)
  end
end

function MonopolyManager:SetV2UnlockData(msg, isInit)
  if msg then
    if msg.monopoly_v2_unlock then
      self.isUnlockV2 = msg.monopoly_v2_unlock
    end
    if msg.monopolyStageInfo then
      self.player.curId = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getNextId(msg.monopolyStageInfo.stageId)
      self.dataManager:SetCurId(self.player.curId)
    end
    EventManager:GetInstance():Broadcast(EventId.MonopolyV2UnlockUpdate)
    self:OnMonopolyV2UnlockUpdate(isInit)
  end
end

function MonopolyManager:GetV2UnlockData()
  return self.isUnlockV2
end

function MonopolyManager:TryMoveCameraEnterCity()
  if self.monopoly_camera_setting == nil then
    self.monopoly_camera_setting = LuaEntry.DataConfig:TryGetNum("monopoly_camera_setting", "k1", -1)
  end
  if self.monopoly_camera_setting > 0 and self.player and self.player.curId then
    local curId = self.player.curId
    if curId <= self.monopoly_camera_setting and self.dataManager and self.dataManager.placealityDataDict then
      local data = self.dataManager.placealityDataDict[curId]
      if data then
        local pos = data:GetCenterWorldPos()
        if CS.SceneManager.World then
          CS.SceneManager.World:Lookat(pos)
        end
      end
    end
  end
end

function MonopolyManager:GetPlayerPosition()
  if self.player.model then
    return self.player.model:GetPosition()
  end
  return 0, 0, 0
end

function MonopolyManager:GetPlayerModel()
  return self.player.model
end

function MonopolyManager:HasPlayer()
  return self.player.model ~= nil
end

function MonopolyManager:GetCurObstacle()
  if not self.mapDic then
    return nil
  end
  if not self.player.curId then
    return nil
  end
  if self.mapDic[self.player.curId] then
    return self.mapDic[self.player.curId].obstacle
  end
  return nil
end

function MonopolyManager:IsLeaveLand(land_lock)
  return self.dataManager:GetLandIsLeave(land_lock)
end

function MonopolyManager:GetLastIdByLand(landId)
  local list = self.dataManager:GetPlacealityIdListByLandlockId(landId)
  if list then
    local count = #list
    if 0 < count then
      return list[count]
    end
  end
  return 0
end

function MonopolyManager:CheckObstacleVisible()
  return true
end

function MonopolyManager:TryObstacleVisibleGuide()
end

function MonopolyManager:CreateDelayTimer(callback, delay, timerName)
  if self.delayTimers == nil then
    self.delayTimers = {}
  end
  timerName = timerName or "timer_" .. tostring(#self.delayTimers + 1)
  local timer = TimerManager:GetInstance():DelayInvoke(function()
    if self.delayTimers[timerName] then
      self.delayTimers[timerName] = nil
    end
    callback()
  end, delay)
  self.delayTimers[timerName] = timer
  return timer
end

function MonopolyManager:ClearAllDelayTimers()
  if self.delayTimers then
    for name, timer in pairs(self.delayTimers) do
      if timer then
        timer:Stop()
      end
    end
    self.delayTimers = {}
  end
end

function MonopolyManager:OnRewardGetPanelClose()
  local self = DataCenter.MonopolyManager
  local data = self.dataManager:GetCurData()
  if data and data.eventType == MonopolyEventType.DigTreasure and data.state == MonopolyPlacealityType.EventEnd then
    self:PlayerGo()
  end
end

function MonopolyManager:GetMapTemplate(id)
  if self.dataManager then
    return self.dataManager:GetTemplate(id)
  end
  return nil
end

function MonopolyManager:GetPlacealityQuestOrder(id)
  local data = self.dataManager:GetTemplate(id)
  if data and not string.IsNullOrEmpty(data.quest_order) then
    return data.quest_order
  end
  return id
end

function MonopolyManager:PlayLandUnlockSound()
  self:StopLandUnlockSound()
  self.playingUnlockSoundId = DataCenter.LWSoundManager:PlaySound(80065, false)
end

function MonopolyManager:StopLandUnlockSound()
  if self.playingUnlockSoundId then
    DataCenter.LWSoundManager:StopSound(self.playingUnlockSoundId)
    self.playingUnlockSoundId = nil
  end
end

return MonopolyManager
