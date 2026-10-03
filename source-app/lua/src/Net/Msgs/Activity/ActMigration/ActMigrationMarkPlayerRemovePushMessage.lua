local ActMigrationMarkPlayerRemovePushMessage = BaseClass("ActMigrationMarkPlayerRemovePushMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowErrorCodeTips(t)
    return
  end
  DataCenter.ActMigrationManager:UpdatePlayerMark(t.targetUid, t.serverId)
end

ActMigrationMarkPlayerRemovePushMessage.OnCreate = OnCreate
ActMigrationMarkPlayerRemovePushMessage.HandleMessage = HandleMessage
return ActMigrationMarkPlayerRemovePushMessage
