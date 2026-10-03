local AllianceScienceData = BaseClass("AllianceScienceData")

local function __init(self)
  self.currentPro = 0
  self.curLevel = 0
  self.needPro = 0
  self.nextPara2 = ""
  self.para1 = ""
  self.para2 = ""
  self.scienceId = 0
  self.science_condition = ""
  self.star = 0
  self.state = 0
  self.goldNum = 0
  self.maxGoldNum = 0
  self.maxNum = 0
  self.refreshTimeBlock = 0
  self.timePoint = 0
  self.useGoldNum = 0
  self.useNum = 0
  self.lowContribute = 0
  self.resNum = 0
  self.lowProgress = 0
  self.res = 0
  self.startTime = 0
  self.finishTime = 0
  self.time = 0
  self.research_consume = 0
  self.maxMemberNum = 0
  self.maxLevel = 0
end

local function __delete(self)
  self.currentPro = nil
  self.curLevel = nil
  self.needPro = nil
  self.nextPara2 = nil
  self.para1 = nil
  self.para2 = nil
  self.scienceId = nil
  self.science_condition = nil
  self.star = nil
  self.state = nil
  self.goldNum = nil
  self.maxGoldNum = nil
  self.maxNum = nil
  self.refreshTimeBlock = nil
  self.timePoint = nil
  self.useGoldNum = nil
  self.useNum = nil
  self.lowContribute = nil
  self.resNum = nil
  self.lowProgress = nil
  self.res = nil
  self.startTime = nil
  self.finishTime = nil
  self.research_consume = nil
  self.maxMemberNum = nil
  self.maxLevel = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.currentPro ~= nil then
    self.currentPro = message.currentPro
  end
  if message.level ~= nil then
    self.curLevel = message.level
  end
  if message.needPro ~= nil then
    self.needPro = message.needPro
  end
  if message.nextPara2 ~= nil then
    self.nextPara2 = message.nextPara2
  end
  if message.para1 ~= nil then
    self.para1 = message.para1
  end
  if message.para2 ~= nil then
    self.para2 = message.para2
  end
  if message.scienceId ~= nil then
    self.scienceId = message.scienceId
  end
  if message.science_condition ~= nil then
    self.science_condition = message.science_condition
  end
  if message.star ~= nil then
    self.star = message.star
  end
  if message.state ~= nil then
    self.state = message.state
  end
  if message.goldNum ~= nil then
    self.goldNum = message.goldNum
  end
  if message.maxGoldNum ~= nil then
    self.maxGoldNum = message.maxGoldNum
  end
  if message.maxNum ~= nil then
    self.maxNum = message.maxNum
  end
  if message.refreshTimeBlock ~= nil then
    self.refreshTimeBlock = message.refreshTimeBlock
  end
  if message.timePoint ~= nil then
    self.timePoint = message.timePoint
  end
  if message.useGoldNum ~= nil then
    self.useGoldNum = message.useGoldNum
  end
  if message.useNum ~= nil then
    self.useNum = message.useNum
  end
  if message.lowContribute ~= nil then
    self.lowContribute = message.lowContribute
  end
  if message.lowNum ~= nil then
    self.resNum = message.lowNum
  end
  if message.lowProgress ~= nil then
    self.lowProgress = message.lowProgress
  end
  if message.lowRes ~= nil then
    self.res = message.lowRes
  end
  if message.startTime ~= nil then
    self.startTime = message.startTime
  end
  if message.finishTime ~= nil then
    self.finishTime = message.finishTime
  end
  if message.time ~= nil then
    self.time = message.time
  end
  if message.research_consume ~= nil then
    self.research_consume = message.research_consume
  end
  if message.maxMemberNum ~= nil then
    self.maxMemberNum = message.maxMemberNum
  end
  if self.needPro <= 0 then
    local needTemplate = DataCenter.AllianceScienceTemplateManager:GetAlScienceTemplate(self.scienceId + self.curLevel)
    if needTemplate ~= nil then
      self.needPro = needTemplate.maxProNum
    else
      Logger.LogError("AllianceScienceData needPro error :" .. self.scienceId .. ", lv=" .. self.curLevel)
      self.needPro = 10000000
    end
  end
end

AllianceScienceData.__init = __init
AllianceScienceData.__delete = __delete
AllianceScienceData.ParseData = ParseData
return AllianceScienceData
