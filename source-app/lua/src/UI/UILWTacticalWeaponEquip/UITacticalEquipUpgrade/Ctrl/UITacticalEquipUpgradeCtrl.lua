local UITacticalEquipUpgradeCtrl = BaseClass("UITacticalEquipUpgradeCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITacticalEquipUpgrade)
end

UITacticalEquipUpgradeCtrl.CloseSelf = CloseSelf
return UITacticalEquipUpgradeCtrl
