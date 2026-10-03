local QueueCcdMNewMessage = BaseClass("QueueCcdMNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param, golloesFreeTime)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutLong("qUUID", param.qUUID)
    if param.itemIDs ~= nil then
      self.sfsObj:PutUtfString("itemIDs", param.itemIDs)
    end
    if param.useGold then
      self.sfsObj:PutInt("useGold", param.useGold)
    end
    if golloesFreeTime then
      local intTime = math.modf(golloesFreeTime)
      self.sfsObj:PutInt("golloesSpeedTime", intTime)
    end
  end
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  DataCenter.QueueDataManager:QueueCcsMNewHandle(message)
  EventManager:GetInstance():Broadcast(EventId.DelayRefreshResource, 0.1)
end

QueueCcdMNewMessage.OnCreate = OnCreate
QueueCcdMNewMessage.HandleMessage = HandleMessage
return QueueCcdMNewMessage
