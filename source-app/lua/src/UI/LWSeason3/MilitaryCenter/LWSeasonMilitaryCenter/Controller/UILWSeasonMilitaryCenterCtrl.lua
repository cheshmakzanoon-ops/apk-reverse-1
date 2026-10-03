local UILWSeasonMilitaryCenterCtrl = BaseClass("UILWSeasonMilitaryCenterCtrl", UIBaseCtrl)

function UILWSeasonMilitaryCenterCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonMilitaryCenter)
end

return UILWSeasonMilitaryCenterCtrl
