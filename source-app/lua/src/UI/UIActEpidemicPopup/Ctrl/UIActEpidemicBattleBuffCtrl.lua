local UIActEpidemicBattleBuffCtrl = BaseClass("UIActEpidemicBattleBuffCtrl", UIBaseCtrl)

function UIActEpidemicBattleBuffCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActEpidemicBattleBuffView)
end

return UIActEpidemicBattleBuffCtrl
