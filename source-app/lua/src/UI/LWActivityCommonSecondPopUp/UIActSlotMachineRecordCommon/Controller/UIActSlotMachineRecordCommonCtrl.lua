local UIActSlotMachineRecordCommonCtrl = BaseClass("UIActSlotMachineRecordCommonCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActSlotMachineRecordCommon)
end

UIActSlotMachineRecordCommonCtrl.CloseSelf = CloseSelf
return UIActSlotMachineRecordCommonCtrl
