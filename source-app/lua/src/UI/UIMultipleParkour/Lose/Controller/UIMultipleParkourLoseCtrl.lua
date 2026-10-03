local UIMultipleParkourLoseCtrl = BaseClass("UIMultipleParkourLoseCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMultipleParkourLose, {anim = false})
end

UIMultipleParkourLoseCtrl.CloseSelf = CloseSelf
return UIMultipleParkourLoseCtrl
