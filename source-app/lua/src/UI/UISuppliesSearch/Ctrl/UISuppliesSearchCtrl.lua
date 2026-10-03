local UISuppliesSearchCtrl = BaseClass("UISuppliesSearchCtrl", UIBaseCtrl)

function UISuppliesSearchCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISuppliesSearch)
end

return UISuppliesSearchCtrl
