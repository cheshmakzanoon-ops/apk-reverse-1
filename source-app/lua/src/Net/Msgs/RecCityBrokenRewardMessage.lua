local RecCityBrokenRewardMessage = BaseClass("RecCityBrokenRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid)
  base.OnCreate(self)
  if uuid ~= nil then
    self.sfsObj:PutLong("uuid", uuid)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.RewardManager:ShowGeift(t)
end

RecCityBrokenRewardMessage.OnCreate = OnCreate
RecCityBrokenRewardMessage.HandleMessage = HandleMessage
return RecCityBrokenRewardMessage
