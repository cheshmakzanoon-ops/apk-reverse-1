local LWDecorationBookPropertyCtrl = BaseClass("LWDecorationBookPropertyCtrl", UIBaseCtrl)

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWDecorationBookProperty, {anim = useAnimation})
end

LWDecorationBookPropertyCtrl.CloseSelf = CloseSelf
return LWDecorationBookPropertyCtrl
