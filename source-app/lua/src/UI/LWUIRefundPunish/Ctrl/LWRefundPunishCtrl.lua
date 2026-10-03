local LWRefundPunishCtrl = BaseClass("LWRefundPunishCtrl", UIBaseCtrl)

function LWRefundPunishCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWRefundPunish)
end

return LWRefundPunishCtrl
