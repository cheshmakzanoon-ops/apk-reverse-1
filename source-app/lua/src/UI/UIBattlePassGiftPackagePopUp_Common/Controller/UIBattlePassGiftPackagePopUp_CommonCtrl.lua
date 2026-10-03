local UIBattlePassGiftPackagePopUp_CommonCtrl = BaseClass("UIBattlePassGiftPackagePopUp_CommonCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIBattlePassGiftPackagePopUp_Common)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIBattlePassGiftPackagePopUp_CommonCtrl.CloseSelf = CloseSelf
UIBattlePassGiftPackagePopUp_CommonCtrl.Close = Close
return UIBattlePassGiftPackagePopUp_CommonCtrl
