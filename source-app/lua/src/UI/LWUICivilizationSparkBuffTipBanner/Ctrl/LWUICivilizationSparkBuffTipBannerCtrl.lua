local LWUICivilizationSparkBuffTipBannerCtrl = BaseClass("LWUICivilizationSparkBuffTipBannerCtrl", UIBaseCtrl)

function LWUICivilizationSparkBuffTipBannerCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUICivilizationSparkBuffTipBanner, {anim = true})
end

return LWUICivilizationSparkBuffTipBannerCtrl
