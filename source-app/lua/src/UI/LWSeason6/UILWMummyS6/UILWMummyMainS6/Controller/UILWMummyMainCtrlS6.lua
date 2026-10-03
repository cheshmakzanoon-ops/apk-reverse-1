local UILWMummyMainCtrlS6 = BaseClass("UILWMummyMainCtrlS6", UIBaseCtrl)

function UILWMummyMainCtrlS6:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWMummyMainS6)
end

return UILWMummyMainCtrlS6
