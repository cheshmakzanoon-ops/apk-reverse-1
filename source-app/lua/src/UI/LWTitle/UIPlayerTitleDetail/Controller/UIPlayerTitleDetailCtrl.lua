local UIPlayerTitleDetailCtrl = BaseClass("UIPlayerTitleDetailCtrl", UIBaseCtrl)

function UIPlayerTitleDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlayerTitleDetail)
end

return UIPlayerTitleDetailCtrl
