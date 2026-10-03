local LWUITrailTowerSweepBattleResultCtrl = BaseClass("LWUITrailTowerSweepBattleResultCtrl", UIBaseCtrl)

function LWUITrailTowerSweepBattleResultCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTrailTowerSweepBattleResult, {anim = false})
end

return LWUITrailTowerSweepBattleResultCtrl
