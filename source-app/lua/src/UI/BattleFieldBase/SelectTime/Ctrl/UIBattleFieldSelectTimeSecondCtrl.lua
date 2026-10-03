local UIBattleFieldSelectTimeSecondCtrl = BaseClass("UIBattleFieldSelectTimeSecondCtrl", UIBaseCtrl)

function UIBattleFieldSelectTimeSecondCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBattleFieldSelectTimeSecond)
end

return UIBattleFieldSelectTimeSecondCtrl
