local base = require("DataCenter.LWGuideFlowManager.Triggers.TriggerBase")
local metatbl = {__index = base}
local trigger = setmetatable({}, metatbl)
trigger.name = "enter_battlefield"
trigger.params = {"number"}

function trigger.OnTrigger(battlefieldType)
  base.TryTrigger(trigger, battlefieldType)
end

EventManager:GetInstance():AddListener(EventId.GF_enter_battlefield, trigger.OnTrigger)

function trigger.CheckParams(params, evtParam)
  if not (params and not (#params < 1) and evtParam) or #evtParam < 1 then
    return false
  end
  local targetBattleFieldType = params[1] and tonumber(params[1]) or -1
  local triggerBattlefieldType = evtParam[1] and tonumber(evtParam[1]) or -2
  return targetBattleFieldType == triggerBattlefieldType
end

return trigger
