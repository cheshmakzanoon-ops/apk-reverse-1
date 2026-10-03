local UIDawnPopupCtrl = BaseClass("UIDawnPopupCtrl", UIBaseCtrl)

function UIDawnPopupCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDawnPopup)
end

return UIDawnPopupCtrl
