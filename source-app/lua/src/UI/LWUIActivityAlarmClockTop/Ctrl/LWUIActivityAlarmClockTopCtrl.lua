local LWUIActivityAlarmClockTopCtrl = BaseClass("LWUIActivityAlarmClockTopCtrl", UIBaseCtrl)

function LWUIActivityAlarmClockTopCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIActivityAlarmClockTop, {anim = false, playEffect = false})
end

return LWUIActivityAlarmClockTopCtrl
