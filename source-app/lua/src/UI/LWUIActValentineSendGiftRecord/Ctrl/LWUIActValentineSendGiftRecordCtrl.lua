local LWUIActValentineSendGiftRecordCtrl = BaseClass("LWUIActValentineSendGiftRecordCtrl", UIBaseCtrl)

function LWUIActValentineSendGiftRecordCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.ValentineSendGiftRecord)
end

return LWUIActValentineSendGiftRecordCtrl
