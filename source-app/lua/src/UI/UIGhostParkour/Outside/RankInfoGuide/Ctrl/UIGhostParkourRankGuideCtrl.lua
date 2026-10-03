local UIGhostParkourRankGuideCtrl = BaseClass("UIGhostParkourRankGuideCtrl", UIBaseCtrl)

function UIGhostParkourRankGuideCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostParkourRankGuideView)
end

return UIGhostParkourRankGuideCtrl
