local UIActSlotMachineTaskCtrl = BaseClass("UIActSlotMachineTaskCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActSlotMachineTask)
end

UIActSlotMachineTaskCtrl.CloseSelf = CloseSelf
return UIActSlotMachineTaskCtrl
