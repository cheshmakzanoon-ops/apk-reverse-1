local LWUIQuickGiftCtrl = BaseClass("LWUIQuickGiftCtrl", UIBaseCtrl)

function LWUIQuickGiftCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIQuickGift)
end

return LWUIQuickGiftCtrl
