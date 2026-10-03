local UIVipExtendCitySkinDetailShowCtrl = BaseClass("UIVipExtendCitySkinDetailShowCtrl", UIBaseCtrl)

function UIVipExtendCitySkinDetailShowCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIVipExtendCitySkinDetailShow)
end

return UIVipExtendCitySkinDetailShowCtrl
