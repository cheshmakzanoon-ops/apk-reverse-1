local LWGotoUpgradeBaseCtrl = BaseClass("LWGotoUpgradeBaseCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWGotoUpgradeBaseView)
end

LWGotoUpgradeBaseCtrl.CloseSelf = CloseSelf
return LWGotoUpgradeBaseCtrl
