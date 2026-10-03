local UILW3V3OpponentCtrl = BaseClass("UILW3V3OpponentCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILW3V3Opponent)
end

UILW3V3OpponentCtrl.CloseSelf = CloseSelf
return UILW3V3OpponentCtrl
