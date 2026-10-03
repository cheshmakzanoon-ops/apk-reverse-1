local BankHistoryCtrl = BaseClass("BankHistoryCtrl", UIBaseCtrl)

function BankHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.BankHistory)
end

return BankHistoryCtrl
