local T11IdleGameIdleBattleNodeManager = BaseClass("T11IdleGameIdleBattleNodeManager")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local T11IdleGameIdleBattleNode_Chest = require("DataCenter/T11IdleGame/IdleBattle/Battle/Node/T11IdleGameIdleBattleNode_Chest")
local T11IdleGameIdleBattleNode_Battle = require("DataCenter/T11IdleGame/IdleBattle/Battle/Node/T11IdleGameIdleBattleNode_Battle")
local T11IdleGameIdleBattleNode_Event = require("DataCenter/T11IdleGame/IdleBattle/Battle/Node/T11IdleGameIdleBattleNode_Event")
local T11IdleGameIdleBattleNode_Base = require("DataCenter/T11IdleGame/IdleBattle/Battle/Node/T11IdleGameIdleBattleNode_Base")

function T11IdleGameIdleBattleNodeManager:__init(logic)
  self.logic = logic
  self.playingNodeIndex = 0
  self.nodeDict = {}
  self.playingNode = nil
  self.state = Const.NodeState.None
end

function T11IdleGameIdleBattleNodeManager:__delete()
  self:Destroy()
end

function T11IdleGameIdleBattleNodeManager:Destroy()
  self:Clear()
  self.logic = nil
  self.playingNodeIndex = nil
  self.nodeDict = nil
  self.playingNode = nil
  self.state = nil
end

function T11IdleGameIdleBattleNodeManager:Clear()
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  if self.nodeDict then
    for i, v in pairs(self.nodeDict) do
      v:Destroy()
    end
  end
  self.playingNode = nil
  self.playingNodeIndex = 0
  self.state = Const.NodeState.Empty
end

function T11IdleGameIdleBattleNodeManager:OnUpdate(deltaTime)
  if self.playingNode then
    self.playingNode:OnUpdate(deltaTime)
  end
end

function T11IdleGameIdleBattleNodeManager:IsCanTrigger(nodeData)
  local isEmpty = self.state == Const.NodeState.Empty or self.state == Const.NodeState.None
  if not isEmpty then
    return false
  end
  return true
end

function T11IdleGameIdleBattleNodeManager:TriggerNode(nodeData)
  if nodeData == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameIdleBattleNodeManager:TriggerNode call with nil data")
    return
  end
  self.playingNodeIndex = nodeData:GetIndex()
  DataCenter.T11IdleGameManager:PrintEditorCustomLog("T11IdleGameIdleBattleNodeManager:TriggerNode index:" .. nodeData:GetIndex())
  self.state = Const.NodeState.WaitForSever
  DataCenter.T11IdleGameDataManager:SendRewardUpdateMessage(nodeData)
end

function T11IdleGameIdleBattleNodeManager:OnRewardUpdate(passedNodeData)
  if passedNodeData == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameIdleBattleNodeManager:OnRewardUpdate call with nil passedNodeData")
    self.state = Const.NodeState.Empty
    return false
  end
  if self.playingNodeIndex <= 0 then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameIdleBattleNodeManager:OnRewardUpdate call playingNodeIndex 0")
    self.state = Const.NodeState.Empty
    return false
  end
  local passedIndex = passedNodeData:GetIndex()
  if passedIndex ~= self.playingNodeIndex then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameIdleBattleNodeManager:OnRewardUpdate wrong index, playingNodeIndex:" .. self.playingNodeIndex .. ", passedIndex:" .. passedIndex)
    self.state = Const.NodeState.Empty
    return false
  end
  self:StartPlay()
  return true
end

function T11IdleGameIdleBattleNodeManager:StartPlay()
  self.state = Const.NodeState.Playing
  local nodeData = self.logic:GetNodeDataByIndex(self.playingNodeIndex)
  self.playingNode = self:GetNodeByType(nodeData:GetType())
  self.playingNode:SetNodeData(nodeData)
  self.playingNode:Start()
  DataCenter.T11IdleGameManager:PrintEditorCustomLog("trigger node, index:" .. nodeData:GetIndex() .. ", type:" .. nodeData:GetType())
end

function T11IdleGameIdleBattleNodeManager:GetNodeByType(type)
  if self.nodeDict == nil then
    self.nodeDict = {}
  end
  if self.nodeDict[type] == nil then
    if type == Const.NodeType.Chest then
      self.nodeDict[type] = T11IdleGameIdleBattleNode_Chest.New(self.logic, self)
    elseif type == Const.NodeType.Battle then
      self.nodeDict[type] = T11IdleGameIdleBattleNode_Battle.New(self.logic, self)
    elseif type == Const.NodeType.Event then
      self.nodeDict[type] = T11IdleGameIdleBattleNode_Event.New(self.logic, self)
    else
      DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameIdleBattleNodeManager:GetNodeByType unknown type: " .. type)
      self.nodeDict[type] = T11IdleGameIdleBattleNode_Base.New(self.logic, self)
    end
  end
  return self.nodeDict[type]
end

function T11IdleGameIdleBattleNodeManager:OnNodePlayFinish(nodeData)
  self:Clear()
  self.logic:OnNodePlayFinish(nodeData)
end

function T11IdleGameIdleBattleNodeManager:GetNodePropRootByNodeType(type)
  if self.logic then
    return self.logic:GetNodePropRootByNodeType(type)
  end
  return nil
end

return T11IdleGameIdleBattleNodeManager
