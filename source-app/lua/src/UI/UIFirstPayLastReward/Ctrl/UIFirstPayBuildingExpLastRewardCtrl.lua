local UIFirstPayBuildingExpLastRewardCtrl = BaseClass("UIFirstPayBuildingExpLastRewardCtrl", UIBaseCtrl)

function UIFirstPayBuildingExpLastRewardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFirstPayBuildingExpLastReward)
end

return UIFirstPayBuildingExpLastRewardCtrl
