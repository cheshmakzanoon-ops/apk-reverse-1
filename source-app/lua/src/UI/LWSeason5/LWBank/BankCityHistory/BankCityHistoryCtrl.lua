local BankCityHistoryCtrl = BaseClass("BankCityHistoryCtrl", UIBaseCtrl)

function BankCityHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.BankCityHistory)
end

return BankCityHistoryCtrl
