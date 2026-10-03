local UIBattleResultParkourVictoryCtrl = BaseClass("UIBattleResultParkourVictoryCtrl", UIBaseCtrl)

function UIBattleResultParkourVictoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBattleResultParkourVictory)
end

return UIBattleResultParkourVictoryCtrl
