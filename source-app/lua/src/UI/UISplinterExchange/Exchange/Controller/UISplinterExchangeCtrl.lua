local UISplinterExchangeCtrl = BaseClass("_TEMPLATE_NAME_Ctrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISplinterExchange)
end

local function GetAlExchangeDataList(self, type)
  return DataCenter.SplinterExchangeManager:GetAlExchangeDataList(type)
end

local function GetSelfExchangeData(self, type)
  return DataCenter.SplinterExchangeManager:GetSelfExchangeData(type)
end

local function SendGetSelfExchangeDataMsg(self, param)
  SFSNetwork.SendMessage(MsgDefines.DispatchTreasureGetSelfInfo, param)
end

local function SendGetAlExchangeDataListMsg(self, param)
  SFSNetwork.SendMessage(MsgDefines.DispatchTreasureGetALInfo, param)
end

local function SendCallExchangeMsg(self, param)
  if string.IsNullOrEmpty(LuaEntry.Player.allianceId) then
    UIUtil.ShowTipsId("371059")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.DispatchTreasureCallExchange, param)
end

local function SendCancelExchangeMsg(self, param)
  SFSNetwork.SendMessage(MsgDefines.DispatchTreasureCancelExchange, param)
end

local function SendALShareMsg(self, param)
  SFSNetwork.SendMessage(MsgDefines.DispatchTreasureSendALInfo, param)
end

local function SendRemoveExchangeShowMessage(self, param)
  SFSNetwork.SendMessage(MsgDefines.DispatchTreasureRemoveExchangeShow, param)
end

local function SendLikeMsg(self, param)
  InteractiveUtil.TryThumbsUp(param.uid, InteractiveUtil.ThumbsUpType.ExchangeRecord, "SplinterExchange", function()
    SFSNetwork.SendMessage(MsgDefines.DispatchTreasureLikeExchangeRecord, param)
  end)
end

local function OpenTreasureExchangeLogView(self, param)
  if param.type == SplinterExchangeType.DispatchTreasure.Id or param.type == SplinterExchangeType.DigTreasure.Id then
    SFSNetwork.SendMessage(MsgDefines.DispatchTreasureExchangeRecord, param)
    SFSNetwork.SendMessage(MsgDefines.DispatchTreasureAllianceExchangeRecord, param)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDispathTreasureExchangeLog, {anim = true})
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISplinterExchangeLog, {anim = true}, param.type)
    SFSNetwork.SendMessage(MsgDefines.DispatchTreasureExchangeRecord, param)
  end
end

UISplinterExchangeCtrl.CloseSelf = CloseSelf
UISplinterExchangeCtrl.GetAlExchangeDataList = GetAlExchangeDataList
UISplinterExchangeCtrl.GetSelfExchangeData = GetSelfExchangeData
UISplinterExchangeCtrl.SendGetSelfExchangeDataMsg = SendGetSelfExchangeDataMsg
UISplinterExchangeCtrl.SendGetAlExchangeDataListMsg = SendGetAlExchangeDataListMsg
UISplinterExchangeCtrl.SendCallExchangeMsg = SendCallExchangeMsg
UISplinterExchangeCtrl.SendCancelExchangeMsg = SendCancelExchangeMsg
UISplinterExchangeCtrl.SendCancelExchangeMsg = SendCancelExchangeMsg
UISplinterExchangeCtrl.SendALShareMsg = SendALShareMsg
UISplinterExchangeCtrl.SendRemoveExchangeShowMessage = SendRemoveExchangeShowMessage
UISplinterExchangeCtrl.SendLikeMsg = SendLikeMsg
UISplinterExchangeCtrl.OpenTreasureExchangeLogView = OpenTreasureExchangeLogView
return UISplinterExchangeCtrl
