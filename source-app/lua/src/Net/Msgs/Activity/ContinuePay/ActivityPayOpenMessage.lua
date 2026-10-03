local ActivityPayOpenMessage = BaseClass("ActivityPayOpenMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, index)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("index", index)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ContinuePayActivityManager:UpdateOneBoxInfo(t)
    if t.reward ~= nil then
      DataCenter.RewardManager:AddRewards(t.reward)
      DataCenter.RewardManager:ShowCommonReward(t)
      if t.bigReward == 1 then
        DataCenter.ContinuePayActivityManager:GetBigReward(t)
      end
    end
  end
end

ActivityPayOpenMessage.OnCreate = OnCreate
ActivityPayOpenMessage.HandleMessage = HandleMessage
return ActivityPayOpenMessage
