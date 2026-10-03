local UILWMummyLackSourceCtrlS6 = BaseClass("UILWMummyLackSourceCtrlS6", UIBaseCtrl)

function UILWMummyLackSourceCtrlS6:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWMummyLackSourceS6)
end

return UILWMummyLackSourceCtrlS6
