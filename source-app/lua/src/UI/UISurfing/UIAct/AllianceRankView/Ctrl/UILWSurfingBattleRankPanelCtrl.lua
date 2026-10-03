local UILWSurfingBattleRankPanelCtrl = BaseClass("UILWSurfingBattleRankPanelCtrl", UIBaseCtrl)

function UILWSurfingBattleRankPanelCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSurfingBattleRankPanelView)
end

return UILWSurfingBattleRankPanelCtrl
