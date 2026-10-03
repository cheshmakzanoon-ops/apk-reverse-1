local UIBrazilAgeVerifyCtrl = BaseClass("UIBrazilAgeVerifyCtrl", UIBaseCtrl)

function UIBrazilAgeVerifyCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBrazilAgeVerify)
end

return UIBrazilAgeVerifyCtrl
