local UITCBoxPointRewardCtrl = BaseClass("UITCBoxPointRewardCtrl", UIBaseCtrl)

function UITCBoxPointRewardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITCBoxPointReward)
end

return UITCBoxPointRewardCtrl
