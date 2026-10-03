local ProductLineCollectMessage = BaseClass("ProductLineCollectMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutLong("uuid", param.bUuid)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.ProductLineManager:HandleCollect(t)
  if t.buildInfo then
    EventManager:GetInstance():Broadcast(EventId.ProductLineCollect, t.buildInfo.uuid)
  end
end

ProductLineCollectMessage.OnCreate = OnCreate
ProductLineCollectMessage.HandleMessage = HandleMessage
return ProductLineCollectMessage
