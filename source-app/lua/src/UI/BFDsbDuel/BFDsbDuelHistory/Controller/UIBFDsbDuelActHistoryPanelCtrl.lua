local UIBFDsbDuelActHistoryPanelCtrl = BaseClass("UIBFDsbDuelActHistoryPanelCtrl", UIBaseCtrl)

function UIBFDsbDuelActHistoryPanelCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBFDsbDuelActHistoryPanel, {anim = true})
end

function UIBFDsbDuelActHistoryPanelCtrl:OnCustomKeyCodeEscape()
  self:CloseSelf()
end

return UIBFDsbDuelActHistoryPanelCtrl
