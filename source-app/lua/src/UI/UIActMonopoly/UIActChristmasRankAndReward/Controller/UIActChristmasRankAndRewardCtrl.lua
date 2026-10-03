local UIActChristmasRankAndRewardCtrl = BaseClass("UIActChristmasRankAndRewardCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIActChristmasRankAndReward)
end

UIActChristmasRankAndRewardCtrl.CloseSelf = CloseSelf
return UIActChristmasRankAndRewardCtrl
