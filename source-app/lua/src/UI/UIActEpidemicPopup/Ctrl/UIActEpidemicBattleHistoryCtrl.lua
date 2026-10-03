local UIActEpidemicBattleHistoryCtrl = BaseClass("UIActEpidemicBattleHistoryCtrl", UIBaseCtrl)

function UIActEpidemicBattleHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActEpidemicBattleHistoryView, {anim = true})
end

return UIActEpidemicBattleHistoryCtrl
