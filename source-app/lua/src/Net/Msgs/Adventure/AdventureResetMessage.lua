local AdventureResetMessage = BaseClass("AdventureResetMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    return
  end
  DataCenter.AdventureManager:HandleReset(t)
end

AdventureResetMessage.OnCreate = OnCreate
AdventureResetMessage.HandleMessage = HandleMessage
return AdventureResetMessage
