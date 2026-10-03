local ReceiveCityGarbageRewardMessage = BaseClass("ReceiveCityGarbageRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid)
  base.OnCreate(self)
  if uuid ~= nil then
    self.sfsObj:PutLong("uuid", uuid)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.GuideCityManager:ReceiveCityGarbageRewardHandle(t)
end

ReceiveCityGarbageRewardMessage.OnCreate = OnCreate
ReceiveCityGarbageRewardMessage.HandleMessage = HandleMessage
return ReceiveCityGarbageRewardMessage
