local LWUIZoneMobilizationMainCtrl = BaseClass("LWUIZoneMobilizationMainCtrl", UIBaseCtrl)

function LWUIZoneMobilizationMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIZoneMobilizationMain)
end

return LWUIZoneMobilizationMainCtrl
