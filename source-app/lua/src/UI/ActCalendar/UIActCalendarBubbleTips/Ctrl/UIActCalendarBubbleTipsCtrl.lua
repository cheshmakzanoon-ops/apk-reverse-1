local UIActCalendarBubbleTipsCtrl = BaseClass("UIActCalendarBubbleTipsCtrl", UIBaseCtrl)

function UIActCalendarBubbleTipsCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActCalendarBubbleTips)
end

return UIActCalendarBubbleTipsCtrl
