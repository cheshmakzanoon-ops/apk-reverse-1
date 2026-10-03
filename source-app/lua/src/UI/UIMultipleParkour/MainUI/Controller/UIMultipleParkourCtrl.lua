local UIMultipleParkourCtrl = BaseClass("UIMultipleParkour", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMultipleParkour, {anim = false})
end

UIMultipleParkourCtrl.CloseSelf = CloseSelf
return UIMultipleParkourCtrl
