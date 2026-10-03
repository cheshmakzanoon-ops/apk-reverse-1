local UIBattleResultCountBattleVictoryCtrl = BaseClass("UIBattleResultCountBattleVictoryCtrl", UIBaseCtrl)

function UIBattleResultCountBattleVictoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBattleResultCountBattleVictory)
end

return UIBattleResultCountBattleVictoryCtrl
