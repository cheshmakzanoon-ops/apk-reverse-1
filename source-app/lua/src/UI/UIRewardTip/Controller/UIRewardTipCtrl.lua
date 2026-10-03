local UIRewardTipCtrl = BaseClass("UIRewardTipCtrl", UIBaseCtrl)

function UIRewardTipCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIRewardTip)
end

return UIRewardTipCtrl
