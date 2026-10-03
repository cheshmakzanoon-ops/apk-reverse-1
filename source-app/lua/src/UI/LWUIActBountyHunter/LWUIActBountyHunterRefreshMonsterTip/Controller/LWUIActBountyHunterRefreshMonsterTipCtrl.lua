local LWUIActBountyHunterRefreshMonsterTipCtrl = BaseClass("LWUIActBountyHunterRefreshMonsterTipCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIActBountyHunterRefreshMonsterTip)
end

LWUIActBountyHunterRefreshMonsterTipCtrl.CloseSelf = CloseSelf
return LWUIActBountyHunterRefreshMonsterTipCtrl
