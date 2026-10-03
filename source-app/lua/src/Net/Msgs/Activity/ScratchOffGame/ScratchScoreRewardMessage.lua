local ScratchScoreRewardMessage = BaseClass("ScratchScoreRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tostring(activityId))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward ~= nil then
      DataCenter.RewardManager:ShowCommonReward(t)
      DataCenter.RewardManager:AddRewardsAndRes(t)
    end
    if t.activityId ~= nil then
      local actId = t.activityId
      local newScore = t.score
      DataCenter.ScratchOffGameManager:UpdateScore(actId, newScore)
    end
  end
end

ScratchScoreRewardMessage.OnCreate = OnCreate
ScratchScoreRewardMessage.HandleMessage = HandleMessage
return ScratchScoreRewardMessage
