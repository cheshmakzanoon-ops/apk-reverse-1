local UIEpidemicBattleSpeedCtrl = BaseClass("UIEpidemicBattleSpeedCtrl", UIBaseCtrl)

function UIEpidemicBattleSpeedCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.UIEpidemicBattleSpeed)
end

return UIEpidemicBattleSpeedCtrl
