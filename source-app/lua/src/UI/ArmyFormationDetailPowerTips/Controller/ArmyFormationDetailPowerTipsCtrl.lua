local ArmyFormationDetailPowerTipsCtrl = BaseClass("ArmyFormationDetailPowerTipsCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.ArmyFormationDetailPowerTips)
end

ArmyFormationDetailPowerTipsCtrl.CloseSelf = CloseSelf
return ArmyFormationDetailPowerTipsCtrl
