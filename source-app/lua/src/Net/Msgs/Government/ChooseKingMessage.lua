local ChooseKingMessage = BaseClass("ChooseKingMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, targetUid)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("targetUid", targetUid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.GovernmentManager:ChooseKingHandler(t)
end

ChooseKingMessage.OnCreate = OnCreate
ChooseKingMessage.HandleMessage = HandleMessage
return ChooseKingMessage
