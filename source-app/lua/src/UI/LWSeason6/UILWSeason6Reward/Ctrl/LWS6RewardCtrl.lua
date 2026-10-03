local LWS6RewardCtrl = BaseClass("LWS6RewardCtrl", UIBaseCtrl)

function LWS6RewardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWS6Reward)
end

return LWS6RewardCtrl
