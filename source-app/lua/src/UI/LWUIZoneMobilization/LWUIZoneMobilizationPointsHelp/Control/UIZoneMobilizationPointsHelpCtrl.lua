local UIZoneMobilizationPointsHelpCtrl = BaseClass("UIZoneMobilizationPointsHelpCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIZoneMobilizationPointsHelp)
end

UIZoneMobilizationPointsHelpCtrl.CloseSelf = CloseSelf
return UIZoneMobilizationPointsHelpCtrl
