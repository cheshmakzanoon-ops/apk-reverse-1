local FinishSamplingMessage = BaseClass("FinishSamplingMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
end

FinishSamplingMessage.OnCreate = OnCreate
FinishSamplingMessage.HandleMessage = HandleMessage
return FinishSamplingMessage
