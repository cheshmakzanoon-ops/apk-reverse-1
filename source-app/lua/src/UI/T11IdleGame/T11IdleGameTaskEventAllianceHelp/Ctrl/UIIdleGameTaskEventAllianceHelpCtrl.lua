local UIIdleGameTaskEventAllianceHelpCtrl = BaseClass("UIIdleGameTaskEventAllianceHelpCtrl", UIBaseCtrl)

function UIIdleGameTaskEventAllianceHelpCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIIdleGameTaskEventAllianceHelp)
end

return UIIdleGameTaskEventAllianceHelpCtrl
