local LWUIActValentineReceiveGiftRecordCtrl = BaseClass("LWUIActValentineReceiveGiftRecordCtrl", UIBaseCtrl)

function LWUIActValentineReceiveGiftRecordCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.ValentineReceiveGiftRecord)
end

return LWUIActValentineReceiveGiftRecordCtrl
