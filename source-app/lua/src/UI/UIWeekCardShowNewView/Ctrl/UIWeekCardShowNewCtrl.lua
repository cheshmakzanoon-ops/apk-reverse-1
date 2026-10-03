local UIWeekCardShowNewCtrl = BaseClass("UIWeekCardShowNewCtrl", UIBaseCtrl)

function UIWeekCardShowNewCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWeekCardShowNew)
end

return UIWeekCardShowNewCtrl
