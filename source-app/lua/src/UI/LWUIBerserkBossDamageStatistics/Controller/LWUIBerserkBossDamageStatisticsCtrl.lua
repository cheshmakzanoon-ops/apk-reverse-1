local LWUIBerserkBossDamageStatisticsCtrl = BaseClass("LWUIBerserkBossDamageStatisticsCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function LWUIBerserkBossDamageStatisticsCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIBerserkBossDamageStatistics)
end

return LWUIBerserkBossDamageStatisticsCtrl
