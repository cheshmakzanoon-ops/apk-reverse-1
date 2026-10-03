require("DataCenter.WelfareData.WelfareTagInfo")
local WelfareTagInfoWeeklyPackage = BaseClass("WelfareTagInfoWeeklyPackage", WelfareTagInfo)
local M = WelfareTagInfoWeeklyPackage
local Timer = CS.GameEntry.Timer

function M:isShow()
  local list = GiftPackageData.GetWeeklyPackageList()
  return 0 < #list and WelfareTagInfo.isShow(self)
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

return M
