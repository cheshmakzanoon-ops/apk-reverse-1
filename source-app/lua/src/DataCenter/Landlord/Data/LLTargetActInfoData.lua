local LLTargetActInfoData = BaseClass("LLTargetActInfoData")

function LLTargetActInfoData:__init()
  self.templateId = 0
  self.configId = 0
  self.startTime = 0
  self.endTime = 0
  self.previewStageBoomStartRaw = 0
  self.previewTime = 0
  self.groupTime = 0
  self.battleWeeks = nil
  self.currentWeekNum = 0
  self.serverGroupMap = nil
  self.destroyScore = 0
end

function LLTargetActInfoData:__delete()
  self.battleWeeks = nil
  self.serverGroupMap = nil
end

function LLTargetActInfoData:ParseData(msg)
  if msg == nil then
    return
  end
  self.templateId = msg.templateId or 0
  self.configId = msg.configId or 0
  self.startTime = msg.startTime or 0
  self.endTime = msg.endTime or 0
  self.previewStageBoomStartRaw = msg.previewStageBoomStartRaw or 0
  self.previewTime = msg.previewTime or 0
  self.groupTime = msg.groupTime or 0
  self.destroyScore = msg.destroyScore or 0
  local battleWeeks = msg.battleWeeks
  if battleWeeks ~= nil then
    self.battleWeeks = {}
    for _, week in ipairs(battleWeeks) do
      table.insert(self.battleWeeks, {
        weekNum = week.weekNum or 0,
        prepareTime = week.prepareTime or 0,
        battleTime = week.battleTime or 0,
        restTime = week.restTime or 0,
        kickTime = week.kickTime or 0
      })
    end
  end
  local serverList = msg.serverList
  if serverList ~= nil then
    self.serverGroupMap = {}
    for _, v in ipairs(serverList) do
      local serverId = v.serverId or 0
      local group = v.group or 0
      self.serverGroupMap[serverId] = group
    end
  end
  self:UpdateCurrentWeekNum()
  local csInst = CS.LandlordManager.Instance
  if csInst then
    csInst.myCampId = LLConst.LandLordGroup.LORD
    csInst.previewBoomTime = self.previewStageBoomStartRaw
  end
end

function LLTargetActInfoData:UpdateCurrentWeekNum()
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  self.currentWeekNum = 0
  if self.battleWeeks == nil or #self.battleWeeks == 0 then
    return
  end
  for _, week in ipairs(self.battleWeeks) do
    local prepareTime = week.prepareTime or 0
    local nextWeekPrepareTime
    local nextIdx = self:_GetWeekIndexByWeekNum(week.weekNum) + 1
    if nextIdx <= #self.battleWeeks then
      nextWeekPrepareTime = self.battleWeeks[nextIdx].prepareTime or 0
    else
      nextWeekPrepareTime = self.endTime or 0
    end
    if curTime >= prepareTime and curTime < nextWeekPrepareTime then
      self.currentWeekNum = week.weekNum
      return
    end
  end
end

function LLTargetActInfoData:_GetWeekIndexByWeekNum(weekNum)
  if self.battleWeeks == nil then
    return 0
  end
  for idx, week in ipairs(self.battleWeeks) do
    if week.weekNum == weekNum then
      return idx
    end
  end
  return 0
end

function LLTargetActInfoData:GetWeekBattleStartTime(weekNum)
  if self.battleWeeks == nil then
    return 0
  end
  for _, week in ipairs(self.battleWeeks) do
    if week.weekNum == weekNum then
      return week.battleTime or 0
    end
  end
  return 0
end

function LLTargetActInfoData:GetStageInfo(stageIdx)
  return nil
end

function LLTargetActInfoData:GetNextBattleStartTime()
  if self.battleWeeks == nil then
    return self.endTime or 0
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  for _, week in ipairs(self.battleWeeks) do
    if curTime < (week.battleTime or 0) then
      return week.battleTime or 0
    end
  end
  return self.endTime or 0
end

function LLTargetActInfoData:GetNextBattleEndTime()
  if self.battleWeeks == nil then
    return self.endTime or 0
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  for _, week in ipairs(self.battleWeeks) do
    if curTime < (week.restTime or 0) then
      return week.restTime or 0
    end
  end
  return self.endTime or 0
end

function LLTargetActInfoData:GetWeekBattleEndTime(week)
  if self.battleWeeks == nil then
    return self.endTime or 0
  end
  for _, v in ipairs(self.battleWeeks) do
    if v.weekNum == week then
      return v.restTime
    end
  end
end

function LLTargetActInfoData:GetActStartTime()
  return self.startTime or 0
end

function LLTargetActInfoData:GetServerGroup(serverId)
  if self.serverGroupMap == nil then
    return 0
  end
  return self.serverGroupMap[serverId] or 0
end

function LLTargetActInfoData:GetCurStageInfo()
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if self.battleWeeks == nil then
    return nil
  end
  if curTime < self.startTime or curTime > self.endTime then
    return nil
  end
  if curTime < self.groupTime then
    return {
      idx = 1,
      stage = LLConst.LandlordStage.PREVIEW,
      sTime = self.previewTime,
      eTime = self.groupTime,
      week = 0
    }
  end
  local firstWeekPrepareTime = self.battleWeeks[1] and self.battleWeeks[1].prepareTime or 0
  if curTime < firstWeekPrepareTime then
    return {
      idx = 2,
      stage = LLConst.LandlordStage.GROUP,
      sTime = self.groupTime,
      eTime = firstWeekPrepareTime,
      week = 0
    }
  end
  for idx, week in ipairs(self.battleWeeks) do
    local prepareTime = week.prepareTime or 0
    local battleTime = week.battleTime or 0
    local restTime = week.restTime or 0
    local kickTime = week.kickTime or 0
    local nextWeekStartTime
    if idx < #self.battleWeeks then
      nextWeekStartTime = self.battleWeeks[idx + 1].prepareTime or 0
    else
      nextWeekStartTime = self.endTime or 0
    end
    if curTime >= prepareTime and curTime < nextWeekStartTime then
      local stage = LLConst.LandlordStage.NONE
      local sTime = prepareTime
      local eTime = prepareTime
      local idx2 = 0
      if curTime >= prepareTime and curTime < battleTime then
        stage = LLConst.LandlordStage.PREPARE
        sTime = prepareTime
        eTime = battleTime
        idx2 = 0
      elseif curTime >= battleTime and curTime < restTime then
        stage = LLConst.LandlordStage.BATTLE
        sTime = battleTime
        eTime = restTime
        idx2 = 1
      elseif curTime >= restTime and curTime < nextWeekStartTime then
        stage = LLConst.LandlordStage.REST
        sTime = restTime
        eTime = nextWeekStartTime
        idx2 = 2
      end
      return {
        idx = idx * 3 + idx2,
        stage = stage,
        sTime = sTime,
        eTime = eTime,
        week = week.weekNum
      }
    end
  end
end

function LLTargetActInfoData:Description(sb)
end

return LLTargetActInfoData
