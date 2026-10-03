require("DataCenter.WelfareData.WelfareTagInfo")
local WelfareTagInfoPopCollectPackage = BaseClass("WelfareTagInfoPopCollectPackage", WelfareTagInfo)
local M = WelfareTagInfoPopCollectPackage
local FREE_REWARD_TYPE = 1

function M:isShow()
  return WelfareTagInfo.isShow(self)
end

function M:getRedDotNum()
  return 0
end

function M:getInfo()
  return nil
end

function M:isShowIcon()
  local info = self:getInfo()
  return info ~= nil and WelfareTagInfo.isShowIcon(self)
end

function M:getBgName()
  return ""
end

function M:isFullBg()
  return true
end

function M:CanBuy()
  local showPackages = WelfareController.GetPopupPackages(RechargeEntryType.PopRechargeInStore)
  return showPackages and 0 < #showPackages
end

return M
