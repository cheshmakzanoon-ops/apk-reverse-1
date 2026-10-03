local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "land_lock_state"
condition.params = {"number", "number"}

function condition.__Check(landId, landState)
  local landData = DataCenter.LandLockManager:GetLandLockDataById(landId)
  if landData == nil then
    return false
  end
  return landData.state == landState
end

return condition
