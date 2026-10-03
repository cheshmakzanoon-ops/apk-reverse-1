local UITowerupBattleWinCtrl = BaseClass("UITowerupBattleWinCtrl", UIBaseCtrl)

function UITowerupBattleWinCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITowerupBattleWin, {anim = false})
end

function UITowerupBattleWinCtrl:InitData()
end

return UITowerupBattleWinCtrl
