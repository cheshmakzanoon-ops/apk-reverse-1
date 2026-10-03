local UIRevivalPlaneBoxRewardCtrl = BaseClass("UIRevivalPlaneBoxRewardCtrl", UIBaseCtrl)

function UIRevivalPlaneBoxRewardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIRevivalPlaneBoxReward)
end

return UIRevivalPlaneBoxRewardCtrl
