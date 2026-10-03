local CheckObjExistsMessage = BaseClass("CheckObjExistsMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, data)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", toInt(data.uuid))
  self.sfsObj:PutInt("serverId", toInt(data.serverId))
  self.sfsObj:PutInt("objType", toInt(data.objType))
  self.sfsObj:PutInt("worldId", toInt(data.worldId))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local data = {}
    data.exists = t.exists
    data.objType = t.objType
    data.uuid = t.uuid
    data.worldId = t.worldId
    data.serverId = t.serverId
    EventManager:GetInstance():Broadcast(EventId.CheckObjExistsEvent, data)
  end
end

CheckObjExistsMessage.OnCreate = OnCreate
CheckObjExistsMessage.HandleMessage = HandleMessage
return CheckObjExistsMessage
