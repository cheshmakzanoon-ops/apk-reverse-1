local UIGiftEffectPreviewWindowCtrl = BaseClass("UIGiftEffectPreviewWindowCtrl", UIBaseCtrl)

function UIGiftEffectPreviewWindowCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.GiftEffectPreview)
end

return UIGiftEffectPreviewWindowCtrl
