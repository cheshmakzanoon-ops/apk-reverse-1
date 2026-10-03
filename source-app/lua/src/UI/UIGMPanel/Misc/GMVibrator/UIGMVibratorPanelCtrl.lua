local UIGMVibratorPanelCtrl = BaseClass("UIGMVibratorPanelCtrl", UIBaseCtrl)

function UIGMVibratorPanelCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMVibratorPanel)
end

return UIGMVibratorPanelCtrl
