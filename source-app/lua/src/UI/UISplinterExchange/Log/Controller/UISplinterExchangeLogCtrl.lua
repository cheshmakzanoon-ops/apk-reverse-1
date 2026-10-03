local UISplinterExchangeLogCtrl = BaseClass("_TEMPLATE_NAME_Ctrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISplinterExchangeLog)
end

local function GetRecordDataList(self, type)
  return DataCenter.SplinterExchangeManager:GetRecordDataList(type)
end

local function SendLikeMsg(self, param)
  SFSNetwork.SendMessage(MsgDefines.DispatchTreasureLikeExchangeRecord, param)
end

UISplinterExchangeLogCtrl.CloseSelf = CloseSelf
UISplinterExchangeLogCtrl.GetRecordDataList = GetRecordDataList
UISplinterExchangeLogCtrl.SendLikeMsg = SendLikeMsg
return UISplinterExchangeLogCtrl
