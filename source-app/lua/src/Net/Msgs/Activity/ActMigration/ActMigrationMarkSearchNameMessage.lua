local ActMigrationMarkSearchNameMessage = BaseClass("ActMigrationMarkSearchNameMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, content)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("content", content or "")
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowErrorCodeTips(t)
  end
end

ActMigrationMarkSearchNameMessage.OnCreate = OnCreate
ActMigrationMarkSearchNameMessage.HandleMessage = HandleMessage
return ActMigrationMarkSearchNameMessage
