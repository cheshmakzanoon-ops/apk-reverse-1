local SandWormHuntDataManager = BaseClass("SandWormHuntDataManager")

function SandWormHuntDataManager:__init()
  self.smallWormList = nil
  self.bigWormList = nil
  self.nearestWorm = nil
  self.achievementList = {}
  self.dailyTaskList = {}
  self.expireTime = 0
end

function SandWormHuntDataManager:__delete()
  self:Destroy()
end

function SandWormHuntDataManager:Destroy()
  self.smallWormList = nil
  self.bigWormList = nil
  self.nearestWorm = nil
end

function SandWormHuntDataManager:FetchActivityData()
  SFSNetwork.SendMessage(MsgDefines.SandWormActivityInfo, 2, 1)
end

function SandWormHuntDataManager:FetchSandWormList(sandWormType)
  SFSNetwork.SendMessage(MsgDefines.SandWormActivityInfo, sandWormType)
end

function SandWormHuntDataManager:HandleSandWormHuntActivityInfo(msg)
  if msg.endTime then
    self.endTime = msg.endTime
  end
  if msg.bigSandwormST then
    self.bigSandwormST = msg.bigSandwormST
  end
  if msg.cur then
    self.cur = msg.cur
  end
  if msg.max then
    self.max = msg.max
  end
  if msg.stateEndTime ~= nil then
    self:SetMyBaseWormWrap(msg.stateEndTime, self.monsterId)
  end
  if msg.type == SandWormType.Small then
    self.smallWormList = msg.ls
    EventManager:GetInstance():Broadcast(EventId.SmallSandWormListRefresh)
  elseif msg.type == SandWormType.Big then
    self.bigWormList = msg.ls
    EventManager:GetInstance():Broadcast(EventId.BigSandWormListRefresh)
  else
    self.nearestWorm = msg.ls and msg.ls[1]
  end
  EventManager:GetInstance():Broadcast(EventId.SandWormActivityRefresh)
end

function SandWormHuntDataManager:SetMyBaseWormWrap(expireTime, monsterId)
  if self.expireTime ~= expireTime then
    local oldState = self:IsMyBaseWormWrap()
    self.expireTime = expireTime
    local newState = self:IsMyBaseWormWrap()
    if oldState ~= newState then
      EventManager:GetInstance():Broadcast(EventId.SandWormWrapRefresh)
    end
  end
  if monsterId then
    self.monsterId = monsterId
  else
    self.monsterId = 0
  end
end

function SandWormHuntDataManager:IsMyBaseWormWrap()
  return self.expireTime > UITimeManager:GetInstance():GetServerTime(), self.expireTime, self.monsterId
end

function SandWormHuntDataManager:IsShowOnMainUI()
  return self.nearestWorm or self.cur and LuaEntry.Player:IsInAlliance() and self.max and self.max ~= 0 and self.cur / self.max > 0.8
end

function SandWormHuntDataManager:GetNearestSandWorm()
  return self.nearestWorm
end

function SandWormHuntDataManager:GetFillAmount()
  if self.cur and self.max and self.max ~= 0 and LuaEntry.Player:IsInAlliance() then
    return self.cur / self.max
  end
  return 0
end

function SandWormHuntDataManager:IsInActivity()
  if not self.endTime then
    return false
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  return now < self.endTime
end

function SandWormHuntDataManager:GetSmallSandWormList()
  return self.smallWormList
end

function SandWormHuntDataManager:GetBigSandWormList()
  return self.bigWormList
end

function SandWormHuntDataManager:GetEndTime()
  return self.endTime
end

function SandWormHuntDataManager:IsStageTwo()
  local now = UITimeManager:GetInstance():GetServerTime()
  return self.bigSandwormST and now > self.bigSandwormST
end

function SandWormHuntDataManager:FetchTaskData()
  SFSNetwork.SendMessage(MsgDefines.SandWormTaskInfo)
end

function SandWormHuntDataManager:HandleSandWormTaskInfo(msg)
  self.achievementList = msg.achievement
  self.dailyTaskList = msg.daily
  EventManager:GetInstance():Broadcast(EventId.SandWormTaskRefresh)
  EventManager:GetInstance():Broadcast(EventId.OnSandWormHuntRewardRefresh)
end

function SandWormHuntDataManager:OnPushTask(msg)
  if table.IsNullOrEmpty(msg) then
    return
  end
  for _, newData in pairs(msg) do
    local taskId = newData.id
    local found = false
    for _, v in pairs(self.achievementList) do
      if v.id == taskId then
        v.num = newData.num
        v.time = newData.time
        v.state = newData.state
        EventManager:GetInstance():Broadcast(EventId.SandWormClaimReward, taskId)
        EventManager:GetInstance():Broadcast(EventId.OnSandWormHuntRewardRefresh)
        found = true
        break
      end
    end
    if not found then
      for _, v in pairs(self.dailyTaskList) do
        if v.id == taskId then
          v.num = newData.num
          v.time = newData.time
          v.state = newData.state
          EventManager:GetInstance():Broadcast(EventId.SandWormClaimReward, taskId)
          EventManager:GetInstance():Broadcast(EventId.OnSandWormHuntRewardRefresh)
          break
        end
      end
    end
  end
end

function SandWormHuntDataManager:HandleSandWormTaskClaimReward(msg)
  local taskId = msg.taskId
  if not taskId then
    return
  end
  for _, v in pairs(self.achievementList) do
    if v.id == taskId then
      v.state = 2
      EventManager:GetInstance():Broadcast(EventId.SandWormClaimReward, taskId)
      EventManager:GetInstance():Broadcast(EventId.OnSandWormHuntRewardRefresh)
      return
    end
  end
  for _, v in pairs(self.dailyTaskList) do
    if v.id == taskId then
      v.state = 2
      EventManager:GetInstance():Broadcast(EventId.SandWormClaimReward, taskId)
      EventManager:GetInstance():Broadcast(EventId.OnSandWormHuntRewardRefresh)
      return
    end
  end
end

function SandWormHuntDataManager:GetTaskList(taskType)
  if taskType == SandWormTaskType.Achievement then
    return self.achievementList
  else
    return self.dailyTaskList
  end
end

function SandWormHuntDataManager:GetCanReceive(taskType)
  if taskType == nil then
    for _, v in pairs(self.achievementList) do
      if v.state == 1 then
        return true
      end
    end
    for _, v in pairs(self.dailyTaskList) do
      if v.state == 1 then
        return true
      end
    end
  elseif taskType == SandWormTaskType.Achievement then
    for _, v in pairs(self.achievementList) do
      if v.state == 1 then
        return true
      end
    end
  elseif taskType == SandWormTaskType.DailyTask then
    for _, v in pairs(self.dailyTaskList) do
      if v.state == 1 then
        return true
      end
    end
  end
  return false
end

function SandWormHuntDataManager:GetFirstSeenRedPoint()
  return false
end

function SandWormHuntDataManager:FetchHistoryData()
  SFSNetwork.SendMessage(MsgDefines.SandWormAlOpRecord)
end

function SandWormHuntDataManager:SetSandWormHistory(list)
  self.historyList = list
  EventManager:GetInstance():Broadcast(EventId.SandWormHistoryRefresh)
end

function SandWormHuntDataManager:GetSandWormHistory()
  return self.historyList or {}
end

function SandWormHuntDataManager:FetchRankData()
  local now = UITimeManager:GetInstance():GetServerSeconds()
  if self.lastTimePersonRank == nil or now > self.lastTimePersonRank + 60 then
    self.lastTimePersonRank = now
    SFSNetwork.SendMessage(MsgDefines.SandWormAlMemberAtkDmgRank, SandWormType.Big)
  end
end

function SandWormHuntDataManager:RecMsgPersonRank(msg)
  if not msg.ls then
    return
  end
  self.ranks = msg.ls
  self.selfRank = nil
  for _, v in pairs(msg.ls) do
    if v.uid == LuaEntry.Player.uid then
      self.selfRank = v
    end
  end
  EventManager:GetInstance():Broadcast(EventId.SandWormRankRefresh)
end

function SandWormHuntDataManager:GetRankData()
  return self.ranks, self.selfRank
end

return SandWormHuntDataManager
