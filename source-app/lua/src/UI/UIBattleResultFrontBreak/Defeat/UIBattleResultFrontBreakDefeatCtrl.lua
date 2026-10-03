local UIBattleResultFrontBreakDefeatCtrl = BaseClass("UIBattleResultFrontBreakDefeatCtrl", UIBaseCtrl)

function UIBattleResultFrontBreakDefeatCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBattleResultFrontBreakDefeat)
end

return UIBattleResultFrontBreakDefeatCtrl
