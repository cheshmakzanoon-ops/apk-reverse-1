local UISeasonOfficialEncourageHistoryCtrl = BaseClass("UISeasonOfficialEncourageHistoryCtrl", UIBaseCtrl)

function UISeasonOfficialEncourageHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISeasonOfficialEncourageHistory)
end

return UISeasonOfficialEncourageHistoryCtrl
