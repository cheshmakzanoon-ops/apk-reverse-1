local UILWMummyLackSourceCtrl = BaseClass("UILWMummyLackSourceCtrl", UIBaseCtrl)

function UILWMummyLackSourceCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWMummyLackSource)
end

return UILWMummyLackSourceCtrl
