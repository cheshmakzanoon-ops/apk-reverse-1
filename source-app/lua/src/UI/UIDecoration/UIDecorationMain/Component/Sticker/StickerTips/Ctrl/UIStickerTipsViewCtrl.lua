local UIStickerTipsViewCtrl = BaseClass("UIStickerTipsViewCtrl", UIBaseCtrl)

function UIStickerTipsViewCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIStickerTipsViewView)
end

return UIStickerTipsViewCtrl
