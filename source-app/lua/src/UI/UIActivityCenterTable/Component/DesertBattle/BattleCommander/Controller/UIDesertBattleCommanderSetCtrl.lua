local UIDesertBattleCommanderSetCtrl = BaseClass("UIDesertBattleCommanderSetCtrl", UIBaseCtrl)

function UIDesertBattleCommanderSetCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertBattleCommanderSet)
end

return UIDesertBattleCommanderSetCtrl
