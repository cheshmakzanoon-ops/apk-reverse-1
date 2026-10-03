local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "monopoly_stage"
condition.params = {"number", "number"}

function condition.__Check(checkStageId, comparisonType)
  if DataCenter.MonopolyManager.player == nil then
    return false
  end
  local currStageId = DataCenter.MonopolyManager.player.curId
  return condition:CompareNumber(currStageId, checkStageId, comparisonType)
end

return condition
