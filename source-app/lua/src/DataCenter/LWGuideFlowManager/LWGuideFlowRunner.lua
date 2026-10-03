local BehaviourBase = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local Runner = {}

function Runner:Run(flowId, context)
  if self.runningFlowId ~= nil then
    printError("LWGuideFlowRunner.Run: already running! -> " .. self.runningFlowId .. " and to run:" .. flowId)
    return
  end
  DataCenter.LWGuideFlowManager:Log("--=== Try: " .. flowId .. " =============")
  self.context = context
  self.runningFlowId = flowId
  self.behaviours = {}
  self.currStep = 0
  self.keyStep = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Guide_Flow), flowId, "key_behaviour_step")
  local behavioursStrArr
  behavioursStrArr = string.split(LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Guide_Flow), flowId, "guide_behaviours"), "|")
  for _, behavioursStr in ipairs(behavioursStrArr) do
    local behaviourStrArr = string.split(behavioursStr, ":")
    local behaviourInst = BehaviourBase.Instantiate(behaviourStrArr[1], flowId, behaviourStrArr[2])
    if behaviourInst then
      table.insert(self.behaviours, behaviourInst)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.GF_guide_start, flowId)
  self:NextStep()
  PostEventLog.Track(PostEventLog.Defines.GuideFlowBegin, {
    flowId = tostring(self.runningFlowId)
  })
end

function Runner:GetCurrBehaviour()
  return self.behaviours[self.currStep]
end

function Runner:NextStep(canceled)
  if not canceled and self.currStep == self.keyStep then
    DataCenter.LWGuideFlowManager:WriteDone(self.runningFlowId)
  end
  self.currStep = self.currStep + 1
  if canceled or self.currStep > #self.behaviours then
    for _, behaviour in ipairs(self.behaviours) do
      if behaviour.Clear ~= nil then
        behaviour:Clear()
        behaviour.context = nil
      end
    end
    self:Done(canceled)
    return
  end
  local behaviour = self.behaviours[self.currStep]
  behaviour.canceled = false
  behaviour.done = false
  behaviour.context = self.context
  behaviour:Begin()
  PostEventLog.Track(PostEventLog.Defines.GuideFlowStepIn, {
    flowId = tostring(self.runningFlowId),
    step = tostring(self.currStep)
  })
end

function Runner:Done(canceled)
  local doneId = self.runningFlowId
  self.runningFlowId = nil
  self.behaviours = nil
  if canceled then
    EventManager:GetInstance():Broadcast(EventId.GF_guide_canceled, doneId)
  else
    EventManager:GetInstance():Broadcast(EventId.GF_guide_done, doneId)
    PostEventLog.Track(PostEventLog.Defines.GuideFlowDone, {
      flowId = tostring(doneId)
    })
  end
  DataCenter.LWGuideFlowManager:Log("@@ Runner Done: " .. doneId .. "canceled: " .. tostring(canceled))
end

function Runner:Update(deltaTime)
  if self.runningFlowId == nil then
    return
  end
  local currBehaviour = self:GetCurrBehaviour()
  if currBehaviour == nil then
    return
  end
  if currBehaviour.done or currBehaviour.canceled then
    if currBehaviour.End ~= nil then
      currBehaviour:End()
    end
    PostEventLog.Track(PostEventLog.Defines.GuideFlowStepOut, {
      flowId = tostring(self.runningFlowId),
      step = tostring(self.currStep)
    })
    EventManager:GetInstance():Broadcast(currBehaviour.done and EventId.GF_guide_step_done or EventId.GF_guide_step_canceled, currBehaviour)
    self:NextStep(currBehaviour.canceled)
  elseif currBehaviour.Update ~= nil then
    currBehaviour:Update(deltaTime)
  end
end

function Runner:Kill()
  local currBehaviour = self:GetCurrBehaviour()
  if currBehaviour ~= nil then
    currBehaviour.canceled = true
    PostEventLog.Track(PostEventLog.Defines.GuideFlowSkip, {
      flowId = tostring(self.runningFlowId)
    })
  end
end

function Runner:IsRun()
  return self.runningFlowId ~= nil
end

function Runner:EditorDebugRun(flowId, context, behavioursStr)
  if self.runningFlowId ~= nil then
    printError("LWGuideFlowRunner.Run: already running! -> " .. self.runningFlowId .. " and to run:" .. flowId)
    return
  end
  DataCenter.LWGuideFlowManager:EditorLog("\229\188\128\229\167\139\232\167\166\229\143\145: %s", flowId)
  self.context = context
  self.runningFlowId = flowId
  self.behaviours = {}
  self.currStep = 0
  self.keyStep = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Guide_Flow), flowId, "key_behaviour_step")
  behavioursStr = behavioursStr or LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Guide_Flow), flowId, "guide_behaviours")
  local behavioursStrArr
  behavioursStrArr = string.split(behavioursStr, "|")
  for _, behavioursStr in ipairs(behavioursStrArr) do
    local behaviourStrArr = string.split(behavioursStr, ":")
    local behaviourInst = BehaviourBase.Instantiate(behaviourStrArr[1], flowId, behaviourStrArr[2])
    table.insert(self.behaviours, behaviourInst)
    DataCenter.LWGuideFlowManager:EditorLog("\229\136\155\229\187\186\232\161\140\228\184\186\229\175\185\232\177\161: name:%s, attr:%s", behaviourStrArr[1], behaviourStrArr[2])
  end
  DataCenter.LWGuideFlowManager:EditorLog("\232\161\140\228\184\186\230\149\176\233\135\143\230\128\187\232\174\161:%s", #self.behaviours)
  EventManager:GetInstance():Broadcast(EventId.GF_guide_start, flowId)
  self:NextStep()
end

function Runner:OnDestroy()
  if self.runningFlowId == nil then
    return
  end
  local currBehaviour = self:GetCurrBehaviour()
  if currBehaviour == nil then
    return
  end
  if currBehaviour.OnDestroy then
    currBehaviour:OnDestroy()
  end
end

return Runner
