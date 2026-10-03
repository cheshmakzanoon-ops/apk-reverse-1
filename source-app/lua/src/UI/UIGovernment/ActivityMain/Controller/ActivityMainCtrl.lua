local ActivityMainCtrl = BaseClass("ActivityMainCtrl", UIBaseCtrl)

function ActivityMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentActivityMain)
end

return ActivityMainCtrl
