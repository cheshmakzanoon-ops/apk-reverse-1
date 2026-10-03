local UIBFDsbDuelBattleMapCtrl = BaseClass("UIBFDsbDuelBattleMapCtrl", UIBaseCtrl)

function UIBFDsbDuelBattleMapCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBFDsbDuelBattleMap)
end

return UIBFDsbDuelBattleMapCtrl
