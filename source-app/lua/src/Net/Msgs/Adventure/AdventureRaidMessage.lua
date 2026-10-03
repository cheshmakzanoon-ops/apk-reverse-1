local AdventureRaidMessage = BaseClass("AdventureRaidMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    return
  end
  DataCenter.AdventureManager:HandleRaid(t)
end

AdventureRaidMessage.OnCreate = OnCreate
AdventureRaidMessage.HandleMessage = HandleMessage
return AdventureRaidMessage
