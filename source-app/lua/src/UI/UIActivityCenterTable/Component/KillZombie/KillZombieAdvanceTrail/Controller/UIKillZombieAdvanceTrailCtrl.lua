local UIKillZombieAdvanceTrailCtrl = BaseClass("UIKillZombieAdvanceTrailCtrl", UIBaseCtrl)

function UIKillZombieAdvanceTrailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIKillZombieAdvanceTrail)
end

return UIKillZombieAdvanceTrailCtrl
