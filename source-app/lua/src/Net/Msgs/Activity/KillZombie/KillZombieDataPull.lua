local KillZombieDataPull = BaseClass("KillZombieDataPull", SFSBaseMessage)
local base = SFSBaseMessage

function KillZombieDataPull:OnCreate()
  base.OnCreate(self)
end

function KillZombieDataPull:HandleMessage(data)
  base.HandleMessage(self, data)
  if data ~= nil then
    local mgr = DataCenter.ActivityListDataManager
    if data.user ~= nil then
      if data.user.monsters ~= nil then
        table.sort(data.user.monsters, function(a, b)
          return a.monsterLevel < b.monsterLevel
        end)
      end
      mgr:UpdateExtraData(KILL_ZOMBIE_ACTIVITY_PLAYER_INFO, data.user)
      if data.user.level == 0 or data.user.count == 0 then
        data.user.level = 1
      end
      mgr:UpdateExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_LEVEL, data.user.level or 1)
      mgr:UpdateExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_SELECT, data.user.curDifficulty or 0)
      local finish_max = data.user.maxDifficulty or 0
      mgr:UpdateExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_MAX, finish_max + 1)
      mgr:UpdateExtraData(KILL_ZOMBIE_PLAYER_LAST_DIFFICULTY, data.user.oldDifficulty or 0)
      EventManager:GetInstance():Broadcast(EventId.MonsterChallengeUpdate)
    else
      mgr:UpdateExtraData(KILL_ZOMBIE_ACTIVITY_PLAYER_INFO, nil)
    end
    if data.alliance ~= nil and data.alliance.curDifficulty == nil then
      for k, v in pairs(data.alliance) do
        if v.progress == 0 then
          v.status = -1
        end
      end
      mgr:UpdateExtraData(KILL_ZOMBIE_ACTIVITY_AL_INFO, data.alliance)
    else
      mgr:UpdateExtraData(KILL_ZOMBIE_ACTIVITY_AL_INFO, nil)
    end
    DataCenter.ActivityKillZombieManager:InitNewChallengeInfo(data.allianceNew)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

return KillZombieDataPull
