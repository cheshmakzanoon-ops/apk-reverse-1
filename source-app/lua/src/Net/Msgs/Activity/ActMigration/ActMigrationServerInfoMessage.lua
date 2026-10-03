local ActMigrationServerInfoMessage = BaseClass("ActMigrationServerInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActMigrationManager:HandleServerInfo(t)
end

ActMigrationServerInfoMessage.OnCreate = OnCreate
ActMigrationServerInfoMessage.HandleMessage = HandleMessage
return ActMigrationServerInfoMessage
