local UISandWormPopupCtrl = BaseClass("UISandWormPopupCtrl", UIBaseCtrl)

function UISandWormPopupCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISandWormPopup)
end

return UISandWormPopupCtrl
