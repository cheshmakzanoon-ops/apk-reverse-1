local UILLRewardCtrl = BaseClass("UILLRewardCtrl", UIBaseCtrl)

function UILLRewardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILLReward)
end

return UILLRewardCtrl
