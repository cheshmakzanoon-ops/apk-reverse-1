local ValentineSendGiftDetailCtrl = BaseClass("ValentineSendGiftDetailCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.ValentineSendGiftDetail)
end

ValentineSendGiftDetailCtrl.CloseSelf = CloseSelf
return ValentineSendGiftDetailCtrl
