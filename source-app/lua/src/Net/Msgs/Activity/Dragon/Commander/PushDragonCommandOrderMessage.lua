local PushDragonCommandOrderMessage = BaseClass("PushDragonCommandOrderMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActDragonManager:HandleOneCommandOrder(t, 1, true)
  end
end

PushDragonCommandOrderMessage.OnCreate = OnCreate
PushDragonCommandOrderMessage.HandleMessage = HandleMessage
return PushDragonCommandOrderMessage
