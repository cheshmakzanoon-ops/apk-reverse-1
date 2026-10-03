local ArmyFormationPowerTipsCtrl = BaseClass("ArmyFormationPowerTipsCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.ArmyFormationPowerTips)
end

ArmyFormationPowerTipsCtrl.CloseSelf = CloseSelf
return ArmyFormationPowerTipsCtrl
