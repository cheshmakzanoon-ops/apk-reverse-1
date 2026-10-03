local ActMigrationApplyListInfoMessage = BaseClass("ActMigrationApplyListInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, startIndex, number)
  base.OnCreate(self)
  self.sfsObj:PutInt("startIndex", startIndex)
  self.sfsObj:PutInt("number", number)
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

ActMigrationApplyListInfoMessage.OnCreate = OnCreate
ActMigrationApplyListInfoMessage.HandleMessage = HandleMessage
return ActMigrationApplyListInfoMessage
