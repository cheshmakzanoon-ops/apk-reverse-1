local base = require("DataCenter.LWGuideFlowManager.Triggers.TriggerBase")
local metatbl = {__index = base}
local trigger = setmetatable({}, metatbl)
trigger.name = "building_menu_btn_popout"
trigger.params = {"number", "number"}

function trigger.OnTrigger(par)
  local buildId = 0
  if par.info and par.info.itemId then
    buildId = par.info.itemId
  end
  base.TryTrigger(trigger, buildId, par.btnType)
end

EventManager:GetInstance():AddListener(EventId["GF_" .. trigger.name], trigger.OnTrigger)

function trigger.CheckParams(params, evtParam)
  local result = true
  result = result and (params[1] < 0 or params[1] == evtParam[1])
  result = result and params[2] == evtParam[2]
  return result
end

return trigger
