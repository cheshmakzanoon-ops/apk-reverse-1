local UILWSeasonDistributeRewardCtrl = BaseClass("UILWSeasonDistributeRewardCtrl", UIBaseCtrl)

function UILWSeasonDistributeRewardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonDistributeReward)
end

return UILWSeasonDistributeRewardCtrl
