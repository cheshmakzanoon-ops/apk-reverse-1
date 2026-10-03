local LWUIMoveCityTipCtrl = BaseClass("LWUIMoveCityTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMoveCityTip)
end

LWUIMoveCityTipCtrl.CloseSelf = CloseSelf
return LWUIMoveCityTipCtrl
