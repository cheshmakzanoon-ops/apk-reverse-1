local UIBattleFieldChangeTimeCtrl = BaseClass("UIBattleFieldChangeTimeCtrl", UIBaseCtrl)

function UIBattleFieldChangeTimeCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBattleFieldChangeTime)
end

return UIBattleFieldChangeTimeCtrl
