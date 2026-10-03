require("DataCenter.WelfareData.WelfareTagInfo")
local WelfareTagInfoPiggyBank = BaseClass("WelfareTagInfoPiggyBank", WelfareTagInfo)
local M = WelfareTagInfoPiggyBank

function M:isShow()
  local pack = GiftPackageData.getPiggyBankPack()
  return pack ~= nil and WelfareTagInfo.isShow(self)
end

return M
