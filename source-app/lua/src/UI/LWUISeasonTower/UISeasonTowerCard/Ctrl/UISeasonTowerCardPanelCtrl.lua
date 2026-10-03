local UISeasonTowerCardPanelCtrl = BaseClass("UISeasonTowerCardPanelCtrl", UIBaseCtrl)

function UISeasonTowerCardPanelCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISeasonTowerCardPanel)
end

return UISeasonTowerCardPanelCtrl
