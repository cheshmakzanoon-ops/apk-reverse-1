local LWSeasonBossLoginTaskCtrl = BaseClass("LWSeasonBossLoginTaskCtrl", UIBaseCtrl)

function LWSeasonBossLoginTaskCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWSeasonBossLoginTask)
end

return LWSeasonBossLoginTaskCtrl
