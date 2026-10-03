local UIBattlePassEasterGiftPackagePopUpCtrl = BaseClass("UIBattlePassEasterGiftPackagePopUpCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIBattlePassEasterGiftPackagePopUp)
end

UIBattlePassEasterGiftPackagePopUpCtrl.CloseSelf = CloseSelf
return UIBattlePassEasterGiftPackagePopUpCtrl
