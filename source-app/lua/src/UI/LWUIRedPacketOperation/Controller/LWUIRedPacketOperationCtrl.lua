local LWUIRedPacketOperationCtrl = BaseClass("LWUIRedPacketOperationCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIRedPacketOperation)
end

local function GetRedPacketList()
  return
end

LWUIRedPacketOperationCtrl.GetRedPacketList = GetRedPacketList
LWUIRedPacketOperationCtrl.CloseSelf = CloseSelf
return LWUIRedPacketOperationCtrl
