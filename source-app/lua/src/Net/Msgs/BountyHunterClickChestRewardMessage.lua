local BountyHunterClickChestRewardMessage = BaseClass("BountyHunterClickChestRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BountyHunterClickChestRewardMessage:OnCreate(activityId, chestUuid)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutUtfString("targetId", tostring(chestUuid))
end

function BountyHunterClickChestRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.activityId then
    local activityId = toInt(t.activityId)
    if t.chestReward then
      EventManager:GetInstance():Broadcast(EventId.BountyHunterPlayStashRewardAni, t.chestReward)
    end
    local actData = DataCenter.BountyHunterActDataManager:GetActData(activityId)
    if actData then
      actData:UpdateStashReward(t.stashReward)
      if actData.sceneData then
        local targetUuid = t.targetId
        local chestReward = t.chestReward
        actData.sceneData:ReceiveFreeChestFromScene(targetUuid, chestReward)
      end
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    end
  end
end

return BountyHunterClickChestRewardMessage
