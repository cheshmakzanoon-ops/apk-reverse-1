local PushDragoCommanderModifyMessage = BaseClass("PushDragoCommanderModifyMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, type, uid)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActDragonManager:HandleCommanderModify(t)
  end
end

PushDragoCommanderModifyMessage.OnCreate = OnCreate
PushDragoCommanderModifyMessage.HandleMessage = HandleMessage
return PushDragoCommanderModifyMessage
