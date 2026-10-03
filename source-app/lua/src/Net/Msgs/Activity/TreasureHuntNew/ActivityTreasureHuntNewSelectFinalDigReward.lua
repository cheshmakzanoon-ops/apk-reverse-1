local ActivityTreasureHuntNewSelectFinalDigReward = BaseClass("ActivityTreasureHuntNewSelectFinalDigReward", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, bigRewardIndex)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("bigRewardIndex", bigRewardIndex)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityTreasureHuntNewManager:OnRecvSelectFinalRewardSucc(t)
  end
end

ActivityTreasureHuntNewSelectFinalDigReward.OnCreate = OnCreate
ActivityTreasureHuntNewSelectFinalDigReward.HandleMessage = HandleMessage
return ActivityTreasureHuntNewSelectFinalDigReward
