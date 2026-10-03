local UILWMummyLackCtrlS5 = BaseClass("UILWMummyLackCtrlS5", UIBaseCtrl)

function UILWMummyLackCtrlS5:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWMummyLackS5)
end

return UILWMummyLackCtrlS5
