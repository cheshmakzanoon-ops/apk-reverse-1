local SeasonHunterManager = BaseClass("SeasonHunterManager")

function SeasonHunterManager:__init()
  self.init = false
  self.masteryGroup = {
    [MasteryHome.Gather] = {
      1309,
      1310,
      1311
    },
    [MasteryHome.Build] = {
      1409,
      1410,
      1411
    }
  }
  self.activityId = nil
  self.activityInfo = nil
  self.rankMap = nil
  self.rewardMap = nil
  self.historyList = nil
  self:AddListener()
end

function SeasonHunterManager:__delete()
  if self.updateSecondTimer then
    UpdateManager:GetInstance():RemoveSecondUpdate(self.updateSecondTimer)
    self.updateSecondTimer = nil
  end
  self:RemoveListener()
end

function SeasonHunterManager:Init()
  if not self:IsActive() then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.SeasonHunterGetActivityInfo)
end

function SeasonHunterManager:Startup()
end

function SeasonHunterManager:AddListener()
  EventManager:GetInstance():AddListenerWithSelf(EventId.OnEnterWorld, self.OnEnterWorld, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.BloodyNightSelfRefresh, self.BloodyNightSelfRefresh, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.SeasonHunterGetActivityInfo, self.CheckBattleStatus, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.LuaEntryEffectRefreshStatus, self.CheckBattleStatus, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.MSG_ITME_STATUS_TIME_CHANGE, self.CheckBattleStatus, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.LWSeasonRankRewardUpdate, self.LWSeasonRankRewardUpdate, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.MoveCitySuccess, self.OnMoveCitySuccess, self)
end

function SeasonHunterManager:RemoveListener()
  EventManager:GetInstance():RemoveListener2(EventId.OnEnterWorld, self.OnEnterWorld, self)
  EventManager:GetInstance():RemoveListener2(EventId.BloodyNightSelfRefresh, self.BloodyNightSelfRefresh, self)
  EventManager:GetInstance():RemoveListener2(EventId.SeasonHunterGetActivityInfo, self.CheckBattleStatus, self)
  EventManager:GetInstance():RemoveListener2(EventId.LuaEntryEffectRefreshStatus, self.CheckBattleStatus, self)
  EventManager:GetInstance():RemoveListener2(EventId.MSG_ITME_STATUS_TIME_CHANGE, self.CheckBattleStatus, self)
  EventManager:GetInstance():RemoveListener2(EventId.LWSeasonRankRewardUpdate, self.LWSeasonRankRewardUpdate, self)
  EventManager:GetInstance():RemoveListener2(EventId.MoveCitySuccess, self.OnMoveCitySuccess, self)
end

function SeasonHunterManager:InitData(data)
  self.activityId = data.id
  self:Init()
end

function SeasonHunterManager:GetConfigData(id)
  return DataCenter.SeasonHunterManager:GetConfigData(id)
end

function SeasonHunterManager:GetActivityInfo()
  if self.activityInfo == nil then
    self.activityInfo = {
      nightOpen = 0,
      wolfNum = 0,
      wolfNumOut = 0,
      endTime = 0,
      serverInfo = {},
      score = 0,
      matchRank = 0,
      joinTime = 0
    }
  end
  return self.activityInfo
end

function SeasonHunterManager:OnEnterWorld()
  if self:IsActive() then
    self:CheckShowBan()
  end
end

function SeasonHunterManager:IsActive(includePrepare)
  return SeasonUtil.IsSeasonActivityOpen(self.activityId, nil, includePrepare, true)
end

function SeasonHunterManager:GetActivityData(includePrepare)
  if not self:IsActive(includePrepare) then
    return
  end
  return DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
end

function SeasonHunterManager:IsBattleBegin()
  if self.activityInfo and UITimeManager:GetInstance():GetServerTime() < self.activityInfo.endTime and self.activityInfo.nightOpen == 1 then
    return true
  end
  if not self:IsActive() or UITimeManager:GetInstance():GetNowWeekdayIndex() == 6 then
    return false
  end
  local state, _, _, _, nightStalker = DataCenter.BloodyNightDataManager:GetBloodyNightState()
  if state ~= BloodyNightState.Bloody or nightStalker then
    return false
  end
  return true
end

function SeasonHunterManager:IsInBattle()
  if not self:IsBattleBegin() then
    return false
  end
  local statusId = EffectDefine.SEASON_DARKNESS_Status_Id_HUNTER
  if LuaEntry.Effect:HasStatus(statusId) and LuaEntry.Effect:GetStatusLayer(statusId) > 0 then
    return true
  end
  return false
end

function SeasonHunterManager:IsBanState()
  local battleInfo = DataCenter.SeasonHunterManager:GetActivityInfo()
  if battleInfo and battleInfo.serverInfo and not table.IsNullOrEmpty(battleInfo.serverInfo.banServerList) then
    return true
  end
  local banTime = self:GetBanTimeStamp()
  if banTime and 0 < banTime then
    return banTime < UITimeManager:GetInstance():GetServerTime()
  end
  return false
end

function SeasonHunterManager:GetBanTimeStamp()
  local battleInfo = DataCenter.SeasonHunterManager:GetActivityInfo()
  local startTime = battleInfo and battleInfo.startTime or 0
  if startTime <= 0 then
    return
  end
  local activity = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  local para = activity and activity.para
  if string.IsNullOrEmpty(para) then
    return
  end
  local params = string.split(para, "|")
  local banDuration = params[1] and tonumber(params[1])
  if not banDuration then
    return
  end
  local banTime = startTime + banDuration * 1000
  return banTime
end

function SeasonHunterManager:GetMasterySkillState(index_)
  local masteryData = DataCenter.MasteryManager:GetData()
  local homeId = masteryData and masteryData.home_id or MasteryHome.Gather
  local masteryGroup = self.masteryGroup[homeId] or {}
  local masteryGroupId = masteryGroup[index_ or 1] or 0
  if not masteryGroupId or masteryGroupId <= 0 then
    return homeId, MasterySkillState.None
  end
  return homeId, DataCenter.MasteryManager:GetMasteryGroupSkillState(masteryGroupId)
end

function SeasonHunterManager:CheckMasterySkillState()
  local homeId, skillState, _, masteryTemp, skillTemplate = DataCenter.SeasonHunterManager:GetMasterySkillState()
  if skillState == MasterySkillState.CD then
    return false
  end
  if not masteryTemp or not skillTemplate then
    return false
  end
  return skillState == MasterySkillState.Normal
end

function SeasonHunterManager:IsBattleServer(serverId, includeBan)
  local battleInfo = DataCenter.SeasonHunterManager:GetActivityInfo()
  if battleInfo and battleInfo.serverInfoList then
    serverId = tonumber(serverId or 0)
    for _, v in ipairs(battleInfo.serverInfoList) do
      if v.serverId == serverId then
        if includeBan or not v.banTime then
          return true
        end
        return UITimeManager:GetInstance():GetServerTime() < v.banTime
      end
    end
  end
  return false
end

function SeasonHunterManager:IsWarnServer(serverId)
  local battleInfo = DataCenter.SeasonHunterManager:GetActivityInfo()
  if not battleInfo or table.IsNullOrEmpty(battleInfo.serverInfoList) then
    return false
  end
  serverId = tonumber(serverId or 0)
  for _, v in ipairs(battleInfo.serverInfoList) do
    if v.serverId == serverId and v.banTime then
      return true
    end
  end
  return false
end

function SeasonHunterManager:IsBanServer(serverId)
  local battleInfo = DataCenter.SeasonHunterManager:GetActivityInfo()
  if not battleInfo or table.IsNullOrEmpty(battleInfo.serverInfoList) then
    return false
  end
  serverId = tonumber(serverId or 0)
  for _, v in ipairs(battleInfo.serverInfoList) do
    if v.serverId == serverId and v.banTime and UITimeManager:GetInstance():GetServerTime() > v.banTime then
      return true, v.banTime
    end
  end
  return false
end

function SeasonHunterManager:CheckBattleStatus()
  local isInBattle = self:IsInBattle()
  if isInBattle ~= self.lastInBattle then
    self.lastInBattle = isInBattle
    self.historyList = nil
    EventManager:GetInstance():Broadcast(EventId.SeasonHunterBattleStatus)
    if isInBattle then
    else
      self:CheckShowBan()
    end
  end
end

function SeasonHunterManager:BloodyNightSelfRefresh()
  if not self:IsActive() then
    return
  end
  self.lastRequestTimeStamp = nil
  TimerManager:GetInstance():DelayInvoke(function()
    self:RequestActivityInfoByDelta()
  end, math.random(0, 3))
end

function SeasonHunterManager:JoinBattle()
  if UITimeManager:GetInstance():GetNowWeekdayIndex() == 6 then
    UIUtil.ShowTipsId("season_s4_activity_1200011_tips13")
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonHunterConvert, {anim = true})
end

function SeasonHunterManager:GetLiftTime()
  local isInBattle = self:IsInBattle()
  if isInBattle then
    local activityInfo = self:GetActivityInfo()
    if activityInfo ~= nil then
      local liftTime = UITimeManager:GetInstance():GetServerSeconds() - math.modf(activityInfo.joinTime / 1000)
      return true, math.modf(liftTime)
    end
  end
  return false
end

function SeasonHunterManager:GetCurRewards()
  local _, liftTime = self:GetLiftTime()
  local showDatalist = DataCenter.SeasonHunterManager:GetTimeReward()
  for _, v in ipairs(showDatalist) do
    if liftTime >= v.minTime and liftTime < v.maxTime then
      return v.rewards
    end
  end
  return nil
end

function SeasonHunterManager:CheckShowBan()
  local isInBan, banTime = false
  if self:IsInBattle() then
    isInBan, banTime = self:IsBanServer(LuaEntry.Player:GetSelfServerId())
  end
  if isInBan ~= self.isInBan or isInBan ~= UIManager:GetInstance():IsWindowOpen(UIWindowNames.SeasonHunterWarning) then
    self.isInBan = isInBan
    if isInBan and banTime then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if banTime then
        local deltaTime = curTime - banTime + 100
        local nextTime = math.ceil(deltaTime / 60000) * 60000 + banTime
        local showTime = (nextTime - curTime) * 0.001
        self:ShowWarning("season_s4_activity_1200011_desc68", nextTime, showTime, nil, self.CheckShowBan, self)
      end
    else
      UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonHunterWarning)
    end
  end
  return self.isInBan
end

function SeasonHunterManager:ShowWarning(key, endTime, showTime, param, callback, callbackObj)
  local params = {
    showTime = showTime,
    msgId = key,
    param = param,
    endTime = endTime,
    callback = callback,
    callbackObj = callbackObj
  }
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.SeasonHunterWarning)
  if window and window.View and UIManager:GetInstance():IsWindowOpen(UIWindowNames.SeasonHunterWarning) then
    window.View:AddNewMsg(params)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonHunterWarning, {anim = true, playEffect = false}, params)
  end
end

local __RequestDelta = 20000

function SeasonHunterManager:RequestActivityInfoByDelta(force)
  if not force and self.lastRequestTimeStamp and self.lastRequestTimeStamp > 0 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime - self.lastRequestTimeStamp < __RequestDelta then
      return
    end
  end
  SFSNetwork.SendMessage(MsgDefines.SeasonHunterGetActivityInfo)
end

function SeasonHunterManager:GetMatchHistory(sendMsg)
  if sendMsg then
    SFSNetwork.SendMessage(MsgDefines.SeasonHunterGetMatchHis)
  end
  return self.historyList
end

function SeasonHunterManager:SeasonHunterGetRankList(t)
  if not self.rankMap then
    self.rankMap = {}
  end
  local selfData = t.owner
  local player = LuaEntry.Player
  local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  t.owner = {
    uid = player.uid,
    name = player.name,
    pic = player.pic,
    picVer = player.picVer,
    serverId = player:GetSourceServerId(),
    score = selfData.score,
    headFrame = player:GetHeadBgImg(),
    rank = selfData.rank,
    abbr = data and data.abbr or ""
  }
  self.rankMap[t.lbType] = t
  EventManager:GetInstance():Broadcast(EventId.SeasonHunterGetRankList, t)
end

function SeasonHunterManager:LWSeasonRankRewardUpdate(reward)
  if not self.rewardMap or self.rewardMap[reward.rankId] == nil then
    return
  end
  self.rewardMap[reward.rankId] = reward
  EventManager:GetInstance():Broadcast(EventId.SeasonHunterRewardInfo, reward)
end

function SeasonHunterManager:GetRankData(rankType, sendMsg)
  local value
  if self.rankMap then
    value = self.rankMap[rankType]
    if not value then
      sendMsg = true
    end
  end
  if sendMsg then
    SFSNetwork.SendMessage(MsgDefines.SeasonHunterGetRankList, rankType)
  end
  return value
end

function SeasonHunterManager:GetRankReward(rankId, sendMsg)
  rankId = rankId and tonumber(rankId) or 0
  local value
  if not self.rewardMap then
    self.rewardMap = {}
  end
  value = self.rewardMap[rankId]
  if not value then
    self.rewardMap[rankId] = false
    sendMsg = true
  end
  if sendMsg then
    SFSNetwork.SendMessage(MsgDefines.GetSeasonRankRewardInfo, rankId)
  end
  return value and (value.rankReward or value.rankRewardInfo)
end

function SeasonHunterManager:GetTimeReward()
  local activityData = DataCenter.SeasonHunterManager:GetActivityData()
  local param = activityData and activityData.para_3
  if string.IsNullOrEmpty(param) then
    return
  end
  local list = {}
  local arr = string.split(param, ";")
  local rankingLast, ranking = 0
  local max, index = #arr
  for i, v in ipairs(arr) do
    local data = string.split(v, "|")
    if #data == 2 then
      ranking = tonumber(data[1])
      index = max - i + 1
      list[index] = {
        rank = index,
        minTime = rankingLast,
        maxTime = ranking,
        rewards = DataCenter.RewardTemplateManager:GetList(data[2])
      }
      rankingLast = ranking
    end
  end
  table.sort(list, function(a, b)
    return a.minTime < b.minTime
  end)
  return list
end

function SeasonHunterManager:ShowMvp(mvpMsg)
  if mvpMsg then
    self.mvpMsg = mvpMsg
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.SeasonHunterResult) then
      return
    end
  end
  if self.mvpMsg then
    DataCenter.UIPopWindowManager:Push(UIWindowNames.SeasonHunterMVP, {anim = true}, self.mvpMsg)
    self.mvpMsg = nil
  end
end

local function __SortServerInfo(a, b)
  return tonumber(a.sid) < tonumber(b.sid)
end

function SeasonHunterManager:OnServerInfoChange(info, activityInfo)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local oldInfo = DataCenter.SeasonHunterManager.activityInfo or {}
  local oldServerInfo = oldInfo and oldInfo.serverInfo or {}
  if activityInfo then
    oldInfo = activityInfo
    self.lastRequestTimeStamp = curTime
  end
  local serverInfo = {}
  local newBanServerList = {}
  local showTips = oldInfo.nightOpen == 1 and not activityInfo
  if info then
    if info.banServerList then
      table.sort(info.banServerList, __SortServerInfo)
      for _, v in ipairs(info.banServerList) do
        v.serverId = tonumber(v.sid)
        if v.banTime then
          v.banTime = v.banTime * 1000
        end
        table.insert(serverInfo, v)
      end
    end
    if info.waitBanServerList then
      table.sort(info.waitBanServerList, __SortServerInfo)
      for _, v in ipairs(info.waitBanServerList) do
        v.serverId = tonumber(v.sid)
        if v.banTime then
          v.banTime = v.banTime * 1000
        end
        table.insert(serverInfo, v)
        if showTips then
          local hasOld = false
          for _, old in ipairs(oldServerInfo) do
            if old.serverId == v.serverId and old.lastWolfNum and old.banTime then
              hasOld = true
              break
            end
          end
          if not hasOld then
            table.insert(newBanServerList, v)
          end
        end
      end
    end
    if info.LastServerList then
      table.sort(info.LastServerList, __SortServerInfo)
      for _, v in ipairs(info.LastServerList) do
        v.serverId = tonumber(v.sid)
        if v.banTime then
          v.banTime = v.banTime * 1000
        end
        table.insert(serverInfo, v)
      end
    end
  end
  oldInfo.serverInfoList = serverInfo
  DataCenter.SeasonHunterManager.activityInfo = oldInfo
  EventManager:GetInstance():Broadcast(EventId.SeasonHunterGetActivityInfo)
  if self:CheckShowBan() then
    return
  end
  if not showTips then
    return
  end
  if table.IsNullOrEmpty(newBanServerList) then
    return
  end
  local endTime, strServerList = 0
  for i, v in ipairs(newBanServerList) do
    if string.IsNullOrEmpty(strServerList) then
      strServerList = string.format("#%s", v.serverId)
      endTime = v.banTime
    else
      strServerList = string.format("%s,#%s", strServerList, v.serverId)
      if curTime > v.banTime then
        endTime = v.banTime
      end
    end
  end
  local time = endTime - curTime
  time = time * 0.001
  if 0 < time then
    time = time < 10 and time or 3
    self:ShowWarning("season_s4_activity_1200011_desc53", endTime, time, strServerList)
  end
end

function SeasonHunterManager:GetMaxHp()
  if DataCenter.SeasonDataManager:HasGlobalStatus(StatusId.BloodyNightHunterEnhance) then
    return LuaEntry.DataConfig:TryGetNum("status_704716", "k2", 5)
  end
  local actData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if actData then
    return toInt(actData.para_5) or 3
  end
  return 3
end

function SeasonHunterManager:FetchSeasonHunterGetShadowInfo()
  SFSNetwork.SendMessage(MsgDefines.SeasonHunterGetShadowInfo)
end

function SeasonHunterManager:HandleSeasonHunterGetShadowInfo(msg)
  if self:IsExpire(msg.startTime) then
    self.shadowServerId = nil
    self.shadowPointId = nil
    self.shadowStartTime = nil
  else
    self.shadowServerId = msg.tarServerId
    self.shadowPointId = msg.sourcePos
    self.shadowStartTime = msg.startTime
  end
  if self.shadowStartTime then
    if self.updateSecondTimer == nil then
      function self.updateSecondTimer()
        self:Update1000MS()
      end
      
      UpdateManager:GetInstance():AddSecondUpdate(self.updateSecondTimer)
    end
  elseif self.updateSecondTimer then
    UpdateManager:GetInstance():RemoveSecondUpdate(self.updateSecondTimer)
    self.updateSecondTimer = nil
  end
  EventManager:GetInstance():Broadcast(EventId.WolfShadowRefresh)
end

function SeasonHunterManager:GetShadow()
  if self.shadowServerId and self.shadowPointId and self.shadowStartTime then
    if self:IsExpire(self.shadowStartTime) then
      self.shadowServerId = nil
      self.shadowPointId = nil
      self.shadowStartTime = nil
      if self.updateSecondTimer then
        UpdateManager:GetInstance():RemoveSecondUpdate(self.updateSecondTimer)
        self.updateSecondTimer = nil
      end
      EventManager:GetInstance():Broadcast(EventId.WolfShadowRefresh)
    else
      return self.shadowServerId, self.shadowPointId, self.shadowStartTime
    end
  end
end

function SeasonHunterManager:OnMoveCitySuccess()
  self:FetchSeasonHunterGetShadowInfo()
  TimerManager:GetInstance():DelayInvoke(function()
    self:FetchSeasonHunterGetShadowInfo()
  end, 3)
end

function SeasonHunterManager:Update1000MS()
  self:GetShadow()
end

function SeasonHunterManager:IsExpire(shadowStartTime)
  if shadowStartTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    local treasureId = LuaEntry.DataConfig:TryGetNum("season_blood_hunter_item", "k1", 501)
    local treasureConfig = LocalController:instance():tryGetLine(TableName.WorldTreasure, treasureId)
    local duration = treasureConfig and treasureConfig.expire_time or 3600
    if now < shadowStartTime + duration * 1000 then
      return false
    else
      return true
    end
  end
  return true
end

function SeasonHunterManager:IsOverLapWolfShadow(serverId, pointId)
  if self.shadowServerId and self.shadowPointId and self.shadowStartTime and self.shadowServerId == serverId then
    local tilePos = SceneUtils.IndexToTilePos(pointId)
    local shadowTilePos = SceneUtils.IndexToTilePos(self.shadowPointId)
    if shadowTilePos.x - 2 <= tilePos.x and tilePos.x <= shadowTilePos.x + 2 and shadowTilePos.y - 2 <= tilePos.y and tilePos.y <= shadowTilePos.y + 2 then
      return true
    end
  end
  return false
end

return SeasonHunterManager
