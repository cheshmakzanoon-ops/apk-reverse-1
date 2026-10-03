local TransferKingMessage = BaseClass("TransferKingMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uid)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("targetUid", uid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.GovernmentManager:TransferKingHandler(t)
end

TransferKingMessage.OnCreate = OnCreate
TransferKingMessage.HandleMessage = HandleMessage
return TransferKingMessage
