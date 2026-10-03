local PushActivityFundRewardAllMessage = BaseClass("PushActivityFundRewardAllMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
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
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    if not table.IsNullOrEmpty(t.questIds) then
      for i, v in pairs(t.questIds) do
        DataCenter.TaskManager:ReceiveOneTask(tostring(v))
      end
    end
  end
end

PushActivityFundRewardAllMessage.OnCreate = OnCreate
PushActivityFundRewardAllMessage.HandleMessage = HandleMessage
return PushActivityFundRewardAllMessage
