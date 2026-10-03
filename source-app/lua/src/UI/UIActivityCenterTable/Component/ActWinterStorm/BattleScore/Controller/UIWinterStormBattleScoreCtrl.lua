local UIWinterStormBattleScoreCtrl = BaseClass("UIWinterStormBattleScoreCtrl", UIBaseCtrl)

function UIWinterStormBattleScoreCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWinterStormBattleScore)
end

return UIWinterStormBattleScoreCtrl
