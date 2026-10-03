local LWUIActEasterEggYesterdayCoinCtrl = BaseClass("LWUIActEasterEggYesterdayCoinCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIActEasterEggYesterdayCoin)
end

LWUIActEasterEggYesterdayCoinCtrl.CloseSelf = CloseSelf
return LWUIActEasterEggYesterdayCoinCtrl
