local UIResistanceWarningPanelCtrl = BaseClass("UIResistanceWarningPanelCtrl", UIBaseCtrl)

function UIResistanceWarningPanelCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIResistanceWarningPanel)
end

return UIResistanceWarningPanelCtrl
