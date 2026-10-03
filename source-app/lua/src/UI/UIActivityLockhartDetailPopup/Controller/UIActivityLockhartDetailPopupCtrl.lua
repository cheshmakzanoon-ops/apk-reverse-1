local UIActivityLockhartDetailPopupCtrl = BaseClass("UIActivityLockhartDetailPopupCtrl", UIBaseCtrl)

function UIActivityLockhartDetailPopupCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActivityLockhartDetailPopup)
end

return UIActivityLockhartDetailPopupCtrl
