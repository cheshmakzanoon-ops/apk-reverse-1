local MainCtrl = BaseClass("MainCtrl", UIBaseCtrl)

function MainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentMain)
end

return MainCtrl
