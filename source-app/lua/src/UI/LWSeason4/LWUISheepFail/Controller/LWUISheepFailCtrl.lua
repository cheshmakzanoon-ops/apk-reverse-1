local LWUISheepFailCtrl = BaseClass("LWUISheepFailCtrl", UIBaseCtrl)

function LWUISheepFailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUISheepFail)
end

function LWUISheepFailCtrl:OnCustomKeyCodeEscape()
  self:CloseSelf()
  EventManager:GetInstance():Broadcast(EventId.SeasonSheepCloseGame)
end

return LWUISheepFailCtrl
