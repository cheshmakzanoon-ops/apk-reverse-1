local UIGhostParkourRankPanelCtrl = BaseClass("UIGhostParkourRankPanelCtrl", UIBaseCtrl)

function UIGhostParkourRankPanelCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostParkourRankPanelView)
end

return UIGhostParkourRankPanelCtrl
