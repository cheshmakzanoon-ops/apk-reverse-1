local EncourageHistoryCtrl = BaseClass("EncourageHistoryCtrl", UIBaseCtrl)

function EncourageHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentEncourageHistory)
end

return EncourageHistoryCtrl
