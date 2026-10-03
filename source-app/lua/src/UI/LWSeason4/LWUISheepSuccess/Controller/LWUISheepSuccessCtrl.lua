local LWUISheepSuccessCtrl = BaseClass("LWUISheepSuccessCtrl", UIBaseCtrl)

function LWUISheepSuccessCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUISheepSuccess)
end

function LWUISheepSuccessCtrl:OnCustomKeyCodeEscape()
  self:CloseSelf()
  EventManager:GetInstance():Broadcast(EventId.SeasonSheepCloseGame)
end

return LWUISheepSuccessCtrl
