local BankCityCtrl = BaseClass("BankCityCtrl", UIBaseCtrl)

function BankCityCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.BankCity)
end

return BankCityCtrl
