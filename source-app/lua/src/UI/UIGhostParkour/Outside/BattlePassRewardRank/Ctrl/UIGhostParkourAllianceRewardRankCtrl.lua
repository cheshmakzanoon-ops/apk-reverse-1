local UIGhostParkourAllianceRewardRankCtrl = BaseClass("UIGhostParkourAllianceRewardRankCtrl", UIBaseCtrl)

function UIGhostParkourAllianceRewardRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostParkourAllianceRewardRankView)
end

return UIGhostParkourAllianceRewardRankCtrl
