local LWUIActivityAlarmClockCtrl = BaseClass("LWUIActivityAlarmClockCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function LWUIActivityAlarmClockCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIActivityAlarmClock)
end

return LWUIActivityAlarmClockCtrl
