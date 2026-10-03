local ModifyKingDeclarationMessage = BaseClass("ModifyKingDeclarationMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, declaration)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("declaration", declaration)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.GovernmentManager:ModifyKingDeclarationHandler(t)
end

ModifyKingDeclarationMessage.OnCreate = OnCreate
ModifyKingDeclarationMessage.HandleMessage = HandleMessage
return ModifyKingDeclarationMessage
