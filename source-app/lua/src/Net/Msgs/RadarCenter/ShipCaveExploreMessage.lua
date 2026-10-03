local ShipCaveExploreMessage = BaseClass("ShipCaveExploreMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, curPathId)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("curPathId", curPathId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.CaveExplorationManager:DeleteSyncMsgUuid(t.uuid)
    EventManager:GetInstance():Broadcast(EventId.UIDetectCaveExploreViewRefresh, t)
  end
end

ShipCaveExploreMessage.OnCreate = OnCreate
ShipCaveExploreMessage.HandleMessage = HandleMessage
return ShipCaveExploreMessage
