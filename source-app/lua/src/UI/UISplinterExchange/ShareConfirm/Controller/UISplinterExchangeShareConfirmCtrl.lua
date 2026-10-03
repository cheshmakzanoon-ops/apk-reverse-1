local UISplinterExchangeShareConfirmCtrl = BaseClass("UISplinterExchangeShareConfirmCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISplinterExchangeShareConfirm)
end

local function SendALShareMsg(self, param)
  SFSNetwork.SendMessage(MsgDefines.DispatchTreasureSendALInfo, param)
end

UISplinterExchangeShareConfirmCtrl.CloseSelf = CloseSelf
UISplinterExchangeShareConfirmCtrl.SendALShareMsg = SendALShareMsg
return UISplinterExchangeShareConfirmCtrl
