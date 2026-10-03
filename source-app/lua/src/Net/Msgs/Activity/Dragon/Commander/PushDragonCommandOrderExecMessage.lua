local PushDragonCommandOrderExecMessage = BaseClass("PushDragonCommandOrderExecMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, index)
  base.OnCreate(self)
  self.sfsObj:PutInt("index", index)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActDragonManager:HandleOneCommandOrder(t, 3, true)
  end
end

PushDragonCommandOrderExecMessage.OnCreate = OnCreate
PushDragonCommandOrderExecMessage.HandleMessage = HandleMessage
return PushDragonCommandOrderExecMessage
