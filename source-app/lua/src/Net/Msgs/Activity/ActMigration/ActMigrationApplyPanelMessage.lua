local ActMigrationApplyPanelMessage = BaseClass("ActMigrationApplyPanelMessage", SFSBaseMessage)
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

ActMigrationApplyPanelMessage.OnCreate = OnCreate
ActMigrationApplyPanelMessage.HandleMessage = HandleMessage
return ActMigrationApplyPanelMessage
