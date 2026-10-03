local UITacticalWeaponSuperStageUpMaskCtrl = BaseClass("UITacticalWeaponSuperStageUpMaskCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITacticalWeaponSuperStageUpMask)
end

local function OnCustomKeyCodeEscape(self)
end

UITacticalWeaponSuperStageUpMaskCtrl.CloseSelf = CloseSelf
UITacticalWeaponSuperStageUpMaskCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
return UITacticalWeaponSuperStageUpMaskCtrl
