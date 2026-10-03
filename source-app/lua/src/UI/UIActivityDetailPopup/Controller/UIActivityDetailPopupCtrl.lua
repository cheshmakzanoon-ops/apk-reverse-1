local UIActivityDetailPopupCtrl = BaseClass("UIActivityDetailPopupCtrl", UIBaseCtrl)

function UIActivityDetailPopupCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActivityDetailPopup)
end

return UIActivityDetailPopupCtrl
