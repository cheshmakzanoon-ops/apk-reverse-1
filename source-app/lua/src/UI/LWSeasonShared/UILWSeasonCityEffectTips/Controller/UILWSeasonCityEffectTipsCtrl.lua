local UILWSeasonCityEffectTipsCtrl = BaseClass("UILWSeasonCityEffectTipsCtrl", UIBaseCtrl)

function UILWSeasonCityEffectTipsCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonCityEffectTips)
end

return UILWSeasonCityEffectTipsCtrl
