local UIGhostParkourAllianceRewardCtrl = BaseClass("UIGhostParkourAllianceRewardCtrl", UIBaseCtrl)

function UIGhostParkourAllianceRewardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostParkourAllianceRewardView)
end

return UIGhostParkourAllianceRewardCtrl
