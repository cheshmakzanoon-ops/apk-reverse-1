local EnterNextCaveExploreMessage = BaseClass("EnterNextCaveExploreMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, curPathId, index)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("curPathId", curPathId)
  self.sfsObj:PutInt("index", index)
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

EnterNextCaveExploreMessage.OnCreate = OnCreate
EnterNextCaveExploreMessage.HandleMessage = HandleMessage
return EnterNextCaveExploreMessage
