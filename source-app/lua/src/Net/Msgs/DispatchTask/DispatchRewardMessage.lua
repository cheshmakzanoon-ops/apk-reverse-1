local DispatchRewardMessage = BaseClass("DispatchRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function DispatchRewardMessage:OnCreate(uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

function DispatchRewardMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if message.endPointId then
      DataCenter.ActDispatchTaskFakeMarchManager:AddMarchIndex(message.endPointId, message.startPointId, true)
    end
    if message.reward then
      DataCenter.RewardManager:AddRewardsAndRes(message)
      DataCenter.ActDispatchTaskDataManager:ShowReward(message)
    end
    if message.data then
      DataCenter.ActDispatchTaskDataManager:UpdateOneSingleTask(message.data, true)
    end
  end
end

return DispatchRewardMessage
