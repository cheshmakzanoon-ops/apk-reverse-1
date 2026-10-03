local PushSeasonVirusStatusMessage = BaseClass("PushSeasonVirusStatusMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushSeasonVirusStatusMessage:OnCreate()
  base.OnCreate(self)
end

function PushSeasonVirusStatusMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  LuaEntry.Effect:SyncSeasonVirusStatus(t)
end

return PushSeasonVirusStatusMessage
