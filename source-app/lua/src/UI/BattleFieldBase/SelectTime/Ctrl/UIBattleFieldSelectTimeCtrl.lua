local UIBattleFieldSelectTimeCtrl = BaseClass("UIBattleFieldSelectTimeCtrl", UIBaseCtrl)

function UIBattleFieldSelectTimeCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBattleFieldSelectTime)
end

return UIBattleFieldSelectTimeCtrl
