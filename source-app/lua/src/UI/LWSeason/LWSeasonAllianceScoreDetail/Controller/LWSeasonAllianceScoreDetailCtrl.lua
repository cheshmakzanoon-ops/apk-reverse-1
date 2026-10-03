local LWSeasonAllianceScoreDetailCtrl = BaseClass("LWSeasonAllianceScoreDetailCtrl", UIBaseCtrl)

function LWSeasonAllianceScoreDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWSeasonAllianceScoreDetail)
end

return LWSeasonAllianceScoreDetailCtrl
