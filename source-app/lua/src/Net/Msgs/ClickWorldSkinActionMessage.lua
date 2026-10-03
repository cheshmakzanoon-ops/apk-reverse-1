local ClickWorldSkinActionMessage = BaseClass("ClickWorldSkinActionMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uid, clickType, serverId, worldId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("otherUid", tostring(uid))
  self.sfsObj:PutInt("clickType", clickType)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutInt("worldId", worldId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
end

ClickWorldSkinActionMessage.OnCreate = OnCreate
ClickWorldSkinActionMessage.HandleMessage = HandleMessage
return ClickWorldSkinActionMessage
