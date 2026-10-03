local UIEpidemicBattleResultCtrl = BaseClass("UIEpidemicBattleResultCtrl", UIBaseCtrl)

function UIEpidemicBattleResultCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIEpidemicBattleResult)
  BattleFieldUtil.BackToCity(BattleFieldType.EpidemicZone)
end

return UIEpidemicBattleResultCtrl
