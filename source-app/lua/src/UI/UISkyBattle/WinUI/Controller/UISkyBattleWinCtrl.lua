local UISkyBattleWinCtrl = BaseClass("UISkyBattleWinCtrl", UIBaseCtrl)

function UISkyBattleWinCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISkyBattleWin, {anim = false})
end

function UISkyBattleWinCtrl:InitData(self)
end

return UISkyBattleWinCtrl
