local UIBattleFieldPingSignCtrl = BaseClass("UIBattleFieldPingSignCtrl", UIBaseCtrl)

function UIBattleFieldPingSignCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBattleFieldPingSign, {anim = false})
end

return UIBattleFieldPingSignCtrl
