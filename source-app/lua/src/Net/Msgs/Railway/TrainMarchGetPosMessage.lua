local TrainMarchGetPosMessage = BaseClass("TrainMarchGetPosMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, point, serverId, worldId, uuid, nowTs, lastPointOrder, lastPullInTs, lastPullOutTs, wayListLog, worldCityTableName)
  base.OnCreate(self)
  self.sfsObj:PutInt("point", point)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutInt("worldId", worldId or 0)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutLong("nowTs", nowTs)
  self.sfsObj:PutInt("lastPointOrder", lastPointOrder)
  self.sfsObj:PutLong("lastPullInTs", lastPullInTs)
  self.sfsObj:PutLong("lastPullOutTs", lastPullOutTs)
  self.sfsObj:PutUtfString("wayListLog", wayListLog)
  self.sfsObj:PutUtfString("worldCityTableName", worldCityTableName)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
end

TrainMarchGetPosMessage.OnCreate = OnCreate
TrainMarchGetPosMessage.HandleMessage = HandleMessage
return TrainMarchGetPosMessage
