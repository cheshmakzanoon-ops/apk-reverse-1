local UILWPowerUpActivityRewardsCtrl = BaseClass("UILWPowerUpActivityRewardsCtrl", UIBaseCtrl)

function UILWPowerUpActivityRewardsCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWPowerUpActivityRewards)
end

return UILWPowerUpActivityRewardsCtrl
