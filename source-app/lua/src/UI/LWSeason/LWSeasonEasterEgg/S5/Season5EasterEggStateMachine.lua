local CSVibrator = CS.Vibrator
local Season5EasterEggStateMachine = BaseClass("Season5EasterEggStateMachine")

function Season5EasterEggStateMachine:__init()
end

function Season5EasterEggStateMachine:__delete()
end

function Season5EasterEggStateMachine:Init(compAnimChicken, compAnimEgg, chickenVfxProxy, eggVfxProxy)
  self.StateConst = {
    Idle = "idle",
    Angry = "angry",
    Spawn = "spawn",
    Reward = "toIdle",
    Break = "break",
    Tips = "tips",
    None = "none"
  }
  self.StateTime = {
    [self.StateConst.Idle] = -1,
    [self.StateConst.Angry] = 5333,
    [self.StateConst.Spawn] = 5333,
    [self.StateConst.Reward] = 333,
    [self.StateConst.Break] = 1333,
    [self.StateConst.None] = -1
  }
  self.StateAnimChicken = {
    [self.StateConst.Idle] = "Default",
    [self.StateConst.Angry] = "angry",
    [self.StateConst.Spawn] = "born",
    [self.StateConst.Reward] = "toIdle",
    [self.StateConst.Break] = "break",
    [self.StateConst.None] = "Default"
  }
  self.StateAnimEgg = {
    [self.StateConst.Idle] = "Default",
    [self.StateConst.Angry] = "Default",
    [self.StateConst.Spawn] = "born",
    [self.StateConst.Reward] = "Default",
    [self.StateConst.Break] = "Default",
    [self.StateConst.None] = "Default"
  }
  self.StateSound = {
    [self.StateConst.Idle] = 0,
    [self.StateConst.Angry] = 5100025,
    [self.StateConst.Spawn] = 5100022,
    [self.StateConst.Reward] = 0,
    [self.StateConst.Break] = 5100023,
    [self.StateConst.None] = 0
  }
  self.Param = {}
  self.ParamConst = {
    ClickIdle = "ClickIdle",
    ClickSpawn = "ClickSpawn",
    Claimed = "Claimed"
  }
  self.compAnimChicken = compAnimChicken
  self.compAnimEgg = compAnimEgg
  self.chickenVfxProxy = chickenVfxProxy
  self.eggVfxProxy = eggVfxProxy
  self.TimingStart = 3500
  self.TimingEnd = 4833
  self.TipsCd = DataCenter.SeasonEasterEggManager:GetTipCd()
  self.TipsTimer = nil
  self.TransTime = 0
  self.StateTimer = nil
  self.StateTransition = {}
  self:InitStates()
  self.CurrentState = self.StateConst.None
end

function Season5EasterEggStateMachine:InitStates()
  self:AddStateTransition(self.StateConst.None, self.StateConst.Idle, function()
    return self:ConditionAlwaysTrue()
  end, nil)
  self:AddStateTransition(self.StateConst.Idle, self.StateConst.Angry, function()
    return self:ConditionIdleToAngry()
  end, function()
    return self:OnIdleToAngryEnter()
  end)
  self:AddStateTransition(self.StateConst.Idle, self.StateConst.Spawn, function()
    return self:ConditionIdleToSpawn()
  end, function()
    return self:OnIdleToSpawnEnter()
  end)
  self:AddStateTransition(self.StateConst.Angry, self.StateConst.Idle, function()
    return self:ConditionAlwaysTrue()
  end, nil)
  self:AddStateTransition(self.StateConst.Spawn, self.StateConst.Reward, function()
    return self:ConditionSpawnToReward()
  end, nil)
  self:AddStateTransition(self.StateConst.Spawn, self.StateConst.Break, function()
    return self:ConditionSpawnToBreak()
  end, nil)
  self:AddStateTransition(self.StateConst.Reward, self.StateConst.Idle, function()
    return self:ConditionAlwaysTrue()
  end, nil)
  self:AddStateTransition(self.StateConst.Break, self.StateConst.Idle, function()
    return self:ConditionAlwaysTrue()
  end, nil)
end

function Season5EasterEggStateMachine:AddStateTransition(fromState, toState, transCondition, onEnter)
  if self.StateTransition[fromState] == nil then
    self.StateTransition[fromState] = {}
  end
  table.insert(self.StateTransition[fromState], {
    ToState = toState,
    TransCondition = transCondition,
    OnEnter = onEnter
  })
end

function Season5EasterEggStateMachine:SetParam(key, value)
  if key ~= nil then
    self.Param[key] = value
  end
end

function Season5EasterEggStateMachine:GetParam(key, default)
  if key ~= nil then
    return self.Param[key] or default
  end
  return default
end

function Season5EasterEggStateMachine:CheckParam(key, value)
  if key ~= nil then
    return self.Param[key] == value
  end
  return false
end

function Season5EasterEggStateMachine:ClearParam()
  self.Param = {}
end

function Season5EasterEggStateMachine:TryTrans()
  local states = self.StateTransition[self.CurrentState]
  if states == nil then
    return
  end
  for _, state in pairs(states) do
    if state:TransCondition() then
      self:TransTo(state)
      return
    end
  end
end

function Season5EasterEggStateMachine:TransTo(state)
  Logger.Log("\227\128\144\229\176\143\233\184\161\227\128\145 \229\136\135\230\141\162\231\138\182\230\128\129 " .. self.CurrentState .. " -> " .. state.ToState)
  if self.StateTimer ~= nil then
    self.StateTimer:Stop()
    self.StateTimer = nil
  end
  self.CurrentState = state.ToState
  self.TransTime = UITimeManager:GetInstance():GetServerTime()
  if state.OnEnter ~= nil then
    state:OnEnter()
  end
  self:HandleTipsVfx(self.CurrentState)
  local animNameChicken = self.StateAnimChicken[self.CurrentState]
  if animNameChicken ~= nil and self.compAnimChicken ~= nil then
    self.compAnimChicken:Play(animNameChicken)
  end
  if self.chickenVfxProxy ~= nil then
    self.chickenVfxProxy(self.CurrentState)
  end
  local animNameEgg = self.StateAnimEgg[self.CurrentState]
  if animNameEgg ~= nil and self.compAnimEgg ~= nil then
    self.compAnimEgg:Play(animNameEgg)
  end
  if self.eggVfxProxy ~= nil then
    self.eggVfxProxy(self.CurrentState)
  end
  local soundId = self.StateSound[self.CurrentState]
  if 0 < soundId then
    DataCenter.LWSoundManager:PlaySound(soundId)
  end
  self:ClearParam()
  local delay = self.StateTime[self.CurrentState]
  if 0 < delay then
    self.StateTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:TryTrans()
    end, delay / 1000)
  end
end

function Season5EasterEggStateMachine:PlayEggIdle()
  Logger.Log("\227\128\144\229\176\143\233\184\161\227\128\145 \232\155\139\229\133\136 idle")
  if self.compAnimEgg ~= nil then
    self.compAnimEgg:Play(self.StateAnimEgg[self.StateConst.Idle])
  end
end

function Season5EasterEggStateMachine:ConditionIdleToAngry()
  return not DataCenter.SeasonEasterEggManager:HasTimeToday()
end

function Season5EasterEggStateMachine:OnIdleToAngryEnter()
  UIUtil.ShowTipsId("click_chicken_tips")
end

function Season5EasterEggStateMachine:ConditionIdleToSpawn()
  return DataCenter.SeasonEasterEggManager:HasTimeToday()
end

function Season5EasterEggStateMachine:OnIdleToSpawnEnter()
  self:Shock()
end

function Season5EasterEggStateMachine:ConditionSpawnToReward()
  local claimed = self:CheckParam(self.ParamConst.Claimed, 1)
  return claimed or self:CheckClaimValid()
end

function Season5EasterEggStateMachine:ConditionSpawnToBreak()
  local claimed = self:CheckParam(self.ParamConst.Claimed, 1)
  return not claimed and not self:CheckClaimValid()
end

function Season5EasterEggStateMachine:ConditionAlwaysTrue()
  return true
end

function Season5EasterEggStateMachine:HandleTipsVfx(toState)
  local hasTime = DataCenter.SeasonEasterEggManager:HasTimeToday()
  if hasTime and toState == self.StateConst.Idle then
    Logger.Log("\227\128\144\229\176\143\233\184\161\227\128\145 \230\183\187\229\138\160 Tips Timer")
    
    local function showTips()
      Logger.Log("\227\128\144\229\176\143\233\184\161\227\128\145 \230\152\190\231\164\186 Tips")
      if self.chickenVfxProxy ~= nil then
        self.chickenVfxProxy(self.StateConst.Tips)
      end
    end
    
    local delayTime = self.TipsCd
    self.TipsTimer = TimerManager:GetInstance():GetTimer(delayTime, showTips, self, false, false, false)
    self.TipsTimer:Start()
  else
    Logger.Log("\227\128\144\229\176\143\233\184\161\227\128\145 \231\167\187\233\153\164 Tips Timer")
    if self.TipsTimer ~= nil then
      self.TipsTimer:Stop()
      self.TipsTimer = nil
    end
  end
end

function Season5EasterEggStateMachine:IsIdle()
  return self.CurrentState == self.StateConst.Idle
end

function Season5EasterEggStateMachine:IsSpawn()
  return self.CurrentState == self.StateConst.Spawn
end

function Season5EasterEggStateMachine:CheckClaimValid()
  local clickTime = self:GetParam(self.ParamConst.ClickSpawn, 0)
  if 0 < clickTime then
    local duration = clickTime - self.TransTime
    local timingValid = duration >= self.TimingStart and duration <= self.TimingEnd
    return timingValid
  end
  return false
end

function Season5EasterEggStateMachine:Shock()
  if not DataCenter.SeasonEasterEggManager:IsShockFuncOpen() then
    return
  end
  if CSVibrator and CSVibrator.HapticsSupported() then
    if CS.SDKManager.IS_UNITY_ANDROID() then
      CSVibrator.Warning()
    elseif CS.SDKManager.IS_UNITY_IOS() then
      CSVibrator.Failure()
    end
  end
end

function Season5EasterEggStateMachine:Clear()
  Logger.Log("\227\128\144\229\176\143\233\184\161\227\128\145 \230\184\133\233\153\164\231\138\182\230\128\129\230\156\186")
  self.Param = {}
  self.StateTransition = {}
  if self.StateTimer ~= nil then
    self.StateTimer:Stop()
    self.StateTimer = nil
  end
  if self.TipsTimer ~= nil then
    self.TipsTimer:Stop()
    self.TipsTimer = nil
  end
end

return Season5EasterEggStateMachine
