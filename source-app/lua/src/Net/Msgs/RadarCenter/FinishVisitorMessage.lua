local FinishVisitorMessage = BaseClass("FinishVisitorMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
end

FinishVisitorMessage.OnCreate = OnCreate
FinishVisitorMessage.HandleMessage = HandleMessage
return FinishVisitorMessage
