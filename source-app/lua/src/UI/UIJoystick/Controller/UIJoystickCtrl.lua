local UIJoystickCtrl = BaseClass("UIJoystickCtrl", UIBaseCtrl)

function UIJoystickCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIJoystick)
end

return UIJoystickCtrl
