local DragonCommandOrderExecMessage = BaseClass("DragonCommandOrderExecMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, group, index)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", group)
  self.sfsObj:PutInt("index", index)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

DragonCommandOrderExecMessage.OnCreate = OnCreate
DragonCommandOrderExecMessage.HandleMessage = HandleMessage
return DragonCommandOrderExecMessage
