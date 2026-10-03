local RunningBossDataManager = BaseClass("RunningBossDataManager")

function RunningBossDataManager:__init()
  self.todaySkill = false
  self.needCount = LuaEntry.DataConfig:TryGetNum("running_monster", "k7")
  self.todayCount = 0
  self.mummyTodayCount = 0
  self.mummyNeedCount = 1
  self.mummyTodaySkill = false
  self.monsterCreateCache = {}
end

function RunningBossDataManager:__delete()
end

function RunningBossDataManager:ReqTodaySkill()
  SFSNetwork.SendMessage(MsgDefines.RunningBossDayKill)
end

function RunningBossDataManager:SetTodaySkill(count)
  self.todayCount = count
  self.needCount = DataCenter.LWDoomsdayManager:IsOpen() and LuaEntry.DataConfig:TryGetNum("doomsday_activity", "k10") or LuaEntry.DataConfig:TryGetNum("running_monster", "k7")
  self.todaySkill = count >= self.needCount
  EventManager:GetInstance():Broadcast(EventId.RunningBossTodaySkillChange)
end

function RunningBossDataManager:SetMummyTodaySkill(count)
  self.mummyTodayCount = count
  self.mummyTodaySkill = count >= self.mummyNeedCount
  EventManager:GetInstance():Broadcast(EventId.RunningBossTodaySkillChange)
end

function RunningBossDataManager:OnMarkMonsterTroopCreate(uuid)
  self.monsterCreateCache[uuid] = true
end

function RunningBossDataManager:GetMonsterTroopCreate(uuid)
  if self.monsterCreateCache[uuid] then
    self.monsterCreateCache[uuid] = nil
    return true
  end
  self.monsterCreateCache[uuid] = nil
  return false
end

function RunningBossDataManager:OnRemoveMonsterTroopCreate(uuid)
  self.monsterCreateCache[uuid] = nil
end

return RunningBossDataManager
