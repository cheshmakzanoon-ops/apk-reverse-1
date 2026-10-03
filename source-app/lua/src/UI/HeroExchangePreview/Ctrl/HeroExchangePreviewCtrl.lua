local HeroExchangePreviewCtrl = BaseClass("HeroExchangePreviewCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.HeroExchangePreview)
end

HeroExchangePreviewCtrl.CloseSelf = CloseSelf
return HeroExchangePreviewCtrl
