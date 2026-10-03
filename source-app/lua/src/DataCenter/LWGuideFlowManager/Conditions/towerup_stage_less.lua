local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "towerup_stage_less"
condition.params = {"number"}

function condition.__Check(checkStageId)
  local currStageId = DataCenter.LWTowerUpStageManager:GetCurStageId()
  return checkStageId > currStageId
end

return condition
