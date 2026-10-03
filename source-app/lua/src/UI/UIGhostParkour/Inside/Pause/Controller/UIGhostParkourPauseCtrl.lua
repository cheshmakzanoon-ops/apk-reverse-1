local UIGhostParkourPauseCtrl = BaseClass("UIGhostParkourPauseCtrl", UIBaseCtrl)

function UIGhostParkourPauseCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostParkourPause, {anim = false})
end

return UIGhostParkourPauseCtrl
