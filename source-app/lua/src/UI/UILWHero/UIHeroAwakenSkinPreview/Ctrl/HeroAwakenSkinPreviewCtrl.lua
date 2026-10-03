local HeroAwakenSkinPreviewCtrl = BaseClass("HeroAwakenSkinPreviewCtrl", UIBaseCtrl)

function HeroAwakenSkinPreviewCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.HeroAwakenSkinPreview)
end

return HeroAwakenSkinPreviewCtrl
