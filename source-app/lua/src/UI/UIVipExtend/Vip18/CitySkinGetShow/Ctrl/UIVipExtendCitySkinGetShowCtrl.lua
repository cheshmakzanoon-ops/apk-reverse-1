local UIVipExtendCitySkinGetShowCtrl = BaseClass("UIVipExtendCitySkinGetShowCtrl", UIBaseCtrl)

function UIVipExtendCitySkinGetShowCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIVipExtendCitySkinGetShow)
end

return UIVipExtendCitySkinGetShowCtrl
