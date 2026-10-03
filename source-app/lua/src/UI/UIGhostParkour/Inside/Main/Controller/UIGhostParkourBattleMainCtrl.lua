local UIGhostParkourBattleMainCtrl = BaseClass("UIGhostParkourBattleMainCtrl", UIBaseCtrl)

function UIGhostParkourBattleMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostParkourBattleMain, {anim = false})
end

return UIGhostParkourBattleMainCtrl
