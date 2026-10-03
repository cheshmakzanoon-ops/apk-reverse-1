local T11IdleGameBattleSoldierInfoTipCtrl = BaseClass("T11IdleGameBattleSoldierInfoTipCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWT11IdleGameBattleSoldierInfoTip)
end

T11IdleGameBattleSoldierInfoTipCtrl.CloseSelf = CloseSelf
return T11IdleGameBattleSoldierInfoTipCtrl
