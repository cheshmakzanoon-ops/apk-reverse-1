local UIChampionDuelRewardCtrl = BaseClass("UIChampionDuelRewardCtrl", UIBaseCtrl)

function UIChampionDuelRewardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChampionDuelReward)
end

return UIChampionDuelRewardCtrl
