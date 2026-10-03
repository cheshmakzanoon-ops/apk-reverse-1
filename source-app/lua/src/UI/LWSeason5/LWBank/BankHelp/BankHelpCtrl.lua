local BankHelpCtrl = BaseClass("BankHelpCtrl", UIBaseCtrl)

function BankHelpCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.BankHelp)
end

return BankHelpCtrl
