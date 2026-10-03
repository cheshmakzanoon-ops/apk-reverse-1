local TalentResetMessage = BaseClass("TalentResetMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, costType)
  base.OnCreate(self)
  self.sfsObj:PutInt("costType", costType)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.TalentDataManager:TalentResetHandler(t)
end

TalentResetMessage.OnCreate = OnCreate
TalentResetMessage.HandleMessage = HandleMessage
return TalentResetMessage
