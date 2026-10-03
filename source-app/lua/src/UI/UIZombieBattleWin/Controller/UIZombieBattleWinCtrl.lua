local UIZombieBattleWinCtrl = BaseClass("UIZombieBattleWinCtrl", UIBaseCtrl)

function UIZombieBattleWinCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIZombieBattleWin, {anim = false})
end

function UIZombieBattleWinCtrl:InitData(self)
end

return UIZombieBattleWinCtrl
