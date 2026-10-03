local DragonRevokeAllPlayerMessage = BaseClass("DragonRevokeAllPlayerMessage", SFSBaseMessage)
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

DragonRevokeAllPlayerMessage.OnCreate = OnCreate
DragonRevokeAllPlayerMessage.HandleMessage = HandleMessage
return DragonRevokeAllPlayerMessage
