local UILWT11IdleGameBattleLeftTimeTipsCtrl = BaseClass("UILWT11IdleGameBattleLeftTimeTipsCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWT11IdleGameBattleLeftTimeTips)
end

UILWT11IdleGameBattleLeftTimeTipsCtrl.CloseSelf = CloseSelf
return UILWT11IdleGameBattleLeftTimeTipsCtrl
