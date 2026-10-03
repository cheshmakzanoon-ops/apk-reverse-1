local UILWMummyLackCtrl = BaseClass("UILWMummyLackCtrl", UIBaseCtrl)

function UILWMummyLackCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWMummyLack)
end

return UILWMummyLackCtrl
