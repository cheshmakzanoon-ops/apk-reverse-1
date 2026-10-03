local DomintorStageManager = BaseClass("DomintorStageManager")

local function __init(self)
  self:UpdateHangUpMaxTime()
end

local function __delete(self)
end

local function UpdateHangUpMaxTime(self)
  local effect = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_STAGE_ADDTIME) * 1000
  if effect == nil or effect < 0 then
    effect = 0
  end
  self.hangUpMaxTime = LuaEntry.DataConfig:TryGetNum("dominator_idle_reward", "k2") * 1000 + effect
end

local function UpdateHangUpReward(self, lastIdleRewardTimeStamp, idleRewardDominatorUpId, idleReward)
  self.lastIdleRewardTimeStamp = lastIdleRewardTimeStamp
  if idleRewardDominatorUpId then
    local cfg = DataCenter.DominatorUpTemplateManager:GetDominatorUpUnlockTemplate(idleRewardDominatorUpId)
    if cfg then
      self.idleRewardStageId = cfg.idle_reward_stageid
    else
      self.idleRewardStageId = nil
    end
  else
    self.idleRewardStageId = nil
  end
  self.idleReward = idleReward
end

local function IsShow(self)
  if self.unlockSeasonData == nil then
    local cfg = LuaEntry.DataConfig:TryGetStr("dominator_idle_reward", "k4")
    self.unlockSeasonData = {}
    local split = string.split(cfg, "|")
    self.unlockSeasonData.season = tonumber(split[1])
    self.unlockSeasonData.day = tonumber(split[2])
  end
  local unlock = DataCenter.SeasonDataManager:CheckNowSeasonArrive(self.unlockSeasonData.season, self.unlockSeasonData.day)
  return unlock
end

local function IsUnlock(self)
  return DataCenter.RadarCenterDataManager.dominatorTowerOpen == 1
end

local function GetUnlockOrder(self)
  local order = LuaEntry.DataConfig:TryGetNum("dominator_idle_reward", "k5", 0)
  return order
end

DomintorStageManager.__init = __init
DomintorStageManager.__delete = __delete
DomintorStageManager.UpdateHangUpReward = UpdateHangUpReward
DomintorStageManager.UpdateHangUpMaxTime = UpdateHangUpMaxTime
DomintorStageManager.IsShow = IsShow
DomintorStageManager.IsUnlock = IsUnlock
DomintorStageManager.GetUnlockOrder = GetUnlockOrder
return DomintorStageManager
