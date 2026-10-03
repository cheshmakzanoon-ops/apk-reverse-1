local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "parkour_stage"
condition.params = {"number"}

function condition.__Check(checkStageId)
  local currStageId = DataCenter.ParkourManager.curStageId
  return checkStageId == currStageId
end

return condition
