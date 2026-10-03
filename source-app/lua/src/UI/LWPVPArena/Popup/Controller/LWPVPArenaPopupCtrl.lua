local LWPVPArenaPopupCtrl = BaseClass("LWPVPArenaPopupCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWPVPArenaPopup)
end

LWPVPArenaPopupCtrl.CloseSelf = CloseSelf
return LWPVPArenaPopupCtrl
