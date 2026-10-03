local UIActBanquetDonateCtrl = BaseClass("UIActBanquetDonateCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIActBanquetDonate)
end

UIActBanquetDonateCtrl.CloseSelf = CloseSelf
return UIActBanquetDonateCtrl
