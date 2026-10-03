local DispatchTreasureCancelExchangeMessage = BaseClass("DispatchTreasureCancelExchangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutLong("uuid", param.uuid)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.SplinterExchangeManager:RefreshSelfInfo(t)
      EventManager:GetInstance():Broadcast(EventId.SplinterRefreshSelf, t.type)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

DispatchTreasureCancelExchangeMessage.OnCreate = OnCreate
DispatchTreasureCancelExchangeMessage.HandleMessage = HandleMessage
return DispatchTreasureCancelExchangeMessage
