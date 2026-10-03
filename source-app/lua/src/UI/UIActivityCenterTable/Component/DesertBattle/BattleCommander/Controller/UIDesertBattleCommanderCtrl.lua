local UIDesertBattleCommanderCtrl = BaseClass("UIDesertBattleCommanderCtrl", UIBaseCtrl)

function UIDesertBattleCommanderCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertBattleCommander)
end

return UIDesertBattleCommanderCtrl
