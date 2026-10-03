local AllianceBaseSkill = require("DataCenter.AllianceSkill.AllianceBaseSkill")
local base = AllianceBaseSkill
local AltarAresMissileSkill = BaseClass("AltarAresMissileSkill", base)
local Localization = CS.GameEntry.Localization
local SuperTextMesh = typeof(CS.SuperTextMesh)
local TypeParticleSystem = typeof(CS.UnityEngine.ParticleSystem)

function AltarAresMissileSkill:Init()
  self.fireTime = toInt(self.aosEndTime) - 10000
  self.playAnim = false
  self.allTime = tonumber(self.skillConfig.pre_time) * 1000
  if self.gameObject then
    local tran = self.gameObject.transform
    self.TimeRoot = tran:Find("ModelGo/CityLabel/TimeLabel")
    if self.TimeRoot then
      self.TimeRoot.gameObject:SetActive(true)
      self.TimeText = self.TimeRoot.transform:Find("TimeText"):GetComponent(SuperTextMesh)
    end
    local fireEffect = self.unityConfig:GetBaseEffectByTags("fire")
    local actionEffect = tran:Find(fireEffect.Path)
    self.actionGo = actionEffect.gameObject
    self.actionTimeLine = actionEffect:GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
    self.actionGo:SetActive(false)
    local loopEffect = self.unityConfig:GetBaseEffectByTags("loop")
    local goLoopEffect = tran:Find(loopEffect.Path)
    if goLoopEffect then
      self.goParticleSystem = goLoopEffect:GetComponentsInChildren(TypeParticleSystem)
    end
    self:SetTimeAction("updateObject", self.aosEndTime + 500, BindCallback(self, self.DoUpdateObject))
  end
  self:DoLoopEffect()
  self:OnTickSec()
end

function AltarAresMissileSkill:Clear()
  self.fireTime = nil
  self.playAnim = nil
end

function AltarAresMissileSkill:DoUpdatePoint(theWorld)
  if self.playAnim then
    return
  end
  self.fireTime = toInt(self.aosEndTime) - 10000
  self:OnTickSec()
end

function AltarAresMissileSkill:DoPlayEffect(effect)
  if effect.Tags == "fire" then
    self.playAnim = true
    if self.TimeRoot then
      self.TimeRoot.gameObject:SetActive(false)
    end
    local effectFx
    if self.actionGo then
      effectFx = base.DoPlayEffect(self, effect)
      if effect ~= nil or not IsNull(effectFx) then
        self.actionTimeLine:Play()
        DataCenter.LWSoundManager:PlaySound(40001, false)
      end
    end
    return effectFx
  else
    return base.DoPlayEffect(self, effect)
  end
end

function AltarAresMissileSkill:OnTickSec(theWorld)
  if self.playAnim then
    if self.TimeRoot then
      self.TimeRoot.gameObject:SetActive(false)
    end
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if now < self.fireTime then
    local remainTime = self.fireTime - now
    if self.TimeText then
      self.TimeText.text = Localization:GetString("2010331", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    end
  end
  self:DoLoopEffect()
end

function AltarAresMissileSkill:DoLoopEffect()
  if self.fireTime ~= nil and self.goParticleSystem and self.goParticleSystem.Length > 0 then
    local now = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.fireTime - now
    local playbackTime = (self.allTime - remainTime) / self.allTime * 2
    for i = 0, self.goParticleSystem.Length - 1 do
      local ps = self.goParticleSystem[i]
      if not IsNull(ps) then
        ps:Simulate(playbackTime, true, true)
      end
    end
  end
end

function AltarAresMissileSkill:UpdateFireTime(info)
  base.UpdateFireTime(self, info)
  self.fireTime = toInt(info.aosEndTime) - 10000
end

function AltarAresMissileSkill:NeedDisplayMode()
  return true
end

return AltarAresMissileSkill
