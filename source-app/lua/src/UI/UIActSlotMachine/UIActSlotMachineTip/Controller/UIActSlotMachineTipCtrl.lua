local UIActSlotMachineTipCtrl = BaseClass("UIActSlotMachineTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActSlotMachineTip)
end

UIActSlotMachineTipCtrl.CloseSelf = CloseSelf
return UIActSlotMachineTipCtrl
