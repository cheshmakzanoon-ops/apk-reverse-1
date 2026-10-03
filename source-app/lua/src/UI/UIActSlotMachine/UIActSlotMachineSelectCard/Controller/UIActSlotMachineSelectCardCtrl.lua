local UIActSlotMachineSelectCardCtrl = BaseClass("UIActSlotMachineSelectCardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActSlotMachineSelectCard)
  PostEventLog.Track(PostEventLog.Defines.ActSlotMachineBoxClose, {})
end

local function OnCustomKeyCodeEscape(self)
end

UIActSlotMachineSelectCardCtrl.CloseSelf = CloseSelf
UIActSlotMachineSelectCardCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
return UIActSlotMachineSelectCardCtrl
