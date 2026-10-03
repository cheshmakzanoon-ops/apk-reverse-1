local UIGhostParkourWaitLoadingCtrl = BaseClass("UIGhostParkourWaitLoadingCtrl", UIBaseCtrl)

function UIGhostParkourWaitLoadingCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostParkourWaitLoading, {anim = false})
end

return UIGhostParkourWaitLoadingCtrl
