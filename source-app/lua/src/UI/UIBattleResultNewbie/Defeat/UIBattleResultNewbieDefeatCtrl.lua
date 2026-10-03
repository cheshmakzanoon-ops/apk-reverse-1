local UIBattleResultNewbieDefeatCtrl = BaseClass("UIBattleResultNewbieDefeatCtrl", UIBaseCtrl)

function UIBattleResultNewbieDefeatCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBattleResultNewbieDefeat)
end

return UIBattleResultNewbieDefeatCtrl
