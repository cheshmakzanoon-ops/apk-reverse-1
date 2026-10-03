local LWUITrailTowerBattleWinCtrl = BaseClass("LWUITrailTowerBattleWinCtrl", UIBaseCtrl)

function LWUITrailTowerBattleWinCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTrailTowerBattleWin, {anim = false})
end

return LWUITrailTowerBattleWinCtrl
