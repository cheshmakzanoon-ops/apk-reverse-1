local UITacticalWeaponSuperStageUpCtrl = BaseClass("UITacticalWeaponSuperStageUpCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITacticalWeaponSuperStageUpPurple)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITacticalWeaponSuperStageUpGold)
end

local function OnCustomKeyCodeEscape(self)
end

UITacticalWeaponSuperStageUpCtrl.CloseSelf = CloseSelf
UITacticalWeaponSuperStageUpCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
return UITacticalWeaponSuperStageUpCtrl
