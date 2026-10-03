local LWSeason5RewardCtrl = BaseClass("LWSeason5RewardCtrl", UIBaseCtrl)

function LWSeason5RewardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeason5Reward)
end

return LWSeason5RewardCtrl
