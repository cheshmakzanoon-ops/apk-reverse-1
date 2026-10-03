local UITacticalWeaponNormalStageUpCtrl = BaseClass("UITacticalWeaponNormalStageUpCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITacticalWeaponNormalStageUp)
end

UITacticalWeaponNormalStageUpCtrl.CloseSelf = CloseSelf
return UITacticalWeaponNormalStageUpCtrl
