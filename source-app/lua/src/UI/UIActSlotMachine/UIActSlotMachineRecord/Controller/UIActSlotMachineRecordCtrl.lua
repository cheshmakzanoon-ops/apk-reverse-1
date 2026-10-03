local UIActSlotMachineRecordCtrl = BaseClass("UIActSlotMachineRecordCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActSlotMachineRecord)
end

UIActSlotMachineRecordCtrl.CloseSelf = CloseSelf
return UIActSlotMachineRecordCtrl
