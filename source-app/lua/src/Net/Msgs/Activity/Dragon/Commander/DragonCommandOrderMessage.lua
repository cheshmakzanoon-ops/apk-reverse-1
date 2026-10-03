local DragonCommandOrderMessage = BaseClass("DragonCommandOrderMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, group, index, type, point, extra)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", group)
  self.sfsObj:PutInt("index", index)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutInt("point", point)
  self.sfsObj:PutUtfString("extra", extra)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

DragonCommandOrderMessage.OnCreate = OnCreate
DragonCommandOrderMessage.HandleMessage = HandleMessage
return DragonCommandOrderMessage
