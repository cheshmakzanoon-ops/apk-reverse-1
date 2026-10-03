local SeasonAttackCityDetailCtrl = BaseClass("SeasonAttackCityDetailCtrl", UIBaseCtrl)

function SeasonAttackCityDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISeasonAttackCityDetail)
end

return SeasonAttackCityDetailCtrl
