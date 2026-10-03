local UIActChristmasRankAndRewardCommonCtrl = BaseClass("UIActChristmasRankAndRewardCommonCtrl", UIBaseCtrl)

function UIActChristmasRankAndRewardCommonCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActChristmasRankAndRewardCommon)
end

return UIActChristmasRankAndRewardCommonCtrl
