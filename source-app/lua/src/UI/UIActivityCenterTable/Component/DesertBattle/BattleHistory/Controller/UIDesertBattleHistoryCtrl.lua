local UIDesertBattleHistoryCtrl = BaseClass("UIDesertBattleHistoryCtrl", UIBaseCtrl)

function UIDesertBattleHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertBattleHistory)
end

return UIDesertBattleHistoryCtrl
