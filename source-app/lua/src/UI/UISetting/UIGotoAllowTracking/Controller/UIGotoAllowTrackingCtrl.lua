local UIGotoAllowTrackingCtrl = BaseClass("UIGotoAllowTrackingCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGotoAllowTracking)
end

UIGotoAllowTrackingCtrl.CloseSelf = CloseSelf
return UIGotoAllowTrackingCtrl
