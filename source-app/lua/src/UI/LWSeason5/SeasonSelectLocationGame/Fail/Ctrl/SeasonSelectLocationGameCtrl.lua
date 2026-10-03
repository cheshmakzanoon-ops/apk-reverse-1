local SeasonSelectLocationGameCtrl = BaseClass("SeasonSelectLocationGameCtrl", UIBaseCtrl)

function SeasonSelectLocationGameCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonSelectLocationGameFail)
end

function SeasonSelectLocationGameCtrl:OnCustomKeyCodeEscape()
  self:CloseSelf()
  EventManager:GetInstance():Broadcast(EventId.SeasonTetrisCloseGame)
end

return SeasonSelectLocationGameCtrl
