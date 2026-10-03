local LWDecorationBookMainCtrl = BaseClass("LWDecorationBookMainCtrl", UIBaseCtrl)

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWDecorationBook, {anim = useAnimation})
end

LWDecorationBookMainCtrl.CloseSelf = CloseSelf
return LWDecorationBookMainCtrl
