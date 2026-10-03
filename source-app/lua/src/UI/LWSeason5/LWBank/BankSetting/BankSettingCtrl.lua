local BankSettingCtrl = BaseClass("BankSettingCtrl", UIBaseCtrl)

function BankSettingCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.BankSetting)
end

return BankSettingCtrl
