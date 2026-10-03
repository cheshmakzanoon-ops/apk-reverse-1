local LWUIMobilizationDonateCtrl = BaseClass("LWUIMobilizationDonateCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMobilizationDonate)
end

LWUIMobilizationDonateCtrl.CloseSelf = CloseSelf
return LWUIMobilizationDonateCtrl
