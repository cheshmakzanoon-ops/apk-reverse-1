local UIGhostParkourBattleCountDownCtrl = BaseClass("UIGhostParkourBattleCountDownCtrl", UIBaseCtrl)

function UIGhostParkourBattleCountDownCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostParkourBattleCountDown, {anim = false})
end

return UIGhostParkourBattleCountDownCtrl
