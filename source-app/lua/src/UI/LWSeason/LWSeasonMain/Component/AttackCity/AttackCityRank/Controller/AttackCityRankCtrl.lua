local SeasonAttackCityRankCtrl = BaseClass("SeasonAttackCityRankCtrl", UIBaseCtrl)

function SeasonAttackCityRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISeasonAttackCityRank)
end

return SeasonAttackCityRankCtrl
