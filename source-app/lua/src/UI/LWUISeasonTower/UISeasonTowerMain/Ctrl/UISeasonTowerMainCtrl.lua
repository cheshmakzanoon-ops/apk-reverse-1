local UISeasonTowerMainCtrl = BaseClass("UISeasonTowerMainCtrl", UIBaseCtrl)

function UISeasonTowerMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISeasonTowerMain)
end

function UISeasonTowerMainCtrl:OnCustomKeyCodeEscape()
  DataCenter.LWSeasonTowerSceneManager:Exit()
end

return UISeasonTowerMainCtrl
