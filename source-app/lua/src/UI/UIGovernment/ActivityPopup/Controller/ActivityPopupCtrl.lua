local ActivityPopupCtrl = BaseClass("ActivityPopupCtrl", UIBaseCtrl)

function ActivityPopupCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentActivityPopup)
end

return ActivityPopupCtrl
