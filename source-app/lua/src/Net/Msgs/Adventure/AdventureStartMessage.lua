local AdventureStartMessage = BaseClass("AdventureStartMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    return
  end
  DataCenter.AdventureManager:HandleStart(t)
end

AdventureStartMessage.OnCreate = OnCreate
AdventureStartMessage.HandleMessage = HandleMessage
return AdventureStartMessage
