local UITacticalEquipUpgradeResultCtrl = BaseClass("UITacticalEquipUpgradeResultCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITacticalEquipUpgradeResult)
end

UITacticalEquipUpgradeResultCtrl.CloseSelf = CloseSelf
return UITacticalEquipUpgradeResultCtrl
