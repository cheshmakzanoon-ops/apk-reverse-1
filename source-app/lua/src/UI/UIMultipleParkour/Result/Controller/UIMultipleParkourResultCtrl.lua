local UIMultipleParkourResultCtrl = BaseClass("UIMultipleParkourResultCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMultipleParkourResult, {anim = false})
end

UIMultipleParkourResultCtrl.CloseSelf = CloseSelf
return UIMultipleParkourResultCtrl
