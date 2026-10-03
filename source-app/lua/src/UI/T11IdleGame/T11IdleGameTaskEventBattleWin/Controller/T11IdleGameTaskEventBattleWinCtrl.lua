local T11IdleGameTaskEventBattleWinCtrl = BaseClass("T11IdleGameTaskEventBattleWinCtrl", UIBaseCtrl)

function T11IdleGameTaskEventBattleWinCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIIdleGameTaskEventBattleWin, {anim = false})
end

function T11IdleGameTaskEventBattleWinCtrl:InitData()
end

return T11IdleGameTaskEventBattleWinCtrl
