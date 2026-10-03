local SeasonAttackCityTargetInfoCtrl = BaseClass("SeasonAttackCityTargetInfoCtrl", UIBaseCtrl)

function SeasonAttackCityTargetInfoCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISeasonAttackCityTargetInfo)
end

return SeasonAttackCityTargetInfoCtrl
