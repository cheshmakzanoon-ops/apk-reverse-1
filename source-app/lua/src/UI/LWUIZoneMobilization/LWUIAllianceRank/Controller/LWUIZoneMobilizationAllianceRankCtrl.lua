local LWUIZoneMobilizationAllianceRankCtrl = BaseClass("LWUIZoneMobilizationAllianceRankCtrl", UIBaseCtrl)

function LWUIZoneMobilizationAllianceRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIZoneMobilizationAllianceRank)
end

return LWUIZoneMobilizationAllianceRankCtrl
