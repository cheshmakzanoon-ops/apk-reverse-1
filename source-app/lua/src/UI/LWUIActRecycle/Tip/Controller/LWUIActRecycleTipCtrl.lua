local LWUIActRecycleTipCtrl = BaseClass("LWUIActRecycleTipCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIActRecycleTip)
end

LWUIActRecycleTipCtrl.CloseSelf = CloseSelf
return LWUIActRecycleTipCtrl
