require("DataCenter.WelfareData.WelfareTagInfo")
local WelfareTagInfoPvePack = BaseClass("WelfareTagInfoPvePack", WelfareTagInfo)
local M = WelfareTagInfoPvePack

function M:isShow(rechargeId)
  local packs = GiftPackageData.getPvePack(rechargeId)
  return not table.IsNullOrEmpty(packs) and WelfareTagInfo.isShow(self)
end

return M
