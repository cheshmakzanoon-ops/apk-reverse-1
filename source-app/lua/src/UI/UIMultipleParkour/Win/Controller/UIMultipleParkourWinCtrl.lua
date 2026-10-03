local UIMultipleParkourWinCtrl = BaseClass("UIMultipleParkourWinCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMultipleParkourWin, {anim = false})
end

UIMultipleParkourWinCtrl.CloseSelf = CloseSelf
return UIMultipleParkourWinCtrl
