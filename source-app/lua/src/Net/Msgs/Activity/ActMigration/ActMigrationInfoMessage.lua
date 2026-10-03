local ActMigrationInfoMessage = BaseClass("ActMigrationInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActMigrationManager:HandleActInfo(t)
end

ActMigrationInfoMessage.OnCreate = OnCreate
ActMigrationInfoMessage.HandleMessage = HandleMessage
return ActMigrationInfoMessage
