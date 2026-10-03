local DragonCommandOrderDelMessage = BaseClass("DragonCommandOrderDelMessage", SFSBaseMessage)
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

DragonCommandOrderDelMessage.OnCreate = OnCreate
DragonCommandOrderDelMessage.HandleMessage = HandleMessage
return DragonCommandOrderDelMessage
