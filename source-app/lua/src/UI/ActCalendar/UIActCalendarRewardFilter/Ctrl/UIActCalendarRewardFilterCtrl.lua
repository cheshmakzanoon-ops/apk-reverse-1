local UIActCalendarRewardFilterCtrl = BaseClass("UIActCalendarRewardFilterCtrl", UIBaseCtrl)

function UIActCalendarRewardFilterCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActCalendarRewardFilter)
end

return UIActCalendarRewardFilterCtrl
