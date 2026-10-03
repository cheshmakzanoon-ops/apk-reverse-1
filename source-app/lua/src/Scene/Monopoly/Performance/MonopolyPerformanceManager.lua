local MonopolyPerformanceManager = BaseClass("MonopolyPerformanceManager")

function MonopolyPerformanceManager:__init()
  self.beginTriggers = nil
  self.endTriggers = nil
  self.performances = nil
  self.landEggRewards = nil
end

function MonopolyPerformanceManager:__delete()
  self:Clear()
end

function MonopolyPerformanceManager:Clear()
  if self.performances then
    for i, v in pairs(self.performances) do
      v:Delete()
    end
  end
  self.beginTriggers = nil
  self.endTriggers = nil
  self.performances = nil
  self.inited = nil
  self.landEggRewards = nil
end

function MonopolyPerformanceManager:InitData()
  if self.inited then
    return
  end
  if not DataCenter.LWCivilizationSparkExtend:UseCivilizationSparkGuide() then
    return
  end
  self.inited = true
  self.beginTriggers = {}
  self.endTriggers = {}
  self.performances = {}
  LocalController:instance():visitTable(LuaEntry.Player:GetABTestTableName(TableName.MONOPOLY_PERFORMANCE), function(perId, lineData)
    if self:NeedInit(lineData) then
      self:InitTriggers(MonopolyPerformanceTriggerType.Begin, perId, lineData)
      self:InitTriggers(MonopolyPerformanceTriggerType.End, perId, lineData)
    end
  end)
end

function MonopolyPerformanceManager:NeedInit(lineData)
  local monopolyCheck = lineData:getValue("monopoly_check")
  if monopolyCheck ~= 0 and DataCenter.MonopolyManager.player.curId ~= 0 and monopolyCheck <= DataCenter.MonopolyManager.player.curId then
    return false
  end
  local perType = lineData:getValue("per_type")
  if perType == MonopolyPerformanceType.EasterEgg then
    local landId = lineData:getValue("land_id")
    return DataCenter.LandLockManager:CanGetLandEggReward(landId)
  end
  return true
end

function MonopolyPerformanceManager:InitTriggers(triggerType, perId, lineData)
  local lineKey, triggers
  if triggerType == MonopolyPerformanceTriggerType.Begin then
    lineKey = "begin_triggers"
    triggers = self.beginTriggers
  elseif triggerType == MonopolyPerformanceTriggerType.End then
    lineKey = "end_triggers"
    triggers = self.endTriggers
  end
  local config = lineData:getValue(lineKey)
  if not string.IsNullOrEmpty(config) then
    local triggersStrArr = string.split(config, "|")
    for _, triggersStr in ipairs(triggersStrArr) do
      local triggerStrArr = string.split(triggersStr, ":")
      local triggerName = triggerStrArr[1]
      local triggerParams = triggerStrArr[2]
      local trigger = triggers[triggerName]
      local success = true
      local class
      if trigger == nil then
        success, class = pcall(require, "Scene.Monopoly.Performance.Triggers." .. triggerName)
        if success then
          local metatbl = {__index = class}
          trigger = setmetatable({}, metatbl)
          triggers[triggerName] = trigger
        else
          Logger.LogError("MonopolyPerformanceManager:InitTriggers: : class is nil! -> " .. triggerName)
          trigger = nil
        end
      end
      if trigger then
        trigger.RegisterPer(triggerType, trigger, perId, triggerParams)
      end
    end
  end
end

function MonopolyPerformanceManager:TryTriggerPerformanceBegin(perId)
  local performance
  if self.beginTriggers then
    for _, trigger in pairs(self.beginTriggers) do
      trigger.UnregisterPer(trigger, perId)
    end
  end
  if self.performances then
    if self.performances[perId] then
      return self.performances[perId]
    end
    local lineData = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.MONOPOLY_PERFORMANCE), perId)
    local perType = tonumber(lineData:getValue("per_type"))
    local success, behaviour = pcall(require, "Scene.Monopoly.Performance.Performance." .. MonopolyPerformanceClass[perType])
    if not success then
      Logger.LogError("MonopolyPerformanceManager:TryTriggerPerformanceBegin: class is nil! -> " .. MonopolyPerformanceClass[perType])
      return
    end
    performance = behaviour.New(self, perId, lineData)
    performance:Begin()
    self.performances[perId] = performance
  end
  return performance
end

function MonopolyPerformanceManager:TryTriggerPerformanceEnd(perId)
  if self.endTriggers then
    for _, trigger in pairs(self.endTriggers) do
      trigger.UnregisterPer(trigger, perId)
    end
  end
  if self.performances and self.performances[perId] then
    self.performances[perId]:End()
    self.performances[perId] = nil
  end
end

function MonopolyPerformanceManager:RunTrigger(triggerName, param)
  if SceneUtils.GetIsInCity() then
    if self.beginTriggers and self.beginTriggers[triggerName] then
      self.beginTriggers[triggerName]:OnTrigger(param)
    end
    if self.endTriggers and self.endTriggers[triggerName] then
      self.endTriggers[triggerName]:OnTrigger(param)
    end
  end
end

function MonopolyPerformanceManager:SetLandEggReward(landId, reward)
  if not self.landEggRewards then
    self.landEggRewards = {}
  end
  self.landEggRewards[landId] = reward
end

function MonopolyPerformanceManager:ConsumeLandEggReward(landId)
  if not self.landEggRewards or not self.landEggRewards[landId] then
    return nil
  end
  local reward = self.landEggRewards[landId]
  self.landEggRewards[landId] = nil
  return reward
end

return MonopolyPerformanceManager
