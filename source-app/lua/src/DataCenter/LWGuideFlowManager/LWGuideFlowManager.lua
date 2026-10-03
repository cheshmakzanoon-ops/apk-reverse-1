local LWGuideFlowManager = BaseClass("LWGuideFlowManager")

function LWGuideFlowManager:__init()
  self.__debugLog = {}
  self.__debugLogSwtich = CS.CommonUtils.IsDebug()
  self.doneFlows = {}
  self.serverDoneFlowsMerged = false
  self.waitingFlows = {}
  self.triggers = {}
  self.flowConditionShots = {}
  self.Runner = require("DataCenter.LWGuideFlowManager.LWGuideFlowRunner")
  UpdateManager:GetInstance():AddUpdate(self.OnUpdate)
end

function LWGuideFlowManager:__delete()
  UpdateManager:GetInstance():RemoveUpdate(self.OnUpdate)
  self.doneFlows = nil
  self.waitingFlows = nil
  self.triggers = nil
  self.flowConditionShots = nil
  if self.Runner then
    self.Runner:OnDestroy()
  end
  self.Runner = nil
end

function LWGuideFlowManager:Log(msg)
  if self.__debugLogSwtich then
    if #self.__debugLog > 500 then
      table.remove(self.__debugLog, 1)
    end
    table.insert(self.__debugLog, msg)
  end
end

function LWGuideFlowManager:DumpLog()
  local str = ""
  for _, log in ipairs(self.__debugLog) do
    str = str .. log .. "\n"
  end
  return str
end

function LWGuideFlowManager:InitData(msg)
  if msg.lwGuideRecordSteps then
    self:OnServerRecords(msg.lwGuideRecordSteps)
  end
end

function LWGuideFlowManager:OnServerRecords(serverDoneFlows)
  if not self.serverDoneFlowsMerged then
    for flowId, _ in pairs(serverDoneFlows) do
      self.doneFlows[tonumber(flowId)] = 1
      if CommonUtil.PlayerPrefsGetInt("GF_Done_" .. flowId, 0) == 0 then
        CommonUtil.PlayerPrefsSetInt("GF_Done_" .. flowId, 1)
      end
    end
    self.serverDoneFlowsMerged = true
  end
end

function LWGuideFlowManager:ReadDone(flowId)
  if not self.doneFlows then
    return
  end
  if self.doneFlows[flowId] == nil then
    self.doneFlows[flowId] = CommonUtil.PlayerPrefsGetInt("GF_Done_" .. flowId, 0)
    if self.doneFlows[flowId] > 0 and self.serverDoneFlowsMerged then
      SFSNetwork.SendMessage(MsgDefines.LWSaveGuideStep, flowId)
    end
  end
  return self.doneFlows[flowId] > 0
end

function LWGuideFlowManager:WriteDone(flowId)
  self.doneFlows[flowId] = 1
  CommonUtil.PlayerPrefsSetInt("GF_Done_" .. flowId, 1)
  SFSNetwork.SendMessage(MsgDefines.LWSaveGuideStep, flowId)
  self:Log("WriteDone: " .. flowId)
  local otherFlows = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Guide_Flow), flowId, "done_together")
  if otherFlows ~= nil and 0 < #otherFlows then
    for _, otherFlowId in ipairs(otherFlows) do
      if not self:ReadDone(otherFlowId) then
        self:WriteDone(otherFlowId)
      end
    end
  end
end

function LWGuideFlowManager:Startup()
end

function LWGuideFlowManager:InitTriggers()
  self.flowConditionShots = {}
  LocalController:instance():visitTable(LuaEntry.Player:GetABTestTableName(TableName.LW_Guide_Flow), function(flowId, lineData)
    if not self:ReadDone(flowId) then
      local event_triggers = lineData:getValue("event_triggers")
      local triggersStrArr = string.split(event_triggers, "|")
      for _, triggersStr in ipairs(triggersStrArr) do
        local triggerStrArr = string.split(triggersStr, ":")
        local triggerName = triggerStrArr[1]
        if string.IsNullOrEmpty(triggerName) then
          Logger.LogError("LWGuideFlowManager.InitTriggers: triggerName is nil! -> " .. flowId)
        end
        local triggerParams = triggerStrArr[2]
        local trigger = self.triggers[triggerName]
        if trigger == nil then
          self:Log("Trigger Listener Setup: " .. triggerName)
          local success = false
          success, trigger = pcall(require, "DataCenter.LWGuideFlowManager.Triggers." .. triggerName)
          if not success then
            Logger.LogError(string.format("[\229\188\149\229\175\188\233\148\153\232\175\175]\229\136\157\229\167\139\229\140\150\229\188\149\229\175\188trigger\239\188\154%s\229\164\177\232\180\165\239\188\129\232\132\154\230\156\172\229\138\160\232\189\189\229\164\177\232\180\165~ \232\191\153\228\184\170\229\188\149\229\175\188 %s \229\143\175\232\131\189\230\151\160\230\179\149\232\167\166\229\143\145~\239\188\140 \233\148\153\232\175\175:%s", triggerName, flowId, trigger))
            trigger = nil
          elseif trigger == true then
            Logger.LogError(string.format("[\229\188\149\229\175\188\233\148\153\232\175\175]\229\136\157\229\167\139\229\140\150\229\188\149\229\175\188trigger\239\188\154%s\229\164\177\232\180\165\239\188\129id=%s, \232\132\154\230\156\172\229\143\175\232\131\189\230\152\175\228\184\170\231\169\186\230\150\135\228\187\182\239\188\129", triggerName, flowId))
            trigger = nil
          else
            self.triggers[triggerName] = trigger
          end
        end
        if trigger then
          trigger.RegisterFlow(trigger, flowId, triggerParams)
        end
      end
    end
  end)
  for _, trigger in pairs(self.triggers) do
    table.sort(trigger.flowIds)
  end
end

function LWGuideFlowManager:TryTriggerFlow(flowId, evtParams)
  self:Log("--=== Try: " .. flowId .. " =============")
  local error
  local conditionShots = self.flowConditionShots[flowId]
  if conditionShots == nil then
    conditionShots = {}
    local conditionsStrValue = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Guide_Flow), flowId, "state_conditions")
    if not string.IsNullOrEmpty(conditionsStrValue) then
      local conditionsStrArr = string.split(conditionsStrValue, "|")
      for _, conditionsStr in ipairs(conditionsStrArr) do
        local conditionStrArr = string.split(conditionsStr, ":")
        local conditionName = conditionStrArr[1]
        local isNot = false
        if string.startswith(conditionName, "!") then
          conditionName = string.SubStr(conditionName, 2)
          isNot = true
        end
        if string.IsNullOrEmpty(conditionName) then
          error = "@" .. flowId .. " take condition shot error: conditionName is nil!"
          break
        end
        local conditionParams = conditionStrArr[2]
        local success, condition = pcall(require, "DataCenter.LWGuideFlowManager.Conditions." .. conditionName)
        if not success then
          Logger.LogError(string.format("[\229\188\149\229\175\188\233\148\153\232\175\175]\229\176\157\232\175\149\232\167\166\229\143\145\229\188\149\229\175\188:%s\229\164\177\232\180\165\239\188\129\230\137\190\228\184\141\229\136\176\230\157\161\228\187\182\232\132\154\230\156\172:%s", flowId, conditionName))
          condition = nil
        end
        if condition == nil then
          error = "@" .. flowId .. " >> " .. conditionName .. " take condition shot error: condition not found!"
          break
        end
        local params, errorMsg = condition.TakeShot(condition, flowId, conditionParams)
        if errorMsg ~= nil then
          error = "@" .. flowId .. " >> " .. conditionName .. " take condition shot error: " .. errorMsg
          break
        end
        table.insert(conditionShots, {
          condition,
          params,
          isNot
        })
      end
    end
    self.flowConditionShots[flowId] = conditionShots
  end
  if error ~= nil then
    Logger.LogError(error)
    for _, trigger in pairs(self.triggers) do
      trigger.UnregisterFlow(trigger, flowId)
    end
    return false
  end
  for _, shot in pairs(conditionShots) do
    local condition = shot[1]
    local params = shot[2]
    local isNot = shot[3]
    local result = condition.Check(condition, params)
    if isNot then
      result = not result
    end
    self:Log("Cond " .. (isNot and "!" or "") .. condition.name .. " -> " .. tostring(result))
    if not result then
      return false
    end
  end
  for _, trigger in pairs(self.triggers) do
    trigger.UnregisterFlow(trigger, flowId)
  end
  if self.Runner.runningFlowId == nil and #self.waitingFlows == 0 then
    self:Log("!! Run Directly: " .. flowId)
    self.Runner:Run(flowId, {evtParams = evtParams})
  else
    self:Log("@@ In Queue: " .. flowId)
    table.insert(self.waitingFlows, {
      flowId,
      {evtParams = evtParams}
    })
  end
  return true
end

function LWGuideFlowManager:TryTriggerFlexibly(flowId, breakCurrent)
  if self.Runner == nil then
    return false
  end
  if self:ReadDone(flowId) then
    return false
  end
  local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Guide_Flow), flowId)
  if line == nil then
    return false
  end
  if self.Runner.runningFlowId == nil then
    if #self.waitingFlows == 0 then
      self:TryTriggerFlow(flowId)
      return true
    end
  elseif breakCurrent and #self.waitingFlows == 0 then
    self:KillRunningFlow()
    self:TryTriggerFlow(flowId)
    return true
  end
  return false
end

function LWGuideFlowManager.OnUpdate()
  local self = DataCenter.LWGuideFlowManager
  if self.Runner == nil then
    return
  end
  if self.Runner.runningFlowId ~= nil then
    self.Runner:Update(Time.deltaTime)
  elseif #self.waitingFlows > 0 then
    local flowContext = self.waitingFlows[1]
    table.remove(self.waitingFlows, 1)
    self:Log("^^ Run From Queue: " .. flowContext[1])
    self.Runner:Run(flowContext[1], flowContext[2])
  end
end

function LWGuideFlowManager:KillRunningFlow()
  if self.Runner.runningFlowId ~= nil then
    self.Runner:Kill()
  end
end

function LWGuideFlowManager:Description()
  local sb = StringBuilder.New()
  sb:AppendFormatLine("serverDoneFlowsMerged : %s", self.serverDoneFlowsMerged)
  sb:AppendFormatLine("doneFlows count : %s", table.count(self.doneFlows))
  sb:AppendFormatLine("curRunning: %s", DataCenter.LWGuideFlowManager:TryGetCurrentRunning())
  return sb:ToString()
end

function LWGuideFlowManager:EditorGetFlows()
  local _ = {}
  for k, v in pairs(self.doneFlows) do
    table.insert(_, {id = k, state = v})
  end
  return _
end

function LWGuideFlowManager:EditorLog(format, ...)
  local log = string.format(format, ...)
  log = string.format("<color=#FFFF00>[Guide]</color>%s", log)
  Logger.Log(log)
end

function LWGuideFlowManager:EditorTryConditions(flowId)
  local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Guide_Flow), flowId)
  if line == nil then
    Logger.LogError("[\233\148\153\232\175\175]\230\137\190\228\184\141\229\136\176\229\188\149\229\175\188\233\133\141\231\189\174! ID = " .. flowId)
    return false
  end
  self:KillRunningFlow()
  self:EditorLog("\230\163\128\230\159\165 %s \230\152\175\229\144\166\232\190\190\230\136\144\232\167\166\229\143\145\230\157\161\228\187\182~", flowId)
  local conditionShots = self.flowConditionShots[flowId]
  if conditionShots == nil then
    conditionShots = {}
    local conditionsStrValue = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Guide_Flow), flowId, "state_conditions")
    if not string.IsNullOrEmpty(conditionsStrValue) then
      local conditionsStrArr = string.split(conditionsStrValue, "|")
      for _, conditionsStr in ipairs(conditionsStrArr) do
        local conditionStrArr = string.split(conditionsStr, ":")
        local conditionName = conditionStrArr[1]
        local isNot = false
        if string.startswith(conditionName, "!") then
          conditionName = string.SubStr(conditionName, 2)
          isNot = true
        end
        if string.IsNullOrEmpty(conditionName) then
          error = "@" .. flowId .. " take condition shot error: conditionName is nil!"
          break
        end
        local conditionParams = conditionStrArr[2]
        local condition = require("DataCenter.LWGuideFlowManager.Conditions." .. conditionName)
        if condition == nil then
          error = "@" .. flowId .. " >> " .. conditionName .. " take condition shot error: condition not found!"
          break
        end
        local params, errorMsg = condition.TakeShot(condition, flowId, conditionParams)
        if errorMsg ~= nil then
          error = "@" .. flowId .. " >> " .. conditionName .. " take condition shot error: " .. errorMsg
          break
        end
        table.insert(conditionShots, {
          condition,
          params,
          isNot
        })
      end
    end
    self.flowConditionShots[flowId] = conditionShots
  end
  local finalResult = true
  for _, shot in pairs(conditionShots) do
    local condition = shot[1]
    local params = shot[2]
    local isNot = shot[3]
    local result = condition.Check(condition, params)
    if isNot then
      result = not result
    end
    self:EditorLog("Cond:%s, name:%s, result:%s", isNot and "!" or "", condition.name, result and "<color=#00FF00>True</color>" or "<color=#FF0000>False</color>")
    if not result then
      finalResult = result
    end
  end
  if finalResult then
    self:EditorLog("\230\129\173\229\150\156\239\188\129%s \232\167\166\229\143\145\230\157\161\228\187\182\230\163\128\230\159\165\233\128\154\232\191\135\229\145\162~", flowId)
  else
    self:EditorLog("\230\129\173\229\150\156\239\188\129%s \232\167\166\229\143\145\230\157\161\228\187\182\230\163\128\230\159\165 <color=#FF0000>\228\184\141</color> \233\128\154\232\191\135\229\145\162~ \229\147\136\229\147\136", flowId)
  end
end

function LWGuideFlowManager:EditorTryGuideBehaviours(flowId, str)
  local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Guide_Flow), flowId)
  if line == nil then
    Logger.LogError("[\233\148\153\232\175\175]\230\137\190\228\184\141\229\136\176\229\188\149\229\175\188\233\133\141\231\189\174! ID = " .. flowId)
    return false
  end
  self:KillRunningFlow()
  self:EditorLog("\229\176\157\232\175\149\230\146\173\230\148\190 %s \231\154\132\232\161\140\228\184\186~, guide_behaviours\228\184\186:%s", flowId, str)
  self.Runner:EditorDebugRun(flowId, {}, str)
end

function LWGuideFlowManager:EditorTryGuideBehavioursStr(str)
  if not str then
    return
  end
  self:KillRunningFlow()
  self:EditorLog("\229\176\157\232\175\149\230\146\173\230\148\190\232\161\140\228\184\186, str=%s", str)
  self.Runner:EditorDebugRun(flowId, {})
end

function LWGuideFlowManager:TryGetCurrentRunning()
  return self.Runner and self.Runner.runningFlowId
end

function LWGuideFlowManager:IsRunning()
  return self.Runner and self.Runner.runningFlowId ~= nil
end

return LWGuideFlowManager
