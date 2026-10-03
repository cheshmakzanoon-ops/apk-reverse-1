local UIOfficialAppointLogCtrl = BaseClass("UIOfficialAppointLogCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIOfficialAppointLog)
end

local function SendKingdomPositionHistoryList(self, positionId)
  SFSNetwork.SendMessage(MsgDefines.KingdomPositionHistoryList, positionId)
end

UIOfficialAppointLogCtrl.CloseSelf = CloseSelf
UIOfficialAppointLogCtrl.SendKingdomPositionHistoryList = SendKingdomPositionHistoryList
return UIOfficialAppointLogCtrl
