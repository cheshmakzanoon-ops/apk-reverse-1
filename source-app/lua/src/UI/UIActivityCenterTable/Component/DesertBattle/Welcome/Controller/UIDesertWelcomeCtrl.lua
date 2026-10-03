local UIDesertWelcomeCtrl = BaseClass("UIDesertWelcomeCtrl", UIBaseCtrl)

function UIDesertWelcomeCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertWelcome)
  EventManager:GetInstance():Broadcast(EventId.DragonGuideStart)
end

return UIDesertWelcomeCtrl
