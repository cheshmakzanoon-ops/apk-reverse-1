local UISeasonTowerPreviewCtrl = BaseClass("UISeasonTowerPreviewCtrl", UIBaseCtrl)

function UISeasonTowerPreviewCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISeasonTowerPreview)
end

return UISeasonTowerPreviewCtrl
