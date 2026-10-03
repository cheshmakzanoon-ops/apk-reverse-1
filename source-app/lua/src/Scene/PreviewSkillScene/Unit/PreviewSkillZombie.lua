local base = require("Scene.LWBattle.BarrageBattle.Unit.BarrageUnit")
local PreviewSkillZombie = BaseClass("Zombie", base)
local Resource = CS.GameEntry.Resource
local Physics = CS.UnityEngine.Physics
local Const = require("Scene.LWBattle.Const")
local ZombieStateBorn = require("Scene.LWBattle.BarrageBattle.ZombieState.ZombieStateBorn")
local ZombieStateRealIdle = require("Scene.LWBattle.BarrageBattle.ZombieState.ZombieStateRealIdle")
local ZombieStateDie = require("Scene.LWBattle.BarrageBattle.ZombieState.ZombieStateDie")
local ZombieStateHardControl = require("Scene.LWBattle.BarrageBattle.ZombieState.ZombieStateHardControl")
local FSM = require("Framework.Common.FSM")
local EliteEffect = "Assets/_Art_LastWar/Effect/Prefab/Common/Eff_ring_purple.prefab"
local BossEffect = "Assets/_Art_LastWar/Effect/Prefab/Common/Eff_ring_orange.prefab"
local TargetEffect = "Assets/_Art_LastWar/Effect/Prefab/Common/Eff_ring_yellow.prefab"
local TargetArrowEffect = "Assets/Main/Prefabs/Guide/GuideWorldArrow.prefab"
local ColliderArrayCapacity = 20
local HPBarCell = require("DataCenter.PreviewSkill.HpBar.PreviewSkillHpBarCell")
local MultHpBarCell = require("DataCenter.PreviewSkill.HpBar.PreviewSkillMultHpBarCell")

function PreviewSkillZombie:Init(battleMgr, guid, meta)
  base.Init(self, battleMgr, guid, meta)
  self.unitType = UnitType.Zombie
  self.searchType = BattleSearchType.Zombie
  self.currState = nil
  self.stateList = {}
  self.attackTargetId = nil
  self.pathIndex = 2
  self.isVisible = true
  self.colliderArray = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Collider), ColliderArrayCapacity)
  self.isJunk = nil
  self.hpBonus = 1
  self.heroEffectMeta = DataCenter.PveHeroEffectTemplateManager:GetTemplate(meta.monster_effect)
end

function PreviewSkillZombie:Create(pos, targetPos, delayTime, isShowBorn)
  self.curWorldPos = pos
  self.isJunk = self.meta.monster_type == Const.MonsterType.Junk
  if self.delayCall ~= nil then
    self.delayCall:Stop()
    self.delayCall = nil
  end
  self.delayCall = TimerManager:GetInstance():DelayInvoke(function()
    self.req = Resource:InstantiateAsync(self.meta.asset)
    self.req:completed("+", function(req)
      local gameObject = req.gameObject
      local transform = gameObject.transform
      self.gameObject = gameObject
      self.transform = transform
      self:ComponentDefine()
      self.curBlood = self:GetRawProperty(HeroEffectDefine.HealthPoint) * (1 + self:GetRawProperty(HeroEffectDefine.HpAddRate)) * self.hpBonus
      self.maxBlood = self.curBlood
      transform.localScale = Vector3.one * self.meta.model_size
      if self.meta.monster_type == Const.MonsterType.Boss then
        self.hpBar = MultHpBarCell.New(Const.HPBarStyle.Enemy, transform, self.meta.hp_bar_height, self.meta.hp_bar_num)
        self.hpBar:LoadAndSetHp(self.curBlood, self.maxBlood)
      end
      transform:Set_position(pos.x, pos.y, pos.z)
      transform:LookAt(targetPos)
      gameObject:SetActive(self.isVisible)
      self.gameObject.name = UnitType2String[self.unitType] .. self.guid
      if self.isJunk then
        self.collider.gameObject.layer = LayerMask.NameToLayer("Junk")
        self:RemoveDestination()
      else
        self.collider.gameObject.layer = LayerMask.NameToLayer("Zombie")
        self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
        if not self.anim then
          Logger.LogError("\232\175\165\229\141\149\228\189\141\228\184\139\233\157\162\230\178\161\230\140\130SimpleAnimation\232\132\154\230\156\172\239\188\140gameObject:" .. self.gameObject.name)
        end
        self:InitFsm(isShowBorn)
      end
      self:InitSkills()
      local effectPath
      if self.meta.monster_type == Const.MonsterType.Boss then
        effectPath = BossEffect
      elseif self.meta.monster_type == Const.MonsterType.Elite then
        effectPath = EliteEffect
      end
      if effectPath ~= nil then
        self.effReq = Resource:InstantiateAsync(effectPath)
        self.effReq:completed("+", function(effreq)
          local effGo = effreq.gameObject
          effGo.transform:SetParent(self.transform)
          effGo.transform:Set_localPosition(0, 0, 0)
          effGo.transform:Set_localScale(self.meta.collide_radius, 1, self.meta.collide_radius)
        end)
      end
    end)
  end, delayTime)
end

function PreviewSkillZombie:DestroyView()
  base.DestroyView(self)
  self.gameObject = nil
  self.transform = nil
  if self.fsm then
    self.fsm:Delete()
    self.fsm = nil
  end
  if self.effReq ~= nil then
    self.effReq:Destroy()
    self.effReq = nil
  end
  if self.arrowReq ~= nil then
    self.arrowReq:Destroy()
    self.arrowReq = nil
  end
  if self.stiffTimer then
    self.stiffTimer:Stop()
    self.stiffTimer = nil
  end
  if self.hpBar then
    self.hpBar:Destroy()
    self.hpBar = nil
  end
  if self.delayCall ~= nil then
    self.delayCall:Stop()
    self.delayCall = nil
  end
  if self.req ~= nil then
    self.req:Destroy()
    self.req = nil
  end
  if self.JunkDeadTimer then
    self.JunkDeadTimer:Stop()
    self.JunkDeadTimer = nil
  end
  self.stiff = false
end

function PreviewSkillZombie:DestroyData()
  base.DestroyData(self)
end

function PreviewSkillZombie:InitFsm(isShowBorn)
  self.fsm = FSM.New()
  local isShowBornState = isShowBorn == nil or isShowBorn == true
  if isShowBornState then
    self.fsm:AddState(ZombieState.Born, ZombieStateBorn.New(self))
  end
  self.fsm:AddState(ZombieState.Idle, ZombieStateRealIdle.New(self))
  self.fsm:AddState(ZombieState.Die, ZombieStateDie.New(self))
  local hardControl = ZombieStateHardControl.New()
  hardControl:Init(self)
  self.fsm:AddState(ZombieState.HardControl, hardControl)
  if isShowBornState then
    self.fsm:ChangeState(ZombieState.Born)
  else
    self.fsm:ChangeState(ZombieState.Idle)
  end
end

function PreviewSkillZombie:InitSkills()
  if self.meta.skill then
    for _, skillId in pairs(self.meta.skill) do
      local skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
      if skillMeta == nil then
        Logger.LogError("\230\138\128\232\131\189\232\161\168\228\184\173\230\178\161\230\156\137id\228\184\186" .. skillId .. "\231\154\132\230\138\128\232\131\189")
      end
      self.skillManager:AddSkill(skillMeta)
    end
  end
end

function PreviewSkillZombie:ComponentDefine()
  base.ComponentDefine(self)
end

function PreviewSkillZombie:OnUpdate(deltaTime)
  base.OnUpdate(self, deltaTime)
  if self.fsm and not self.stiff then
    self.fsm:OnUpdate()
  end
  if self.hpBar then
    self.hpBar:Update()
  end
end

function PreviewSkillZombie:SetVisible(visible)
  self.isVisible = visible
  if self.gameObject then
    self.gameObject:SetActive(visible)
  end
end

function PreviewSkillZombie:GetCurBlood()
  return self.curBlood
end

function PreviewSkillZombie:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, dir, hitEff)
  self.isAlert = true
  base.BeAttack(self, hurt, hitPoint, hitDir, whiteTime, stiffTime, dir, hitEff)
  if dir and not self.isJunk and self.meta.ignore_hit_back == 0 then
    if 0 < self.curBlood then
      self.fsm:ChangeState(ZombieState.HardControl, HardControlType.Imprison, 0.5)
    end
    self.transform:DOMove(self.transform.position + dir, 0.5):SetEase(CS.DG.Tweening.Ease.OutCirc)
  end
  if stiffTime and 0 < stiffTime and not self.isJunk and self.meta.ignore_hit_stiff == 0 then
    self.stiff = true
    self:PlaySimpleAnim(self:GetCurAnimName(), 0)
    self.skillManager:Interrupt()
    if self.stiffTimer then
      self.stiffTimer:Stop()
      self.stiffTimer = nil
    end
    self.stiffTimer = TimerManager:DelayInvoke(function()
      self.stiff = false
      self:PlaySimpleAnim(self:GetCurAnimName(), 1)
    end, stiffTime)
  end
  if 0 >= self.curBlood then
    if self.isJunk then
      self.battleMgr:OnMonsterDeath(self)
      self.gameObject:SetActive(false)
      self.JunkDeadTimer = TimerManager:DelayInvoke(function()
        self.battleMgr:RemoveUnit(self)
      end, 5)
    else
      self.fsm:ChangeState(ZombieState.Die)
    end
  end
  if 0 < hurt then
    if 0 < self.curBlood and not self.hpBar then
      if self.meta.hp_bar_num > 1 then
        self.hpBar = MultHpBarCell.New(Const.HPBarStyle.Enemy, self.transform, self.meta.hp_bar_height, self.meta.hp_bar_num)
        self.hpBar:LoadAndSetHp(self.curBlood, self.maxBlood)
      else
        self.hpBar = HPBarCell.New(Const.HPBarStyle.Enemy, self.transform, self.meta.hp_bar_height)
        self.hpBar:LoadAndSetHp(self.curBlood, self.maxBlood)
      end
    end
    if self.hpBar then
      if 0 >= self.curBlood then
        self.hpBar:Destroy()
        self.hpBar = nil
      else
        self.hpBar:SetHp(self.curBlood, self.maxBlood)
      end
    end
  end
end

function PreviewSkillZombie:AfterBeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, dir, hitEff, skill)
  base.AfterBeAttack(self, hurt, hitPoint, hitDir, whiteTime, stiffTime, dir, hitEff, skill)
  if self.fsm and self.curBlood > 0 and hurt > 0.5 * self.maxBlood then
    self.fsm:ChangeState(ZombieState.HardControl, HardControlType.Hurt, 0.5)
  end
end

function PreviewSkillZombie:SetPosition(pos)
  if self.transform then
    self.transform.position = pos
  end
end

function PreviewSkillZombie:SetRotation(quaternion)
  if self.transform then
    self.transform.rotation = quaternion
  end
end

function PreviewSkillZombie:GetMoveSpeed()
  return self.meta.move_speed
end

function PreviewSkillZombie:GetPhysicsDefence()
  return self.meta.physics_defence
end

function PreviewSkillZombie:GetMagicDefence()
  return self.meta.magic_defence
end

function PreviewSkillZombie:CheckEnemyInAlertRange()
  return PveUtil.CheckHasUnitInSphereRange(self.battleMgr, self.transform.position, self.meta.alert_range, LayerMask.GetMask("Member"))
end

function PreviewSkillZombie:GetAttackTarget()
  if self.attackTargetId == nil then
    return nil
  end
  return self.battleMgr:GetUnit(self.attackTargetId)
end

function PreviewSkillZombie:RemoveDestination()
end

function PreviewSkillZombie:GetFirePoint()
  return self.transform, false
end

function PreviewSkillZombie:GetRawProperty(type)
  if self.meta == nil then
    return 0
  end
  return self.meta.property[type] or 0
end

return PreviewSkillZombie
