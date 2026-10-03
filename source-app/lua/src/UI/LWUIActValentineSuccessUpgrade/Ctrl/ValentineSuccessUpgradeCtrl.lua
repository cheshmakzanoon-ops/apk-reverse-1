local ValentineSuccessUpgradeCtrl = BaseClass("ValentineSuccessUpgradeCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.ValentineSuccessUpgrade)
end

local function OnCustomKeyCodeEscape(self)
end

ValentineSuccessUpgradeCtrl.CloseSelf = CloseSelf
ValentineSuccessUpgradeCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
return ValentineSuccessUpgradeCtrl
