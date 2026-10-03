local BankDepositInfoCtrl = BaseClass("BankDepositInfoCtrl", UIBaseCtrl)

function BankDepositInfoCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.BankDepositInfo)
end

return BankDepositInfoCtrl
