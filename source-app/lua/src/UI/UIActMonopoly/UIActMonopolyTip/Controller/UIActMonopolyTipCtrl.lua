local UIActMonopolyTipCtrl = BaseClass("UIActMonopolyTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActMonopolyTip)
  EventManager:GetInstance():Broadcast(EventId.ActMonopolyEventTipClose)
end

UIActMonopolyTipCtrl.CloseSelf = CloseSelf
return UIActMonopolyTipCtrl
