local UIPersonalArmsCalendarCtrl = BaseClass("UIPersonalArmsCalendarCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPersonalArmsCalendar)
end

UIPersonalArmsCalendarCtrl.CloseSelf = CloseSelf
return UIPersonalArmsCalendarCtrl
