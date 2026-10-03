local VIPDataInfo = BaseClass("VIPDataInfo")

function VIPDataInfo:__init()
  self.level = -1
  self.loginDays = 0
  self.score = 0
  self.loginScoreState = 0
  self.everyDayReward = 0
  self.lastUpdateTime = 0
  self.privilegeReward = ""
  self.addScore = 0
  self.nextDayScore = 0
  self.boxRewardArr = {}
  self._privilegeRewardCanGet = {}
  self.endTime = 0
end

function VIPDataInfo:__delete()
  self.level = nil
  self.loginDays = nil
  self.score = nil
  self.loginScoreState = nil
  self.everyDayReward = nil
  self.lastUpdateTime = nil
  self.privilegeReward = nil
  self.addScore = nil
  self.nextDayScore = nil
  self.boxRewardArr = nil
  self._privilegeRewardCanGet = nil
  self.endTime = nil
end

function VIPDataInfo:UpdateVipInfo(message, fromDailyPoint)
  if message == nil then
    return
  end
  local preLevel = self.level
  if message.vipInfo == nil then
    return
  end
  local vipinfo = message.vipInfo
  if vipinfo.level ~= nil then
    self.level = vipinfo.level
  end
  if vipinfo.loginDays ~= nil then
    self.loginDays = vipinfo.loginDays
  end
  if vipinfo.score then
    self.score = vipinfo.score
  end
  if vipinfo.loginScoreState ~= nil then
    self.loginScoreState = vipinfo.loginScoreState
  end
  if vipinfo.everyDayReward ~= nil then
    self.everyDayReward = vipinfo.everyDayReward
  end
  self.lastUpdateTime = UITimeManager:GetInstance():GetServerTime()
  if vipinfo.privilegeReward ~= nil then
    self.privilegeReward = vipinfo.privilegeReward
  end
  if vipinfo.endTime ~= nil then
    self.endTime = vipinfo.endTime
  end
  self:ParsePrivilegeState()
end

function VIPDataInfo:UpdateVip(message, isLoginScore)
  if message == nil then
    return
  end
  local preLevel = self.level
  if message.level ~= nil then
    self.level = message.level
  end
  if message.loginDays ~= nil then
    self.loginDays = message.loginDays
  end
  if message.score then
    self.score = message.score
  end
  if message.loginScoreState ~= nil then
    self.loginScoreState = message.loginScoreState
  end
  if message.everyDayReward ~= nil then
    self.everyDayReward = message.everyDayReward
  end
  if message.privilegeReward ~= nil then
    self.privilegeReward = message.privilegeReward
  end
  if message.addScore ~= nil then
    self.addScore = message.addScore
  end
  if message.nextDayScore ~= nil then
    self.nextDayScore = message.nextDayScore
  end
  local prevEndTime = self.endTime
  if message.endTime ~= nil then
    self.endTime = message.endTime
    if prevEndTime ~= self.endTime then
      EventManager:GetInstance():Broadcast(EventId.VipEndTimeChange)
    end
  end
  local isLevelUp = self:CheckLevelUp(preLevel, self.level)
  local isShowWindowType = 0
  if isLevelUp then
    isShowWindowType = 1
  elseif isLoginScore then
    isShowWindowType = 2
  end
  EventManager:GetInstance():Broadcast(EventId.VipDataRefresh, isShowWindowType)
  local chatUserInfo = ChatManager2:GetInstance().User:getChatUserInfo(LuaEntry.Player.uid)
  if chatUserInfo then
    chatUserInfo.svipLevel = self.level
    chatUserInfo.svipEndTime = self.endTime
  end
end

function VIPDataInfo:UpdateVipBoxRewardInfo(message)
  table.walk(message, function(k, v)
    self.boxRewardArr[v.level] = DataCenter.RewardManager:ReturnRewardParamForView(v.reward)
  end)
end

function VIPDataInfo:UpdateVipPoint(vipPoint)
  self.score = vipPoint
  EventManager:GetInstance():Broadcast(EventId.VipDataRefresh, 0)
  local nextVipInfo = DataCenter.VIPManager:GetNextVipData()
  if self.score > nextVipInfo.MinPoint then
    DataCenter.VIPManager:RequestLatestVipInfo()
    pcall(function()
      DataCenter.VIPManager:VipReqSourceRecord(VipRequestSource.VipLevelUp)
    end)
  end
end

function VIPDataInfo:CheckLevelUp(preLevel, curLevel)
  if preLevel < 0 then
    return false
  end
  if preLevel < curLevel then
    return true
  end
  return false
end

function VIPDataInfo:ParsePrivilegeState()
  self._privilegeRewardCanGet = {}
  if self.privilegeReward == nil then
    return
  end
  local states = string.split(self.privilegeReward, ";")
  if #states < 1 then
    return
  end
  for i, v in pairs(states) do
    table.insert(self._privilegeRewardCanGet, tonumber(v))
  end
end

function VIPDataInfo:GetLoginDays()
  if self.lastUpdateTime < UITimeManager:GetInstance():TodayZero() then
    DataCenter.VIPManager:RequestLatestVipInfo()
    pcall(function()
      DataCenter.VIPManager:VipReqSourceRecord(VipRequestSource.UpdatePassDay)
    end)
    return self.loginDays + 1
  end
  return self.loginDays
end

function VIPDataInfo:CanGetDailyPoint()
  if self.loginScoreState == 1 then
    return true
  end
  local todayZero = UITimeManager:GetInstance():TodayZero()
  return todayZero > self.lastUpdateTime
end

function VIPDataInfo:CanGetDailyFreeReward()
  if not self:IsVIPActive() then
    return false
  end
  if self.everyDayReward == 1 then
    return true
  end
  local todayZero = UITimeManager:GetInstance():TodayZero()
  return todayZero > self.lastUpdateTime
end

function VIPDataInfo:GetPrivilegeRewardState(level)
  if level > self.level then
    return -1
  end
  for i = 1, #self._privilegeRewardCanGet do
    if self._privilegeRewardCanGet[i] == level then
      return 1
    end
  end
  return 0
end

function VIPDataInfo:IsVIPActive()
  if self.endTime == nil then
    return false
  end
  if self.endTime <= 0 then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if curTime >= self.endTime then
    return false
  end
  return true
end

function VIPDataInfo:GetRemainTime()
  if self.endTime == nil then
    return 0
  end
  if self.endTime <= 0 then
    return 0
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if curTime >= self.endTime then
    return 0
  end
  return self.endTime - curTime
end

return VIPDataInfo
