local LWUIGiftHistoryCtrl = BaseClass("LWUIGiftHistoryCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIGiftHistory)
end

LWUIGiftHistoryCtrl.CloseSelf = CloseSelf
return LWUIGiftHistoryCtrl
