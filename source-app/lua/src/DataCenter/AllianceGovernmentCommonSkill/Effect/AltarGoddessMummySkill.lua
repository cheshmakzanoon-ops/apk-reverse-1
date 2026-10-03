local AllianceBaseSkill = require("DataCenter.AllianceSkill.AllianceBaseSkill")
local base = AllianceBaseSkill
local AltarGoddessMummySkill = BaseClass("AltarGoddessMummySkill", base)
local SuperTextMesh = typeof(CS.SuperTextMesh)
local TypeParticleSystem = typeof(CS.UnityEngine.ParticleSystem)
local DEAD_ANIM_LENGTH = 4

function AltarGoddessMummySkill:Init()
  self.playEndEffected = nil
  self.fireTime = toInt(self.aosEndTime) - DEAD_ANIM_LENGTH * 1000
  if self.gameObject then
    self.effectGo = self.gameObject.transform:Find("ModelGo/EffectGo")
    self.TimeRoot = self.gameObject.transform:Find("ModelGo/CityLabel/TimeLabel")
    if self.TimeRoot then
      self.TimeRoot.gameObject:SetActive(true)
      self.TimeText = self.TimeRoot.transform:Find("TimeText"):GetComponent(SuperTextMesh)
    end
  end
  self.attackInv = self.skillConfig.skill_para6 * 1000
  self:CacAttackEffectTimes()
  self:Update()
end

function AltarGoddessMummySkill:Clear()
  self.playEndEffected = nil
  if CS.SceneManager.World and self.loopVfx then
    self:ReleaseSkillEffById(self.loopVfx)
    self.loopVfx = nil
  end
  if self.startTimer then
    self.startTimer:Stop()
    self.startTimer = nil
  end
end

function AltarGoddessMummySkill:LodChange()
  if self.theLod ~= 0 and self.theLod <= 2 then
    self:DoAttackEffectProgress()
    self:PopGos()
  else
    self:ReleaseGos()
  end
end

function AltarGoddessMummySkill:OnTickSec(theWorld)
  local now = UITimeManager:GetInstance():GetServerTime()
  if now > self.fireTime then
    if self.TimeRoot then
      self.TimeRoot.gameObject:SetActive(false)
    end
    return
  end
  local nextTime = self:GetNexPlayerTime()
  if self.TimeText and nextTime then
    local remainTime = nextTime - now
    self.TimeText.text = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
  end
end

function AltarGoddessMummySkill:DoEffects()
  local now = UITimeManager:GetInstance():GetServerTime()
  if table.count(self.loopEffects) > 0 then
    for _, effect in pairs(self.loopEffects) do
      if not effect.played then
        local playSuccess = self:DoPlayEffect(effect.data)
        if playSuccess ~= nil or not IsNull(playSuccess) then
          effect.played = true
        end
      end
    end
  end
  if 0 < table.count(self.startEffects) then
    for _, effect in pairs(self.startEffects) do
      local playTime = self.aosStartTime + effect.data.StartTime * 1000
      local overTime = playTime + effect.data.OverTime * 1000
      if now < overTime then
        local canPlay = not effect.played
        canPlay = canPlay and playTime >= effect.time and now > playTime
        effect.time = now
        if canPlay then
          local playSuccess = self:DoPlayEffect(effect.data)
          if playSuccess ~= nil or not IsNull(playSuccess) then
            effect.played = true
          end
        end
      end
    end
  end
  if 0 < table.count(self.endEffects) then
    for _, effect in pairs(self.endEffects) do
      if not effect.played then
        local playTime = self.aosEndTime + effect.data.StartTime * 1000
        local canPlay = playTime >= effect.time and now > playTime
        effect.time = now
        if canPlay then
          local playSuccess = self:DoPlayEffect(effect.data)
          if playSuccess ~= nil or not IsNull(playSuccess) then
            effect.played = true
          end
        end
      end
    end
  end
end

function AltarGoddessMummySkill:DoPlayEffect(effect)
  if effect.Tags == "loop" then
    self.loopVfx = self:PlaySkillEffBySelfPoint(effect.Path, effect.Duration, self.effectGo or nil, false, false, nil, effect)
    return self.loopVfx
  elseif effect.Tags == "end" then
    if self.loopVfx then
      self:ReleaseSkillEffById(self.loopVfx)
      self.loopVfx = nil
    end
    return self:PlaySkillEffBySelfPoint(effect.Path, effect.Duration, self.effectGo or nil, true, true, nil, effect)
  elseif effect.Tags == "start" then
    if self.loopVfx then
      self:ReleaseSkillEffById(self.loopVfx)
      self.loopVfx = nil
    end
    local startFx = self:PlaySkillEffBySelfPoint(effect.Path, effect.Duration, self.effectGo or nil, true, false, nil, effect)
    if self.startTimer then
      self.startTimer:Stop()
      self.startTimer = nil
    end
    self.startTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:DoPlayEffect(self.unityConfig:GetBaseEffectByTags("loop"))
      if self.goParticleSystem then
        for i = 0, self.goParticleSystem.Length - 1 do
          local ps = self.goParticleSystem[i]
          ps.gameObject:SetActive(true)
        end
      end
    end, 2.8)
    return startFx
  else
    return base.DoPlayEffect(self, effect)
  end
end

function AltarGoddessMummySkill:GetNexPlayerTime()
  local now = UITimeManager:GetInstance():GetServerTime()
  for _, time in ipairs(self.attackTimes) do
    if time > now then
      return time
    end
  end
end

function AltarGoddessMummySkill:UpdateFireTime(info)
  base.UpdateFireTime(self, info)
  self.fireTime = toInt(self.aosEndTime) - DEAD_ANIM_LENGTH * 1000
end

function AltarGoddessMummySkill:CacAttackEffectTimes()
  self.attackTimes = {}
  local now = UITimeManager:GetInstance():GetServerTime()
  local duration = now - self.aosStartTime
  local attackCount = duration / self.attackInv
  local nextAttackTime = math.ceil(attackCount) * self.attackInv
  local nextToPlayAttack = self.aosStartTime + nextAttackTime
  while nextToPlayAttack <= self.aosEndTime + 1000 do
    table.insert(self.attackTimes, nextToPlayAttack)
    nextToPlayAttack = nextToPlayAttack + self.attackInv
  end
  if table.count(self.attackTimes) > 0 then
    for index, v in ipairs(self.attackTimes) do
      self:SetTimeAction("attack" .. index, v, BindCallback(self, self.PlayerAttackEffect))
    end
  end
  if now < self.aosEndTime - 4000 then
    self:PlayerAttackEffect()
  end
end

function AltarGoddessMummySkill:PlayerAttackEffect()
  local chargeEffect = self.unityConfig:GetBaseEffectByTags("charge")
  if self.attackVfx ~= nil then
    self:ReleaseSkillEffById(self.attackVfx)
    self.attackVfx = nil
  end
  self.attackVfx = self:PlaySkillEffBySelfPoint(chargeEffect.Path, self.attackInv / 1000, self.effectGo or nil, true, true, function(go)
    self.goParticleSystem = go:GetComponentsInChildren(TypeParticleSystem)
    self:DoAttackEffectProgress()
  end, chargeEffect)
end

function AltarGoddessMummySkill:DoAttackEffectProgress()
  local nextAttack = self:GetNexPlayerTime()
  if nextAttack ~= nil and not IsNull(self.goParticleSystem) and self.goParticleSystem.Length > 0 then
    local now = UITimeManager:GetInstance():GetServerTime()
    local hasEndTime = nextAttack - now
    local startAttackTime = self.attackInv - hasEndTime
    local progress = startAttackTime / self.attackInv
    local chargeEffect = self.unityConfig:GetBaseEffectByTags("charge")
    local playbackTime = progress * chargeEffect.Duration
    for i = 0, self.goParticleSystem.Length - 1 do
      local ps = self.goParticleSystem[i]
      if not IsNull(ps) then
        ps:Simulate(playbackTime, true, true)
        ps:Play()
      end
    end
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.fireTime and now < self.fireTime and now - self.aosStartTime <= 1200 and self.goParticleSystem then
    for i = 0, self.goParticleSystem.Length - 1 do
      local ps = self.goParticleSystem[i]
      ps.gameObject:SetActive(false)
    end
  end
end

function AltarGoddessMummySkill:NeedDisplayMode()
  return true
end

return AltarGoddessMummySkill
