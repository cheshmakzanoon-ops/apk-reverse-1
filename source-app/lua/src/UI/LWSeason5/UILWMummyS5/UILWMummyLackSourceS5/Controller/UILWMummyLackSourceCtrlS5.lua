local UILWMummyLackSourceCtrlS5 = BaseClass("UILWMummyLackSourceCtrlS5", UIBaseCtrl)

function UILWMummyLackSourceCtrlS5:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWMummyLackSourceS5)
end

return UILWMummyLackSourceCtrlS5
