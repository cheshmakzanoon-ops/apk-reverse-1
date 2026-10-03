local UIHSRMainCtrl = BaseClass("UIHSRMainCtrl", UIBaseCtrl)

function UIHSRMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHSRMain)
end

return UIHSRMainCtrl
