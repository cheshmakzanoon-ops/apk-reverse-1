local base = require("Scene.LWBattle.UnitBase")
local ParkourUnit = BaseClass("ParkourUnit", base)
local UnitViewFacade = CS.PVEBattleLogic.Unit.UnitViewFacade
local ApplyRimMPB = CS.AppearenceUtils.ApplyRimMPB
local AppearenceUtils = CS.AppearenceUtils

function ParkourUnit:CanChangePosition()
  if self.playingPosTimeline then
    return false
  end
  return true
end

function ParkourUnit:HitWhite()
  if self.unitType ~= UnitType.Member then
    if self.viewHandle then
      UnitViewFacade.MPBFlashRed(self.viewHandle)
      return
    elseif self.logic.GetHitWhiteMPB then
      local mpb = self.logic:GetHitWhiteMPB()
      for _, v in pairs(self.renders) do
        AppearenceUtils.HitWhiteV2(v.renderer, true, true)
      end
      return
    end
  end
  base.HitWhite(self)
end

function ParkourUnit:HitWhiteReset()
  if self.unitType ~= UnitType.Member then
    if self.viewHandle then
      UnitViewFacade.MPBResetFlashRed(self.viewHandle)
      return
    elseif self.logic.GetHitWhiteMPB then
      for _, v in pairs(self.renders) do
        AppearenceUtils.HitWhiteV2(v.renderer, false, true)
      end
      return
    end
  end
  base.HitWhiteReset(self)
end

function ParkourUnit:DieGray()
  if self.unitType == UnitType.Zombie then
    if self.viewHandle then
      UnitViewFacade.MPBFlashGray(self.viewHandle)
      return
    elseif self.logic.GetDieGrayMPB then
      local mpb = self.logic:GetDieGrayMPB()
      for _, v in pairs(self.renders) do
        AppearenceUtils.GrayEffect(v.renderer, true)
      end
      return
    end
  end
  base.DieGray(self)
end

function ParkourUnit:DestroyView()
  if self.unitType ~= UnitType.Member and not self.viewHandle then
    for _, v in pairs(self.renders) do
      AppearenceUtils.HitWhiteV2(v.renderer, false, true)
      AppearenceUtils.GrayEffect(v.renderer, false)
    end
  end
  base.DestroyView(self)
end

function ParkourUnit:DestroyData()
  self.attackProperty = nil
  self.AddDamagePhysicsProperty = nil
  self.AddDamageMagicProperty = nil
  self.CriticalRateProperty = nil
  self.CriticalDamageProperty = nil
  self.defenceProperty = nil
  self.reduceDamagePhysicsProperty = nil
  self.reduceDamageMagicProperty = nil
  self.equipDamageReduceRatePhysicsProperty = nil
  self.equipDamageReduceRateMagicProperty = nil
  self.ChanceToHitProperty = nil
  self.critProperty = nil
  self.attackBuffDirty = nil
  self.defenceBuffDirty = nil
  self.chanceToHitDirty = nil
  self.critDirty = nil
  base.DestroyData(self)
end

function ParkourUnit:GetCritProperty()
  if self.critProperty == nil then
    self.critProperty = self:GetProperty(HeroEffectDefine.CriticalRate_Result)
    self.critDirty = nil
  elseif self.critDirty then
    self.critProperty = self:GetProperty(HeroEffectDefine.CriticalRate_Result)
    self.critDirty = nil
  end
  return self.critProperty
end

function ParkourUnit:GetAttackAndAddDamageBase()
  if self.attackProperty == nil then
    self.attackProperty, self.AddDamagePhysicsProperty, self.AddDamageMagicProperty, self.CriticalRateProperty, self.CriticalDamageProperty = PveUtil.CalculateAttackAndAddDamage(self)
    self.attackBuffDirty = nil
  elseif self.attackBuffDirty then
    self.attackProperty, self.AddDamagePhysicsProperty, self.AddDamageMagicProperty, self.CriticalRateProperty, self.CriticalDamageProperty = PveUtil.CalculateAttackAndAddDamage(self)
    self.attackBuffDirty = nil
  end
  return self.attackProperty, self.AddDamagePhysicsProperty, self.AddDamageMagicProperty, self.CriticalRateProperty, self.CriticalDamageProperty
end

function ParkourUnit:GetDefenceAndReduceDamageBase()
  if self.defenceProperty == nil then
    self.defenceProperty, self.reduceDamagePhysicsProperty, self.reduceDamageMagicProperty, self.equipDamageReduceRatePhysicsProperty, self.equipDamageReduceRateMagicProperty = PveUtil.CalculateDefenceAndReduceDamage(self)
    self.defenceBuffDirty = nil
  elseif self.defenceBuffDirty then
    self.defenceProperty, self.reduceDamagePhysicsProperty, self.reduceDamageMagicProperty, self.equipDamageReduceRatePhysicsProperty, self.equipDamageReduceRateMagicProperty = PveUtil.CalculateDefenceAndReduceDamage(self)
    self.defenceBuffDirty = nil
  end
  return self.defenceProperty, self.reduceDamagePhysicsProperty, self.reduceDamageMagicProperty, self.equipDamageReduceRatePhysicsProperty, self.equipDamageReduceRateMagicProperty
end

function ParkourUnit:GetChanceToHit()
  ProfilerUtil.BeginSample("GetChanceToHit")
  if self.ChanceToHitProperty == nil then
    self.ChanceToHitProperty = self:GetProperty(HeroEffectDefine.ChanceToHit_Result)
    self.chanceToHitDirty = nil
  elseif self.chanceToHitDirty then
    self.ChanceToHitProperty = self:GetProperty(HeroEffectDefine.ChanceToHit_Result)
    self.chanceToHitDirty = nil
  end
  ProfilerUtil.EndSample()
  return self.ChanceToHitProperty
end

function ParkourUnit:AfterCreateUnitViewList(viewHandle, viewLoaded)
end

function ParkourUnit:AfterCreateHpBarList(viewHandle)
end

return ParkourUnit
