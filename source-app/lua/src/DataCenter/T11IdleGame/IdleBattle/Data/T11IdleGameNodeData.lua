local T11IdleGameNodeData = BaseClass("T11IdleGameNodeData")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function T11IdleGameNodeData:__init()
  self.nodeId = 0
  self.nodeIndex = 0
  self.idleGameEvent = nil
  self.owner = nil
  self.triggerSeverTime = 0
end

function T11IdleGameNodeData:__delete()
  self:Destroy()
end

function T11IdleGameNodeData:SetOwner(owner)
  self.owner = owner
end

function T11IdleGameNodeData:UpdateData(data)
  if data == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameNodeData:UpdateData call with nil data")
    return
  end
  if data.nodeId then
    self.nodeId = data.nodeId
  end
  if data.nodeIndex then
    self.nodeIndex = data.nodeIndex
  end
  if data.idleGameEvent then
    self.idleGameEvent = data.idleGameEvent
  end
  self:UpdateTriggerSeverTime()
end

function T11IdleGameNodeData:Destroy()
  self.nodeId = nil
  self.nodeIndex = nil
  self.idleGameEvent = nil
  self.owner = nil
  self.triggerSeverTime = nil
end

function T11IdleGameNodeData:GetIndex()
  return self.nodeIndex
end

function T11IdleGameNodeData:PrintTriggerSeverTimeDebugLog()
  local template = self.owner:GetLevelTemplate()
  if template then
    local severTimeNow = UITimeManager:GetInstance():GetServerTime()
    local startTime = self.owner:GetStartTime()
    local index = self:GetIndex()
    local triggerSeverTime = startTime + template.node_interval * 1000 * index
    DataCenter.T11IdleGameManager:PrintRealInfoLog("T11IdleGameNodeData:PrintTriggerSeverTimeDebugLog startTime: " .. startTime .. " index: " .. index .. " triggerSeverTime: " .. triggerSeverTime .. " interval: " .. template.node_interval .. " severTimeNow: " .. severTimeNow)
  else
    DataCenter.T11IdleGameManager:PrintRealInfoLog("T11IdleGameNodeData:PrintTriggerSeverTimeDebugLog template is nil")
  end
end

function T11IdleGameNodeData:UpdateTriggerSeverTime()
  self.triggerSeverTime = 0
  if self.owner then
    local template = self.owner:GetLevelTemplate()
    if template then
      local startTime = self.owner:GetStartTime()
      local index = self:GetIndex()
      self.triggerSeverTime = startTime + template.node_interval * 1000 * index
    else
      DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameNodeData:UpdateTriggerSeverTime template is nil")
    end
  else
    DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameNodeData:UpdateTriggerSeverTime owner is nil")
  end
end

function T11IdleGameNodeData:GetTriggerSeverTime()
  return self.triggerSeverTime
end

function T11IdleGameNodeData:GetTemplate()
  return DataCenter.T11IdleGameTemplateManager:GetNodeTemplateById(self.nodeId)
end

function T11IdleGameNodeData:GetType()
  local template = self:GetTemplate()
  if template then
    return template.node_type
  end
  return 0
end

function T11IdleGameNodeData:GetPropAssetPath()
  local template = self:GetTemplate()
  if template and not string.IsNullOrEmpty(template.asset_path) then
    return template.asset_path
  end
  return ""
end

function T11IdleGameNodeData:GetMonsterData()
  local template = self:GetTemplate()
  if template then
    local monsterData = template:GetMonsterData()
    if monsterData then
      local bossId = monsterData.bossData[math.random(1, #monsterData.bossData)]
      local zombieId1 = monsterData.zombieData[math.random(1, #monsterData.zombieData)]
      local zombieId2 = monsterData.zombieData[math.random(1, #monsterData.zombieData)]
      return {
        bossId = bossId,
        zombieId1 = zombieId1,
        zombieId2 = zombieId2
      }
    end
  end
end

return T11IdleGameNodeData
