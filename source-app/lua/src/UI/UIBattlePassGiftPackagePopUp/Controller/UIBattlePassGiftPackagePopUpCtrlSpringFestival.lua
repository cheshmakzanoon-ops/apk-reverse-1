local UIBattlePassGiftPackagePopUpSpringFestivalCtrl = BaseClass("UIBattlePassGiftPackagePopUpSpringFestivalCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIBattlePassGiftPackagePopUpSpringFestival)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIBattlePassGiftPackagePopUpSpringFestivalCtrl.CloseSelf = CloseSelf
UIBattlePassGiftPackagePopUpSpringFestivalCtrl.Close = Close
return UIBattlePassGiftPackagePopUpSpringFestivalCtrl
