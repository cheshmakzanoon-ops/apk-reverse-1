local UIBattlePassRamadanGiftPackagePopUpCtrl = BaseClass("UIBattlePassRamadanGiftPackagePopUpCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIBattlePassRamadanGiftPackagePopUp)
end

UIBattlePassRamadanGiftPackagePopUpCtrl.CloseSelf = CloseSelf
return UIBattlePassRamadanGiftPackagePopUpCtrl
