local DragonActivityInfoMessage = BaseClass("DragonActivityInfoMessage", SFSBaseMessage)
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
    DataCenter.ActDragonManager:HandleGetInfo(t)
  end
end

DragonActivityInfoMessage.OnCreate = OnCreate
DragonActivityInfoMessage.HandleMessage = HandleMessage
return DragonActivityInfoMessage
