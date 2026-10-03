local UIHSRRobCtrl = BaseClass("UIHSRRobCtrl", UIBaseCtrl)

function UIHSRRobCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHSRRob)
end

return UIHSRRobCtrl
