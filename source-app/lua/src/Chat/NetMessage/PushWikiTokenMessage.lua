local PushWikiTokenMessage = BaseClass("PushWikiTokenMessage", SFSBaseMessage)

local function OnCreate(self)
end

local function HandleMessage(self, serverData)
  DataCenter.LWNewsCenterManager:SetToken(serverData)
end

PushWikiTokenMessage.OnCreate = OnCreate
PushWikiTokenMessage.HandleMessage = HandleMessage
return PushWikiTokenMessage
