local UIBattlePassNewYearGiftPackagePopUpCtrl = BaseClass("UIBattlePassNewYearGiftPackagePopUpCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIBattlePassNewYearGiftPackagePopUp)
end

UIBattlePassNewYearGiftPackagePopUpCtrl.CloseSelf = CloseSelf
return UIBattlePassNewYearGiftPackagePopUpCtrl
