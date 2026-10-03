local UIStageFeatureHelpResultCtrl = BaseClass("UIStageFeatureHelpResultCtrl", UIBaseCtrl)

function UIStageFeatureHelpResultCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIStageFeatureHelpResult)
end

return UIStageFeatureHelpResultCtrl
