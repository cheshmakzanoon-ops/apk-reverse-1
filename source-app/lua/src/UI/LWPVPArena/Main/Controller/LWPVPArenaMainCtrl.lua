local LWPVPArenaMainCtrl = BaseClass("LWPVPArenaMainCtrl", UIBaseCtrl)

function LWPVPArenaMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWPVPArenaMain)
end

return LWPVPArenaMainCtrl
