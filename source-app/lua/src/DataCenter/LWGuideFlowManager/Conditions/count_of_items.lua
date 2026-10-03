local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "count_of_items"
condition.params = {"number", "number"}

function condition.__Check(itemId, needCount)
  local item = DataCenter.ItemData:GetItemByItemId(itemId)
  if item then
    return needCount <= item.count
  end
  return false
end

return condition
