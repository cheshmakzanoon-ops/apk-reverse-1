local UIDeviceManageCtrl = BaseClass("UIDeviceManageCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDeviceManage)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIDeviceManageCtrl.CloseSelf = CloseSelf
UIDeviceManageCtrl.Close = Close
return UIDeviceManageCtrl
