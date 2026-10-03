local UIActMonopolyTip2Ctrl = BaseClass("UIActMonopolyTip2Ctrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActMonopolyTip2)
  EventManager:GetInstance():Broadcast(EventId.ActMonopolyEventTipClose)
end

UIActMonopolyTip2Ctrl.CloseSelf = CloseSelf
return UIActMonopolyTip2Ctrl
