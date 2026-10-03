local base = require("DataCenter.LWGuideFlowManager.Triggers.TriggerBase")
local metatbl = {__index = base}
local trigger = setmetatable({}, metatbl)
trigger.name = "building_upgrade_started"
trigger.params = {
  "number",
  "number",
  "number"
}

function trigger.OnTrigger(buildingData)
  base.TryTrigger(trigger, buildingData.itemId, buildingData.pointId, buildingData.level)
end

EventManager:GetInstance():AddListener(EventId["GF_" .. trigger.name], trigger.OnTrigger)

function trigger.CheckParams(params, evtParam)
  local result = true
  result = result and (params[1] < 0 or params[1] == evtParam[1])
  result = result and (0 > params[2] or params[2] == evtParam[2])
  result = result and (0 > params[3] or params[3] == evtParam[3])
  return result
end

return trigger
