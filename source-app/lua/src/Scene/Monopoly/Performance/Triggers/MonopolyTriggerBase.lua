local base = {}
local parser = require("DataCenter.LWGuideFlowManager.LWGuideFlowParamParser")

function base.RegisterPer(triggerType, trigger, perId, paramsStr)
  if trigger.triggerType and trigger.triggerType ~= triggerType then
    Logger.LogError("trigger type error! triggerType: " .. trigger.triggerType .. " perId: " .. perId)
  end
  trigger.triggerType = triggerType
  if trigger.shots == nil then
    trigger.shots = {}
  end
  if trigger.perIds == nil then
    trigger.perIds = {}
  end
  table.insert(trigger.perIds, perId)
  if trigger.shots[perId] == nil then
    trigger.shots[perId] = {}
  end
  if trigger.params == nil or #trigger.params == 0 then
    table.insert(trigger.shots[perId], {})
    return
  end
  if string.IsNullOrEmpty(paramsStr) then
    Logger.LogError("@" .. perId .. " trigger<" .. trigger.name .. "> params is nil!")
    return
  end
  local params = string.split(paramsStr, ",")
  if #params ~= #trigger.params then
    Logger.LogError("@" .. perId .. " trigger<" .. trigger.name .. "> params count error! need " .. #trigger.params .. " params but got " .. #params)
    return
  end
  if trigger.ParseParams ~= nil then
    params = trigger.ParseParams(params)
  else
    for i = 1, #trigger.params do
      local output, error = parser.Parse(trigger.params[i], params[i])
      if error ~= nil then
        Logger.LogError("@" .. perId .. " trigger<" .. trigger.name .. "> params type error! " .. error)
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
  table.insert(trigger.shots[perId], shot)
end

function base.UnregisterPer(trigger, perId)
  trigger.shots[perId] = nil
end

function base.TryTrigger(trigger, ...)
  local evtParam = {
    ...
  }
  for _, perId in pairs(trigger.perIds) do
    local shot = trigger.shots[perId]
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
        if trigger.triggerType == MonopolyPerformanceTriggerType.Begin then
          DataCenter.MonopolyManager.performanceManager:TryTriggerPerformanceBegin(perId)
        else
          DataCenter.MonopolyManager.performanceManager:TryTriggerPerformanceEnd(perId)
        end
      end
    end
  end
end

return base
