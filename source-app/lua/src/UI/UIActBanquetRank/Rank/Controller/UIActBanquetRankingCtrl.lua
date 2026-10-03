local UIActBanquetRankingCtrl = BaseClass("UIActBanquetRankingCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIActBanquetRanking)
end

UIActBanquetRankingCtrl.CloseSelf = CloseSelf
return UIActBanquetRankingCtrl
