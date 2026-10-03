local UIGhostParkourRankPageCtrl = BaseClass("UIGhostParkourRankPageCtrl", UIBaseCtrl)

function UIGhostParkourRankPageCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostParkourRankPageView)
end

return UIGhostParkourRankPageCtrl
