local SeasonMilitaryShopNewPopupCtrl = BaseClass("SeasonMilitaryShopNewPopupCtrl", UIBaseCtrl)

function SeasonMilitaryShopNewPopupCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonMilitaryShopNewPopup)
end

return SeasonMilitaryShopNewPopupCtrl
