local UIActMonopolyShopCtrl = BaseClass("UIActMonopolyShopCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIActMonopolyShop)
end

UIActMonopolyShopCtrl.CloseSelf = CloseSelf
return UIActMonopolyShopCtrl
