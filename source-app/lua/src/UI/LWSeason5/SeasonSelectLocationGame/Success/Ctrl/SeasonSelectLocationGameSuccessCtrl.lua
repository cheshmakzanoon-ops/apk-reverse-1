local SeasonSelectLocationGameSuccessCtrl = BaseClass("SeasonSelectLocationGameSuccessCtrl", UIBaseCtrl)

function SeasonSelectLocationGameSuccessCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonSelectLocationGameSuccess)
end

function SeasonSelectLocationGameSuccessCtrl:OnCustomKeyCodeEscape()
  self:CloseSelf()
  EventManager:GetInstance():Broadcast(EventId.SeasonTetrisCloseGame)
end

return SeasonSelectLocationGameSuccessCtrl
