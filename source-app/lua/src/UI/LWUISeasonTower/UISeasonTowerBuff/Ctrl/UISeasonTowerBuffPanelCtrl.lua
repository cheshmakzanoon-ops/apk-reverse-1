local UISeasonTowerBuffPanelCtrl = BaseClass("UISeasonTowerBuffPanelCtrl", UIBaseCtrl)

function UISeasonTowerBuffPanelCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISeasonTowerBuffPanel)
end

return UISeasonTowerBuffPanelCtrl
