local UISiegeInstructionCtrl = BaseClass("UISiegeInstructionCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UISiegeInstruction)
end

UISiegeInstructionCtrl.CloseSelf = CloseSelf
return UISiegeInstructionCtrl
