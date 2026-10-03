local StrongestCommandGetTodayRewardMessage = BaseClass("StrongestCommandGetTodayRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, actId, stage, type)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("actId", actId)
  self.sfsObj:PutInt("stage", stage)
  self.sfsObj:PutInt("type", type)
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
    if t.scoreInfo ~= nil then
      local dictScore = t.scoreInfo
      if dictScore.newRewardFlagList ~= nil then
        DataCenter.StrongestCommanderDataManager:OnEventGetReward(dictScore.newRewardFlagList)
      end
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshDataSingleScore)
  end
end

StrongestCommandGetTodayRewardMessage.OnCreate = OnCreate
StrongestCommandGetTodayRewardMessage.HandleMessage = HandleMessage
return StrongestCommandGetTodayRewardMessage
