local UITacticalWeaponChipPlanCtrl = BaseClass("UITacticalWeaponChipPlanCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITacticalWeaponChipPlan)
end

UITacticalWeaponChipPlanCtrl.CloseSelf = CloseSelf
return UITacticalWeaponChipPlanCtrl
