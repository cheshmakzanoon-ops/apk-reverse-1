local UIActSlotMachineRewardGetCtrl = BaseClass("UIActSlotMachineRewardGetCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIActSlotMachineRewardGet)
end

UIActSlotMachineRewardGetCtrl.CloseSelf = CloseSelf
return UIActSlotMachineRewardGetCtrl
