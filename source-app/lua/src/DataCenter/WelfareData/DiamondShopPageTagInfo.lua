require("DataCenter.WelfareData.WelfareTagInfo")
local DiamondShopPageTagInfo = BaseClass("DiamondShopPageTagInfo", WelfareTagInfo)
local M = DiamondShopPageTagInfo

function M:isShow()
  return true
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
  return "DiamondShop"
end

function M:isFullBg()
  return true
end

function M:CanShow()
  return true
end

return M
