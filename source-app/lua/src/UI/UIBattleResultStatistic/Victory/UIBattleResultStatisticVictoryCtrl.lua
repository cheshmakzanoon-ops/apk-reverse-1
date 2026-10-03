local UIBattleResultStatisticVictoryCtrl = BaseClass("UIBattleResultStatisticVictoryCtrl", UIBaseCtrl)

function UIBattleResultStatisticVictoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBattleResultStatisticVictory)
end

return UIBattleResultStatisticVictoryCtrl
