local UIBattleResultParkourBonusVictoryCtrl = BaseClass("UIBattleResultParkourBonusVictoryCtrl", UIBaseCtrl)

function UIBattleResultParkourBonusVictoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBattleResultParkourBonusVictory)
end

return UIBattleResultParkourBonusVictoryCtrl
