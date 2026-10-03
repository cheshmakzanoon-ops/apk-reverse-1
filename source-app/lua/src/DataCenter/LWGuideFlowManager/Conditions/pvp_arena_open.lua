local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "pvp_arena_open"
condition.params = {"number"}

function condition.__Check(pvpArenaType)
  if pvpArenaType == nil or type(pvpArenaType) ~= "number" then
    return false
  end
  if not UIManager:GetInstance():IsWindowOpen("LWPVPArenaMain") then
    return false
  end
  local window = UIManager:GetInstance():GetWindow("LWPVPArenaMain")
  if window and window.View then
    return window.View.arenaCompletedTab == pvpArenaType
  end
end

return condition
