local UIBattleResultJeepAdventureDefeatCtrl = BaseClass("UIBattleResultJeepAdventureDefeatCtrl", UIBaseCtrl)

function UIBattleResultJeepAdventureDefeatCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBattleResultJeepAdventureDefeat)
end

return UIBattleResultJeepAdventureDefeatCtrl
