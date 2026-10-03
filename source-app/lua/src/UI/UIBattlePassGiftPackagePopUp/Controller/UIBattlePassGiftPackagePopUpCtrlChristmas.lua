local UIBattlePassGiftPackagePopUpChristmasCtrl = BaseClass("UIBattlePassGiftPackagePopUpChristmasCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIBattlePassGiftPackagePopUpChristmas)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIBattlePassGiftPackagePopUpChristmasCtrl.CloseSelf = CloseSelf
UIBattlePassGiftPackagePopUpChristmasCtrl.Close = Close
return UIBattlePassGiftPackagePopUpChristmasCtrl
