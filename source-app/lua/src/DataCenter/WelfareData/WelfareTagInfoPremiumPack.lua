require("DataCenter.WelfareData.WelfareTagInfo")
local WelfareTagInfoPremiumPack = BaseClass("WelfareTagInfoPremiumPack", WelfareTagInfo)
local M = WelfareTagInfoPremiumPack

function M:isShow()
  local list = self:getPackList(false)
  return list ~= nil and 0 < #list and WelfareTagInfo.isShow(self)
end

function M:getPackList(isSort)
  local list = GiftPackageData.getPremiumPacks(isSort)
  for _, v in ipairs(list) do
    v:setTagID(self:getID())
  end
  return list
end

function M:getPopPackList(isSort)
  local list = GiftPackageData.getPopPremiumPacks(isSort)
  for _, v in ipairs(list) do
    v:setTagID(self:getID())
  end
  return list
end

return M
