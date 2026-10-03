local LWUIZoneMobilizationTaskCtrl = BaseClass("LWUIZoneMobilizationTaskCtrl", UIBaseCtrl)

function LWUIZoneMobilizationTaskCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIZoneMobilizationTask)
end

return LWUIZoneMobilizationTaskCtrl
