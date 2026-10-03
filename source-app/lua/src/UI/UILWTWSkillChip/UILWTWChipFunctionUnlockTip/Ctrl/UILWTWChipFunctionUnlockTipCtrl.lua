local UILWTWChipFunctionUnlockTipCtrl = BaseClass("UILWTWChipFunctionUnlockTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTWChipFunctionUnlockTip)
end

UILWTWChipFunctionUnlockTipCtrl.CloseSelf = CloseSelf
return UILWTWChipFunctionUnlockTipCtrl
