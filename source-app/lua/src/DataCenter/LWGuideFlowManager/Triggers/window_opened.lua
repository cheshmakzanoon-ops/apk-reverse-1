local base = require("DataCenter.LWGuideFlowManager.Triggers.TriggerBase")
local metatbl = {__index = base}
local trigger = setmetatable({}, metatbl)
trigger.name = "window_opened"
trigger.params = {"string"}

function trigger.OnTrigger(windowName)
  base.TryTrigger(trigger, windowName)
end

EventManager:GetInstance():AddListener(EventId["GF_" .. trigger.name], trigger.OnTrigger)

function trigger.CheckParams(params, evtParam)
  if string.IsNullOrEmpty(params[1]) or params[1] == "any" then
    return true
  end
  return params[1] == evtParam[1]
end

return trigger
