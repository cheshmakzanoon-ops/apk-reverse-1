local ActMigrationApplyRedNumPushMessage = BaseClass("ActMigrationApplyRedNumPushMessage", SFSBaseMessage)
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
  DataCenter.ActMigrationManager:HandleApplyRedNum(t.applyRedNum)
end

ActMigrationApplyRedNumPushMessage.OnCreate = OnCreate
ActMigrationApplyRedNumPushMessage.HandleMessage = HandleMessage
return ActMigrationApplyRedNumPushMessage
