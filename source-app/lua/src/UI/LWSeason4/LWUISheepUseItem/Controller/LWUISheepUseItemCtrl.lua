local LWUISheepUseItemCtrl = BaseClass("LWUISheepUseItemCtrl", UIBaseCtrl)

function LWUISheepUseItemCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUISheepUseItem)
end

function LWUISheepUseItemCtrl:OnCustomKeyCodeEscape()
  self:CloseSelf()
  EventManager:GetInstance():Broadcast(EventId.SeasonSheepCloseUseItem)
end

return LWUISheepUseItemCtrl
