local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "detect_event_state"
condition.params = {"number", "number"}

function condition.__Check(eventId, state)
  local events = DataCenter.RadarCenterDataManager:GetDetectEventsInfoByEventId(eventId)
  local event = events[1]
  if event == nil then
    return state < 0
  end
  return event.state == state
end

return condition
