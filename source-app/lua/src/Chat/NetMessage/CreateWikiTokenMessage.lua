local CreateWikiTokenMessage = BaseClass("CreateWikiTokenMessage", SFSBaseMessage)

local function OnCreate(self, uuid)
end

local function HandleMessage(self, msg)
  if msg then
    DataCenter.LWNewsCenterManager:SetToken(msg)
  end
end

CreateWikiTokenMessage.OnCreate = OnCreate
CreateWikiTokenMessage.HandleMessage = HandleMessage
return CreateWikiTokenMessage
