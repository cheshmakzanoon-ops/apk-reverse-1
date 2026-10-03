local PushUserMaxForceValueMessage = BaseClass("PushUserMaxForceValueMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, id)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.SeasonRewardDataManager:UpdatePersonalOccupyLandCount(t, SeasonScoreRewardPanelType.PersonalOccupyLand)
end

PushUserMaxForceValueMessage.OnCreate = OnCreate
PushUserMaxForceValueMessage.HandleMessage = HandleMessage
return PushUserMaxForceValueMessage
