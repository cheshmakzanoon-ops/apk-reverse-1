local UIStageFeatureHelpInviteCtrl = BaseClass("UIStageFeatureHelpInviteCtrl", UIBaseCtrl)

function UIStageFeatureHelpInviteCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIStageFeatureHelpInvite)
end

return UIStageFeatureHelpInviteCtrl
