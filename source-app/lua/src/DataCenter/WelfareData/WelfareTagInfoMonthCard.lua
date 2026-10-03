require("DataCenter.WelfareData.WelfareTagInfo")
local WelfareTagInfoMonthCard = BaseClass("WelfareTagInfoMonthCard", WelfareTagInfo)
local M = WelfareTagInfoMonthCard
local Timer = CS.GameEntry.Timer

function M:isShow()
  local isAvailable = DataCenter.MonthCardNewManager:CheckIfGolloesMonthCardAvailable()
  return isAvailable
end

function M:hasRedPoint()
  local golloesMonthCard = DataCenter.MonthCardNewManager:GetGolloesMonthCard()
  if not golloesMonthCard then
    return false
  end
  if not golloesMonthCard:IsBought() then
    return false
  end
  if not golloesMonthCard:IsTodayClaimed() then
    return true
  else
    return false
  end
end

function M:getRedDotNum()
  local redNum = 0
  if self:hasRedPoint() then
    redNum = 1
  end
  return redNum
end

function M:getInfo()
  local golloesMonthCard = DataCenter.MonthCardNewManager:GetGolloesMonthCard()
  return golloesMonthCard
end

function M:isShowIcon()
  return true
end

function M:CanShow()
  return true
end

return M
