local UICoppaBrazilCtrl = BaseClass("UICoppaBrazilCtrl", UIBaseCtrl)

function UICoppaBrazilCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICoppaBrazil)
end

return UICoppaBrazilCtrl
