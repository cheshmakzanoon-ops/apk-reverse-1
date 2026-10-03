local LWActivityAlarmClockManager = BaseClass("LWActivityAlarmClockManager")
local LWActivityAlarmClockInfo = require("DataCenter.LWActivityAlarmClock.LWActivityAlarmClockInfo")

function LWActivityAlarmClockManager:__init()
  self.activityAlarmClockList = {}
  self.needShowMainUITopAlarmClockList = {}
  self.localRecordAlarmClockDict = CommonUtil.PlayerPrefsGetTable(SettingKeys.ActivityAlarmClockCloseTips, {})
end

function LWActivityAlarmClockManager:__delete()
  self.activityAlarmClockList = nil
  self.needShowMainUITopAlarmClockList = nil
  self.localRecordAlarmClockDict = nil
end

function LWActivityAlarmClockManager:TrySendGetActivityAlarmClockDataMsg()
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if allianceData then
    SFSNetwork.SendMessage(MsgDefines.GetActivityClockInfo)
  end
end

function LWActivityAlarmClockManager:InitData(message)
  self.activityAlarmClockList = {}
  self.needShowMainUITopAlarmClockList = {}
  local list = message.list
  if list ~= nil then
    for k, v in pairs(list) do
      local info = LWActivityAlarmClockInfo.New()
      info:InitData(v)
      if info:NeedShow() then
        table.insert(self.activityAlarmClockList, info)
        if self:CheckNeedShowMainUITop(info) then
          table.insert(self.needShowMainUITopAlarmClockList, info)
        end
      end
    end
    table.sort(self.activityAlarmClockList, function(a, b)
      local timeA
      if a.status == ActivityAlarmClockState.NoOpen then
        timeA = a.startTime or 0
      else
        timeA = a.endTime or 0
      end
      local timeB
      if b.status == ActivityAlarmClockState.NoOpen then
        timeB = b.startTime or 0
      else
        timeB = b.endTime or 0
      end
      return timeA < timeB
    end)
    EventManager:GetInstance():Broadcast(EventId.GetActivityAlarmClockData)
  end
end

function LWActivityAlarmClockManager:UpdateData(message)
  if message.id then
    local id = message.id
    local param = 0
    if message.param then
      param = message.param
    end
    local info
    local info_index = 0
    for i = 1, table.count(self.activityAlarmClockList) do
      local activityAlarmClockInfo = self.activityAlarmClockList[i]
      param = DataCenter.LWActivityAlarmClockManager:SplitActivityAlarmClockParamData(activityAlarmClockInfo.template.type, param)
      if activityAlarmClockInfo.id == id and activityAlarmClockInfo.param == param then
        info = activityAlarmClockInfo
        info_index = i
        break
      end
    end
    if info == nil then
      info = LWActivityAlarmClockInfo.New()
      info:InitData(message)
      if info:NeedShow() then
        table.insert(self.activityAlarmClockList, info)
        if self:CheckNeedShowMainUITop(info) then
          table.insert(self.needShowMainUITopAlarmClockList, info)
        end
      end
    else
      info:InitData(message)
      local hasData, targetIndex = self:JudgeNeedShowMainUITopAlarmClockHasData(info)
      if not info:NeedShow() then
        if 0 < info_index then
          table.remove(self.activityAlarmClockList, info_index)
        end
        if hasData then
          table.remove(self.needShowMainUITopAlarmClockList, targetIndex)
        end
      elseif self:CheckNeedShowMainUITop(info) and not hasData then
        table.insert(self.needShowMainUITopAlarmClockList, info)
      elseif hasData and not self:CheckNeedShowMainUITop(info) then
        table.remove(self.needShowMainUITopAlarmClockList, targetIndex)
      end
    end
    EventManager:GetInstance():Broadcast(EventId.UpdateActivityAlarmClockData)
  end
end

function LWActivityAlarmClockManager:CheckNeedShowMainUITop(activityAlarmClockInfo)
  if activityAlarmClockInfo.template and activityAlarmClockInfo.template.top_timer ~= -1 then
    local state = activityAlarmClockInfo:GetActivityAlarmClockState()
    local localIsValid = self:CheckLocalAlarmClockDataIsValid(activityAlarmClockInfo)
    if state == ActivityAlarmClockState.NoOpen and not localIsValid then
      if activityAlarmClockInfo.template.type == ActivityAlarmClockType.AllyDrill and activityAlarmClockInfo.status == 1 then
        return true
      end
      return true
    end
  end
  return false
end

function LWActivityAlarmClockManager:OnLeaveAlliance()
  self.activityAlarmClockList = {}
  self.needShowMainUITopAlarmClockList = {}
end

function LWActivityAlarmClockManager:GetActivityAlarmClockData()
  return self.activityAlarmClockList
end

function LWActivityAlarmClockManager:GetShowServerTimeMode()
  if LuaEntry.Player:GetUserSetting(UserSettingKey.ActivityAlarmClock) == nil then
    return true
  end
  return LuaEntry.Player:GetUserSetting(UserSettingKey.ActivityAlarmClock) == "1"
end

function LWActivityAlarmClockManager:SetShowServerTimeMode(showServerTime)
  local value = showServerTime and "1" or "0"
  SFSNetwork.SendMessage(MsgDefines.UserSetting, UserSettingKey.ActivityAlarmClock, value)
end

function LWActivityAlarmClockManager:SplitActivityAlarmClockParamData(activityAlarmClockType, paramData)
  if activityAlarmClockType == ActivityAlarmClockType.AllianceMark then
    return paramData
  end
  return paramData
end

function LWActivityAlarmClockManager:GetActivityAlarmClockSurplusDayToStartTime(info, showServerTime)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local diff = -1
  if showServerTime then
    diff = UITimeManager:GetInstance():GetBetweenDaysForServerTime(info.startTime / 1000, curTime / 1000)
  else
    diff = UITimeManager:GetInstance():GetBetweenDaysForLocal(info.startTime / 1000, curTime / 1000)
  end
  return diff
end

function LWActivityAlarmClockManager:JumpTo(activityAlarmClockInfo)
  local template = activityAlarmClockInfo.template
  if template.type ~= ActivityAlarmClockType.AllianceMark and template.type ~= ActivityAlarmClockType.Meteorite and template.type ~= ActivityAlarmClockType.DesertWall and template.type ~= ActivityAlarmClockType.Epidemic and template.type ~= ActivityAlarmClockType.BFWinter and not LuaEntry.Player:IsLoginSourceServer() then
    UIUtil.ShowTipsId("activity_clock_go_err_01")
    return
  end
  if template.type == ActivityAlarmClockType.AllyDrill then
    DataCenter.AllyDrillDataManager:JumpToDrill()
  elseif template.type == ActivityAlarmClockType.ReserveSiege then
    local allianceMarkData = DataCenter.WorldFavoDataManager:GetAllianceBookmarkByType(MarkType.Alliance_Attack, LuaEntry.Player:GetSourceServerId())
    if allianceMarkData and allianceMarkData.IsSelfAlliance and allianceMarkData:IsSelfAlliance() then
      local pointIndex = allianceMarkData:GetPointIndex()
      local v3 = SceneUtils.TileIndexToWorld(pointIndex, ForceChangeScene.World)
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      end)
    end
  elseif template.type == ActivityAlarmClockType.AllianceMark then
    local allianceMarkData = DataCenter.WorldFavoDataManager:GetAllianceBookmarkByType(activityAlarmClockInfo.param, LuaEntry.Player:GetSourceServerId())
    if allianceMarkData and allianceMarkData.IsSelfAlliance and allianceMarkData:IsSelfAlliance() then
      local pointIndex = allianceMarkData:GetPointIndex()
      local v3 = SceneUtils.TileIndexToWorld(pointIndex, ForceChangeScene.World)
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      end, allianceMarkData.server)
    end
  elseif template.type == ActivityAlarmClockType.ZombieRush then
    local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.ZombieRush.Type)
    if table.count(actList) > 0 then
      GoToUtil.GoActWindow({
        tonumber(actList[1].id)
      })
    end
  elseif template.type == ActivityAlarmClockType.DesertWall then
    RaceEntranceUtil.GotoOpenView(EnumActivity.ActDragon.Type)
  elseif template.type == ActivityAlarmClockType.MonsterInvasion then
    DataCenter.ActivityMonsterInvasionDataManager:GotoInvasionAisillaPoint(true)
  elseif template.type == ActivityAlarmClockType.KingdomPosition then
    if LuaEntry.Player:AtHomeNow() then
      SFSNetwork.SendMessage(MsgDefines.GetKingdomPositions, LuaEntry.Player:GetSourceServerId())
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIOfficialApply, {anim = true}, activityAlarmClockInfo.positionId)
    else
      UIUtil.ShowTipsId(500019)
    end
  elseif template.type == ActivityAlarmClockType.AllianceTrain then
    RailwayUtil.OpenUITrainPrepare(TrainPreparePage.Passenger)
  elseif template.type == ActivityAlarmClockType.AllianceStar then
    local hasAlliance = LuaEntry.Player:IsInAlliance()
    if hasAlliance then
      GoToUtil.GotoOpenView(UIWindowNames.UILWAlMain)
    else
      local params = {guide = false}
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
    end
  elseif template.type == ActivityAlarmClockType.Meteorite then
    DataCenter.ActMeteoriteBattleManager:OpenActWindowPls()
  elseif template.type == ActivityAlarmClockType.KillZombie then
    local newAlData = DataCenter.ActivityKillZombieManager.newAlData
    local point = newAlData and newAlData.bossPointId or 0
    local serverId = newAlData and newAlData.bossServerId or nil
    DataCenter.ActivityKillZombieManager:GotoWorldPos(point, function(point)
      GoToUtil.OnClickWorldPoint(point)
    end, serverId)
  elseif template.type == ActivityAlarmClockType.Epidemic then
    RaceEntranceUtil.GotoOpenView(EnumActivity.ActEpidemic.Type)
  elseif template.type == ActivityAlarmClockType.QueenOfBlood then
    local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.OffSeason1QueenOfBlood.Type)
    if table.count(actList) > 0 then
      GoToUtil.GoActWindow({
        tonumber(actList[1].id)
      })
    end
  elseif template.type == ActivityAlarmClockType.AllyDrillBooking then
    local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.AllyDrill.Type)
    if table.count(actList) > 0 then
      GoToUtil.GoActWindow({
        tonumber(actList[1].id)
      })
    end
  elseif template.type == ActivityAlarmClockType.DsbDuel then
    RaceEntranceUtil.GotoOpenView(EnumActivity.ActDsbDuel.Type)
  elseif template.type == ActivityAlarmClockType.ChampionDuel then
    DataCenter.NewPeakArenaManager:GoToChampionDuelMain()
  elseif template.type == ActivityAlarmClockType.BFWinter then
    RaceEntranceUtil.GotoOpenView(EnumActivity.ActWinterStorm.Type)
  elseif template.type == ActivityAlarmClockType.S0AllianceBossAppoint then
    DataCenter.S0AllianceBossDataManager:GotoActivityPanel()
  elseif template.type == ActivityAlarmClockType.S0AllianceBossBattle then
    DataCenter.S0AllianceBossDataManager:GotoActivityPanel()
  end
end

local function CompareActivityAlarmClockInfo(k1, k2)
  if k1.showMainUITopStartTime == k2.showMainUITopStartTime then
    if k1.id == k2.id then
      return k1.param < k2.param
    end
    return k1.id < k2.id
  end
  return k1.showMainUITopStartTime < k2.showMainUITopStartTime
end

function LWActivityAlarmClockManager:GetNeedShowMainUITopAlarmClockData()
  local count = table.count(self.needShowMainUITopAlarmClockList)
  if 0 < count then
    table.sort(self.needShowMainUITopAlarmClockList, CompareActivityAlarmClockInfo)
    for i = 1, count do
      local activityAlarmClockInfo = self.needShowMainUITopAlarmClockList[i]
      if self:CheckNeedShowMainUITop(activityAlarmClockInfo) then
        return activityAlarmClockInfo
      end
    end
  end
  return nil
end

function LWActivityAlarmClockManager:JudgeNeedShowMainUITopAlarmClockHasData(info)
  local count = table.count(self.needShowMainUITopAlarmClockList)
  for i = 1, count do
    local activityAlarmClockInfo = self.needShowMainUITopAlarmClockList[i]
    if activityAlarmClockInfo.id == info.id and activityAlarmClockInfo.param == info.param then
      return true, i
    end
  end
  return false, -1
end

function LWActivityAlarmClockManager:RemoveNeedShowMainUITopAlarmClock(info)
  for i = 1, table.count(self.needShowMainUITopAlarmClockList) do
    local activityAlarmClockInfo = self.needShowMainUITopAlarmClockList[i]
    if activityAlarmClockInfo.id == info.id and activityAlarmClockInfo.param == info.param then
      table.remove(self.needShowMainUITopAlarmClockList, i)
      break
    end
  end
end

function LWActivityAlarmClockManager:RecordLocalAlarmClockData(info)
  local key = self:GenerateLocalRecordId(info.id, info.param)
  self.localRecordAlarmClockDict[key] = tostring(info.startTime)
  CommonUtil.PlayerPrefsSetTable(SettingKeys.ActivityAlarmClockCloseTips, self.localRecordAlarmClockDict)
end

function LWActivityAlarmClockManager:CheckLocalAlarmClockDataIsValid(info)
  local key = self:GenerateLocalRecordId(info.id, info.param)
  if self.localRecordAlarmClockDict[key] then
    local recordStartTime = tonumber(self.localRecordAlarmClockDict[key])
    if recordStartTime ~= info.startTime then
      return false
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local showMainUITopStartTime, showMainUITopEndTime = self:CalcShowMainUITopStartTimeAndEndTime(recordStartTime, info.template)
    if curTime >= showMainUITopStartTime and curTime <= showMainUITopEndTime then
      return true
    end
  end
  return false
end

function LWActivityAlarmClockManager:CalcShowMainUITopStartTimeAndEndTime(startTime, template)
  local showMainUITopStartTime = startTime - template.top_timer * 1000
  local showMainUITopEndTime = showMainUITopStartTime + template.reminder * 1000
  return showMainUITopStartTime, showMainUITopEndTime
end

function LWActivityAlarmClockManager:GenerateLocalRecordId(id, type)
  local newId = id * 100 + type
  return newId
end

function LWActivityAlarmClockManager:GetLocalRecordIdAndType(id)
  local configId = id - id % 100
  local type = id % 1000
  return configId, type
end

function LWActivityAlarmClockManager:AlarmClockTipNeedShowTop()
  return LuaEntry.DataConfig:CheckSwitch("clock_tips_show_in_info")
end

return LWActivityAlarmClockManager
