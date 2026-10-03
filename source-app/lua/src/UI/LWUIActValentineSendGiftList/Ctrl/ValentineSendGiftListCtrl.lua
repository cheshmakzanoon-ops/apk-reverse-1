local ValentineSendGiftListCtrl = BaseClass("ValentineSendGiftListCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.ValentineSendGiftList)
end

ValentineSendGiftListCtrl.CloseSelf = CloseSelf
return ValentineSendGiftListCtrl
