local UILWMummyLackCtrlS6 = BaseClass("UILWMummyLackCtrlS6", UIBaseCtrl)

function UILWMummyLackCtrlS6:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWMummyLackS6)
end

return UILWMummyLackCtrlS6
