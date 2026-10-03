local WelfareTagInfoWeeklyPackageNew = BaseClass("WelfareTagInfoWeeklyPackageNew", WelfareTagInfo)
local M = WelfareTagInfoWeeklyPackageNew
local Timer = CS.GameEntry.Timer

function M:isShow()
  return GiftPackageData.CheckIfNewWeeklyPackageOpen() and WelfareTagInfo.isShow(self)
end

function M:hasRedPoint()
  return false
end

function M:getRedDotNum()
  return 0
end

function M:getInfo()
  return nil
end

function M:isShowIcon()
  return true
end

function M:CanBuy()
  local packages = GiftPackageData.GetWeeklyPackageNewList()
  for _, v in pairs(packages) do
    if v:canGet() and v:isTimeValid() then
      return true
    end
  end
  return false
end

return M
