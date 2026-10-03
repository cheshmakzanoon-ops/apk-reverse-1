local UIBattleResultNewbieVictoryCtrl = BaseClass("UIBattleResultNewbieVictoryCtrl", UIBaseCtrl)

function UIBattleResultNewbieVictoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBattleResultNewbieVictory)
end

return UIBattleResultNewbieVictoryCtrl
