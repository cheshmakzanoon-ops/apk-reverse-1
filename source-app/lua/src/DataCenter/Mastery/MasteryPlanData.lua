local MasteryPlanData = BaseClass("MasteryPlanData")

local function __init(self)
  self.index = 0
  self.groupLevelDict = {}
  self.restPoint = 0
end

local function __delete(self)
  self.index = 0
  self.groupLevelDict = {}
  self.restPoint = 0
end

local function ParseServerData(self, serverData)
  if serverData.page then
    self.index = serverData.page
  end
  if serverData.pagePoints then
    self.groupLevelDict = {}
    for _, v in ipairs(serverData.pagePoints) do
      local group = tonumber(v.talentId) // MasteryLvCap
      self.groupLevelDict[group] = v.level
    end
  end
  if serverData.talentPoint then
    self.restPoint = serverData.talentPoint
  end
end

local function SetGroupLevel(self, group, level)
  self.groupLevelDict[group] = level
end

local function GetGroupLevel(self, group)
  return self.groupLevelDict[group] or 0
end

local function GetGroupLevelDict(self)
  return self.groupLevelDict
end

local function GetUsePoint(self)
  local usePoint = 0
  for _, level in pairs(self.groupLevelDict) do
    usePoint = usePoint + level
  end
  return usePoint
end

local function GetUsePointByHome(self, home)
  local usePoint = 0
  for group, level in pairs(self.groupLevelDict) do
    local template = DataCenter.MasteryManager:GetTemplate(group)
    if template.home == home then
      usePoint = usePoint + level
    end
  end
  return usePoint
end

local function GetTipState(self, group)
  local data = DataCenter.MasteryManager:GetData()
  local level = self:GetGroupLevel(group)
  local template = DataCenter.MasteryManager:GetTemplate(group, level)
  local nextTemplate = DataCenter.MasteryManager:GetTemplate(group, level + 1)
  if template.isClosed then
    return MasteryTipState.Closed, {}
  end
  if level >= template.maxLv then
    return MasteryTipState.Maxed, {}
  end
  local needGroupLv = {}
  for priorGroup, needPriorLv in pairs(template.needPriorLv) do
    if needPriorLv > self:GetGroupLevel(priorGroup) then
      needGroupLv[priorGroup] = needPriorLv
    end
  end
  local priorEnough
  if template.condType == MasteryCondType.And then
    priorEnough = table.count(needGroupLv) == 0
  elseif template.condType == MasteryCondType.Or then
    priorEnough = table.count(needGroupLv) < table.count(template.needPriorLv)
  end
  if priorEnough then
    needGroupLv = {}
  end
  if data.level < nextTemplate.needLv then
    return MasteryTipState.NeedLv, needGroupLv
  end
  if not priorEnough then
    return MasteryTipState.NeedPrior, needGroupLv
  end
  if 0 >= self.restPoint then
    return MasteryTipState.NeedPoint, needGroupLv
  end
  return MasteryTipState.CanLearn, needGroupLv
end

local function GetNodeState(self, group)
  local template = DataCenter.MasteryManager:GetTemplate(group)
  if self:GetGroupLevel(group) > 0 then
    return MasteryNodeState.On
  end
  if template.condType == MasteryCondType.And then
    for _, priorGroup in ipairs(template.priors) do
      if self:GetGroupLevel(priorGroup) <= 0 then
        return MasteryNodeState.Hide
      end
    end
    return MasteryNodeState.Off
  elseif template.condType == MasteryCondType.Or then
    for _, priorGroup in ipairs(template.priors) do
      if self:GetGroupLevel(priorGroup) > 0 then
        return MasteryNodeState.Off
      end
    end
    return MasteryNodeState.Hide
  end
  return MasteryNodeState.Hide
end

MasteryPlanData.__init = __init
MasteryPlanData.__delete = __delete
MasteryPlanData.ParseServerData = ParseServerData
MasteryPlanData.SetGroupLevel = SetGroupLevel
MasteryPlanData.GetGroupLevel = GetGroupLevel
MasteryPlanData.GetGroupLevelDict = GetGroupLevelDict
MasteryPlanData.GetUsePoint = GetUsePoint
MasteryPlanData.GetUsePointByHome = GetUsePointByHome
MasteryPlanData.GetTipState = GetTipState
MasteryPlanData.GetNodeState = GetNodeState
return MasteryPlanData
