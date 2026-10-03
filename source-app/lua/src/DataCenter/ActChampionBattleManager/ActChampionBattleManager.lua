local ActChampionBattleInfo = require("DataCenter.ActChampionBattleManager.ActChampionBattleInfo")
local ActChampionBattleReportList = require("DataCenter.ActChampionBattleManager.ActChampionBattleReportList")
local ActChampionBattleBetRecordsInfo = require("DataCenter.ActChampionBattleManager.ActChampionBattleBetRecordsInfo")
local ActChampionBattleManager = BaseClass("ActChampionBattleManager")

local function __init(self)
  self.entranceOpenState = false
  self.redReason = nil
  self.redStartTime = nil
  self.totalFightRound = -1
  self.needShowRecord = false
  EventManager:GetInstance():AddListener(EventId.UpdateTask, self.UpdateActTaskState)
end

local function __delete(self)
  EventManager:GetInstance():AddListener(EventId.UpdateTask, self.UpdateActTaskState)
  self.championBattleInfo = nil
  self.championBattleReportList = nil
  self.needShowRecord = nil
end

local function RefreshChampionBattleInfo(self, message)
  if self.championBattleInfo == nil then
    self.championBattleInfo = ActChampionBattleInfo.New()
  end
  self.championBattleInfo:parseServerData(message)
  local currentWin = self.championBattleInfo.winRound or 0
  local currentLose = self.championBattleInfo.loseRound or 0
  if self.totalFightRound ~= -1 and self.totalFightRound ~= currentWin + currentLose then
    self.needShowRecord = true
  end
  self.totalFightRound = currentWin + currentLose
  EventManager:GetInstance():Broadcast(EventId.ChampionBattleDataRefresh)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

local function GetNeedShowRecord(self)
  return self.needShowRecord
end

local function ResetNeedShowRecord(self)
  self.needShowRecord = false
end

local function RefreshChampionBattleTeamInfo(self, message, notSendEvent)
  if self.championBattleInfo == nil then
    self.championBattleInfo = ActChampionBattleInfo.New()
  end
  self.championBattleInfo:UpdateFormationInfo(message)
  EventManager:GetInstance():Broadcast(EventId.OnUpdateTeamDataEvent)
end

local function RefreshChampionBattleReportList(self, message)
  if self.championBattleReportList == nil then
    self.championBattleReportList = ActChampionBattleReportList.New()
  end
  self.championBattleReportList:ParseServerData(message)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LFChampionBattleFight)
end

local function UpdateActTaskState(self, taskId)
end

local function GetChampionBattleInfo(self)
  return self.championBattleInfo
end

local function GetChampionBattleReportList(self)
  return self.championBattleReportList
end

local function GetFormationData(self, index)
  if self.championBattleInfo ~= nil then
    return self.championBattleInfo:GetFormationData(index)
  end
  return nil
end

local function GetFormationHeroPic(self, index)
  if self.championBattleInfo ~= nil then
    return self.championBattleInfo:GetFormationHeroPic(index)
  end
  return nil
end

local function GetFormationIsOpen(self, index)
  local function checkBuilding(buildType)
    local build = DataCenter.BuildManager:GetFunbuildByItemID(buildType)
    
    return build and build.level > 0
  end
  
  if index == 1 then
    return checkBuilding(BuildingTypes.FUN_BUILD_TRAINFIELD_1)
  end
  if index == 2 then
    return checkBuilding(BuildingTypes.FUN_BUILD_TRAINFIELD_2)
  end
  if index == 3 then
    return checkBuilding(BuildingTypes.FUN_BUILD_TRAINFIELD_3)
  end
  if index == 4 then
    return checkBuilding(BuildingTypes.FUN_BUILD_TRAINFIELD_4)
  end
  return false
end

local function GetHeroIndexInFormation(self, heroUUid)
  if self.championBattleInfo ~= nil then
    return self.championBattleInfo:GetHeroIndexInFormation(heroUUid)
  end
  return 0
end

local function CheckIsOver(self)
  local isOver = true
  if self.championBattleInfo ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local endTime = self.championBattleInfo.endTime
    if curTime < endTime then
      isOver = false
    end
  end
  return isOver
end

local function CheckIsOpen(self)
  local isOpen = true
  isOpen = self.championBattleInfo ~= nil
  return isOpen
end

local function GetEntranceOpenState(self)
  return self.entranceOpenState
end

local function SetEntranceOpenState(self, state)
  self.entranceOpenState = state
  if self.entranceOpenState then
    local mainBuildLV = DataCenter.BuildManager.MainLv
    local showLv = LuaEntry.DataConfig:TryGetNum("champ_battle", "k3")
    if mainBuildLV >= showLv then
      self:SendActChampBattleDataRefreshCmd()
    end
  end
  EventManager:GetInstance():Broadcast(EventId.ChampionBattleEntranceNotice)
end

local function RefreshRedPoint(self, msg)
  self.redStartTime = msg.startTime
  self.redReason = msg.reason
  self:CheckEntranceRed(self.redStartTime, self.redReason)
end

local function GetRedPointKey(self)
  return "Act_ChampionBattle_" .. self.redStartTime .. "_" .. self.redReason
end

local function ShowRedPointKey(self)
  if self.redStartTime == nil or self.redReason == nil then
    return false
  end
  local hasOpened = Setting:GetBool(self:GetRedPointKey(), false)
  return not hasOpened
end

local function CheckEntranceRed(self, startTime, reason)
  EventManager:GetInstance():Broadcast(EventId.ChampionBattleEntranceNotice)
end

local function SetEntranceRed(self)
  Setting:SetBool(self:GetRedPointKey(), true)
  EventManager:GetInstance():Broadcast(EventId.ChampionBattleEntranceNotice)
end

local function GetChampionPosterState(self, startTime)
  local state = Setting:GetBool("Act_ChampionBattle_Poster" .. startTime, true)
  return state
end

local function SetChampionPosterState(self, startTime, state)
  Setting:SetBool("Act_ChampionBattle_Poster" .. startTime, state)
end

local function GetChampionStrongestPoster(self, type, startTime)
  local localPrivateKey = "Act_ChampionStrongestPoster" .. startTime .. "_type_"
  local state = Setting:GetBool(localPrivateKey .. type, true)
  return state
end

local function SetChampionStrongestPoster(self, type, startTime, state)
  local localPrivateKey = "Act_ChampionStrongestPoster" .. startTime .. "_type_"
  local postfix
  if type == ChampionBattlePosterType.Strongest_Eight then
  elseif type == ChampionBattlePosterType.Strongest_Four then
    Setting:SetBool(localPrivateKey .. ChampionBattlePosterType.Strongest_Eight, state)
  elseif type == ChampionBattlePosterType.Strongest_Two then
    Setting:SetBool(localPrivateKey .. ChampionBattlePosterType.Strongest_Eight, state)
    Setting:SetBool(localPrivateKey .. ChampionBattlePosterType.Strongest_Four, state)
  elseif type == ChampionBattlePosterType.Strongest_King then
    Setting:SetBool(localPrivateKey .. ChampionBattlePosterType.Strongest_Eight, state)
    Setting:SetBool(localPrivateKey .. ChampionBattlePosterType.Strongest_Four, state)
    Setting:SetBool(localPrivateKey .. ChampionBattlePosterType.Strongest_Two, state)
  end
  Setting:SetBool(localPrivateKey .. type, state)
end

local function SwitchRecordsData(self, msg)
  local list = {}
  if msg == nil then
    return list
  end
  for i = 1, #msg.recordArray do
    local records = msg.recordArray[i]
    local player = records.playerInfo
    local betState = records.state
    for i = 1, #records.betRecords do
      local itemData = records.betRecords[i]
      local data = ActChampionBattleBetRecordsInfo.New()
      if i == 1 then
        data:parseServerData(1, player, itemData, records.state)
      else
        data:parseServerData(3, player, itemData, records.state)
      end
      table.insert(list, data)
    end
    local data = ActChampionBattleBetRecordsInfo.New()
    data:parseServerData(2, player, records.totalWinCount, records.state)
    table.insert(list, data)
  end
  return list
end

local function SetRankIndexFormat(self, rankIndex)
  local rankIndexStr = ""
  if rankIndex == nil or rankIndex == "" then
    return rankIndexStr
  end
  if 999 < rankIndex then
    rankIndexStr = "999+"
  elseif 500 < rankIndex then
    rankIndexStr = "500+"
  elseif 200 < rankIndex then
    rankIndexStr = "200+"
  elseif 150 < rankIndex then
    rankIndexStr = "150+"
  elseif rankIndex <= 0 then
    rankIndexStr = "-"
  else
    rankIndexStr = tostring(rankIndex)
  end
  return rankIndexStr
end

local function SendActChampionBattleSingUpCmd(self)
  SFSNetwork.SendMessage(MsgDefines.ACT_CHAMPIONBATTLE_SINGUP)
end

local function SendActChampBattleDataRefreshCmd(self)
  SFSNetwork.SendMessage(MsgDefines.ACT_CHAMPIONBATTLE_DATA_REFRESH)
end

local function SendActChampionBattleRewardCmd(self, boxIndex)
  SFSNetwork.SendMessage(MsgDefines.ACT_CHAMPIONBATTLE_REWARD, boxIndex)
end

local function SendActChampBattleRewardPreviewCmd(self)
  SFSNetwork.SendMessage(MsgDefines.ACT_CHAMPIONBATTLE_REWARD_VIEW)
end

local function SendActChampionBattleReportListCmd(self)
  SFSNetwork.SendMessage(MsgDefines.ACT_CHAMPIONBATTLE_REPORT_LIST)
end

local function SendActChampionBattleReportDescCmd(self, type, reportId)
  SFSNetwork.SendMessage(MsgDefines.ACT_CHAMPIONBATTLE_REPORT_DESC, type, reportId)
end

local function SendActChampionStrongestReportDescCmd(self, phase, location)
  SFSNetwork.SendMessage(MsgDefines.ACT_CHAMPIONSTRONGEST_REPORT_LIST, phase, location)
end

local function SendChampionBattleBetViewCmd(self, phase, location)
  SFSNetwork.SendMessage(MsgDefines.ACT_CHAMPIONBATTLE_BET_VIEW, phase, location)
end

local function SendChampionBattleBetCmd(self, phase, location, bettedIndex, count)
  SFSNetwork.SendMessage(MsgDefines.ACT_CHAMPIONBATTLE_BET, phase, location, bettedIndex, count)
end

local function SendChampionBattleBetRecordCmd(self)
  SFSNetwork.SendMessage(MsgDefines.ACT_CHAMPIONBATTLE_BET_RECORD)
end

local function SendChampionBattleFormationSave(self, formations)
  SFSNetwork.SendMessage(MsgDefines.ACT_CHAMPIONBATTLE_SAVE_FORMATION, formations)
end

local function SendChampionBattleRankData(self)
  SFSNetwork.SendMessage(MsgDefines.ACT_CHAMPIONBATTLE_GET_RANK_DATA)
end

local function GetLastRecordRound(self)
  local saveKey = self:GetRecordKey()
  if saveKey == nil then
    return nil
  end
  local saveStr = Setting:GetString(saveKey, "")
  if string.IsNullOrEmpty(saveKey) then
    return 0, 0, 0
  end
  local vec = string.split(saveStr, "_")
  if vec == nil or table.count(vec) ~= 3 then
    return 1, 0, 0
  end
  return toInt(vec[1]), toInt(vec[2]), toInt(vec[3])
end

local function GetCurrentRecordRound(self)
  if self.championBattleInfo == nil or self.championBattleInfo:GetCurState() ~= Activity_ChampionBattle_Stage_State.Auditions or self.championBattleInfo.hasSingUp ~= 1 then
    return nil
  end
  local currentRound = self.championBattleInfo.curRound
  local currentWin = self.championBattleInfo.winRound
  local currentLose = self.championBattleInfo.loseRound
  return currentRound, currentWin, currentLose
end

local function SaveLastRecordRound(self)
  local saveKey = self:GetRecordKey()
  if saveKey == nil then
    return
  end
  local currentRound, currentWin, currentLose = self:GetCurrentRecordRound()
  if currentRound == nil then
    return
  end
  local saveStr = tostring(currentRound) .. "_" .. tostring(currentWin) .. "_" .. tostring(currentLose)
  Setting:SetString(saveKey, saveStr)
end

local function GetRecordKey(self)
  if self.championBattleInfo == nil then
    return nil
  end
  return "Act_ChampionBattle_" .. self.championBattleInfo.startTime .. "_" .. LuaEntry.Player.uid
end

local function NeedShowRecord(self)
  local lastRound, lastWin, lastLose = self:GetLastRecordRound()
  if lastRound == nil then
    return false
  end
  if self.championBattleInfo == nil or self.championBattleInfo:GetCurState() ~= Activity_ChampionBattle_Stage_State.Auditions or self.championBattleInfo.hasSingUp ~= 1 then
    return false
  end
  local currentWin = self.championBattleInfo.winRound or 0
  local currentLose = self.championBattleInfo.loseRound or 0
  if lastLose + lastWin == currentWin + currentLose then
    return false
  end
  return true
end

ActChampionBattleManager.__init = __init
ActChampionBattleManager.__delete = __delete
ActChampionBattleManager.RefreshChampionBattleInfo = RefreshChampionBattleInfo
ActChampionBattleManager.RefreshChampionBattleReportList = RefreshChampionBattleReportList
ActChampionBattleManager.UpdateActTaskState = UpdateActTaskState
ActChampionBattleManager.GetChampionBattleInfo = GetChampionBattleInfo
ActChampionBattleManager.GetChampionBattleReportList = GetChampionBattleReportList
ActChampionBattleManager.CheckIsOver = CheckIsOver
ActChampionBattleManager.CheckIsOpen = CheckIsOpen
ActChampionBattleManager.GetEntranceOpenState = GetEntranceOpenState
ActChampionBattleManager.SetEntranceOpenState = SetEntranceOpenState
ActChampionBattleManager.RefreshRedPoint = RefreshRedPoint
ActChampionBattleManager.CheckEntranceRed = CheckEntranceRed
ActChampionBattleManager.SetEntranceRed = SetEntranceRed
ActChampionBattleManager.GetChampionPosterState = GetChampionPosterState
ActChampionBattleManager.SetChampionPosterState = SetChampionPosterState
ActChampionBattleManager.GetChampionStrongestPoster = GetChampionStrongestPoster
ActChampionBattleManager.SetChampionStrongestPoster = SetChampionStrongestPoster
ActChampionBattleManager.SwitchRecordsData = SwitchRecordsData
ActChampionBattleManager.SendActChampionBattleSingUpCmd = SendActChampionBattleSingUpCmd
ActChampionBattleManager.SendActChampBattleDataRefreshCmd = SendActChampBattleDataRefreshCmd
ActChampionBattleManager.SendActChampionBattleRewardCmd = SendActChampionBattleRewardCmd
ActChampionBattleManager.SendActChampBattleRewardPreviewCmd = SendActChampBattleRewardPreviewCmd
ActChampionBattleManager.SendActChampionBattleReportListCmd = SendActChampionBattleReportListCmd
ActChampionBattleManager.SendActChampionBattleReportDescCmd = SendActChampionBattleReportDescCmd
ActChampionBattleManager.SendActChampionStrongestReportDescCmd = SendActChampionStrongestReportDescCmd
ActChampionBattleManager.SendChampionBattleBetViewCmd = SendChampionBattleBetViewCmd
ActChampionBattleManager.SendChampionBattleBetCmd = SendChampionBattleBetCmd
ActChampionBattleManager.SendChampionBattleBetRecordCmd = SendChampionBattleBetRecordCmd
ActChampionBattleManager.SetRankIndexFormat = SetRankIndexFormat
ActChampionBattleManager.SendChampionBattleFormationSave = SendChampionBattleFormationSave
ActChampionBattleManager.GetFormationData = GetFormationData
ActChampionBattleManager.GetFormationHeroPic = GetFormationHeroPic
ActChampionBattleManager.GetFormationIsOpen = GetFormationIsOpen
ActChampionBattleManager.GetHeroIndexInFormation = GetHeroIndexInFormation
ActChampionBattleManager.RefreshChampionBattleTeamInfo = RefreshChampionBattleTeamInfo
ActChampionBattleManager.GetRedPointKey = GetRedPointKey
ActChampionBattleManager.ShowRedPointKey = ShowRedPointKey
ActChampionBattleManager.SendChampionBattleRankData = SendChampionBattleRankData
ActChampionBattleManager.GetLastRecordRound = GetLastRecordRound
ActChampionBattleManager.SaveLastRecordRound = SaveLastRecordRound
ActChampionBattleManager.GetRecordKey = GetRecordKey
ActChampionBattleManager.NeedShowRecord = NeedShowRecord
ActChampionBattleManager.GetCurrentRecordRound = GetCurrentRecordRound
ActChampionBattleManager.GetNeedShowRecord = GetNeedShowRecord
ActChampionBattleManager.ResetNeedShowRecord = ResetNeedShowRecord
return ActChampionBattleManager
