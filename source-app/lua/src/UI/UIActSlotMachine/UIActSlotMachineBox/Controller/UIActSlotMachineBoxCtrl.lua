local UIActSlotMachineBoxCtrl = BaseClass("UIActSlotMachineBoxCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActSlotMachineBox)
  PostEventLog.Track(PostEventLog.Defines.ActSlotMachineBoxClose, {})
end

local function OnCustomKeyCodeEscape(self)
end

UIActSlotMachineBoxCtrl.CloseSelf = CloseSelf
UIActSlotMachineBoxCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
return UIActSlotMachineBoxCtrl
