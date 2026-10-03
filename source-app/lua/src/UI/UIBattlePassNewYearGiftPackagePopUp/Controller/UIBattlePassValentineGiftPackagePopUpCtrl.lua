local UIBattlePassValentineGiftPackagePopUpCtrl = BaseClass("UIBattlePassValentineGiftPackagePopUpCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIBattlePassValentineGiftPackagePopUp)
end

UIBattlePassValentineGiftPackagePopUpCtrl.CloseSelf = CloseSelf
return UIBattlePassValentineGiftPackagePopUpCtrl
