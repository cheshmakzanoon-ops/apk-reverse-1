local BankReportCtrl = BaseClass("BankReportCtrl", UIBaseCtrl)

function BankReportCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.BankReport)
end

return BankReportCtrl
