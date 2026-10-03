local RefreshBaseTalentMessage = BaseClass("RefreshBaseTalentMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.TalentDataManager:TalentChooseResetHandler(t)
end

RefreshBaseTalentMessage.OnCreate = OnCreate
RefreshBaseTalentMessage.HandleMessage = HandleMessage
return RefreshBaseTalentMessage
