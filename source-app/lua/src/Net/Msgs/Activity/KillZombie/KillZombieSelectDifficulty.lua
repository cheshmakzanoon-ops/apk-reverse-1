local KillZombieSelectDifficulty = BaseClass("KillZombieSelectDifficulty", SFSBaseMessage)
local base = SFSBaseMessage

function KillZombieSelectDifficulty:OnCreate(select_index)
  base.OnCreate(self)
  self.sfsObj:PutInt("difficulty", select_index)
end

function KillZombieSelectDifficulty:HandleMessage(data)
  base.HandleMessage(self, data)
  if data ~= nil then
    local errorCode = data.errorCode
    if errorCode then
      UIUtil.ShowTipsId(errorCode)
      return
    end
    local difficulty = tonumber(data.difficulty)
    local mgr = DataCenter.ActivityListDataManager
    mgr:UpdateExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_SELECT, difficulty)
    CS.GameEntry.Setting:SetBool("KillZombieActiveDifficulty_" .. LuaEntry.Player.uid, true)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    EventManager:GetInstance():Broadcast(EventId.MonsterChallengeUpdate)
  end
end

return KillZombieSelectDifficulty
