local TalentChooseMessage = BaseClass("TalentChooseMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, talentId)
  base.OnCreate(self)
  self.sfsObj:PutInt("talentId", talentId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.TalentDataManager:TalentChooseHandler(t)
end

TalentChooseMessage.OnCreate = OnCreate
TalentChooseMessage.HandleMessage = HandleMessage
return TalentChooseMessage
