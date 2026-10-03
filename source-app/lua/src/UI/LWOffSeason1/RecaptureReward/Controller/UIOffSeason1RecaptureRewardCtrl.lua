local UIOffSeason1RecaptureRewardCtrl = BaseClass("UIOffSeason1RecaptureRewardCtrl", UIBaseCtrl)

function UIOffSeason1RecaptureRewardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIOffSeason1RecaptureReward)
end

return UIOffSeason1RecaptureRewardCtrl
