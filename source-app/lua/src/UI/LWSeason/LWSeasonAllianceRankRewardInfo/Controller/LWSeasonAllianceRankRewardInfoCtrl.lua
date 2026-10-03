local LWSeasonAllianceRankRewardInfoCtrl = BaseClass("LWSeasonAllianceRankRewardInfoCtrl", UIBaseCtrl)

function LWSeasonAllianceRankRewardInfoCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWSeasonAllianceRankRewardInfo)
end

return LWSeasonAllianceRankRewardInfoCtrl
