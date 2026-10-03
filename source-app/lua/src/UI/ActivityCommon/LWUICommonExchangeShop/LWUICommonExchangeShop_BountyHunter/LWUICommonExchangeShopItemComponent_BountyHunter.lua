local base = require("UI/ActivityCommon/LWUICommonExchangeShop/LWUICommonExchangeShopItemComponent_Base")
local LWUICommonExchangeShopItemComponent_BountyHunter = BaseClass("LWUICommonExchangeShopItemComponent_BountyHunter", base)

function LWUICommonExchangeShopItemComponent_BountyHunter:Update1000MS()
  base.Update1000MS(self)
  if self.data == nil then
    return
  end
  self:RefreshTimes()
end

return LWUICommonExchangeShopItemComponent_BountyHunter
