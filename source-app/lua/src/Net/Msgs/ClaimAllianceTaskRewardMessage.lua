local ClaimAllianceTaskRewardMessage = BaseClass("ClaimAllianceTaskRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, taskId)
  base.OnCreate(self)
  self.sfsObj:PutInt("taskId", taskId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.RewardManager:AddRewardsAndRes(t)
    DataCenter.AllianceTaskManager:SetTaskClaimed(t.taskId)
    DataCenter.AllianceSeasonTaskManager:SetTaskClaimed(t.taskId)
    DataCenter.RewardManager:ShowCommonReward(t, Localization:GetString(128027))
    EventManager:GetInstance():Broadcast(EventId.OnUpdateAllianceTask, t.taskId)
  end
end

ClaimAllianceTaskRewardMessage.OnCreate = OnCreate
ClaimAllianceTaskRewardMessage.HandleMessage = HandleMessage
return ClaimAllianceTaskRewardMessage
