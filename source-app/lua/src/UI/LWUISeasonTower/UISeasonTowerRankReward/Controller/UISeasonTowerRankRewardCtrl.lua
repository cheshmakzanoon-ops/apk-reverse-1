local UISeasonTowerRankRewardCtrl = BaseClass("UISeasonTowerRankRewardCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function UISeasonTowerRankRewardCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUISeasonTowerRankReward)
end

function UISeasonTowerRankRewardCtrl:Close()
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUISeasonTowerRankReward)
end

return UISeasonTowerRankRewardCtrl
