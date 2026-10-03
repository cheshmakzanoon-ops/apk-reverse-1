require("DataCenter.WelfareData.WelfareTagInfo")
local WelfareTagInfoGoldBrickStore = BaseClass("WelfareTagInfoGoldBrickStore", WelfareTagInfo)
local M = WelfareTagInfoGoldBrickStore

function M:isShow()
  local isAvailable = WelfareController.CanOpenGoldBrickStore()
  return isAvailable
end

function M:hasRedPoint()
  return false
end

function M:getRedDotNum()
  local redNum = 0
  if self:hasRedPoint() then
    redNum = 1
  end
  return redNum
end

function M:CanShow()
  local isAvailable = WelfareController.CanOpenGoldBrickStore()
  return isAvailable
end

return M
