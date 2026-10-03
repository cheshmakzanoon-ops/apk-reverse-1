local RadarCenterDataManager = BaseClass("RadarCenterDataManager")
local Localization = CS.GameEntry.Localization
local DetectEventGetTreasureClaimInfo = require("DataCenter.RadarCenterDataManager.DetectEventGetTreasureClaimInfo")
local ITEM_DETECT_ZOMBIE_BUS_CONFIG_KEY = "detect_zombie_bus_config"
local ArmyNpc = require("DataCenter.LWBeginnerDirectorManager.LWBeginnerArmyNpc")

local function __init(self)
  self.detectInfo = {}
  self.events = {}
  self.scoutDeclareCityEvents = {}
  self.scoutOccupyCityEvents = {}
  self.detectFirstGotoPlot = nil
  self.helpShowRecordTab = nil
  self.cacheDetectEventRewardList = {}
  self.radarLevelLimit = 0
  self.lastShowRadarZombieBusAttackEffTime = 0
  self.lastShowRadarZombieBusTime = 0
  self.festivalparty_broad_config_tab = nil
  self.plotFinishData = nil
  EventManager:GetInstance():AddListenerWithSelf(EventId.GF_plot_group_done, self.CheckPlotGroupDone, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.SetMainWorldPointId, self.OnSetMainWorldPointId, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.DeclareWar, self.OnDeclareWar, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.WorldMarchGetCurPos, self.DoGoToWorldMarchCurPoint, self)
end

local function HandleResetData(self, message)
  if message.detectInfo ~= nil then
    self:UpdateDetectInfo(message.detectInfo)
  end
  if message.deleteEventUuid ~= nil then
    self:RemoveDetectEventInfo(message.deleteEventUuid)
  end
  if message.newEvent ~= nil then
    self:UpdateOneDetectEventInfo(message.newEvent)
  end
  if message.gold ~= nil then
    LuaEntry.Player.gold = message.gold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
end

local function UpdateDetectEventInfo(self, message)
  self.detectInfo = {}
  if message.detectInfo ~= nil then
    self:UpdateDetectInfo(message.detectInfo)
    self.detectTypeProgressDatas = message.detectInfo.type2Data or {}
  end
  self.events = {}
  if message.events ~= nil then
    table.walk(message.events, function(k, v)
      self:UpdateOneDetectEventInfo(v)
    end)
  end
  self:RefreshZombieBusDetectData()
  DataCenter.FakeCollectGarbageMarchManager:RemoveAllDisappearEvent()
  DataCenter.FakeHelperMarchManager:RemoveAllDisappearEvent()
end

local function GetDetectEventInfoUuids(self)
  local tmp = table.keys(self.events)
  local result = {}
  for eventUuid, eventInfo in pairs(self.events) do
    local template = eventInfo.template
    if template and template.type ~= DetectEventType.DOMINATOR_COCKATRICE_GUIDE_1 and template.type ~= DetectEventType.DOMINATOR_COCKATRICE_GUIDE_2 and template.type ~= DetectEventType.DOMINATOR_COCKATRICE_GUIDE_3 then
      if eventInfo.state == DetectEventState.DETECT_EVENT_STATE_FINISHED then
        table.insert(result, eventUuid)
      elseif template.type == DetectEventType.DetectEventTypeSpecial or template.type == DetectEventType.DetectEventRadarRally or template.type == DetectEventType.DetectEventPVE or template.type == DetectEventType.DetectEventTypeBoss or template.type == DetectEventType.SPECIAL_OPS or template.type == DetectEventType.PARKOUR_BATTLE or template.type == DetectEventType.FAKE_PVP or template.type == DetectEventType.GATHER_RESOURCE then
        table.insert(result, eventUuid)
      elseif eventInfo.endTime > UITimeManager:GetInstance():GetServerTime() then
        if template.type == DetectEventType.ScoutDeclareCity then
          if eventInfo:OnDeclareWar() then
            table.insert(result, eventUuid)
          end
        elseif template.type == DetectEventType.ScoutOccupyCity then
          if eventInfo:OnSetMainWorldPointId() then
            table.insert(result, eventUuid)
          end
        else
          table.insert(result, eventUuid)
        end
      end
    end
  end
  table.sort(result, function(k, v)
    local data1 = self:GetDetectEventInfo(k)
    local data2 = self:GetDetectEventInfo(v)
    if data1 ~= nil and data2 ~= nil then
      local posAY = 0
      local posBY = 0
      if 0 < data1.pointId then
        local posA = SceneUtils.IndexToTilePos(data1.pointId, ForceChangeScene.World)
        posAY = posA.y
      end
      if 0 < data2.pointId then
        local posB = SceneUtils.IndexToTilePos(data2.pointId, ForceChangeScene.World)
        posBY = posB.y
      end
      return posAY > posBY
    end
    return false
  end)
  return result
end

local function GetFinishedDetectEventNum(self)
  local count = 0
  table.walk(self.events, function(k, v)
    if v and v.state == DetectEventState.DETECT_EVENT_STATE_FINISHED and (not v.IsShowRedPointInMainUI or v:IsShowRedPointInMainUI()) then
      count = count + 1
    end
  end)
  return count
end

local function GetUnFinishedDetectEventNum(self)
  local count = 0
  table.walk(self.events, function(k, v)
    if v and v.state ~= DetectEventState.DETECT_EVENT_STATE_REWARDED then
      count = count + 1
    end
  end)
  return count
end

local function GetDetectEventInfo(self, uuid)
  return self.events[uuid]
end

local function GetDetectEventsInfoByEventId(self, eventId)
  local result = {}
  for _, v in pairs(self.events) do
    if tonumber(v.eventId) == eventId then
      table.insert(result, v)
    end
  end
  return result
end

local function GetDetectEventInfoByPointId(self, pointId)
  for _, v in pairs(self.events) do
    if v.pointId == pointId then
      return v
    end
  end
  return nil
end

local function GetNotFinishDetectEventInfoByPointId(self, pointId)
  for _, v in pairs(self.events) do
    if v.pointId == pointId and v.state == DetectEventState.DETECT_EVENT_STATE_NOT_FINISH then
      return v
    end
  end
  return nil
end

local function GetDetectInfoLevel(self)
  if self.detectInfo == nil then
    return 1
  end
  return self.detectInfo.level or 1
end

local function GetDetectInfoRewardLevel(self)
  if self.detectInfo == nil then
    return 1
  end
  return self.detectInfo.rewardLevel or 1
end

local function GetDetectInfoPower(self)
  if self.detectInfo == nil then
    return 1
  end
  return self.detectInfo.power or 1
end

local function GetDetectInfoCompleteNum(self)
  if self.detectInfo == nil then
    return 1
  end
  return self.detectInfo.completeNum or 1
end

local function GetDetectInfoNextRefreshTime(self)
  if self.detectInfo == nil then
    return 1
  end
  return self.detectInfo.nextRefreshTime or 1
end

local function GetPowerRewardList(self)
  return self.detectInfo.powerRewardList
end

local function GetDetectInfo(self)
  return self.detectInfo
end

local function GetMaxDetectNum(self)
  return self.detectInfo.eventNum or 0
end

local function GetResetNum(self)
  return self.detectInfo.resetNum or 0
end

local function UpdateOneDetectEventInfo(self, message)
  if message.uuid ~= nil then
    local uuid = message.uuid
    if self.events[uuid] == nil then
      local info = DetectEventInfo.New()
      self.events[uuid] = info
    end
    self.events[uuid]:ParseData(message)
    local event = self.events[uuid]
    if event.template then
      if event.template.type == DetectEventType.ScoutDeclareCity then
        self.scoutDeclareCityEvents[uuid] = event
      elseif event.template.type == DetectEventType.ScoutOccupyCity then
        self.scoutOccupyCityEvents[uuid] = event
      elseif event.template.type == DetectEventType.ZOMBIE_BUS_TRAIN then
        self.zombieBusTrainEventInfo = event
      end
    end
  end
end

local function GetCurEventNum(self)
  local num = table.count(self.events)
  return num + GetMaxDetectNum(self)
end

local function GetDetectEventCount(self)
  return table.count(self.events)
end

local function UpdateDetectInfo(self, message)
  self.detectInfo.level = message.level
  self.detectInfo.power = message.power
  self.detectInfo.completeNum = message.completeNum
  self.detectInfo.nextRefreshTime = message.nextRefreshTime or 0
  self.detectInfo.eventNum = message.eventNum
  self.detectInfo.signal = message.signal
  self.detectInfo.resetNum = message.resetNum
  self.detectInfo.specialOpsOrder = message.specialOpsOrder or 0
  self.detectInfo.specialOpsNum = message.specialOpsNum or 0
  self.detectInfo.rewardLevel = message.rewardLevel or 1
  self.detectInfo.powerRewardList = {}
  if message.powerReward then
    self.detectInfo.powerRewardList = DataCenter.RewardManager:ReturnRewardParamForView(message.powerReward)
  end
end

local function UpgradeDetectPowerInfo(self, message)
  self.detectInfo = {}
  if message.detectInfo ~= nil then
    self:UpdateDetectInfo(message.detectInfo)
  end
  if message.reward ~= nil then
    DataCenter.RewardManager:ShowCommonReward(message)
    DataCenter.RewardManager:AddRewardsAndRes(message)
  end
end

local function RemoveDetectEventInfo(self, uuid)
  local event = self.events[uuid]
  if event then
    if event.template and event.template.type == DetectEventType.ZOMBIE_BUS_TRAIN then
      self.zombieBusTrainEventInfo = nil
    end
    event:Delete()
  end
  self.events[uuid] = nil
  self.scoutDeclareCityEvents[uuid] = nil
  self.scoutOccupyCityEvents[uuid] = nil
end

local function GetDetectEventRewardBack(self, message)
  local eventId
  if message.uuid ~= nil then
    local event = self.events[message.uuid]
    if event then
      eventId = tonumber(event.eventId) or 0
    end
    self:RemoveDetectEventInfo(message.uuid)
    DataCenter.RadarFakeUIMarchManager:RemoveClaimingTask(message.uuid)
  end
  if message.detectInfo ~= nil then
    self:UpdateDetectInfo(message.detectInfo)
  end
  if message.reward ~= nil then
    local param = {}
    param.reward = message.reward
    param.eventUuid = message.uuid
    EventManager:GetInstance():Broadcast(EventId.LWDetectEventRewardReceive, param)
    DataCenter.RewardManager:AddRewardsAndRes(message)
    if self:UnlockDetectEventRewardCacheModel() then
      self:AddCacheDetectEventRewardInfo(message)
    else
      DataCenter.RewardManager:ShowCommonReward(message)
    end
    EventManager:GetInstance():Broadcast(EventId.UpdatePlayerExp)
  end
  if message.gold ~= nil then
    LuaEntry.Player.gold = message.gold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
  if message.newEvent ~= nil then
    self:UpdateOneDetectEventInfo(message.newEvent)
  end
  if message.dominatorTowerOpen ~= nil then
    self.dominatorTowerOpen = message.dominatorTowerOpen
  end
  self:RefreshZombieBusDetectData()
  if eventId and 0 < eventId then
    EventManager:GetInstance():Broadcast(EventId.GF_detect_event_state_changed, {eventId = eventId, state = 2})
  end
end

local function GetClaimLevelReward(self, message)
  if self.detectInfo == nil then
    return
  end
  if self.events == nil then
    return
  end
  self.detectInfo.rewardLevel = message.rewardLevel or 1
  if message.events ~= nil then
    table.walk(message.events, function(k, v)
      self:UpdateOneDetectEventInfo(v)
    end)
  end
end

local function __delete(self)
  self.detectInfo = nil
  if self.events then
    for _, v in pairs(self.events) do
      v:Delete()
    end
  end
  self.events = nil
  self.scoutDeclareCityEvents = {}
  self.scoutOccupyCityEvents = {}
  self.detectFirstGotoPlot = nil
  self.helpShowRecordTab = nil
  self.detectEventTreasureClaimInfoData = nil
  self.cacheDetectEventRewardList = nil
  self.radarLevelLimit = nil
  self.zombieBusTrainEventInfo = nil
  self.detectTypeProgressDatas = nil
  self.zombieBusTrainProgressData = nil
  self.fakeZombieBusTrainInCDEvent = nil
  self.zombieBusTrainVers = nil
  self.zombieBusTrainArriveInCityData = nil
  self.recentZombieBusRewardMsg = nil
  EventManager:GetInstance():RemoveListener2(EventId.GF_plot_group_done, self.CheckPlotGroupDone)
  EventManager:GetInstance():RemoveListener(EventId.SetMainWorldPointId, self.OnSetMainWorldPointId)
  EventManager:GetInstance():RemoveListener(EventId.DeclareWar, self.OnDeclareWar)
  EventManager:GetInstance():RemoveListener(EventId.WorldMarchGetCurPos, self.DoGoToWorldMarchCurPoint)
end

local function OnDeclareWar(self)
  for _, v in pairs(self.scoutDeclareCityEvents) do
    v:OnDeclareWar()
  end
end

local function OnSetMainWorldPointId(self)
  for _, v in pairs(self.scoutOccupyCityEvents) do
    v:OnSetMainWorldPointId()
  end
end

local function InitData(self, t)
  if t.dominatorTowerOpen then
    self.dominatorTowerOpen = t.dominatorTowerOpen
  end
  self:GetDetectEventData(false)
end

local function GetDetectEventData(self, isOpenView)
  SFSNetwork.SendMessage(MsgDefines.DetectInfoGet, isOpenView)
end

local function StartDetectEventPve(self, uuid)
end

local function ResetDetectEvent(self, uuid)
  SFSNetwork.SendMessage(MsgDefines.ResetDetectEvent, uuid)
end

local function FindMonsterBoss(self, level)
  SFSNetwork.SendMessage(MsgDefines.FindMonsterBoss, level, 1)
end

local function HandleFindMonsterBossBack(self, message)
  if message.errorCode ~= nil and message.errorCode ~= SeverErrorCode then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  if message.uuid ~= nil then
    local pointId = message.pointId
    UIManager.Instance:DestroyWindow(UIWindowNames.UIDetectEvent)
    GoToUtil.MoveToWorldMarchAndOpen(pointId, message.uuid, LuaEntry.Player:GetSelfServerId(), 0)
  end
end

local function IsCanUpdate(self)
end

local function GetUpgradeItem(self)
end

local function IsDetectEventDoing(self, uuid)
  local eventData = self:GetDetectEventInfo(uuid)
  if eventData == nil then
    return false
  end
  if DataCenter.FakeCollectGarbageMarchManager:IsEventDoing(eventData.pointId) then
    return true
  end
  if DataCenter.FakeHelperMarchManager:IsEventDoing(eventData.pointId) then
    return true
  end
  if DataCenter.AttackCityS0DataManager:GetCityDetectRadarIsDoing(uuid) then
    return true
  end
  if DataCenter.RadarFakeUIMarchManager:IsMarched(uuid) then
    return true
  end
  local Player = LuaEntry.Player
  local allianceId = Player.allianceId
  local myUid = Player.uid
  local allList = DataCenter.ArmyFormationDataManager:GetArmyFormationList()
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(eventData.eventId)
  if allList ~= nil then
    for _, v in ipairs(allList) do
      if v.state == ArmyFormationState.March then
        local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(myUid, v.uuid, allianceId)
        if march ~= nil and march:GetMarchTargetType() ~= MarchTargetType.BACK_HOME then
          if template.type == DetectEventType.GATHER_RESOURCE then
            if eventData.pointId == march.targetPos then
              return true
            end
          elseif eventData.uuid == march.targetUuid then
            return true
          end
        end
      end
    end
  end
  return false
end

local function GetSpecialEventInfo(self)
  if self.events ~= nil then
    for k, v in pairs(self.events) do
      local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(v.eventId)
      if template.type == DetectEventType.DetectEventTypeSpecial then
        return v
      end
    end
  end
end

local function GetRadarRallyFinishedNum(self)
  local count = 0
  for _, event in pairs(self.events) do
    if event.state == DetectEventState.DETECT_EVENT_STATE_FINISHED then
      local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(event.eventId)
      if template.type == DetectEventType.DetectEventRadarRally then
        count = count + 1
      end
    end
  end
  return count
end

local function IsCanReset(self, type)
  return type ~= DetectEventType.DetectEventTypeSpecial and type ~= DetectEventType.DetectEventRadarRally and type ~= DetectEventType.HeroTrial and type ~= DetectEventType.SPECIAL_OPS
end

local function UpdateEventNum(self, count)
  if self.detectInfo ~= nil then
    self.detectInfo.eventNum = count
  end
end

local function GetRadarMonsterList(self)
  local result = {}
  for _, event in pairs(self.events) do
    if event.state == DetectEventState.DETECT_EVENT_STATE_NOT_FINISH or event.state == DetectEventState.DETECT_EVENT_STATE_NOT_IN_WORLD then
      local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(event.eventId)
      if template.type == DetectEventType.DetectEventTypeNormal then
        table.insert(result, event)
      end
    end
  end
  return result
end

local function GetOneInfoByEventTypeAndState(self, eventType, state)
  local result
  local quality = 999
  if self.events ~= nil then
    for _, event in pairs(self.events) do
      if event.state == state then
        local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(event.eventId)
        if template.type == eventType and quality > template.quality then
          quality = template.quality
          result = event
        end
      end
    end
  end
  return result
end

local function GetOneInfoByEventTypeAndPara(self, eventType, para)
  local result
  if self.events ~= nil then
    for _, event in pairs(self.events) do
      local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(event.eventId)
      if template.type == eventType and template.para == para then
        result = event
        break
      end
    end
  end
  return result
end

local function GetRadarBubbleOpenMainCityLevel(self)
  if self.bubbleOpenLv == nil then
    self.bubbleOpenLv = LuaEntry.DataConfig:TryGetNum("buildingBubble_control", "k2")
  end
  return self.bubbleOpenLv or 0
end

local function CheckGuideOpenBuildBubble(self)
  local mainBuildLV = DataCenter.BuildManager.MainLv
  if mainBuildLV >= self:GetRadarBubbleOpenMainCityLevel() then
    return true
  end
  return DataCenter.GuideManager:IsShowRadarBubble()
end

local function GetNextSpecialEventRefreshTime(self)
  local key1 = "detect_config"
  if LuaEntry.Player:IsMonopolyDetectB() then
    key1 = "detect_config_new"
  end
  local timeGap = LuaEntry.DataConfig:TryGetNum(key1, "k20") * 3600 * 1000
  local time = UITimeManager:GetInstance():GetServerTime()
  local nextDayTime = UITimeManager:GetInstance():GetNextDayMs()
  local leftTime = nextDayTime - time
  return timeGap, nextDayTime - math.floor(leftTime / timeGap) * timeGap
end

local function GetSpecialEvent(self)
  if self.events ~= nil then
    for k, v in pairs(self.events) do
      local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(v.eventId)
      if template.type == DetectEventType.SPECIAL_OPS then
        return v
      end
    end
  end
  return nil
end

local function GetEventInfoByPointId(self, pointId)
  if self.events ~= nil then
    for k, v in pairs(self.events) do
      if v.pointId == pointId then
        return v
      end
    end
  end
  return nil
end

local function GetDetectEventInfoByType(self)
end

local function IsDetectEventUIFirstOpen(self)
  local time = Setting:GetPrivateString("IsDetectEventUIFirstOpen", "")
  if time ~= "" then
    return not UITimeManager:GetInstance():IsSameDayForServer(tonumber(time), UITimeManager:GetInstance():GetServerSeconds())
  end
  return true
end

local function RecordDetectEventUIFirstOpen(self)
  Setting:SetPrivateString("IsDetectEventUIFirstOpen", tostring(UITimeManager:GetInstance():GetServerSeconds()))
end

local function IsDetectEventFirstOpen(self, uuid)
  if self.isDetectEventHasOpen == nil or self.isDetectEventHasOpen[uuid] == nil then
    return true
  else
    return false
  end
end

local function RecordDetectEventFirstOpen(self, uuid)
  if self.isDetectEventHasOpen == nil then
    self.isDetectEventHasOpen = {}
  end
  self.isDetectEventHasOpen[uuid] = true
end

local function IsDetectEventShowTip(self)
  if self.detectTriggerTime == nil then
    self.detectTriggerTime = -1
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local needTipNum = 3
  local nextRefreshTime = GetDetectInfoNextRefreshTime(self)
  local curNum = GetCurEventNum(self)
  local isShow = false
  if self.detectTriggerTime < 0 then
    isShow = needTipNum <= curNum
  else
    isShow = curTime >= nextRefreshTime and nextRefreshTime > self.detectTriggerTime
  end
  return isShow
end

local function RecordDetectTriggerTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.detectTriggerTime = curTime
end

local function GetDetectTriggerTime(self)
  local time = -1
  if self.detectTriggerTime then
    time = self.detectTriggerTime
  end
  return time
end

local DetectFirstGotoFlag = "DetectFirstGotoFlag"

local function InitDetectFirstGotoPlotDict(self)
  if self.detectFirstGotoPlot == nil then
    self.detectFirstGotoPlot = {}
    local key1 = "detect_config"
    if LuaEntry.Player:IsMonopolyDetectB() then
      key1 = "detect_config_new"
    end
    local dataStr = LuaEntry.DataConfig:TryGetStr(key1, "k24")
    local dataArr = string.split(dataStr, "|")
    for k, v in pairs(dataArr) do
      local detectPlotData = string.split(v, ";")
      if detectPlotData ~= nil and #detectPlotData == 2 then
        local detectType = tonumber(detectPlotData[1])
        local plotId = tonumber(detectPlotData[2])
        self.detectFirstGotoPlot[detectType] = plotId
      end
    end
  end
end

local function GetFirstGotoPlotIdByDetectType(self, type)
  self:InitDetectFirstGotoPlotDict()
  local plotId = -1
  if self.detectFirstGotoPlot[type] then
    plotId = self.detectFirstGotoPlot[type]
  end
  return plotId
end

local function GetDetectFirstGotoPoint(self, detectType)
  local strK = LuaEntry.Player.uid .. DetectFirstGotoFlag .. detectType
  local isHave = Setting:GetInt(strK, 0)
  return 0 < isHave
end

local function RecordDetectFirstGotoPoint(self, detectType)
  local strK = LuaEntry.Player.uid .. DetectFirstGotoFlag .. detectType
  Setting:SetInt(strK, 1)
end

local function TryDetectFirstGotoPlot(self, uuid)
  local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(uuid)
  if data == nil then
    return
  end
  local config = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
  if config == nil then
    return
  end
  local detectType = config.type
  local plotId = self:GetFirstGotoPlotIdByDetectType(detectType)
  if plotId <= 0 then
    return
  end
  local isHaveRecord = self:GetDetectFirstGotoPoint(detectType)
  if isHaveRecord then
    return
  end
  self:RecordDetectFirstGotoPoint(detectType)
  TimerManager:GetInstance():DelayInvoke(function()
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = plotId, hideMainUI = false})
  end, 1)
end

local function GetHelperEventDataByBuildUid(self, uid)
  local helperEventData
  if self.events ~= nil then
    for k, v in pairs(self.events) do
      local template = v.template
      if template and template.type == DetectEventType.HELPER and v.helpInfo and v.helpInfo.bUid == uid then
        helperEventData = v
        break
      end
    end
  end
  return helperEventData
end

local function GetCityEventDataByPointIndex(self, pointIndex)
  if self.events ~= nil then
    for k, v in pairs(self.events) do
      local template = v.template or {}
      if (template.type == DetectEventType.ScoutDeclareCity or template.type == DetectEventType.ScoutOccupyCity) and v.pointId == pointIndex then
        return v
      end
    end
  end
  return nil
end

local DetectHelperShowRecordPoint = "DetectHelperShowRecordPoint"
local DetectHelpShowRecordSplitChar = "|"

local function UpdateHelperRecordTab(self)
  if self.helpShowRecordTab == nil then
    self.helpShowRecordTab = {}
    local str = CommonUtil.PlayerPrefsGetString(DetectHelperShowRecordPoint, "")
    if not string.IsNullOrEmpty(str) then
      local uidList = string.split(str, DetectHelpShowRecordSplitChar)
      for i, uid in pairs(uidList) do
        local numUid = tonumber(uid)
        self.helpShowRecordTab[numUid] = 1
      end
    end
  end
  if table.count(self.events) > 0 then
    for uid, v in pairs(self.helpShowRecordTab) do
      if self.events[uid] == nil then
        self.helpShowRecordTab[uid] = nil
      end
    end
  end
  self:RecordCurHelpTab()
end

local function GeteHelperRecordTab(self)
  if self.helpShowRecordTab == nil then
    self:UpdateHelperRecordTab()
  end
  return self.helpShowRecordTab
end

local function RecordCurHelpTab(self)
  if self.helpShowRecordTab == nil then
    return
  end
  local recordStr = ""
  local recordIndex = 1
  for uid, v in pairs(self.helpShowRecordTab) do
    if recordIndex == 1 then
      recordStr = recordStr .. uid
    else
      recordStr = recordStr .. DetectHelpShowRecordSplitChar .. uid
    end
    recordIndex = recordIndex + 1
  end
  CommonUtil.PlayerPrefsSetString(DetectHelperShowRecordPoint, recordStr)
end

local function AddOneHelpRecordUid(self, uid)
  if self.helpShowRecordTab == nil then
    return
  end
  self.helpShowRecordTab[uid] = 1
  self:RecordCurHelpTab()
end

local function GetBeHelpedDetectUid(self)
  local uidList = {}
  if self.events ~= nil then
    for uid, v in pairs(self.events) do
      if v.completeByHelper ~= nil then
        table.insert(uidList, uid)
      end
    end
  end
  table.sort(uidList)
  return uidList
end

local function GetDetectHelpTypeCostNum(self)
  return 10
end

local function GetDetectEventFakePVPTypeCostNum(self)
  return 10
end

function RadarCenterDataManager:GetDetectEventTreasureClaimInfo(message)
  self.detectEventTreasureClaimInfoData = DetectEventGetTreasureClaimInfo.New()
  self.detectEventTreasureClaimInfoData:InitData(message)
  if message.source then
    if message.source == SeeDetectEventGetTreasureClaimInfoType.Chat then
      EventManager:GetInstance():Broadcast(EventId.DetectEventGetTreasureClaimInfo, self.detectEventTreasureClaimInfoData)
    elseif message.source == SeeDetectEventGetTreasureClaimInfoType.World then
      UIUtil.OpenDetectEventTreasureClaimInfoView(self.detectEventTreasureClaimInfoData)
    end
  end
end

local function UnlockDetectEventRewardCacheModel(self)
  if self.radarLevelLimit == 0 then
    self.radarLevelLimit = LuaEntry.DataConfig:TryGetNum("detect_reward_value", "k2")
  end
  local curRadarLevel = self:GetDetectInfoLevel()
  return curRadarLevel >= self.radarLevelLimit
end

local function AddCacheDetectEventRewardInfo(self, message)
  if message.reward then
    local rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(message.reward)
    for i = 1, table.count(rewardList) do
      local reward = rewardList[i]
      table.insert(self.cacheDetectEventRewardList, reward)
    end
  end
end

local function ClearCacheDetectEventRewardList(self)
  self.cacheDetectEventRewardList = {}
end

local function GetCacheDetectEventRewardList(self)
  return self.cacheDetectEventRewardList
end

function RadarCenterDataManager:SetPlotFinishData(data)
  self.plotFinishData = data
end

function RadarCenterDataManager:CheckPlotGroupDone(groupId)
  if self.plotFinishData and self.plotFinishData.groupId == groupId then
    SFSNetwork.SendMessage(MsgDefines.EndDetectEventTalk, self.plotFinishData.uuid)
  end
  self.plotFinishData = nil
end

function RadarCenterDataManager:UpdateBuildersAllianceDrop(isFarmer)
  if self.events ~= nil then
    for uuid, data in pairs(self.events) do
      if data then
        data:UpdateBuildersAllianceDrop(isFarmer)
      end
    end
  end
end

function RadarCenterDataManager:Description()
  local info = self.detectInfo
  if not info then
    return "DetectInfo is null."
  end
  local sb = StringBuilder.New()
  sb:AppendLine("\229\164\167\229\174\182\229\165\189\239\188\140\230\136\145\230\152\175\233\155\183\232\190\190")
  sb:AppendLine(string.format("lv:%s", info.level))
  sb:AppendLine(string.format("power:%s", info.power))
  sb:AppendLine(string.format("completeNum:%s", info.completeNum))
  sb:AppendLine(string.format("eventNum:%s", info.eventNum))
  sb:AppendLine(string.format("signal:%s", info.signal))
  sb:AppendLine(string.format("resetNum:%s", info.resetNum))
  sb:AppendLine(string.format("specialOpsOrder:%s", info.specialOpsOrder))
  sb:AppendLine(string.format("rewardLevel:%s", info.rewardLevel))
  sb:AppendLine("----------")
  local events = self.events or {}
  sb:AppendLine(string.format("\229\189\147\229\137\141\228\186\139\228\187\182\230\149\176\233\135\143\228\184\186:%s", table.count(events)))
  for k, v in pairs(events) do
    sb:Append(v:Description())
  end
  return sb:ToString()
end

function RadarCenterDataManager:TryInitActTreasureViewTab()
  if self.festivalparty_broad_config_tab == nil then
    self.festivalparty_broad_config_tab = {}
    local dataStr = LuaEntry.DataConfig:TryGetStr("festivalparty_broad_config", "k1")
    local dataArr = string.string2array_i_oneSep(dataStr, "|")
    for k, v in pairs(dataArr) do
      self.festivalparty_broad_config_tab[v] = true
    end
  end
end

function RadarCenterDataManager:GetIsActTreasureUseOldView(eventId)
  self:TryInitActTreasureViewTab()
  local useOldView = false
  if self.festivalparty_broad_config_tab[eventId] then
    useOldView = true
  end
  return useOldView
end

function RadarCenterDataManager:RefreshZombieBusDetectData()
  self:CheckToUpdateZombieBusTrainTypeInfo()
  self:CheckToAddFakeZombieBusTrainInCDEvent()
  self.nextToForceRefreshZombieBusTrainTime = nil
  if self.fakeZombieBusTrainInCDEvent then
    self.nextToForceRefreshZombieBusTrainTime = self.fakeZombieBusTrainInCDEvent.nextRefreshSTime
  elseif self.zombieBusTrainEventInfo and self.zombieBusTrainEventInfo.endTime > UITimeManager:GetInstance():GetServerTime() then
    self.nextToForceRefreshZombieBusTrainTime = self.zombieBusTrainEventInfo.endTime
  end
end

function RadarCenterDataManager:UpdateZombieBusTrainArriveCity(msg)
  if not msg then
    return
  end
  self.zombieBusTrainArriveInCityData = msg.detectBusInfo
  EventManager:GetInstance():Broadcast(EventId.DetectZombieBusCityDataChange)
end

function RadarCenterDataManager:IsZombieBusTrainEventComplete()
  if not self.zombieBusTrainEventInfo then
    return true
  end
  for i, v in ipairs(self.zombieBusTrainEventInfo) do
    if v and v.isPass == 0 then
      return false
    end
  end
  return true
end

function RadarCenterDataManager:GetZombieBusTrainEventBusList()
  if not self.zombieBusTrainEventInfo then
    return nil
  end
  return self.zombieBusTrainEventInfo.busList
end

function RadarCenterDataManager:GetZombieBusTrainCityData()
  return self.zombieBusTrainArriveInCityData
end

function RadarCenterDataManager:CheckToUpdateZombieBusTrainTypeInfo()
  self.zombieBusTrainProgressData = nil
  if self.detectTypeProgressDatas then
    for i, data in pairs(self.detectTypeProgressDatas) do
      if tonumber(i) == DetectEventType.ZOMBIE_BUS_TRAIN then
        self.zombieBusTrainProgressData = data
        break
      end
    end
  end
end

function RadarCenterDataManager:GetEventRefreshCDMillSec(type)
  if not self.eventRefreshCd then
    self.eventRefreshCd = {}
    local key1 = "detect_config"
    if LuaEntry.Player:IsMonopolyDetectB() then
      key1 = "detect_config_new"
    end
    local str = LuaEntry.DataConfig:TryGetStr(key1, "k28")
    if not string.IsNullOrEmpty(str) then
      local eventParams = string.split(str, "|")
      if eventParams then
        for i, param in ipairs(eventParams) do
          local paramPairs = string.split(param, ";")
          if paramPairs[1] then
            local eventType = tonumber(paramPairs[1])
            local cd = paramPairs[2] and tonumber(paramPairs[2]) or 10
            self.eventRefreshCd[eventType] = cd * 60 * 1000
          end
        end
      end
    end
  end
  return self.eventRefreshCd[type]
end

function RadarCenterDataManager:CheckToAddFakeZombieBusTrainInCDEvent()
  self.fakeZombieBusTrainInCDEvent = nil
  local zombieBusDetectIsOpen = LuaEntry.DataConfig:CheckSwitch("detect_zombiebus")
  if not zombieBusDetectIsOpen then
    return
  end
  if self.zombieBusTrainProgressData == nil or self.zombieBusTrainProgressData.order == 0 then
    return
  end
  if self.zombieBusTrainEventInfo == nil and self.zombieBusTrainProgressData.order >= self.zombieBusTrainProgressData.maxOrder then
    return
  end
  local showZombieBusTrainEvent = self.zombieBusTrainEventInfo ~= nil and (self.zombieBusTrainEventInfo.state == DetectEventState.DETECT_EVENT_STATE_FINISHED or self.zombieBusTrainEventInfo.endTime > UITimeManager:GetInstance():GetServerTime())
  if showZombieBusTrainEvent then
    return
  end
  local eventCompleteTime = self.zombieBusTrainProgressData.completeTime
  local cfgRefreshMinTimeMillSeconds = self:GetEventRefreshCDMillSec(DetectEventType.ZOMBIE_BUS_TRAIN)
  local tomorrowZeroTime = UITimeManager:GetInstance():GetTomorrowZero()
  local nextRefreshServerTime = tomorrowZeroTime
  if eventCompleteTime and eventCompleteTime ~= 0 then
    local assumeNextRefreshServerTime = eventCompleteTime + cfgRefreshMinTimeMillSeconds
    if tomorrowZeroTime < assumeNextRefreshServerTime then
      nextRefreshServerTime = assumeNextRefreshServerTime
    else
      nextRefreshServerTime = 0 < self.zombieBusTrainProgressData.num and assumeNextRefreshServerTime or tomorrowZeroTime
    end
  end
  self.fakeZombieBusTrainInCDEvent = {
    nextRefreshSTime = nextRefreshServerTime + 1500
  }
end

function RadarCenterDataManager:GetZombieBusTrainVerbs()
  if not self.zombieBusTrainVers then
    local verStr = LuaEntry.DataConfig:TryGetStr(ITEM_DETECT_ZOMBIE_BUS_CONFIG_KEY, "k4", "")
    self.zombieBusTrainVers = string.split(verStr, ";")
  end
  return self.zombieBusTrainVers
end

function RadarCenterDataManager:ClickAttackWorldZombieBus(busData, busIndex, eventUuid, position, euler)
  local param = self:GetAttackZombieBusFightParam(busData, busIndex, eventUuid, true)
  DataCenter.LWBattleManager:Enter(param)
  self:OnEnterZombieBusBattle(busIndex, true, position, euler)
end

function RadarCenterDataManager:GetLastZombieBusBattleEnterPosAndEuler()
  return self.lastAttackZombieBusPosition, self.lastAttackZombieBusEuler
end

function RadarCenterDataManager:OnEnterZombieBusBattle(busIndex, isInWorld, position, euler)
  self.lastAttackZombieBusPosition = position
  self.lastAttackZombieBusEuler = euler
  self.lastAttackZombieBusInWorld = isInWorld
  self.lastAttackZombieBusIndex = busIndex
end

function RadarCenterDataManager:GetAttackZombieBusFightParam(busData, busIndex, eventUuid, isInWorld)
  local param = {}
  param.type = busData.type == 1 and PVEType.Parkour or PVEType.FakePVP
  param.enterType = PVEEnterType.DetectZombieBusTrain
  param.levelId = tonumber(busData.param) or 0
  local sceneId = LocalController:instance():getValue("detect_zombie_bus", busData.busId, "scene_id")
  param.sceneId = sceneId or 0
  param.extraData = {}
  param.extraData.isInWorld = isInWorld
  param.extraData.busId = busData.busId
  param.extraData.busIndex = busIndex
  param.extraData.eventUuid = eventUuid
  return param
end

function RadarCenterDataManager:GetZombieBusTrainEvent()
  return self.zombieBusTrainEventInfo, self.zombieBusTrainProgressData and self.zombieBusTrainProgressData.order or 0
end

function RadarCenterDataManager:GetFakeZombieBusTrainEvent()
  return self.fakeZombieBusTrainInCDEvent
end

function RadarCenterDataManager:GetNextTimeToForceRefreshZombieBusTrain()
  return self.nextToForceRefreshZombieBusTrainTime
end

local cityZombieBusXDelta = 10
local cityZombieBusXCenter = 103
local cityZombieBusBaseZ = 32

function RadarCenterDataManager:GetCityZombieBusPosXZ(index, total)
  local isOdd = total % 2 > 0
  local baseDelta = 0
  local middle = math.ceil(total / 2)
  local multiScale = 1
  local indexDelta = 0
  if isOdd then
    baseDelta = 0
    indexDelta = index - middle
    multiScale = 0 < indexDelta and 1 or -1
  else
    baseDelta = cityZombieBusXDelta / 2
    indexDelta = index - middle
    indexDelta = 0 < indexDelta and indexDelta - 1 or indexDelta
    multiScale = 0 < index - middle and 1 or -1
  end
  return cityZombieBusXCenter + indexDelta * cityZombieBusXDelta + baseDelta * multiScale, cityZombieBusBaseZ
end

function RadarCenterDataManager:GetNextOneCanAttackZombieBusData(curBusIndex)
  local busList = self:GetZombieBusTrainEventBusList()
  if not busList then
    return
  end
  local busCount = #busList
  if busCount == 0 or curBusIndex <= 1 then
    return
  end
  local startIndex = curBusIndex > busCount and busCount or curBusIndex - 1
  for i = startIndex, 1, -1 do
    local busData = busList[i]
    if busData and busData.isPass == 0 then
      return busData, i
    end
  end
end

function RadarCenterDataManager:GetOneCanAttackZombieBusData(busList)
  if not busList or #busList == 0 then
    return
  end
  for i = #busList, 1, -1 do
    local busData = busList[i]
    if busData and busData.isPass == 0 then
      return busData, i
    end
  end
end

function RadarCenterDataManager:SaveZombieBusReward(msg)
  self.recentZombieBusRewardMsg = msg
end

function RadarCenterDataManager:GetRecentZombieBusReward()
  return self.recentZombieBusRewardMsg
end

function RadarCenterDataManager:RequestToJumpZombieBusTrain(eventUuid, JumpType)
  if self.targetJumpEventUuid then
    return
  end
  self.targetJumpEventUuid = eventUuid
  local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(eventUuid)
  if data ~= nil and data.template ~= nil and data.template.type == DetectEventType.ZOMBIE_BUS_TRAIN then
    local zombieBusArriveData = self:GetZombieBusTrainCityData()
    local cityZombieBusListData = zombieBusArriveData and zombieBusArriveData.busList
    if JumpType == DetectEventZombieBusTrainJumpToType.RadarUI then
      if cityZombieBusListData then
        local nextCanAttackData, index = self:GetOneCanAttackZombieBusData(cityZombieBusListData)
        local cityPosition = Vector3(0, 0, 0)
        if nextCanAttackData and index then
          local x, z = self:GetCityZombieBusPosXZ(index, #cityZombieBusListData)
          cityPosition.x = x
          cityPosition.z = z
        else
          local x, z = self:GetCityZombieBusPosXZ(1, 1)
          cityPosition.x = x
          cityPosition.z = z
        end
        GoToUtil.GotoCityPos(cityPosition, CS.SceneManager.World.InitZoom, 0, nil)
        self.targetJumpEventUuid = nil
      else
        local marchUUId = data.marchUuid
        SFSNetwork.SendMessage(MsgDefines.GetWorldMarchCurPos, marchUUId)
      end
    elseif JumpType == DetectEventZombieBusTrainJumpToType.WorldBattle then
      local marchUUId = data.marchUuid
      SFSNetwork.SendMessage(MsgDefines.GetWorldMarchCurPos, marchUUId)
    elseif JumpType == DetectEventZombieBusTrainJumpToType.CityBattle then
      local cityPosition = self.lastAttackZombieBusPosition
      if not cityPosition then
        cityPosition = Vector3(0, 0, 0)
        local x, z = self:GetCityZombieBusPosXZ(1, 1)
        cityPosition.x = x
        cityPosition.z = z
      end
      GoToUtil.GotoCityPos(cityPosition, CS.SceneManager.World.InitZoom, 0, nil)
      self.targetJumpEventUuid = nil
    end
  end
end

function RadarCenterDataManager:DoGoToWorldMarchCurPoint(msg)
  if self.targetJumpEventUuid ~= nil then
    local errCode = msg.errorCode
    if not errCode then
      local eventUuid = self.targetJumpEventUuid
      local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(eventUuid)
      if data ~= nil and data.template ~= nil and data.template.type == DetectEventType.ZOMBIE_BUS_TRAIN and data.marchUuid ~= nil and data.marchUuid == msg.uuid then
        do
          local zombieBusArriveData = self:GetZombieBusTrainCityData()
          local cityZombieBusListData = zombieBusArriveData and zombieBusArriveData.busList
          local lastAttackPosition = self.lastAttackZombieBusPosition
          local lastAttackEuler = self.lastAttackZombieBusEuler
          if cityZombieBusListData and self:GetOneCanAttackZombieBusData(cityZombieBusListData) then
            local myPointInfo = CS.SceneManager.World:GetMyPointInfo()
            local worldPosition = myPointInfo and SceneUtils.TileIndexToWorld(myPointInfo.pointIndex or 0, ForceChangeScene.World) or lastAttackPosition or Vector3(0, 0, 0)
            GoToUtil.GotoWorldPos(worldPosition, nil, nil, nil, nil, nil)
          elseif msg.curPoint then
            GoToUtil.MoveToWorldPointAndOpen(msg.curPoint, data.type, data.marchUuid)
          else
            do
              local worldPosition = lastAttackPosition or Vector3(0, 0, 0)
              GoToUtil.GotoWorldPos(worldPosition, nil, nil, function()
                local busList = DataCenter.RadarCenterDataManager:GetZombieBusTrainEventBusList()
                if busList then
                  DataCenter.ZombieBusTrainEntityManager:DoPlayFakeZombieBusDead(worldPosition, lastAttackEuler or Vector3(0, 0, 0), busList, eventUuid)
                end
              end, nil, nil)
            end
          end
        end
      end
    end
    self.targetJumpEventUuid = nil
  end
end

function RadarCenterDataManager:ClaimDetectEventRewardByEventData(data)
  local resourceItemNum = 0
  local soldierItemNum = 0
  table.walk(data.rewardList, function(_, v)
    if v.rewardType == RewardType.RESOURCE_ITEM then
      resourceItemNum = resourceItemNum + v.count
      if data.template and data.template.type == DetectEventType.RESCUE and v.itemId and LocalController:instance():hasLine(TableName.LW_Soldier, tostring(v.itemId)) then
        soldierItemNum = soldierItemNum + v.count
      end
    end
  end)
  if 0 <= resourceItemNum and DataCenter.ResourceItemDataManager:CheckIsStorageFull(resourceItemNum) then
    return false
  end
  if 0 < soldierItemNum then
    local number = math.modf(LuaEntry.Effect:GetGameEffect(EffectDefine.LW_SOLDIER_MAX_STOCK))
    local playerNumber = DataCenter.SoldierDataManager:GetPlayerSoldiersTotalNum()
    local maxCount = number - playerNumber
    if soldierItemNum > maxCount then
      UIUtil.TryShowConfirm(TodayNoSecondConfirmType.DetectRescueSodlierFull, Localization:GetString("radar_army_01"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        SFSNetwork.SendMessage(MsgDefines.DetectEventRewardReceive, data.uuid)
        DataCenter.RadarFakeUIMarchManager:AddClaimingTask(data.uuid)
      end, function()
      end, nil, nil, false, nil, nil)
    else
      SFSNetwork.SendMessage(MsgDefines.DetectEventRewardReceive, data.uuid)
      DataCenter.RadarFakeUIMarchManager:AddClaimingTask(data.uuid)
    end
  else
    SFSNetwork.SendMessage(MsgDefines.DetectEventRewardReceive, data.uuid)
    DataCenter.RadarFakeUIMarchManager:AddClaimingTask(data.uuid)
  end
  return true
end

RadarCenterDataManager.__init = __init
RadarCenterDataManager.__delete = __delete
RadarCenterDataManager.UpdateDetectEventInfo = UpdateDetectEventInfo
RadarCenterDataManager.GetDetectEventRewardBack = GetDetectEventRewardBack
RadarCenterDataManager.GetClaimLevelReward = GetClaimLevelReward
RadarCenterDataManager.UpdateOneDetectEventInfo = UpdateOneDetectEventInfo
RadarCenterDataManager.UpdateDetectInfo = UpdateDetectInfo
RadarCenterDataManager.UpgradeDetectPowerInfo = UpgradeDetectPowerInfo
RadarCenterDataManager.GetDetectEventInfoUuids = GetDetectEventInfoUuids
RadarCenterDataManager.GetDetectEventInfo = GetDetectEventInfo
RadarCenterDataManager.GetDetectInfo = GetDetectInfo
RadarCenterDataManager.GetDetectInfoLevel = GetDetectInfoLevel
RadarCenterDataManager.GetDetectInfoRewardLevel = GetDetectInfoRewardLevel
RadarCenterDataManager.GetDetectInfoPower = GetDetectInfoPower
RadarCenterDataManager.GetDetectInfoCompleteNum = GetDetectInfoCompleteNum
RadarCenterDataManager.GetDetectInfoNextRefreshTime = GetDetectInfoNextRefreshTime
RadarCenterDataManager.RemoveDetectEventInfo = RemoveDetectEventInfo
RadarCenterDataManager.GetPowerRewardList = GetPowerRewardList
RadarCenterDataManager.GetFinishedDetectEventNum = GetFinishedDetectEventNum
RadarCenterDataManager.GetUnFinishedDetectEventNum = GetUnFinishedDetectEventNum
RadarCenterDataManager.InitData = InitData
RadarCenterDataManager.GetDetectEventData = GetDetectEventData
RadarCenterDataManager.GetDetectEventInfoByPointId = GetDetectEventInfoByPointId
RadarCenterDataManager.GetDetectEventInfoByType = GetDetectEventInfoByType
RadarCenterDataManager.IsCanUpdate = IsCanUpdate
RadarCenterDataManager.GetUpgradeItem = GetUpgradeItem
RadarCenterDataManager.IsDetectEventDoing = IsDetectEventDoing
RadarCenterDataManager.GetSpecialEventInfo = GetSpecialEventInfo
RadarCenterDataManager.GetRadarRallyFinishedNum = GetRadarRallyFinishedNum
RadarCenterDataManager.StartDetectEventPve = StartDetectEventPve
RadarCenterDataManager.GetMaxDetectNum = GetMaxDetectNum
RadarCenterDataManager.IsCanReset = IsCanReset
RadarCenterDataManager.ResetDetectEvent = ResetDetectEvent
RadarCenterDataManager.HandleResetData = HandleResetData
RadarCenterDataManager.GetResetNum = GetResetNum
RadarCenterDataManager.UpdateEventNum = UpdateEventNum
RadarCenterDataManager.FindMonsterBoss = FindMonsterBoss
RadarCenterDataManager.HandleFindMonsterBossBack = HandleFindMonsterBossBack
RadarCenterDataManager.GetRadarMonsterList = GetRadarMonsterList
RadarCenterDataManager.GetOneInfoByEventTypeAndState = GetOneInfoByEventTypeAndState
RadarCenterDataManager.GetOneInfoByEventTypeAndPara = GetOneInfoByEventTypeAndPara
RadarCenterDataManager.CheckGuideOpenBuildBubble = CheckGuideOpenBuildBubble
RadarCenterDataManager.GetNextSpecialEventRefreshTime = GetNextSpecialEventRefreshTime
RadarCenterDataManager.GetSpecialEvent = GetSpecialEvent
RadarCenterDataManager.GetEventInfoByPointId = GetEventInfoByPointId
RadarCenterDataManager.GetRadarBubbleOpenMainCityLevel = GetRadarBubbleOpenMainCityLevel
RadarCenterDataManager.IsDetectEventUIFirstOpen = IsDetectEventUIFirstOpen
RadarCenterDataManager.RecordDetectEventUIFirstOpen = RecordDetectEventUIFirstOpen
RadarCenterDataManager.IsDetectEventFirstOpen = IsDetectEventFirstOpen
RadarCenterDataManager.RecordDetectEventFirstOpen = RecordDetectEventFirstOpen
RadarCenterDataManager.GetDetectEventsInfoByEventId = GetDetectEventsInfoByEventId
RadarCenterDataManager.IsDetectEventShowTip = IsDetectEventShowTip
RadarCenterDataManager.RecordDetectTriggerTime = RecordDetectTriggerTime
RadarCenterDataManager.GetDetectTriggerTime = GetDetectTriggerTime
RadarCenterDataManager.GetCurEventNum = GetCurEventNum
RadarCenterDataManager.InitDetectFirstGotoPlotDict = InitDetectFirstGotoPlotDict
RadarCenterDataManager.GetFirstGotoPlotIdByDetectType = GetFirstGotoPlotIdByDetectType
RadarCenterDataManager.GetDetectFirstGotoPoint = GetDetectFirstGotoPoint
RadarCenterDataManager.RecordDetectFirstGotoPoint = RecordDetectFirstGotoPoint
RadarCenterDataManager.TryDetectFirstGotoPlot = TryDetectFirstGotoPlot
RadarCenterDataManager.GetHelperEventDataByBuildUid = GetHelperEventDataByBuildUid
RadarCenterDataManager.GetCityEventDataByPointIndex = GetCityEventDataByPointIndex
RadarCenterDataManager.UpdateHelperRecordTab = UpdateHelperRecordTab
RadarCenterDataManager.RecordCurHelpTab = RecordCurHelpTab
RadarCenterDataManager.AddOneHelpRecordUid = AddOneHelpRecordUid
RadarCenterDataManager.GetBeHelpedDetectUid = GetBeHelpedDetectUid
RadarCenterDataManager.GeteHelperRecordTab = GeteHelperRecordTab
RadarCenterDataManager.GetDetectHelpTypeCostNum = GetDetectHelpTypeCostNum
RadarCenterDataManager.GetDetectEventFakePVPTypeCostNum = GetDetectEventFakePVPTypeCostNum
RadarCenterDataManager.AddCacheDetectEventRewardInfo = AddCacheDetectEventRewardInfo
RadarCenterDataManager.ClearCacheDetectEventRewardList = ClearCacheDetectEventRewardList
RadarCenterDataManager.GetCacheDetectEventRewardList = GetCacheDetectEventRewardList
RadarCenterDataManager.UnlockDetectEventRewardCacheModel = UnlockDetectEventRewardCacheModel
RadarCenterDataManager.OnDeclareWar = OnDeclareWar
RadarCenterDataManager.OnSetMainWorldPointId = OnSetMainWorldPointId
RadarCenterDataManager.GetNotFinishDetectEventInfoByPointId = GetNotFinishDetectEventInfoByPointId
RadarCenterDataManager.GetDetectEventCount = GetDetectEventCount
return RadarCenterDataManager
