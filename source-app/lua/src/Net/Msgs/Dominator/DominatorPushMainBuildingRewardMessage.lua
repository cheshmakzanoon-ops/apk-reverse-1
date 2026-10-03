local DominatorPushMainBuildingRewardMessage = BaseClass("DominatorPushMainBuildingRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutLong("trainId", param.trainId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.RewardManager:AddRewardsAndRes(t)
  end
end

DominatorPushMainBuildingRewardMessage.OnCreate = OnCreate
DominatorPushMainBuildingRewardMessage.HandleMessage = HandleMessage
return DominatorPushMainBuildingRewardMessage
