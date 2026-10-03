local UIStageFeatureGoToHelpCtrl = BaseClass("UIStageFeatureGoToHelpCtrl", UIBaseCtrl)

function UIStageFeatureGoToHelpCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIStageFeatureGoToHelp)
end

return UIStageFeatureGoToHelpCtrl
