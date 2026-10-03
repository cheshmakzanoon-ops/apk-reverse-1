local UIBattleResultParkourDefeatCtrl = BaseClass("UIBattleResultParkourDefeatCtrl", UIBaseCtrl)

function UIBattleResultParkourDefeatCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBattleResultParkourDefeat)
end

return UIBattleResultParkourDefeatCtrl
