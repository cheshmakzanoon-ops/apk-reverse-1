local LWUIZoneMobilizationPersonalRankCtrl = BaseClass("LWUIZoneMobilizationPersonalRankCtrl", UIBaseCtrl)

function LWUIZoneMobilizationPersonalRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIZoneMobilizationPersonalRank)
end

return LWUIZoneMobilizationPersonalRankCtrl
