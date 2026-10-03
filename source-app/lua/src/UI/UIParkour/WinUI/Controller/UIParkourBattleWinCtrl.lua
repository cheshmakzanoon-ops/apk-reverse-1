local UIParkourBattleWinCtrl = BaseClass("UIParkourBattleWinCtrl", UIBaseCtrl)

function UIParkourBattleWinCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIParkourBattleWin, {anim = false})
end

function UIParkourBattleWinCtrl:InitData(self)
end

return UIParkourBattleWinCtrl
