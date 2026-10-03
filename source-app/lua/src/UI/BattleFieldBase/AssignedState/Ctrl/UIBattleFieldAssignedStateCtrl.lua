local UIBattleFieldAssignedStateCtrl = BaseClass("UIBattleFieldAssignedStateCtrl", UIBaseCtrl)

function UIBattleFieldAssignedStateCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBattleFieldAssignedState, {anim = false})
end

return UIBattleFieldAssignedStateCtrl
