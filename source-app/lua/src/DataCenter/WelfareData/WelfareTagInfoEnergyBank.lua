require("DataCenter.WelfareData.WelfareTagInfo")
local WelfareTagInfoEnergyBank = BaseClass("WelfareTagInfoEnergyBank", WelfareTagInfo)
local M = WelfareTagInfoEnergyBank

function M:isShow()
  local pack = GiftPackageData.getEnergyBankPack()
  return pack ~= nil and WelfareTagInfo.isShow(self)
end

return M
