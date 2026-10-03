local LWUITimelineQTECtrl = BaseClass("LWUITimelineQTECtrl", UIBaseCtrl)

function LWUITimelineQTECtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUITimelineQTE)
end

return LWUITimelineQTECtrl
