local LWUICommonExchangeShopItemHorizontalComponent_Base = require("UI.ActivityCommon.LWUICommonExchangeShop.LWUICommonExchangeShopItemHorizontalComponent_Base")
local LWUICommonExchangeShopItemHorizontalComponent_Recycle = BaseClass("LWUICommonExchangeShopItemHorizontalComponent_Recycle", LWUICommonExchangeShopItemHorizontalComponent_Base)

function LWUICommonExchangeShopItemHorizontalComponent_Recycle:RefreshAll()
  LWUICommonExchangeShopItemHorizontalComponent_Base.RefreshAll(self)
  self:RefreshArrow()
end

function LWUICommonExchangeShopItemHorizontalComponent_Recycle:RefreshArrow()
  if self.imgArrow == nil or self.data == nil then
    return
  end
  if self.data.GetArrowImagePath ~= nil then
    local path = self.data:GetArrowImagePath()
    if not string.IsNullOrEmpty(path) then
      self.imgArrow:LoadSpriteAsync(path)
    end
  end
end

return LWUICommonExchangeShopItemHorizontalComponent_Recycle
