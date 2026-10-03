local UIStageFeatureHelpInfoCtrl = BaseClass("UIStageFeatureHelpInfoCtrl", UIBaseCtrl)

function UIStageFeatureHelpInfoCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIStageFeatureHelpInfo)
end

return UIStageFeatureHelpInfoCtrl
