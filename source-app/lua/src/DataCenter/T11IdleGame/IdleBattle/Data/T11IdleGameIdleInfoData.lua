local T11IdleGameIdleInfoData = BaseClass("T11IdleGameIdleInfoData")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local T11IdleGameNodeData = require("DataCenter/T11IdleGame/IdleBattle/Data/T11IdleGameNodeData")

function T11IdleGameIdleInfoData:__init()
  self.startTime = 0
  self.endTime = 0
  self.soldierId = 0
  self.soldierNum = 0
  self.rewardPool = {}
  self.rewardNew = {}
  self.passNode = 0
  self.futureNodes = {}
  self.nodeRecord = ""
  self.challengePower = 0
  self.levelId = 0
  self.levelTemplate = nil
end

function T11IdleGameIdleInfoData:__delete()
  self:ClearData()
  self.levelId = nil
  self.levelTemplate = nil
end

function T11IdleGameIdleInfoData:ClearData()
  self.startTime = nil
  self.endTime = nil
  self.soldierId = nil
  self.soldierNum = nil
  self.rewardPool = nil
  self.rewardNew = nil
  self.passNode = nil
  self.nodeRecord = nil
  self.challengePower = nil
  self:DestroyFutureNodes()
end

function T11IdleGameIdleInfoData:UpdateData(data, levelId)
  if data == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameIdleInfoData:UpdateData call with nil data")
    return
  end
  if levelId ~= nil then
    self.levelId = levelId
  end
  if data.startTime then
    self.startTime = data.startTime
  end
  if data.endTime then
    self.endTime = data.endTime
  end
  if data.soldierId then
    self.soldierId = data.soldierId
  end
  if data.soldierNum then
    self.soldierNum = data.soldierNum
  end
  if data.rewardPool then
    self.rewardPool = data.rewardPool
  end
  if data.rewardNew then
    self.rewardNew = data.rewardNew
  end
  if data.passNode then
    self.passNode = data.passNode
  end
  if data.futureNodes then
    self:UpdateFutureNodes(data.futureNodes)
  end
  if data.nodeRecord then
    self.nodeRecord = data.nodeRecord
  end
  if data.challengePower then
    self.challengePower = data.challengePower
  end
  EventManager:GetInstance():Broadcast(EventId.T11IdleGameIdleInfoDataUpdate)
end

function T11IdleGameIdleInfoData:GetGamePassedTime()
  local timeNow = UITimeManager:GetInstance():GetServerTime()
  return math.max(timeNow - self.startTime)
end

function T11IdleGameIdleInfoData:DestroyFutureNodes()
  if self.futureNodes ~= nil then
    for k, v in pairs(self.futureNodes) do
      v:Destroy()
    end
  end
  ObjectPool:GetInstance():Clear(T11IdleGameNodeData)
  self.futureNodes = nil
end

function T11IdleGameIdleInfoData:UpdateFutureNodes(nodes)
  if self.futureNodes == nil then
    self.futureNodes = {}
  end
  for i, v in pairs(self.futureNodes) do
    v:Destroy()
    ObjectPool:GetInstance():Save(v)
  end
  self.futureNodes = {}
  if not table.IsNullOrEmpty(nodes) then
    for _, node in ipairs(nodes) do
      local nodeData = ObjectPool:GetInstance():Load(T11IdleGameNodeData)
      nodeData:SetOwner(self)
      nodeData:UpdateData(node)
      self.futureNodes[node.nodeIndex] = nodeData
    end
  end
end

function T11IdleGameIdleInfoData:GetPassedNodeIndex()
  return self.passNode
end

function T11IdleGameIdleInfoData:GetLevelTemplate()
  if self.levelTemplate == nil or self.levelTemplate.id ~= self.levelId then
    self.levelTemplate = DataCenter.T11IdleGameTemplateManager:GetLevelTemplateById(self.levelId)
  end
  return self.levelTemplate
end

function T11IdleGameIdleInfoData:GetStartTime()
  return self.startTime
end

function T11IdleGameIdleInfoData:GetNextTriggerNodeData()
  if not table.IsNullOrEmpty(self.futureNodes) then
    local severTimeNow = UITimeManager:GetInstance():GetServerTime()
    local node
    local passedIndex = self:GetPassedNodeIndex()
    for i, v in pairs(self.futureNodes) do
      if passedIndex < v:GetIndex() then
        local triggerTime = v:GetTriggerSeverTime()
        if severTimeNow > triggerTime and (node == nil or triggerTime > node:GetTriggerSeverTime()) then
          node = v
        end
      end
    end
    return node
  end
end

function T11IdleGameIdleInfoData:GetPassedNodeData()
  local index = self:GetPassedNodeIndex()
  return self:GetNodeDataByIndex(index)
end

function T11IdleGameIdleInfoData:GetNodeDataByIndex(index)
  if not table.IsNullOrEmpty(self.futureNodes) then
    for i, v in pairs(self.futureNodes) do
      if v:GetIndex() == index then
        return v
      end
    end
  end
end

function T11IdleGameIdleInfoData:IsFutureNodeDataExpired()
  local lastNodeIndex = 0
  local lastNode
  if self.futureNodes then
    for i, v in pairs(self.futureNodes) do
      local index = v:GetIndex()
      if lastNodeIndex < index then
        lastNodeIndex = index
        lastNode = v
      end
    end
  end
  local levelTemplate = self:GetLevelTemplate()
  if levelTemplate == nil then
    return true
  end
  local maxNodeIndex = levelTemplate.node_num
  if lastNodeIndex >= maxNodeIndex then
    return false
  end
  if not lastNode then
    return true
  end
  local timeNow = UITimeManager:GetInstance():GetServerTime()
  local lastNodeTriggerTime = lastNode:GetTriggerSeverTime()
  return timeNow >= lastNodeTriggerTime
end

function T11IdleGameIdleInfoData:GetRewardPoolForShow()
  return DataCenter.RewardManager:ReturnRewardParamForView(self.rewardPool)
end

function T11IdleGameIdleInfoData:GetRewardNewForShow()
  return DataCenter.RewardManager:ReturnRewardParamForView(self.rewardNew)
end

function T11IdleGameIdleInfoData:IsHasStarted()
  return self.startTime ~= nil and self.startTime > 0
end

function T11IdleGameIdleInfoData:GetSoldierAssetPath()
  return DataCenter.T11IdleGameTemplateManager:GetIdleBattleSoldierAssetPath(self.soldierId)
end

function T11IdleGameIdleInfoData:IsRewardPoolEmpty()
  return table.IsNullOrEmpty(self.rewardPool)
end

function T11IdleGameIdleInfoData:GetEndTime()
  local levelTemplate = self:GetLevelTemplate()
  if levelTemplate == nil then
    return 0
  end
  local startTime = self:GetStartTime()
  return startTime + levelTemplate.node_num * levelTemplate.node_interval * 1000
end

function T11IdleGameIdleInfoData:IsCanEnd()
  if not self:IsHasStarted() then
    return false
  end
  local endTime = self:GetEndTime()
  local severTimeNow = UITimeManager:GetInstance():GetServerTime()
  return endTime < severTimeNow
end

function T11IdleGameIdleInfoData:GetPassedNodeNumDict()
  local res = {}
  if not string.IsNullOrEmpty(self.nodeRecord) then
    local split1 = string.split(self.nodeRecord, "|")
    for _, v in ipairs(split1) do
      local split2 = string.split(v, ";")
      if #split2 == 2 then
        local data = {
          nodeType = tonumber(split2[1]),
          nodeNum = tonumber(split2[2])
        }
        table.insert(res, data)
      end
    end
  end
  return res
end

function T11IdleGameIdleInfoData:GetPowerStr()
  return string.GetFormattedSeparatorNum(math.floor(self.challengePower))
end

return T11IdleGameIdleInfoData
