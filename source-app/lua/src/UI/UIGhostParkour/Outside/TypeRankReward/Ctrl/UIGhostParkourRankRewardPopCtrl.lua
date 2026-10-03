local UIGhostParkourRankRewardPopCtrl = BaseClass("UIGhostParkourRankRewardPopCtrl", UIBaseCtrl)

function UIGhostParkourRankRewardPopCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostParkourRankRewardPopView)
end

return UIGhostParkourRankRewardPopCtrl
