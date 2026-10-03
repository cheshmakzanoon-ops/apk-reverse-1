local GaleArenaGetTopThreeListMessage = BaseClass("GaleArenaGetTopThreeListMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, arenaType)
  base.OnCreate(self)
  if arenaType then
    self.sfsObj:PutInt("arenaType", arenaType)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      EventManager:GetInstance():Broadcast(EventId.NewGaleArenaGetTopThreeListPreview, t)
    else
      EventManager:GetInstance():Broadcast(EventId.NewGaleArenaGetMessageError, t)
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

GaleArenaGetTopThreeListMessage.OnCreate = OnCreate
GaleArenaGetTopThreeListMessage.HandleMessage = HandleMessage
return GaleArenaGetTopThreeListMessage
