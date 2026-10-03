local LWUIZREliteBossRewardInfoCtrl = BaseClass("LWUIZREliteBossRewardInfoCtrl", UIBaseCtrl)

function LWUIZREliteBossRewardInfoCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIZREliteBossRewardInfoView)
end

return LWUIZREliteBossRewardInfoCtrl
