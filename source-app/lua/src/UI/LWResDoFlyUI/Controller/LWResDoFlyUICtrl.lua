local LWResDoFlyUICtrl = BaseClass("LWResDoFlyUICtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWResDoFlyUI)
end

LWResDoFlyUICtrl.CloseSelf = CloseSelf
return LWResDoFlyUICtrl
