local UIFirstPayHeroTipCtrl = BaseClass("UIFirstPayHeroTipCtrl", UIBaseCtrl)

function UIFirstPayHeroTipCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFirstPayHeroTip)
end

return UIFirstPayHeroTipCtrl
