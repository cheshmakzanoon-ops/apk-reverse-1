local ActMigrationApplyListSearchMessage = BaseClass("ActMigrationApplyListSearchMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, name)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("name", name)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActMigrationManager:HandleApplyList(t)
end

ActMigrationApplyListSearchMessage.OnCreate = OnCreate
ActMigrationApplyListSearchMessage.HandleMessage = HandleMessage
return ActMigrationApplyListSearchMessage
