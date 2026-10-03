local DragonAutoAssignPlayerMessage = BaseClass("DragonAutoAssignPlayerMessage", SFSBaseMessage)
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
    DataCenter.ActDragonManager:HandleGetPlayerList(t)
  end
end

DragonAutoAssignPlayerMessage.OnCreate = OnCreate
DragonAutoAssignPlayerMessage.HandleMessage = HandleMessage
return DragonAutoAssignPlayerMessage
