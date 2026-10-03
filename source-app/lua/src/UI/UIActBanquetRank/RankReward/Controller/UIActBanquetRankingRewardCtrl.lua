local UIActBanquetRankingRewardCtrl = BaseClass("UIActBanquetRankingRewardCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIActBanquetRankingReward)
end

UIActBanquetRankingRewardCtrl.CloseSelf = CloseSelf
return UIActBanquetRankingRewardCtrl
