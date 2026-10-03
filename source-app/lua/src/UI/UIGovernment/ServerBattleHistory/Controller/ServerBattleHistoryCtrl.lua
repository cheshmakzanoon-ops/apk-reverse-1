local ServerBattleHistoryCtrl = BaseClass("ServerBattleHistoryCtrl", UIBaseCtrl)

function ServerBattleHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentServerBattleHistory)
end

return ServerBattleHistoryCtrl
