local UIWinterStormBattleTaskCtrl = BaseClass("UIWinterStormBattleTaskCtrl", UIBaseCtrl)

function UIWinterStormBattleTaskCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWinterStormBattleTask)
end

return UIWinterStormBattleTaskCtrl
