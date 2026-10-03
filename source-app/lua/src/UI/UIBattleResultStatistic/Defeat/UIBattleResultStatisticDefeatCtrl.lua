local UIBattleResultStatisticDefeatCtrl = BaseClass("UIBattleResultStatisticDefeatCtrl", UIBaseCtrl)

function UIBattleResultStatisticDefeatCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBattleResultStatisticDefeat)
end

return UIBattleResultStatisticDefeatCtrl
