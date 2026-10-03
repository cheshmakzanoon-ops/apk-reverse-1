local SyncSeasonVirusLayerMessage = BaseClass("SyncSeasonVirusLayerMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SyncSeasonVirusLayerMessage:OnCreate()
  base.OnCreate(self)
end

function SyncSeasonVirusLayerMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  LuaEntry.Effect:SyncSeasonVirusStatus(t)
end

return SyncSeasonVirusLayerMessage
