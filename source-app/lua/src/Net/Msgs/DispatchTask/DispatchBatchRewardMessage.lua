local DispatchBatchRewardMessage = BaseClass("DispatchBatchRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DispatchBatchRewardMessage:OnCreate(list)
  base.OnCreate(self)
  self.sfsObj:PutLongArray("uuidList", list)
end

function DispatchBatchRewardMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTipsId(message.errorCode)
    return
  end
  if message.array then
    for _, one in ipairs(message.array) do
      if one then
        if one.reward then
          DataCenter.RewardManager:AddRewardsAndRes(one)
        end
        if one.data then
          DataCenter.ActDispatchTaskDataManager:UpdateOneSingleTask(one.data, false)
        end
        if one.endPointId then
          DataCenter.ActDispatchTaskFakeMarchManager:AddMarchIndex(one.endPointId, one.startPointId, true)
        end
      end
    end
    DataCenter.ActDispatchTaskDataManager:ShowBatchReward(message)
    EventManager:GetInstance():Broadcast(EventId.DispatchTaskUpdateSingle)
  end
end

return DispatchBatchRewardMessage
