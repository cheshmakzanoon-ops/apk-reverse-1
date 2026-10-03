local base = {}
local mgr = DataCenter.LWGuideFlowManager
local parser = require("DataCenter.LWGuideFlowManager.LWGuideFlowParamParser")

function base.RegisterFlow(trigger, flowId, paramsStr)
  if trigger.shots == nil then
    trigger.shots = {}
  end
  if trigger.flowIds == nil then
    trigger.flowIds = {}
  end
  table.insert(trigger.flowIds, flowId)
  if trigger.shots[flowId] == nil then
    trigger.shots[flowId] = {}
  end
  if trigger.params == nil or #trigger.params == 0 then
    table.insert(trigger.shots[flowId], {})
    return
  end
  if string.IsNullOrEmpty(paramsStr) then
    Logger.LogError("@" .. flowId .. " trigger<" .. trigger.name .. "> params is nil!")
    return
  end
  local params = string.split(paramsStr, ",")
  if #params ~= #trigger.params then
    Logger.LogError("@" .. flowId .. " trigger<" .. trigger.name .. "> params count error! need " .. #trigger.params .. " params but got " .. #params)
    return
  end
  if trigger.ParseParams ~= nil then
    params = trigger.ParseParams(params)
  else
    for i = 1, #trigger.params do
      local output, error = parser.Parse(trigger.params[i], params[i])
      if error ~= nil then
        Logger.LogError("@" .. flowId .. " trigger<" .. trigger.name .. "> params type error! " .. error)
        return
      else
        params[i] = output
      end
    end
  end
  local shot = {}
  for i = 1, #trigger.params do
    table.insert(shot, params[i])
  end
  table.insert(trigger.shots[flowId], shot)
end

function base.UnregisterFlow(trigger, flowId)
  trigger.shots[flowId] = nil
end

function base.TryTrigger(trigger, ...)
  local evtParam = {
    ...
  }
  mgr:Log("<<" .. trigger.name .. ">> TIRGGERED!!!")
  for _, flowId in pairs(trigger.flowIds) do
    local shot = trigger.shots[flowId]
    if shot ~= nil then
      local hit = false
      for _, params in ipairs(shot) do
        if trigger.CheckParams ~= nil then
          hit = trigger.CheckParams(params, evtParam)
        else
          local match = true
          if #params ~= 0 then
            for i = 1, #params do
              match = match and params[i] == evtParam[i]
              if not match then
                break
              end
            end
          end
          hit = match
        end
        if hit then
          break
        end
      end
      if hit then
        mgr:TryTriggerFlow(flowId, evtParam)
      end
    end
  end
end

return base
