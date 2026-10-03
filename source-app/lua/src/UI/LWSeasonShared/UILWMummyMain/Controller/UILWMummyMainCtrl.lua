local UILWMummyMainCtrl = BaseClass("UILWMummyMainCtrl", UIBaseCtrl)

function UILWMummyMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWMummyMain)
end

return UILWMummyMainCtrl
