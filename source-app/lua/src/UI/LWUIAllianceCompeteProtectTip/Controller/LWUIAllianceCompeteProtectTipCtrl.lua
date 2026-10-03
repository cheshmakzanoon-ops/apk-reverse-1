local LWUIAllianceCompeteProtectTipCtrl = BaseClass("LWUIAllianceCompeteProtectTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIAllianceCompeteProtectTip)
end

LWUIAllianceCompeteProtectTipCtrl.CloseSelf = CloseSelf
return LWUIAllianceCompeteProtectTipCtrl
