local UIFrontBreakSundayRankRewardCtrl = BaseClass("UIFrontBreakSundayRankRewardCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function UIFrontBreakSundayRankRewardCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.UIFrontBreakSundayRankReward)
end

return UIFrontBreakSundayRankRewardCtrl
