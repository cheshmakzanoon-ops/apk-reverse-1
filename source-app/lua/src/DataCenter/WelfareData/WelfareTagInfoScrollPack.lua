require("DataCenter.WelfareData.WelfareTagInfo")
local WelfareTagInfoScrollPack = BaseClass("WelfareTagInfoScrollPack", WelfareTagInfo)
local M = WelfareTagInfoScrollPack

function M:isShow(rechargeId)
  local packs = GiftPackageData.getScrollPack(rechargeId)
  return not table.IsNullOrEmpty(packs) and WelfareTagInfo.isShow(self)
end

return M
