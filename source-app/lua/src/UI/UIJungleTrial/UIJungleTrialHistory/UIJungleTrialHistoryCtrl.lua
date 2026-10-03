local UIJungleTrialHistoryCtrl = BaseClass("UIJungleTrialHistoryCtrl", UIBaseCtrl)

function UIJungleTrialHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIJungleTrialHistory)
end

return UIJungleTrialHistoryCtrl
