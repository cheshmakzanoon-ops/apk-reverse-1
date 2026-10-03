local UILWMummyMainCtrlS5 = BaseClass("UILWMummyMainCtrlS5", UIBaseCtrl)

function UILWMummyMainCtrlS5:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWMummyMainS5)
end

return UILWMummyMainCtrlS5
