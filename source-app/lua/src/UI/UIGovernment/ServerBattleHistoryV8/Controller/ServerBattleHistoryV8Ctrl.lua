local ServerBattleHistoryV8Ctrl = BaseClass("ServerBattleHistoryV8Ctrl", UIBaseCtrl)

function ServerBattleHistoryV8Ctrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentServerBattleHistoryV8)
end

return ServerBattleHistoryV8Ctrl
