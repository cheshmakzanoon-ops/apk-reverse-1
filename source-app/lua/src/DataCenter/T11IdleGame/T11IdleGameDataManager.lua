local T11IdleGameDataManager = BaseClass("T11IdleGameDataManager")
local T11IdleGameMainData = require("DataCenter/T11IdleGame/IdleBattle/Data/T11IdleGameMainData")
local T11IdleGameIdleInfoData = require("DataCenter/T11IdleGame/IdleBattle/Data/T11IdleGameIdleInfoData")
local T11IdleGameEventData = require("DataCenter/T11IdleGame/IdleBattle/Data/T11IdleGameEventData")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local Localization = CS.GameEntry.Localization

function T11IdleGameDataManager:__init()
  self.idleGameInfoData = nil
  self.idleGameMainData = nil
  self.idleGameCanIdle = nil
  self.eventNodeUpdateList = nil
  self.nodeUpdateTimer = nil
  self.lastChallengeBossId = nil
  self.gameEventDict = {}
  self.gameEventList = {}
  self.InvitePlayersDict = {}
  self.newSpecialEventList = {}
  self.newEventList = {}
  self.shareCd = -1
  self.lastShareTimestamp = 0
end

function T11IdleGameDataManager:__delete()
  self.idleGameInfoData = nil
  self.idleGameMainData = nil
  self.idleGameCanIdle = nil
  self.eventNodeUpdateList = nil
  if self.nodeUpdateTimer ~= nil then
    self.nodeUpdateTimer:Stop()
    self.nodeUpdateTimer = nil
  end
  self.lastChallengeBossId = nil
  self.gameEventDict = nil
  self.gameEventList = nil
  self.InvitePlayersDict = nil
  self.newSpecialEventList = nil
  self.newEventList = nil
  self.shareCd = -1
  self.lastShareTimestamp = 0
end

function T11IdleGameDataManager:UpdateMainData(data)
  if self.idleGameMainData == nil then
    self.idleGameMainData = T11IdleGameMainData.New()
  end
  self.idleGameMainData:UpdateData(data)
end

function T11IdleGameDataManager:GetMainData()
  return self.idleGameMainData
end

function T11IdleGameDataManager:GetIdleGameCurLevelId()
  local mainData = self:GetMainData()
  if mainData == nil then
    return 0
  end
  return mainData:GetCurLevelId()
end

function T11IdleGameDataManager:GetIdleGameCurLevel()
  local levelId = self:GetIdleGameCurLevelId()
  if levelId == 0 then
    return 0
  end
  local template = DataCenter.T11IdleGameTemplateManager:GetLevelTemplateById(levelId)
  if template then
    return template.stage_order
  end
  return 0
end

function T11IdleGameDataManager:UpdateIdleInfoData(data, levelId)
  if self.idleGameInfoData == nil then
    self.idleGameInfoData = T11IdleGameIdleInfoData.New()
  end
  self.idleGameInfoData:UpdateData(data, levelId)
end

function T11IdleGameDataManager:GetIdleInfoData()
  return self.idleGameInfoData
end

function T11IdleGameDataManager:ClearIdleInfoData()
  if self.idleGameInfoData then
    self.idleGameInfoData:ClearData()
  end
end

function T11IdleGameDataManager:SendGetIdleGameMainMessage()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  DataCenter.T11IdleGameManager:PrintEditorCustomLog("send get main at: " .. curTime .. "," .. UITimeManager:GetInstance():TimeStampToTimeForServer(curTime))
  SFSNetwork.SendMessage(MsgDefines.IdleGameMain)
end

function T11IdleGameDataManager:OnGetIdleGameMainMessage(msg)
  if msg == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameDataManager:OnGetIdleGameMainMessage call with nil data")
    return
  end
  self:UpdateMainData(msg)
  self:UpdateNewEventTipsData(msg.idleGameIdleInfo)
  if msg.changeLevel then
    self:UpdateMainData(msg.changeLevel.idleGameMain)
    if msg.changeLevel.reward ~= nil then
      DataCenter.RewardManager:AddRewards(msg.changeLevel.reward)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.T11IdleGameOnGetIdleGameMainMessage)
  EventManager:GetInstance():Broadcast(EventId.T11IdleGameRefreshAlertTowerBubble)
end

function T11IdleGameDataManager:SendStartIdleGameMessage()
  SFSNetwork.SendMessage(MsgDefines.IdleGameStart)
end

function T11IdleGameDataManager:OnStartIdleGameMessage(msg)
  if msg == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameDataManager:OnStartIdleGameMessage call with nil data")
    return
  end
  self:UpdateIdleInfoData(msg)
  self:UpdateMainData({
    startGameLeftTime = msg.startGameLeftTime
  })
  EventManager:GetInstance():Broadcast(EventId.T11IdleGameOnStartIdleGameMessage)
  EventManager:GetInstance():Broadcast(EventId.T11IdleGameRefreshAlertTowerBubble)
  self.eventNodeUpdateList = nil
  if not table.IsNullOrEmpty(msg.eventNodeUpdateTime) then
    self.eventNodeUpdateList = {}
    for i, v in pairs(msg.eventNodeUpdateTime) do
      table.insert(self.eventNodeUpdateList, {time = v, index = i})
    end
    table.sort(self.eventNodeUpdateList, function(a, b)
      return a.time < b.time
    end)
  end
  self:RefreshNextNodeUpdateTimer()
end

function T11IdleGameDataManager:SendRewardUpdateMessage(nodeData)
  if nodeData == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameDataManager:SendRewardUpdateMessage call with nil data")
    return
  end
  if self.idleGameInfoData == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameDataManager:SendRewardUpdateMessage call with nil idleGameInfoData")
    return
  end
  local curIndex = self.idleGameInfoData:GetPassedNodeIndex()
  local index = nodeData:GetIndex()
  if curIndex >= index then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameDataManager:SendRewardUpdateMessage index invalid")
    return
  end
  DataCenter.T11IdleGameManager:PrintEditorCustomLog("T11IdleGameDataManager:SendRewardUpdateMessage index " .. index)
  nodeData:PrintTriggerSeverTimeDebugLog()
  SFSNetwork.SendMessage(MsgDefines.IdleGameRewardUpdate, {index = index})
end

function T11IdleGameDataManager:OnRewardUpdateMessage(msg)
  if msg == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameDataManager:OnRewardUpdateMessage call with nil data")
    return
  end
  self:UpdateIdleInfoData(msg)
  self:AddNewEventTipsData(msg)
  EventManager:GetInstance():Broadcast(EventId.T11IdleGameOnRewardUpdateMessage)
end

function T11IdleGameDataManager:SendRewardReceiveMessage()
  if self.idleGameInfoData == nil or self.idleGameInfoData:IsRewardPoolEmpty() then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.IdleGameRewardReceive)
end

function T11IdleGameDataManager:OnRewardReceiveMessage(msg)
  if msg == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameDataManager:OnRewardReceiveMessage call with nil data")
    return
  end
  if msg.reward ~= nil then
    DataCenter.RewardManager:AddRewards(msg.reward)
    DataCenter.RewardManager:ShowCommonReward(msg)
  end
  self:UpdateIdleInfoData(msg.idleGameIdleInfo)
  EventManager:GetInstance():Broadcast(EventId.T11IdleGameOnRewardReceiveMessage)
end

function T11IdleGameDataManager:SendIdleGameEndMessage()
  if self.idleGameInfoData == nil or not self.idleGameInfoData:IsCanEnd() then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.IdleGameEnd)
end

function T11IdleGameDataManager:OnEndMessage(msg)
  if msg == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameDataManager:OnEndMessage call with nil data")
    return
  end
  self:ClearIdleInfoData()
  self:UpdateIdleInfoData(msg.idleGameIdleInfo)
  if msg.surpriseBoxGainTime then
    self:UpdateMainData({
      surpriseBoxGainTime = msg.surpriseBoxGainTime
    })
  end
  if msg.reward ~= nil then
    DataCenter.RewardManager:AddRewards(msg.reward)
  end
  EventManager:GetInstance():Broadcast(EventId.T11IdleGameOnShowEndGameReward, msg)
  EventManager:GetInstance():Broadcast(EventId.T11IdleGameRefreshAlertTowerBubble)
end

function T11IdleGameDataManager:SendChallengeBossMessage(bossId)
  SFSNetwork.SendMessage(MsgDefines.IdleGameChallenge, bossId)
  self.lastChallengeBossId = bossId
end

function T11IdleGameDataManager:OnChallengeBossMessage(msg)
  if msg == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameDataManager:OnChallengeBossMessage call with nil data")
    return
  end
  if msg.reward ~= nil then
    DataCenter.RewardManager:AddRewards(msg.reward)
  end
  self:UpdateMainData(msg)
  if msg.changeLevel then
    self:UpdateMainData(msg.changeLevel.idleGameMain)
    if msg.changeLevel.reward ~= nil then
      DataCenter.RewardManager:AddRewards(msg.changeLevel.reward)
    end
    EventManager:GetInstance():Broadcast(EventId.T11IdleGameRefreshAlertTowerBubble)
  end
  local evtData = msg
  evtData.challengeBoss = self.lastChallengeBossId
  EventManager:GetInstance():Broadcast(EventId.T11IdleGameOnChallengeBossMessage, evtData)
end

function T11IdleGameDataManager:SendOpenSurpriseBoxMessage()
  SFSNetwork.SendMessage(MsgDefines.IdleGameSurpriseOpen)
end

function T11IdleGameDataManager:OnOpenSurpriseBoxMessage(msg)
  if msg == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameDataManager:OnOpenSurpriseBoxMessage call with nil data")
    return
  end
  if msg.reward ~= nil then
    DataCenter.RewardManager:AddRewards(msg.reward)
  end
  EventManager:GetInstance():Broadcast(EventId.T11IdleGameOnOpenSurpriseBoxMessage, msg)
end

function T11IdleGameDataManager:OnInitMessage(msg)
  if msg == nil then
    return
  end
  self.eventNodeUpdateList = nil
  self.idleGameCanIdle = msg.idleGameCanIdle
  if not table.IsNullOrEmpty(msg.eventNodeUpdateTime) then
    self.eventNodeUpdateList = {}
    for i, v in pairs(msg.eventNodeUpdateTime) do
      table.insert(self.eventNodeUpdateList, {time = v, index = i})
    end
    table.sort(self.eventNodeUpdateList, function(a, b)
      return a.time < b.time
    end)
  end
  self:RefreshNextNodeUpdateTimer()
  EventManager:GetInstance():Broadcast(EventId.T11IdleGameOnInitMessage)
end

function T11IdleGameDataManager:RefreshNextNodeUpdateTimer()
  if self.nodeUpdateTimer ~= nil then
    self.nodeUpdateTimer:Stop()
    self.nodeUpdateTimer = nil
  end
  if not table.IsNullOrEmpty(self.eventNodeUpdateList) then
    local timeNow = UITimeManager:GetInstance():GetServerTime()
    for i, v in ipairs(self.eventNodeUpdateList) do
      if timeNow < v.time then
        local leftTime = math.floor((v.time - timeNow) / 1000 + 0.5)
        self.nodeUpdateTimer = TimerManager:GetInstance():DelayInvoke(function()
          if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWT11IdleGameBattleMain) and DataCenter.T11IdleGameManager:IsT11IdleGameFunctionOn() then
            self:SendGetIdleGameMainMessage()
          end
          self:RefreshNextNodeUpdateTimer()
        end, leftTime)
        break
      end
    end
  end
end

function T11IdleGameDataManager:GetIsServerAlertTowerBubbleShowRed()
  return checknumber(self.idleGameCanIdle) > 0
end

function T11IdleGameDataManager:GetStartGameAddTimePerDay()
  return LuaEntry.DataConfig:TryGetNum("idle_game_para", "k17", 0)
end

function T11IdleGameDataManager:GetStartGameLeftTimeLimit()
  return LuaEntry.DataConfig:TryGetNum("idle_game_para", "k18", 0)
end

function T11IdleGameDataManager:GetNewSpecialEventTipsData()
  return self.newSpecialEventList
end

function T11IdleGameDataManager:ClearNewSpecialEventTipsData()
  self.newSpecialEventList = {}
end

function T11IdleGameDataManager:GetLastEventTipsUpdateTime()
  return CommonUtil.PlayerPrefsGetLong("t11_idle_game_last_event_update_time", 0)
end

function T11IdleGameDataManager:SetLastEventTipsUpdateTime(time)
  CommonUtil.PlayerPrefsSetLong("t11_idle_game_last_event_update_time", time)
end

function T11IdleGameDataManager:UpdateNewEventTipsData(msg)
  self.newSpecialEventList = {}
  self.newEventList = {}
  local rewardEvents = msg.rewardEvents
  if rewardEvents == nil or #rewardEvents == 0 then
    return
  end
  local lastUpdateTime = self:GetLastEventTipsUpdateTime()
  DataCenter.T11IdleGameManager:PrintEditorCustomLog("T11IdleGameDataManager:UpdateNewEventTipsData lastUpdateTime: " .. lastUpdateTime)
  for i = 1, #rewardEvents do
    if not (lastUpdateTime > rewardEvents[i].getTime) then
      local eventData = T11IdleGameEventData.New()
      eventData:UpdateData(rewardEvents[i])
      local eventCfgData = DataCenter.T11IdleGameTemplateManager:GetGameEventTemplateById(eventData.eventId)
      if eventCfgData then
        if eventCfgData.event_type ~= Const.T11GameEventType.NormalEvent then
          DataCenter.T11IdleGameManager:PrintEditorCustomLog("T11IdleGameDataManager:UpdateNewEventTipsData add special event: " .. eventData.eventId .. " uuid: " .. eventData.uuid .. " time: " .. eventData.getTime)
          table.insert(self.newSpecialEventList, eventData)
        end
        table.insert(self.newEventList, eventData)
      end
    end
  end
  table.sort(self.newSpecialEventList, function(a, b)
    return a:GetEventTimestamp() > b:GetEventTimestamp()
  end)
end

function T11IdleGameDataManager:AddNewEventTipsData(msg)
  self.newSpecialEventList = self.newSpecialEventList or {}
  self.newEventList = self.newEventList or {}
  local rewardEvents = msg.rewardEvents
  if rewardEvents == nil or #rewardEvents <= 0 then
    return
  end
  local lastUpdateTime = self:GetLastEventTipsUpdateTime()
  DataCenter.T11IdleGameManager:PrintEditorCustomLog("T11IdleGameDataManager:AddNewEventTipsData lastUpdateTime: " .. lastUpdateTime)
  for i = 1, #rewardEvents do
    if not (lastUpdateTime > rewardEvents[i].getTime) then
      local eventData = T11IdleGameEventData.New()
      eventData:UpdateData(rewardEvents[i])
      local eventCfgData = DataCenter.T11IdleGameTemplateManager:GetGameEventTemplateById(eventData.eventId)
      if eventCfgData then
        if eventCfgData.event_type ~= Const.T11GameEventType.NormalEvent then
          DataCenter.T11IdleGameManager:PrintEditorCustomLog("T11IdleGameDataManager:AddNewEventTipsData add special event: " .. eventData.eventId .. " uuid: " .. eventData.uuid .. " time: " .. eventData.getTime)
          table.insert(self.newSpecialEventList, eventData)
        end
        table.insert(self.newEventList, eventData)
      end
    end
  end
end

function T11IdleGameDataManager:IsShowEventRedPointByMainMsg()
  self.newEventList = self.newEventList or {}
  local mainData = self:GetMainData()
  local canReceiveEventNum = mainData:GetCanReceiveEventNum() or 0
  return #self.newEventList > 0 or 0 < canReceiveEventNum
end

function T11IdleGameDataManager:IsShowEventRedPointByTaskList()
  self.newEventList = self.newEventList or {}
  self.gameEventList = self.gameEventList or {}
  local hasCanReceiveStateTask = false
  for i = 1, #self.gameEventList do
    if self.gameEventList[i].status == Const.TaskState.CanReceive then
      hasCanReceiveStateTask = true
      break
    end
  end
  return hasCanReceiveStateTask or #self.newEventList > 0
end

function T11IdleGameDataManager:IsShowEventRedPointByUpdateMsg()
  return #self.newEventList > 0
end

function T11IdleGameDataManager:CheckOpenTaskEventNewTipsView()
  local newEventList = self:GetNewSpecialEventTipsData()
  if newEventList and 0 < #newEventList then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIIdleGameTaskEventNewTips, {anim = true}, newEventList)
  end
  self:ClearNewSpecialEventTipsData()
end

function T11IdleGameDataManager:GetNewEventTipsData()
  return self.newEventList
end

function T11IdleGameDataManager:ClearNewEventTipsData()
  self.newEventList = {}
end

function T11IdleGameDataManager:SendIdleGameEventAllMessage()
  SFSNetwork.SendMessage(MsgDefines.IdleGameEventAll)
end

function T11IdleGameDataManager:ParseAllGameEvent(msg)
  if msg == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameDataManager:ParseAllGameEvent call with nil data")
    return
  end
  self.gameEventDict = {}
  self.gameEventList = {}
  for _, event in ipairs(msg.events) do
    self:AddOrUpdateEventData(event)
  end
  self:SortGameEventList()
end

function T11IdleGameDataManager:SendIdleGameEventPlotMessage(eventUuid)
  local param = {}
  param.eventUuid = eventUuid
  SFSNetwork.SendMessage(MsgDefines.IdleGameEventPlot, param)
end

function T11IdleGameDataManager:SendIdleGameEventGoods(eventUuid)
  local param = {}
  param.eventUuid = eventUuid
  SFSNetwork.SendMessage(MsgDefines.IdleGameEventGoods, param)
end

function T11IdleGameDataManager:SendIdleGameEventReceiveMessage(eventUuid)
  local param = {}
  param.eventUuid = eventUuid
  SFSNetwork.SendMessage(MsgDefines.IdleGameEventReceive, param)
end

function T11IdleGameDataManager:SendIdleGameEventGetMessage(playerUid, eventUuid, type)
  local param = {}
  param.playerUid = playerUid
  param.eventUuid = eventUuid
  param.type = type
  SFSNetwork.SendMessage(MsgDefines.IdleGameEventGet, param)
end

function T11IdleGameDataManager:SendIdleGameEventHelpMessage(playerUid, eventUuid, eventId)
  local param = {}
  param.playerUid = playerUid
  param.eventUuid = eventUuid
  param.eventId = eventId
  SFSNetwork.SendMessage(MsgDefines.IdleGameEventHelp, param)
end

function T11IdleGameDataManager:SendIdleGameEventBattleMessage(eventUuid, armyId, heroInfo, chipEquipGroup)
  local param = {}
  param.eventUuid = eventUuid
  param.armyId = armyId
  param.heroInfo = heroInfo
  param.chipEquipGroup = chipEquipGroup
  SFSNetwork.SendMessage(MsgDefines.IdleGameEventBattle, param)
end

function T11IdleGameDataManager:SendIdleGameEventDeleteMessage(eventUuid)
  local param = {}
  param.eventUuid = eventUuid
  SFSNetwork.SendMessage(MsgDefines.IdleGameEventDelete, param)
end

function T11IdleGameDataManager:AddOrUpdateEventData(data)
  self.gameEventDict = self.gameEventDict or {}
  self.gameEventList = self.gameEventList or {}
  if data == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameDataManager:AddOrUpdateEventData call with nil data")
    return
  end
  if self.gameEventDict[data.uuid] then
    self.gameEventDict[data.uuid]:UpdateData(data)
  else
    local eventData = T11IdleGameEventData.New()
    eventData:UpdateData(data)
    self.gameEventDict[data.uuid] = eventData
  end
  local isExistInList = false
  for i = 1, #self.gameEventList do
    if self.gameEventList[i].uuid == data.uuid then
      isExistInList = true
      self.gameEventList[i] = self.gameEventDict[data.uuid]
    end
  end
  if not isExistInList then
    table.insert(self.gameEventList, self.gameEventDict[data.uuid])
  end
end

function T11IdleGameDataManager:SortGameEventList()
  if self.gameEventList == nil then
    return
  end
  local normalEventList = {}
  local specialEventList = {}
  for i = 1, #self.gameEventList do
    local eventCfgData = DataCenter.T11IdleGameTemplateManager:GetGameEventTemplateById(self.gameEventList[i].eventId)
    if eventCfgData.event_type == Const.T11GameEventType.NormalEvent then
      table.insert(normalEventList, self.gameEventList[i])
    else
      table.insert(specialEventList, self.gameEventList[i])
    end
  end
  table.sort(normalEventList, function(a, b)
    return a:GetEventTimestamp() > b:GetEventTimestamp()
  end)
  table.sort(specialEventList, function(a, b)
    return a:GetEventTimestamp() > b:GetEventTimestamp()
  end)
  self.gameEventList = {}
  for i = 1, #specialEventList do
    table.insert(self.gameEventList, specialEventList[i])
  end
  for i = 1, #normalEventList do
    table.insert(self.gameEventList, normalEventList[i])
  end
end

function T11IdleGameDataManager:ParsePushGameEvent(msg)
  if msg == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameDataManager:ParsePushGameEvent call with nil data")
    return
  end
  for _, event in ipairs(msg.events) do
    if msg.status == TaskState.Received then
      self:RemoveEventData(event)
    else
      self:AddOrUpdateEventData(event)
    end
  end
  self:SortGameEventList()
end

function T11IdleGameDataManager:RemoveEventData(data)
  if self.gameEventDict == nil or self.gameEventList == nil then
    return
  end
  if data == nil then
    return
  end
  if self.gameEventDict[data.uuid] then
    self.gameEventDict[data.uuid] = nil
  end
  for i = 1, #self.gameEventList do
    if self.gameEventList[i].uuid == data.uuid then
      table.remove(self.gameEventList, i)
      break
    end
  end
end

function T11IdleGameDataManager:GetEventData(eventUuid)
  self.gameEventDict = self.gameEventDict or {}
  return self.gameEventDict[eventUuid]
end

function T11IdleGameDataManager:GetGameEventList()
  return self.gameEventList
end

function T11IdleGameDataManager:TryPlayPlot(eventUuid, plotId)
  if eventUuid and eventUuid ~= 0 and plotId and plotId ~= 0 and not self:IsRecordPlot(eventUuid, plotId) then
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = plotId, hideMainUI = false})
    self:SaveRecordPlot(eventUuid, plotId)
    return true
  end
  return false
end

function T11IdleGameDataManager:IsRecordPlot(eventUuid, plotId)
  self.recordGameEventPlotList = CommonUtil.PlayerPrefsGetTable(SettingKeys.T11GameEventPlot, {})
  for i = 1, #self.recordGameEventPlotList do
    local key = self.recordGameEventPlotList[i]
    local strList = string.split(key, "_")
    if tonumber(strList[1]) == tonumber(eventUuid) and tonumber(strList[2]) == tonumber(plotId) then
      return true
    end
  end
  return false
end

function T11IdleGameDataManager:SaveRecordPlot(eventUuid, plotId)
  local key = string.format("%d_%d", eventUuid, plotId)
  table.insert(self.recordGameEventPlotList, key)
  CommonUtil.PlayerPrefsSetTable(SettingKeys.T11GameEventPlot, self.recordGameEventPlotList)
end

function T11IdleGameDataManager:PlayPlotWithoutRecord(plotId)
  if plotId and plotId ~= 0 then
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = plotId, hideMainUI = false})
  end
end

function T11IdleGameDataManager:AddInvitePlayerInfoDict(eventUuid, helpUsers)
  self.InvitePlayersDict = self.InvitePlayersDict or {}
  local playerInfoList = {}
  for i = 1, #helpUsers do
    local playerInfo = DeepCopy(helpUsers[i])
    table.insert(playerInfoList, playerInfo)
  end
  self.InvitePlayersDict[eventUuid] = playerInfoList
end

function T11IdleGameDataManager:GetInvitePlayerInfoList(eventUuid)
  self.InvitePlayersDict = self.InvitePlayersDict or {}
  return self.InvitePlayersDict[eventUuid] or {}
end

function T11IdleGameDataManager:ShareToChat(eventPlayerUuid, eventUuid, eventId, questId)
  local share_param = {}
  share_param.post = PostType.T11IdleGameAllianceHelp
  share_param.postType = PostType.T11IdleGameAllianceHelp
  local data = {}
  data.eventPlayerUuid = eventPlayerUuid
  data.eventUuid = eventUuid
  data.eventId = eventId
  data.questId = questId
  share_param.param = data
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
end

function T11IdleGameDataManager:EnterBattle(levelId, eventUuid)
  DataCenter.LWBattleManager:Destroy()
  local param = {}
  param.type = PVEType.FakePVP
  param.enterType = PVEEnterType.T11IdleGameBattleEvent
  param.levelId = tonumber(levelId)
  param.sceneId = 51
  param.extraData = {}
  param.extraData.eventUuid = eventUuid
  param.extraData.levelId = tonumber(levelId)
  DataCenter.LWBattleManager:Enter(param)
end

function T11IdleGameDataManager:CheckOpenTaskEventAllianceHelpView(t)
  if t == nil then
    UIUtil.ShowTipsId("t11_idle_game_desc_84")
    return
  end
  if t.clientParam == Const.IdleGameEventGetType.GetDataAndOpenHelpView then
    if t.status == Const.TaskState.Received then
      UIUtil.ShowTipsId("t11_idle_game_desc_84")
      return
    end
    local param = {}
    param.playerUid = t.uid
    param.eventUuid = t.idleGameEvent.uuid
    param.idleGameEventMsg = t.idleGameEvent
    param.helpTimesDaily = t.helpTimesDaily
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIIdleGameTaskEventAllianceHelp, {anim = true}, param)
  end
  EventManager:GetInstance():Broadcast(EventId.T11IdleGameTaskEventInvitePlayers, {
    eventUuid = t.idleGameEvent.uuid,
    idleGameEventMsg = t.idleGameEvent,
    helpTimesDaily = t.helpTimesDaily
  })
end

function T11IdleGameDataManager:CanShareAllianceHelp()
  if self.shareCd == nil or self.shareCd < 0 then
    self.shareCd = tonumber(LuaEntry.DataConfig:TryGetStr("idle_game_para", "k8", 60))
  end
  local currentTime = UITimeManager:GetInstance():GetServerTime()
  local delta = currentTime - self.lastShareTimestamp
  if delta / 1000 >= self.shareCd then
    self.lastShareTimestamp = currentTime
    return true
  end
  return false
end

return T11IdleGameDataManager
