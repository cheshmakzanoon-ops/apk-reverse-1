local LWSeasonBossLoginRecordCtrl = BaseClass("LWSeasonBossLoginRecordCtrl", UIBaseCtrl)

function LWSeasonBossLoginRecordCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWSeasonBossLoginRecord)
end

return LWSeasonBossLoginRecordCtrl
