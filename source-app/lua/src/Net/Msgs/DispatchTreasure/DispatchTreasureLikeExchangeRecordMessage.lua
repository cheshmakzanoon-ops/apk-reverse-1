local DispatchTreasureLikeExchangeRecordMessage = BaseClass("DispatchTreasureLikeExchangeRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutLong("uuid", tonumber(param.uuid))
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.SplinterExchangeManager:RefreshOneRecordData(t)
      DataCenter.SplinterExchangeManager:RefreshSelfRecordShowData(t)
      EventManager:GetInstance():Broadcast(EventId.SplinterRefreshLogCell, t.uuid)
      UIUtil.ShowTipsId("Treasure_map_45")
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

DispatchTreasureLikeExchangeRecordMessage.OnCreate = OnCreate
DispatchTreasureLikeExchangeRecordMessage.HandleMessage = HandleMessage
return DispatchTreasureLikeExchangeRecordMessage
