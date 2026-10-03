local UITCCardIntactStarUpgradeShowCtrl = BaseClass("UITCCardIntactStarUpgradeShowCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITCCardIntactStarUpgradeShow)
end

UITCCardIntactStarUpgradeShowCtrl.CloseSelf = CloseSelf
return UITCCardIntactStarUpgradeShowCtrl
