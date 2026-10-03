local UIPVEPowerLackCtrl = BaseClass("UIPVEPowerLackCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEPowerLack)
end

UIPVEPowerLackCtrl.CloseSelf = CloseSelf
return UIPVEPowerLackCtrl
