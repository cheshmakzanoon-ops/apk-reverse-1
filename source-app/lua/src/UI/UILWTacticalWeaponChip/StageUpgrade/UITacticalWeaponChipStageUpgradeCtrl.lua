local UITacticalWeaponChipStageUpgradeCtrl = BaseClass("UITacticalWeaponChipStageUpgradeCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITacticalWeaponChipStageUpgrade)
end

UITacticalWeaponChipStageUpgradeCtrl.CloseSelf = CloseSelf
return UITacticalWeaponChipStageUpgradeCtrl
