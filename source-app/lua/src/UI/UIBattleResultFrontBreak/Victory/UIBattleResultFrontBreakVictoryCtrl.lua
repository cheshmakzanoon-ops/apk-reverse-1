local UIBattleResultFrontBreakVictoryCtrl = BaseClass("UIBattleResultFrontBreakVictoryCtrl", UIBaseCtrl)

function UIBattleResultFrontBreakVictoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBattleResultFrontBreakVictory)
end

return UIBattleResultFrontBreakVictoryCtrl
