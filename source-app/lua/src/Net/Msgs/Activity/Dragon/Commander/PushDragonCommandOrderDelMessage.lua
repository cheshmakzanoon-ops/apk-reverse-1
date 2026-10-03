local PushDragonCommandOrderDelMessage = BaseClass("PushDragonCommandOrderDelMessage", SFSBaseMessage)
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
    DataCenter.ActDragonManager:HandleOneCommandOrder(t, 2, true)
  end
end

PushDragonCommandOrderDelMessage.OnCreate = OnCreate
PushDragonCommandOrderDelMessage.HandleMessage = HandleMessage
return PushDragonCommandOrderDelMessage
