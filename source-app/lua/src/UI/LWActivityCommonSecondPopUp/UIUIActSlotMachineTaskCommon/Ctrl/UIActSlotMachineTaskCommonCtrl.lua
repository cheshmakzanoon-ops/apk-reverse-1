local UIActSlotMachineTaskCommonCtrl = BaseClass("UIActSlotMachineTaskCommonCtrl", UIBaseCtrl)

function UIActSlotMachineTaskCommonCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActSlotMachineTaskCommon)
end

return UIActSlotMachineTaskCommonCtrl
