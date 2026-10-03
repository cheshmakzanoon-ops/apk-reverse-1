local LWUISheepGameCtrl = BaseClass("LWUISheepGameCtrl", UIBaseCtrl)

function LWUISheepGameCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUISheepGame)
end

function LWUISheepGameCtrl:OnCustomKeyCodeEscape()
  EventManager:GetInstance():Broadcast(EventId.SeasonSheepGameESC)
end

return LWUISheepGameCtrl
