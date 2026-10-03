local ActivityMainS4Ctrl = BaseClass("ActivityMainS4Ctrl", UIBaseCtrl)

function ActivityMainS4Ctrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentActivityMainS4)
end

return ActivityMainS4Ctrl
