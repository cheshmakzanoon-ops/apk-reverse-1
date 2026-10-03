local AllianceMilitaryPayDataManager = BaseClass("AllianceMilitaryPayDataManager", CEventable)

function AllianceMilitaryPayDataManager:__init()
  self.weeklyAllianceSalary = nil
  self.weeklyUserSalary = nil
  self.dailyUserSalary = nil
  self.dutyDaysPerWeek = 0
  self.weeklySalaryInfo = nil
  self.dailySalaryInfo = nil
  self.dailySalaryStatus = nil
  self.dailySalary = nil
  self:RegisterEvent(EventId.OnPassDay, self.OnPassDay)
end

function AllianceMilitaryPayDataManager:__delete()
  self.weeklyAllianceSalary = nil
  self.weeklyUserSalary = nil
  self.dailyUserSalary = nil
  self.dutyDaysPerWeek = nil
  self.weeklySalaryInfo = nil
  self.dailySalaryInfo = nil
  self.dailySalaryStatus = nil
  self.dailySalary = nil
end

function AllianceMilitaryPayDataManager:SendAllianceSalaryGainActivityInfo()
  SFSNetwork.SendMessage(MsgDefines.AllianceSalaryGainActivityInfo)
end

function AllianceMilitaryPayDataManager:GetAllianceSalaryGainReward(configId)
  SFSNetwork.SendMessage(MsgDefines.AllianceSalaryGainReward, configId)
end

function AllianceMilitaryPayDataManager:InitData(msg)
  self.dailySalaryStatus = msg.dailySalaryStatus
  self.dailySalary = msg.dailySalary
  self.salaryActivityState = msg.salaryActivityState
  self.salaryTime = msg.salaryTime
end

function AllianceMilitaryPayDataManager:OnDailySalaryStatusChange(msg)
  if not msg then
    return
  end
  local curState = self.dailySalaryStatus
  self.dailySalaryStatus = msg.dailySalaryStatus
  self.dailySalary = msg.dailySalary
  if curState ~= self.dailySalaryStatus then
    EventManager:GetInstance():Broadcast(EventId.OnDailySalaryChange)
  end
end

function AllianceMilitaryPayDataManager:OnActivityStatusChange(msg)
  if not msg then
    return
  end
  self.salaryActivityState = msg.salaryActivityState
  self.salaryTime = msg.salaryTime
  EventManager:GetInstance():Broadcast(EventId.OnAllianceMilitaryStatusChange, self.salaryActivityState)
end

function AllianceMilitaryPayDataManager:SetActivityState(status)
  self.salaryActivityState = status
end

function AllianceMilitaryPayDataManager:GetActivityState()
  return self.salaryActivityState
end

function AllianceMilitaryPayDataManager:GetActivityStartTime()
  return self.salaryTime or 0
end

function AllianceMilitaryPayDataManager:GetActivityEndTime()
  if not self.endTime then
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.AllianceSalary.Type)
    if dataList and dataList[1] then
      self.endTime = dataList[1].endTime
    end
  end
  return self.endTime or 0
end

function AllianceMilitaryPayDataManager:SaveAllianceMilitaryPayInfo(msg)
  if not msg then
    return
  end
  self.data = msg
  self.weeklyAllianceSalary = msg.weeklyAllianceSalary
  self.weeklyUserSalary = msg.weeklyUserSalary
  self.dutyDaysPerWeek = msg.dutyDaysPerWeek
  self.weeklySalaryInfo = msg.weeklySalaryInfo
  self.dailySalaryInfo = msg.dailySalaryInfo
  self.dailySalary = msg.dailyUserSalary
  self.dailySalaryStatus = self.dailySalaryInfo.status
  EventManager:GetInstance():Broadcast(EventId.OnAllianceMilitaryPayGetActivityInfo, msg)
end

function AllianceMilitaryPayDataManager:GetAllianceMilitaryPayInfo()
  return self.data
end

function AllianceMilitaryPayDataManager:GetRedPointNum()
  if not self.dailySalaryStatus then
    return 0
  end
  local canGet = self.dailySalaryStatus == SalaryStatus.CanGet
  if canGet then
    return 1
  end
  if self.data then
    for i, v in ipairs(self.data.weeklySalaryInfo) do
      if v.status == SalaryStatus.CanGet then
        return 1
      end
    end
  end
  return 0
end

function AllianceMilitaryPayDataManager:GetCurDailySalaryScore()
  return self.dailySalary or 0
end

function AllianceMilitaryPayDataManager:GetMaxDailySalaryScore()
  local config = DataCenter.AlliancePayTemplateManager:GetTemplate(101)
  local maxScore = config.maxDailySalaryScore or 1
  return maxScore
end

function AllianceMilitaryPayDataManager:HasGotDailySalary()
  if not self.dailySalaryStatus then
    return false
  end
  return self.dailySalaryStatus == SalaryStatus.HasGot
end

function AllianceMilitaryPayDataManager:CanGetDailySalary()
  if not self.dailySalaryStatus then
    return false
  end
  local isScoreEnough = self.dailySalary >= self:GetMaxDailySalaryScore()
  local canGet = isScoreEnough and self.dailySalaryStatus ~= SalaryStatus.HasGot
  return canGet or self.dailySalaryStatus == SalaryStatus.CanGet
end

function AllianceMilitaryPayDataManager:OnPassDay()
  self.dailySalaryStatus = SalaryStatus.NotAchieved
  self.dailySalary = 0
  EventManager:GetInstance():Broadcast(EventId.OnDailySalaryChange)
  if self.data then
    self.data.canShared = true
  end
end

function AllianceMilitaryPayDataManager:GetMilitaryLevelByGiftLevel(giftLevel)
  if not self.levelArr then
    local str = LuaEntry.DataConfig:TryGetStr("alliance_pay_config", "k1")
    self.levelArr = string.string2table_ii_toList(str, ";", "|")
  end
  for i, v in ipairs(self.levelArr) do
    local minLevel = tonumber(v[1]) or 0
    local maxLevel = tonumber(v[2]) or 0
    if giftLevel >= minLevel and giftLevel <= maxLevel then
      return i
    end
  end
  return 0
end

function AllianceMilitaryPayDataManager:IsFunctionOpen()
  local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.AllianceSalary.Type)
  if dataList and dataList[1] and DataCenter.ActivityListDataManager:CheckIsSend(dataList[1]) then
    return true
  end
  return false
end

function AllianceMilitaryPayDataManager:IsDuringStateOpen()
  if not self:IsFunctionOpen() then
    return false
  end
  if self.salaryActivityState ~= SalaryActivityState.Open then
    return false
  end
  return true
end

function AllianceMilitaryPayDataManager:ShareReminder(configId)
  SFSNetwork.SendMessage(MsgDefines.AllianceSalaryNotifyAllFinishTask, configId)
end

function AllianceMilitaryPayDataManager:OnShareSuccess(message)
  self.data.canShared = false
  EventManager:GetInstance():Broadcast(EventId.OnAllianceMilitaryShareSuccess, message)
end

function AllianceMilitaryPayDataManager:OnGetReward(configId)
  if not self.data then
    return
  end
  if self.data.dailySalaryInfo and self.data.dailySalaryInfo.configId == configId then
    self.data.dailySalaryInfo.status = SalaryStatus.HasGot
    return
  end
  for i, v in ipairs(self.data.weeklySalaryInfo) do
    if v.configId == configId then
      v.status = SalaryStatus.HasGot
      break
    end
  end
end

return AllianceMilitaryPayDataManager
