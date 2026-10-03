local PushLockhartKillBossNumberMessage = BaseClass("PushLockhartKillBossNumberMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushLockhartKillBossNumberMessage:OnCreate()
  base.OnCreate(self)
end

function PushLockhartKillBossNumberMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t[KILL_LOCK_HART_BOSS] ~= nil then
      DataCenter.ActivityListDataManager:UpdateExtraData(KILL_LOCK_HART_BOSS, t[KILL_LOCK_HART_BOSS])
    end
    if t[KILL_LOCK_HART_BOSS_LEADER] ~= nil then
      DataCenter.ActivityListDataManager:UpdateExtraData(KILL_LOCK_HART_BOSS_LEADER, t[KILL_LOCK_HART_BOSS_LEADER])
    end
  end
end

return PushLockhartKillBossNumberMessage
