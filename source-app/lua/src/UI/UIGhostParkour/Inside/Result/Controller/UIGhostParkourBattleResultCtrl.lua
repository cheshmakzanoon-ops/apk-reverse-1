local UIGhostParkourBattleResultCtrl = BaseClass("UIGhostParkourBattleResultCtrl", UIBaseCtrl)

function UIGhostParkourBattleResultCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostParkourBattleResult, {anim = false})
end

return UIGhostParkourBattleResultCtrl
