local PushActBossAttackDamageMessage = BaseClass("PushActBossAttackDamageMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushActBossAttackDamageMessage:OnCreate()
  base.OnCreate(self)
end

function PushActBossAttackDamageMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.maxDamage ~= nil and t.activityId ~= nil then
    local actData = DataCenter.ActivityListDataManager:GetActivityDataById(t.activityId)
    if actData ~= nil then
      if actData.type == EnumActivity.WorldBoss.Type then
        DataCenter.ActBossDataManager.maxDamage = t.maxDamage
        EventManager:GetInstance():Broadcast(EventId.OnActBossRankRefresh)
      end
      if actData.type == EnumActivity.BossLogin.Type then
        DataCenter.LWSeasonBossLoginDataManager.maxDamage = t.maxDamage
        EventManager:GetInstance():Broadcast(EventId.OnActBossRankRefresh)
      end
    end
  end
end

return PushActBossAttackDamageMessage
