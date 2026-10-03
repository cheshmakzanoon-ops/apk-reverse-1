local LWUIActEasterThumbsUpGloryCtrl = BaseClass("LWUIActEasterThumbsUpGloryCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIActEasterThumbsUpGlory)
end

LWUIActEasterThumbsUpGloryCtrl.CloseSelf = CloseSelf
return LWUIActEasterThumbsUpGloryCtrl
