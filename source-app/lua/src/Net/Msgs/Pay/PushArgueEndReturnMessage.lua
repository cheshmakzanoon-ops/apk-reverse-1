local PushArgueEndReturnMessage = BaseClass("PushArgueEndReturnMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode == nil then
    DataCenter.RewardManager:AddRewardsAndRes(t)
  end
end

PushArgueEndReturnMessage.OnCreate = OnCreate
PushArgueEndReturnMessage.HandleMessage = HandleMessage
return PushArgueEndReturnMessage
