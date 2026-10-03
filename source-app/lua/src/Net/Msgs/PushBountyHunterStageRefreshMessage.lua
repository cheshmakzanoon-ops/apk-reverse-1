local PushBountyHunterStageRefreshMessage = BaseClass("PushBountyHunterStageRefreshMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushBountyHunterStageRefreshMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushBountyHunterStageRefreshMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.activityId then
    local activityId = toInt(t.activityId)
    local actData = DataCenter.BountyHunterActDataManager:GetActData(activityId)
    if actData then
      if t.isRefreshByPlayer and t.refreshCount then
        local refreshCount = toInt(t.refreshCount)
        actData:UpdateRefreshData(refreshCount)
      end
      if actData.sceneData then
        local isClearMonsterData = true
        actData.sceneData:UpdateStageData(t, isClearMonsterData)
      end
      if t.showReward then
        local chestRewardList = t.showReward.chestReward
        if chestRewardList then
          for _, v in ipairs(chestRewardList) do
            local targetUuid = v.targetId
            local chestReward = v.showReward
            actData.sceneData:ReceiveFreeChestFromScene(targetUuid, chestReward)
          end
        end
      end
      local isRefreshByPlayer = t.isRefreshByPlayer or false
      local refreshData = {}
      refreshData.activityId = activityId
      refreshData.isRefreshByPlayer = isRefreshByPlayer
      refreshData.nextStageTemp = actData.sceneData.stageTmpData
      if isRefreshByPlayer then
        local params = {}
        params.actionType = BountyHunterAniActionType.ConfuseMonster
        params.triggerType = BountyHunterActionTriggerType.PushQueue
        params.data = refreshData
        EventManager:GetInstance():Broadcast(EventId.BountyHunterAddAniActionToQueue, params)
      end
      local params = {}
      params.actionType = BountyHunterAniActionType.RefreshScene
      params.triggerType = BountyHunterActionTriggerType.PushQueue
      params.data = refreshData
      EventManager:GetInstance():Broadcast(EventId.BountyHunterAddAniActionToQueue, params)
    end
  end
end

return PushBountyHunterStageRefreshMessage
