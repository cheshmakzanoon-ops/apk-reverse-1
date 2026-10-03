local base = require("DataCenter.LWGuideFlowManager.Triggers.TriggerBase")
local metatbl = {__index = base}
local trigger = setmetatable({}, metatbl)
trigger.name = "get_special_item"
trigger.params = {"string"}

function trigger.OnTrigger(itemInfo)
  base.TryTrigger(trigger, itemInfo)
end

EventManager:GetInstance():AddListener(EventId.CheckTriggerGuideWhenGetSpecialItem, trigger.OnTrigger)

function trigger.CheckParams(params, evtParam)
  if not (params and not (#params < 1) and evtParam) or #evtParam < 1 then
    return false
  end
  local evtParamInfo = evtParam[1]
  local evtParamArr = string.split(params[1], ";")
  for _, str in ipairs(evtParamArr) do
    local itemInfoArr = string.split(str, "_")
    if 2 <= #itemInfoArr then
      local rewardType = itemInfoArr[1]
      local itemId = itemInfoArr[2]
      if table.containsKey(evtParamInfo, tonumber(rewardType)) and table.hasvalue(evtParamInfo[tonumber(rewardType)], tonumber(itemId)) then
        return true
      end
    end
  end
  return false
end

return trigger
