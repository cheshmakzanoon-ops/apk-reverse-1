local AdventureGetLevelMessage = BaseClass("AdventureGetLevelMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    return
  end
  DataCenter.AdventureManager:HandleContinue(t)
end

AdventureGetLevelMessage.OnCreate = OnCreate
AdventureGetLevelMessage.HandleMessage = HandleMessage
return AdventureGetLevelMessage
