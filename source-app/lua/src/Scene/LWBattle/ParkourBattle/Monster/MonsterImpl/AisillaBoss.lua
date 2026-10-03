local base = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.CommonAIMonster")
local AisillaBoss = BaseClass("AisillaBoss", base)
local BornState = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.FSM.AisillaBoss.AisillaBossBornState")
local IdleState = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.FSM.AisillaBoss.AisillaBossIdleState")
local DiveState = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.FSM.AisillaBoss.AisillaBossDiveState")
local DieState = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.FSM.AisillaBoss.AisillaBossDieState")
local FSM = require("Framework.Common.FSMWithPool")
local pveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local UnitViewFacade = CS.PVEBattleLogic.Unit.UnitViewFacade

function AisillaBoss:Init(logic, mgr, guid, x, y, monsterMeta)
  base.Init(self, logic, mgr, guid, x, y, monsterMeta)
  self.eulerY = 180
  self.realY = -8
end

function AisillaBoss:Load()
  self.viewLoaded = false
  self.viewHandle = VIEW_INVALID_HANDLE
  local scale = ResetScale.x
  if self.meta.model_size then
    scale = self.meta.model_size
  end
  self.viewHandle, self.viewLoaded = pveUnitViewUtil.CreateUnitView(self.guid, self.monsterMeta.asset, nil, scale, self.x, self.realY, self.y, ResetPosition.x, self.eulerY, ResetPosition.z, self.layer)
  if self.viewLoaded then
    self:OnViewLoaded(true)
  end
end

function AisillaBoss:OnLoadComplete()
  self:InitFsm()
  self.hasExtFirePath = false
  local fire_paths = self.monsterMeta.fire_paths
  if fire_paths then
    local firePathCount = #fire_paths
    if 0 < firePathCount then
      local append = UnitViewFacade.InitFirePoints(self.viewHandle, self.monsterMeta.id, firePathCount)
      if append then
        for i = 1, firePathCount do
          UnitViewFacade.AppendFirePoint(self.viewHandle, fire_paths[i])
        end
      end
      self.hasExtFirePath = true
    end
  end
  self:InitSkills()
  self:SetInvincible(true)
  self.skillManager:PassiveCast(SkillTriggerType.BeHitNew)
end

function AisillaBoss:InitFsm()
  self.fsm = ObjectPool:GetInstance():Load(FSM)
  self.fsm:Init(self)
  local bornState = ObjectPool:GetInstance():Load(BornState)
  bornState:Init(self)
  self.fsm:AddState(ZombieState.Born, bornState)
  local idleState = ObjectPool:GetInstance():Load(IdleState)
  idleState:Init(self)
  self.fsm:AddState(ZombieState.Idle, idleState)
  local dieState = ObjectPool:GetInstance():Load(DieState)
  dieState:Init(self)
  self.fsm:AddState(ZombieState.Die, dieState)
  local diveState = ObjectPool:GetInstance():Load(DiveState)
  diveState:Init(self)
  self.fsm:AddState(ZombieState.Dive, diveState)
  self.fsm:ChangeState(ZombieState.Born)
end

function AisillaBoss:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, dir, hitEff)
  if self.invincible then
    return
  end
  base.BeAttack(self, hurt, hitPoint, hitDir, whiteTime, stiffTime, dir, hitEff)
end

function AisillaBoss:OnBuffAdded(buff)
  if self.fsm then
    local curState = self.fsm:GetStateIndex()
    if buff.meta.type == BuffType.Dive and curState ~= ZombieState.Dive then
      self.fsm:ChangeState(ZombieState.Dive)
    end
  end
  base.OnBuffAdded(self, buff)
end

function AisillaBoss:EnterDive()
  self:PlaySimpleAnim("dive")
  self:SetInvincible(true)
  self.skillManager:Interrupt()
  local specialSkill = self.monsterMeta.specialSkill
  if specialSkill ~= nil then
    for _, metaId in ipairs(specialSkill) do
      local skill = self.skillManager:GetSkillById(metaId)
      if skill ~= nil then
        skill:ReInit()
      else
        local skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(metaId)
        if skillMeta == nil then
          Logger.LogError("\230\138\128\232\131\189\232\161\168\228\184\173\230\178\161\230\156\137id\228\184\186" .. skillId .. "\231\154\132\230\138\128\232\131\189")
        end
        self.skillManager:AddSkill(skillMeta)
      end
    end
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Enemy_Boss_Aisila_Xiaqian, false)
end

function AisillaBoss:OnBuffRemoved(buff)
  if self.fsm then
    local curState = self.fsm:GetStateIndex()
    if buff.meta.type == BuffType.Dive and curState == ZombieState.Dive then
      self.fsm:ChangeState(ZombieState.Idle)
    end
  end
  base.OnBuffRemoved(self, buff)
end

function AisillaBoss:ExitDive()
  self:PlaySimpleAnim("born")
  self:SetInvincible(true)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Enemy_Boss_Aisila_Emerge, false)
end

function AisillaBoss:GetActiveSkillIgnoreRangeLimit()
  if self.monsterMeta.skill then
    return self.skillManager:GetActiveSkillIgnoreRangeLimit(self.monsterMeta.skill)
  end
  return nil
end

function AisillaBoss:GetSpecialActiveSkillIgnoreRangeLimit()
  if self.monsterMeta.specialSkill then
    return self.skillManager:GetActiveSkillIgnoreRangeLimit(self.monsterMeta.specialSkill)
  end
  return nil
end

function AisillaBoss:ForbidSkillAnim()
  if self.fsm and self.fsm:GetStateIndex() == ZombieState.Dive then
    return true
  end
  return base.ForbidSkillAnim(self)
end

function AisillaBoss:HitWhite()
  if self.invincible then
    return
  end
  base.HitWhite(self)
end

return AisillaBoss
