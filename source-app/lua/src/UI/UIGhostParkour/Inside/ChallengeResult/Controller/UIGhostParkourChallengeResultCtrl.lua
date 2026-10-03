local UIGhostParkourChallengeResultCtrl = BaseClass("UIGhostParkourChallengeResultCtrl", UIBaseCtrl)

function UIGhostParkourChallengeResultCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostParkourChallengeResult, {anim = false})
end

return UIGhostParkourChallengeResultCtrl
