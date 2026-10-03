local PushUnlockLandMessage = BaseClass("PushUnlockLandMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTips(Localization:GetString(t.errorCode))
  else
    DataCenter.LandLockManager:PushUnlockHandle(t)
    DataCenter.RewardManager:AddRewardsAndRes(t)
  end
end

PushUnlockLandMessage.OnCreate = OnCreate
PushUnlockLandMessage.HandleMessage = HandleMessage
return PushUnlockLandMessage
