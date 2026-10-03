local LWUITranslationRatingCtrl = BaseClass("LWUITranslationRatingCtrl", UIBaseCtrl)

function LWUITranslationRatingCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUITranslationRating)
end

function LWUITranslationRatingCtrl:Close()
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

return LWUITranslationRatingCtrl
