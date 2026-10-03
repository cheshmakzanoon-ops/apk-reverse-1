local UIBattleResultCountBattleDefeatCtrl = BaseClass("UIBattleResultCountBattleDefeatCtrl", UIBaseCtrl)

function UIBattleResultCountBattleDefeatCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBattleResultCountBattleDefeat)
end

return UIBattleResultCountBattleDefeatCtrl
