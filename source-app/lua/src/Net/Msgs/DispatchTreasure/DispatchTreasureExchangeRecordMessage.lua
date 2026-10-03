local DispatchTreasureExchangeRecordMessage = BaseClass("DispatchTreasureExchangeRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutInt("type", param.type)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      if t.type == SplinterExchangeType.DispatchTreasure.Id or t.type == SplinterExchangeType.DigTreasure.Id then
        DataCenter.ActDispatchTreasureManager:RefreshRecordData(t, SplinterExchangeLogType.Own)
      else
        DataCenter.SplinterExchangeManager:RefreshRecordDataList(t)
        EventManager:GetInstance():Broadcast(EventId.SplinterRefreshLog, t.type)
      end
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

DispatchTreasureExchangeRecordMessage.OnCreate = OnCreate
DispatchTreasureExchangeRecordMessage.HandleMessage = HandleMessage
return DispatchTreasureExchangeRecordMessage
