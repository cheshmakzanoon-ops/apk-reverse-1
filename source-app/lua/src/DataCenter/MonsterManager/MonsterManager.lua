local MonsterManager = BaseClass("MonsterManager")

local function __init(self)
  self.find_monster_max_level = 0
  self.kill_boss_max_num = 0
  self.daily_kill_boss = 0
  self.lastTime = 0
  self.whistleRewardNum = 0
end

local function __delete(self)
  self.find_monster_max_level = nil
  self.kill_boss_max_num = nil
  self.daily_kill_boss = nil
  self.lastTime = nil
  self.whistleRewardNum = nil
end

local function InitData(self, message)
  self.find_monster_max_level = message.find_monster_max_level
  self.kill_boss_max_num = LuaEntry.DataConfig:TryGetNum("assembly_monster_toplimit", "k1")
  self:UpdateKillBossNum(message)
  self:HandleWhistleBoxReward(message)
end

local function UpdateKillBossNum(self, message)
  if message.daily_kill_boss then
    self.daily_kill_boss = message.daily_kill_boss
    self.lastTime = UITimeManager:GetInstance():GetServerSeconds()
  end
end

local function GetCurCanAttackMaxLevel(self)
  local hasAttackMaxLevel = LuaEntry.Player.pveLevel
  local result = hasAttackMaxLevel + 1
  local configOpenState = LuaEntry.DataConfig:CheckSwitch("detect_monster")
  if configOpenState then
    local k6 = LuaEntry.DataConfig:TryGetNum("search_monster", "k6")
    result = DataCenter.BuildManager.MainLv + k6
  end
  local max = DataCenter.MonsterTemplateManager:GetMonsterMaxLevel()
  if result > max then
    result = max
  end
  if result <= 0 then
    result = 1
  end
  return result
end

local function GetCanFindMonsterMaxLevel(self)
  return self.find_monster_max_level
end

local function GetCurCanAttackBossMaxLevel(self)
  local result = DataCenter.BuildManager.MainLv
  if result < 10 then
    return 1
  elseif result < 100 then
    return Mathf.Floor(result / 10)
  elseif result < 1000 then
    return Mathf.Floor(result / 100)
  end
end

local function GetRestKillBossNum(self)
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if not UITimeManager:GetInstance():IsSameDayForServer(self.lastTime, curTime) then
    self.daily_kill_boss = 0
  end
  local killAddNum = LuaEntry.Effect:GetGameEffect(EffectDefine.AUTO_RALLY_REWARD_NUM_ADD)
  local restNum = self.kill_boss_max_num - self.daily_kill_boss + killAddNum
  return math.max(restNum, 0)
end

local function GetKillBossNum(self)
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if self.lastTime ~= nil and not UITimeManager:GetInstance():IsSameDayForServer(self.lastTime, curTime) then
    self.daily_kill_boss = 0
  end
  return self.daily_kill_boss
end

local function GetMaxKillBossNum(self)
  local killAddNum = LuaEntry.Effect:GetGameEffect(EffectDefine.AUTO_RALLY_REWARD_NUM_ADD)
  if self.kill_boss_max_num then
    return self.kill_boss_max_num + killAddNum
  else
    return killAddNum
  end
end

function MonsterManager:GetWhistleRewardNum()
  return self.whistleRewardNum
end

function MonsterManager:ClaimWhistleBoxReward()
  if self.whistleRewardNum and self.whistleRewardNum > 0 then
    SFSNetwork.SendMessage(MsgDefines.ClaimWhistleBoxReward)
  end
end

function MonsterManager:HandleWhistleBoxReward(msg)
  if msg.whistle_reward then
    self.whistleRewardNum = msg.whistle_reward
    EventManager:GetInstance():Broadcast(EventId.WhistleBoxNumRefresh)
  end
end

MonsterManager.__init = __init
MonsterManager.__delete = __delete
MonsterManager.GetCurCanAttackMaxLevel = GetCurCanAttackMaxLevel
MonsterManager.GetCanFindMonsterMaxLevel = GetCanFindMonsterMaxLevel
MonsterManager.InitData = InitData
MonsterManager.UpdateKillBossNum = UpdateKillBossNum
MonsterManager.GetRestKillBossNum = GetRestKillBossNum
MonsterManager.GetKillBossNum = GetKillBossNum
MonsterManager.GetMaxKillBossNum = GetMaxKillBossNum
MonsterManager.GetCurCanAttackBossMaxLevel = GetCurCanAttackBossMaxLevel
return MonsterManager
