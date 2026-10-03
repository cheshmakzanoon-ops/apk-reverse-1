local UICommonCountdownCtrl = BaseClass("UICommonCountdownCtrl", UIBaseCtrl)

function UICommonCountdownCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonCountdown)
end

return UICommonCountdownCtrl
