local IdleGameEventReceiveMessage = BaseClass("IdleGameEventReceiveMessage", SFSBaseMessage)
local base = SFSBaseMessage

function IdleGameEventReceiveMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", param.eventUuid)
end

function IdleGameEventReceiveMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIIdleGameTaskEventDetail)
    local reward = t.reward
    if reward then
      DataCenter.RewardManager:ShowCommonReward(t)
      DataCenter.RewardManager:AddRewardsAndRes(t)
    end
    local eventUuid = t.uuid
    if eventUuid then
      DataCenter.T11IdleGameDataManager:RemoveEventData({uuid = eventUuid})
      EventManager:GetInstance():Broadcast(EventId.T11IdleGameTaskEventListRefresh)
    end
  end
end

return IdleGameEventReceiveMessage
