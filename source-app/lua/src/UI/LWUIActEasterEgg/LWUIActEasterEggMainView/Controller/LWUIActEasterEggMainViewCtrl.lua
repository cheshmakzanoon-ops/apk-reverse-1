local LWUIActEasterEggMainViewCtrl = BaseClass("LWUIActEasterEggMainViewCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIActEasterEggMain)
end

LWUIActEasterEggMainViewCtrl.CloseSelf = CloseSelf
return LWUIActEasterEggMainViewCtrl
