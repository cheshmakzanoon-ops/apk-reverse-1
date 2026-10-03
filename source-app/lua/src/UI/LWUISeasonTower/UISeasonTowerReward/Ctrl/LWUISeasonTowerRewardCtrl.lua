local LWUISeasonTowerRewardCtrl = BaseClass("LWUISeasonTowerRewardCtrl", UIBaseCtrl)

function LWUISeasonTowerRewardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUISeasonTowerReward)
end

return LWUISeasonTowerRewardCtrl
