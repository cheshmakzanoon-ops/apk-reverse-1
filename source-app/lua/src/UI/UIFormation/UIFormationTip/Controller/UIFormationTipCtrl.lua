local UIFormationTipCtrl = BaseClass("UIFormationTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFormationTip)
end

UIFormationTipCtrl.CloseSelf = CloseSelf
return UIFormationTipCtrl
