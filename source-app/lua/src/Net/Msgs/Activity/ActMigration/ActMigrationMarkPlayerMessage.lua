local ActMigrationMarkPlayerMessage = BaseClass("ActMigrationMarkPlayerMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, targetUid, isMark)
  base.OnCreate(self)
  self.targetUid = targetUid
  self.isMark = isMark
  self.sfsObj:PutUtfString("targetUid", targetUid)
  self.sfsObj:PutBool("isMark", isMark)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowErrorCodeTips(t)
    return
  end
  DataCenter.ActMigrationManager:UpdatePlayerMark(t.targetUid, t.serverId, t.isMark)
end

ActMigrationMarkPlayerMessage.OnCreate = OnCreate
ActMigrationMarkPlayerMessage.HandleMessage = HandleMessage
return ActMigrationMarkPlayerMessage
