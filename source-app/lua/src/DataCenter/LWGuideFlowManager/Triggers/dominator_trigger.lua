local base = require("DataCenter.LWGuideFlowManager.Triggers.TriggerBase")
local metatbl = {__index = base}
local trigger = setmetatable({}, metatbl)
trigger.name = "dominator_trigger"
trigger.params = {"number", "number"}

function trigger.OnTrigger(eventInfo)
  base.TryTrigger(trigger, eventInfo)
end

EventManager:GetInstance():AddListener(EventId.DominatorReceiveNewOne, trigger.OnTrigger)

function trigger.CheckParams(params, evtParam)
  if params then
    local dominatorId = params[1]
    local triggerId = params[2]
    if dominatorId == DominatorId.Cockatrice and triggerId == DominatorGuideTriggerId.STEP_0 and evtParam and evtParam[1] and evtParam[1].dominatorId and evtParam[1].dominatorId == DominatorId.Cockatrice then
      return true
    end
  end
  return false
end

return trigger
