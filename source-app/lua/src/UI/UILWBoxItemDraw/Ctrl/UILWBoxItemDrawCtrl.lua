local UILWBoxItemDrawCtrl = BaseClass("UILWBoxItemDrawCtrl", UIBaseCtrl)

function UILWBoxItemDrawCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWBoxItemDraw)
end

return UILWBoxItemDrawCtrl
