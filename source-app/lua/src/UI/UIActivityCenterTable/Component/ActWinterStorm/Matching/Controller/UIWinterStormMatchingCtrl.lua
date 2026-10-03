local UIWinterStormMatchingCtrl = BaseClass("UIWinterStormMatchingCtrl", UIBaseCtrl)

function UIWinterStormMatchingCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWinterStormMatching)
end

function UIWinterStormMatchingCtrl:OnCustomKeyCodeEscape()
end

return UIWinterStormMatchingCtrl
