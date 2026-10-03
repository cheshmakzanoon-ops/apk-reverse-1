local UIJungleTrialPopupCtrl = BaseClass("UIJungleTrialPopupCtrl", UIBaseCtrl)

function UIJungleTrialPopupCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIJungleTrialPopup)
end

return UIJungleTrialPopupCtrl
