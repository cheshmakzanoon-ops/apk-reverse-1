local LWActivityArenaBuyTimesCtrl = BaseClass("LWActivityArenaBuyTimesCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWActivityArenaBuyTimes)
end

LWActivityArenaBuyTimesCtrl.CloseSelf = CloseSelf
return LWActivityArenaBuyTimesCtrl
