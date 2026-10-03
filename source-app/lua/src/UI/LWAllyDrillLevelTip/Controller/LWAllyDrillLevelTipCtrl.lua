local LWAllyDrillLevelTipCtrl = BaseClass("LWAllyDrillLevelTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWAllyDrillLevelTip)
end

LWAllyDrillLevelTipCtrl.CloseSelf = CloseSelf
return LWAllyDrillLevelTipCtrl
