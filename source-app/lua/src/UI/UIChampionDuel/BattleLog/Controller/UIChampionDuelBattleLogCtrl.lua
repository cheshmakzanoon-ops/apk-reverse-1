local UIChampionDuelBattleLogCtrl = BaseClass("UIChampionDuelBattleLogCtrl", UIBaseCtrl)

function UIChampionDuelBattleLogCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChampionDuelBattleLog)
end

return UIChampionDuelBattleLogCtrl
