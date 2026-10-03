local UIGhostParkourRankPageRewardPopCtrl = BaseClass("UIGhostParkourRankPageRewardPopCtrl", UIBaseCtrl)

function UIGhostParkourRankPageRewardPopCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostParkourRankPageRewardPopView)
end

return UIGhostParkourRankPageRewardPopCtrl
