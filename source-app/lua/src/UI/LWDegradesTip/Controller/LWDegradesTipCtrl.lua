local LWDegradesTipCtrl = BaseClass("LWDegradesTipCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWDegradesTip, {anim = useAnimation})
end

LWDegradesTipCtrl.CloseSelf = CloseSelf
return LWDegradesTipCtrl
