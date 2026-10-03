local LWUIActBountyHunterEventInfoTipCtrl = BaseClass("LWUIActBountyHunterEventInfoTipCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIActBountyHunterEventInfoTip)
end

LWUIActBountyHunterEventInfoTipCtrl.CloseSelf = CloseSelf
return LWUIActBountyHunterEventInfoTipCtrl
