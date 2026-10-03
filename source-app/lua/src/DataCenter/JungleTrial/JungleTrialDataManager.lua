local JungleTrialDataManager = BaseClass("JungleTrialDataManager")

function JungleTrialDataManager:__init()
  self.expireTime = 0
  self.monsterUuid = 0
  self.taskList = {}
end

function JungleTrialDataManager:__delete()
  self:Destroy()
end

function JungleTrialDataManager:Destroy()
  if self.updateSecTimer then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
  self.taskList = nil
  self.serverData = nil
end

function JungleTrialDataManager:IsChomper(monsterId)
  if self.chomperId == nil then
    self.chomperId = LuaEntry.DataConfig:TryGetNum("season6_trial_monster", "k1", 5100001)
  end
  return monsterId == self.chomperId, self.chomperId
end

function JungleTrialDataManager:FetchActivityData()
  SFSNetwork.SendMessage(MsgDefines.SeasonMonsterEventActView)
end

function JungleTrialDataManager:HandleJungleTrialActivityInfo(msg)
  self.serverData = msg
  if msg.bindMonsterInfo then
    self:SetMyBaseSwallow(msg.bindMonsterInfo.stateEndTime, msg.bindMonsterInfo.monsterUuid)
  else
    self:SetMyBaseSwallow(0, 0)
  end
  EventManager:GetInstance():Broadcast(EventId.JungleTrialMonsterRefresh)
  EventManager:GetInstance():Broadcast(EventId.JungleTrialActivityDataRefresh)
  EventManager:GetInstance():Broadcast(EventId.OnJungleTrialBoxRefresh)
  DataCenter.JungleTrialDataManager:FetchTaskData()
end

function JungleTrialDataManager:HandleMonsterAdd(msg)
  if self.serverData then
    if self.serverData.allianceMonsterPointArr == nil then
      self.serverData.allianceMonsterPointArr = {}
    end
    table.insert(self.serverData.allianceMonsterPointArr, msg)
    EventManager:GetInstance():Broadcast(EventId.JungleTrialMonsterRefresh)
    if LuaEntry.Player:GetUid() == msg.uid then
      local monsterTemplate = DataCenter.MonsterTemplateManager:GetMonsterTemplate(msg.monsterId)
      if monsterTemplate then
        local expireTime = monsterTemplate.expire * 60000 + msg.createTime
        self:SetMyBaseSwallow(expireTime, msg.monsterUuid)
      end
    end
  end
end

function JungleTrialDataManager:HandleMonsterRemove(monsterUuid)
  if self.serverData then
    if self.serverData.allianceMonsterPointArr == nil then
      return
    end
    for i, v in ipairs(self.serverData.allianceMonsterPointArr) do
      if v.monsterUuid == monsterUuid then
        table.remove(self.serverData.allianceMonsterPointArr, i)
        EventManager:GetInstance():Broadcast(EventId.JungleTrialMonsterRefresh)
        break
      end
    end
    if self.monsterUuid == monsterUuid then
      self:SetMyBaseSwallow(0, 0)
    end
  end
end

function JungleTrialDataManager:SetMyBaseSwallow(expireTime, monsterUuid)
  expireTime = expireTime or 0
  monsterUuid = monsterUuid or 0
  if self.expireTime ~= expireTime or self.monsterUuid ~= monsterUuid then
    local now = UITimeManager:GetInstance():GetServerTime()
    local oldState = 0 < self.monsterUuid
    local newState = 0 < monsterUuid
    if oldState and newState then
      self.expireTime = expireTime
      self.monsterUuid = monsterUuid
    elseif oldState and not newState then
      self.expireTime = 0
      self.monsterUuid = 0
      if self.updateSecTimer then
        self.updateSecTimer:Stop()
        self.updateSecTimer = nil
      end
      EventManager:GetInstance():Broadcast(EventId.JungleTrialWrapRefresh)
    elseif not oldState and newState then
      self.expireTime = expireTime
      self.monsterUuid = monsterUuid
      if self.updateSecTimer == nil then
        self.updateSecTimer = TimerManager:GetInstance():GetTimer(1, self.OnUpdateSec, self, false, false, false)
        self.updateSecTimer:Start()
      end
      EventManager:GetInstance():Broadcast(EventId.JungleTrialWrapRefresh)
    else
      self.expireTime = 0
      self.monsterUuid = 0
    end
  end
end

function JungleTrialDataManager:OnUpdateSec()
  if self.expireTime > 0 and self.expireTime < UITimeManager:GetInstance():GetServerTime() then
    self:SetMyBaseSwallow(0, 0)
  end
end

function JungleTrialDataManager:IsMyBaseSwallow()
  return self.expireTime > UITimeManager:GetInstance():GetServerTime(), self.expireTime
end

function JungleTrialDataManager:IsShowOnMainUI()
  return self.serverData and self:IsInActivity() and LuaEntry.Player:IsInAlliance() and self:GetNearestChomper()
end

function JungleTrialDataManager:GetNearestChomper()
  local list = self:GetChomperList()
  if #list <= 0 then
    return nil
  end
  local selfTilePos = SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)
  local myServerId = LuaEntry.Player:GetSelfServerId()
  local nearestChomper
  local nearestDistance = math.huge
  for _, v in ipairs(list) do
    if v.serverId == myServerId then
      local markTilePos = SceneUtils.IndexToTilePos(v.pointId, ForceChangeScene.World)
      local distance = SceneUtils.ManhattanDistance(markTilePos, selfTilePos)
      if nearestDistance > distance then
        nearestDistance = distance
        nearestChomper = v
      end
    end
  end
  return nearestChomper
end

function JungleTrialDataManager:GetChomperList()
  if not self.serverData or not self.serverData.allianceMonsterPointArr then
    return {}
  end
  return self.serverData.allianceMonsterPointArr
end

function JungleTrialDataManager:IsInActivity()
  local now = UITimeManager:GetInstance():GetServerTime()
  return now > self:GetStartTime() and now < self:GetEndTime()
end

function JungleTrialDataManager:GetFillAmount()
  if not (self.serverData and self.serverData.allianceActInfo) or not self.serverData.allianceActInfo.totalScore then
    return 0
  end
  local totalScore = self.serverData.allianceActInfo.totalScore
  local actData = DataCenter.ActivityListDataManager:GetActivityDataById(self.serverData.actId)
  if not actData then
    return 0
  end
  local para = actData.para or "3000;7000;15000|10000"
  para = string.split(para, "|")
  if not (para and para[1]) or not para[2] then
    return 0
  end
  para[1] = string.split(para[1], ";")
  local para1 = {0}
  local para2 = tonumber(para[2])
  for k, v in ipairs(para[1]) do
    table.insert(para1, tonumber(v))
  end
  local para1Max = para1[#para1]
  if totalScore < para1Max then
    for k, v in ipairs(para1) do
      if totalScore < v then
        return (totalScore - para1[k - 1]) / (v - para1[k - 1])
      end
    end
  else
    return (totalScore - para1Max) % para2 / para2
  end
end

function JungleTrialDataManager:GetTodayKill()
  if not (self.serverData and self.serverData.allianceActInfo) or not self.serverData.allianceActInfo.dailyKill then
    return 0
  end
  return self.serverData.allianceActInfo.dailyKill
end

function JungleTrialDataManager:GetKilledChomperCount()
  if not (self.serverData and self.serverData.allianceActInfo) or not self.serverData.allianceActInfo.totalKill then
    return 0
  end
  local data = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.JungleTrial.Type)
  return self.serverData.allianceActInfo.totalKill % (data and tonumber(data.para_3) or 5)
end

function JungleTrialDataManager:GetEndTime()
  if self.serverData and self.serverData.userSeasonMonsterActFullInfo and self.serverData.userSeasonMonsterActFullInfo.userSeasonMonsterEventActInfo and self.serverData.userSeasonMonsterActFullInfo.userSeasonMonsterEventActInfo.endTime then
    return self.serverData.userSeasonMonsterActFullInfo.userSeasonMonsterEventActInfo.endTime
  end
  return MANY_YEARS_LATER
end

function JungleTrialDataManager:GetStartTime()
  if self.serverData and self.serverData.userSeasonMonsterActFullInfo and self.serverData.userSeasonMonsterActFullInfo.userSeasonMonsterEventActInfo and self.serverData.userSeasonMonsterActFullInfo.userSeasonMonsterEventActInfo.startTime then
    return self.serverData.userSeasonMonsterActFullInfo.userSeasonMonsterEventActInfo.startTime
  end
  return 0
end

function JungleTrialDataManager:FetchOpenBox()
  if self:GetCanOpenBoxNum() > 0 then
    SFSNetwork.SendMessage(MsgDefines.SeasonMonsterEventOpenBox, self.serverData.actId)
  end
end

function JungleTrialDataManager:HandleOpenBox(msg)
  if self.serverData and self.serverData.userSeasonMonsterActFullInfo then
    self.serverData.userSeasonMonsterActFullInfo.userSeasonMonsterEventActInfo = msg
  end
  EventManager:GetInstance():Broadcast(EventId.OnJungleTrialBoxRefresh)
end

function JungleTrialDataManager:HandlePushBox(msg)
  if self.serverData and self.serverData.userSeasonMonsterActFullInfo then
    self.serverData.userSeasonMonsterActFullInfo.userSeasonMonsterEventRewardRecordInfo = msg
  end
  EventManager:GetInstance():Broadcast(EventId.OnJungleTrialBoxRefresh)
end

function JungleTrialDataManager:GetCanOpenBoxNum()
  if not (self.serverData and self.serverData.userSeasonMonsterActFullInfo and self.serverData.userSeasonMonsterActFullInfo.userSeasonMonsterEventActInfo and self.serverData.userSeasonMonsterActFullInfo.userSeasonMonsterEventActInfo.receiveNum and self.serverData.userSeasonMonsterActFullInfo.userSeasonMonsterEventRewardRecordInfo) or not self.serverData.userSeasonMonsterActFullInfo.userSeasonMonsterEventRewardRecordInfo.rewardNum then
    return 0
  end
  return self.serverData.userSeasonMonsterActFullInfo.userSeasonMonsterEventRewardRecordInfo.rewardNum - self.serverData.userSeasonMonsterActFullInfo.userSeasonMonsterEventActInfo.receiveNum
end

function JungleTrialDataManager:GetBoxReward()
  if self.serverData then
    return self.serverData.boxReward
  end
end

function JungleTrialDataManager:FetchTaskData()
  if self.serverData and self.serverData.actId then
    SFSNetwork.SendMessage(MsgDefines.SeasonMonsterEventTaskView, self.serverData.actId)
  end
end

function JungleTrialDataManager:HandleJungleTrialTaskInfo(msg)
  self.taskList = msg
  EventManager:GetInstance():Broadcast(EventId.JungleTrialTaskRefresh)
  EventManager:GetInstance():Broadcast(EventId.OnJungleTrialRewardRefresh)
end

function JungleTrialDataManager:HandlePushTask(msg)
  if table.IsNullOrEmpty(msg) then
    return
  end
  local taskId = msg.taskId
  for _, v in pairs(self.taskList) do
    if v.taskId == taskId then
      v.num = msg.num
      v.state = msg.state
      EventManager:GetInstance():Broadcast(EventId.JungleTrialClaimReward, taskId)
      EventManager:GetInstance():Broadcast(EventId.OnJungleTrialRewardRefresh)
      break
    end
  end
end

function JungleTrialDataManager:FetchClaimTaskReward(taskId)
  if self.serverData and self.serverData.actId then
    SFSNetwork.SendMessage(MsgDefines.SeasonMonsterEventTaskGetReward, self.serverData.actId, taskId)
  end
end

function JungleTrialDataManager:HandleJungleTrialTaskClaimReward(msg)
  if msg.reward then
    DataCenter.RewardManager:AddRewardsAndRes(msg)
    DataCenter.RewardManager:ShowCommonReward(msg)
  end
  if msg.seasonMonsterEventTaskInfo then
    local taskId = msg.seasonMonsterEventTaskInfo.taskId
    if not taskId then
      return
    end
    for _, v in pairs(self.taskList) do
      if v.taskId == taskId then
        v.state = 2
        EventManager:GetInstance():Broadcast(EventId.JungleTrialClaimReward, taskId)
        EventManager:GetInstance():Broadcast(EventId.OnJungleTrialRewardRefresh)
        return
      end
    end
  end
end

function JungleTrialDataManager:GetTaskList()
  return self.taskList
end

function JungleTrialDataManager:GetCanReceive()
  for _, v in pairs(self.taskList) do
    if v.state == 1 then
      return true
    end
  end
  return false
end

function JungleTrialDataManager:GetFirstSeenRedPoint()
  return false
end

function JungleTrialDataManager:FetchHistoryData()
  SFSNetwork.SendMessage(MsgDefines.AllianceSummonLogView)
end

function JungleTrialDataManager:HandleHistory(list)
  self.historyList = list
  EventManager:GetInstance():Broadcast(EventId.JungleTrialHistoryRefresh)
end

function JungleTrialDataManager:GetJungleTrialHistory()
  return self.historyList or {}
end

function JungleTrialDataManager:FetchRankData()
  local now = UITimeManager:GetInstance():GetServerSeconds()
  if self.lastTimePersonRank == nil or now > self.lastTimePersonRank + 60 then
    self.lastTimePersonRank = now
    SFSNetwork.SendMessage(MsgDefines.SeasonMonsterEventActRankView)
  end
end

function JungleTrialDataManager:HandleRankInfo(msg)
  if not msg then
    return
  end
  self.ranks = msg.ranks
  for _, v in pairs(self.ranks) do
    v.serverId = nil
    v.abbr = nil
  end
  self.selfRank = msg.self
  EventManager:GetInstance():Broadcast(EventId.JungleTrialRankRefresh)
end

function JungleTrialDataManager:GetRankData()
  return self.ranks or {}, self.selfRank
end

function JungleTrialDataManager:HandleRankRewardList(msg)
  if not msg then
    return
  end
  self.rankRewardList = msg
  EventManager:GetInstance():Broadcast(EventId.JungleTrialRankRewardRefresh)
end

function JungleTrialDataManager:GetRankRewardList()
  return self.rankRewardList or {}
end

return JungleTrialDataManager
