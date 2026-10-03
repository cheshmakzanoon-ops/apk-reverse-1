local LWUIGoldTreeThirdCtrl = BaseClass("LWUIGoldTreeThirdCtrl", UIBaseCtrl)

function LWUIGoldTreeThirdCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIGoldTreeThird)
end

function LWUIGoldTreeThirdCtrl:OnCustomKeyCodeEscape()
  EventManager:GetInstance():Broadcast(EventId.LWUIGoldTreeThirdESC)
end

return LWUIGoldTreeThirdCtrl
