local UIMonsterInvasionShopCtrl = BaseClass("UIMonsterInvasionShopCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIMonsterInvasionShop)
end

UIMonsterInvasionShopCtrl.CloseSelf = CloseSelf
return UIMonsterInvasionShopCtrl
