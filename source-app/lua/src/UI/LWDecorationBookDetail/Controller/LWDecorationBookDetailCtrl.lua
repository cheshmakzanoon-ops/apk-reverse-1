local LWDecorationBookDetailCtrl = BaseClass("LWDecorationBookDetailCtrl", UIBaseCtrl)

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWDecorationBookDetail, {anim = useAnimation})
end

LWDecorationBookDetailCtrl.CloseSelf = CloseSelf
return LWDecorationBookDetailCtrl
