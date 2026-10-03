local PushBountyHunterMonsterAttackMessage = BaseClass("PushBountyHunterMonsterAttackMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushBountyHunterMonsterAttackMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushBountyHunterMonsterAttackMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.activityId then
    local activityId = toInt(t.activityId)
    local actData = DataCenter.BountyHunterActDataManager:GetActData(activityId)
    if actData then
      actData:UpdateStashReward(t.stashReward)
      if t.score then
        actData:UpdateScore(t.score)
      end
      if actData.sceneData then
        local dropReward = t.monsterReward
        local attackReward = t.attackReward
        actData.sceneData:UpdateMonsterDataAfterNormalHit(t.monsterChange, dropReward, attackReward)
      end
      actData:UpdateTodayConsume(t)
      actData:UpdateTotalConsume(t)
      actData:UpdateNextBossCount(t)
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    end
  end
end

return PushBountyHunterMonsterAttackMessage
