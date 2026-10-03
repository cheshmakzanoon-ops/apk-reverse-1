require("DataCenter.WelfareData.WelfareTagInfo")
local WelfareTagInfoStorePack = BaseClass("WelfareTagInfoStorePack", WelfareTagInfo)
local M = WelfareTagInfoStorePack

function M:isShow()
  return GiftPackageData.hasStorePacks() and WelfareTagInfo.isShow(self)
end

function M:getPackList()
  return GiftPackageData.getStorePacks()
end

return M
