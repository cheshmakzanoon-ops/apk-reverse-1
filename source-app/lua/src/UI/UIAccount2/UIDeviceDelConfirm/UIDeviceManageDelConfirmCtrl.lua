local UIDeviceManageDelConfirmCtrl = BaseClass("UIDeviceManageDelConfirmCtrl", UIBaseCtrl)

function UIDeviceManageDelConfirmCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDeviceManageDelConfirm)
end

return UIDeviceManageDelConfirmCtrl
