local base = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.MonsterObj")
local Const = require("Scene.LWBattle.Const")
local BornState = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.FSM.CommonAI.ParkourMonsterBornState")
local IdleAndSearchState = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.FSM.CommonAI.ParkourMonsterIdleState")
local DefenseRunState = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.FSM.CommonAI.DefenseRunState")
local RunState = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.FSM.CommonAI.ParkourMonsterRunState")
local AttackState = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.FSM.CommonAI.ParkourMonsterAttackNormalState")
local AttackToIdleState = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.FSM.CommonAI.ParkourMonsterAttackToIdleState")
local DieState = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.FSM.CommonAI.DieState")
local GrayDieState = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.FSM.CommonAI.GrayDieState")
local ZombieStateHardControl = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.FSM.CommonAI.ParkourMonsterHardControlState")
local FSM = require("Framework.Common.FSMWithPool")
local MultHpBarCell = require("DataCenter.ZombieBattle.HpBar.MultHpBarCell")
local SkillManager = require("Scene.LWBattle.Skill.SkillManager")
local pveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local UnitViewFacade = CS.PVEBattleLogic.Unit.UnitViewFacade
local CommonAIMonster = BaseClassCache("CommonAIMonster", base)
local TornadoDownTime = 0.3

function CommonAIMonster:Init(logic, mgr, guid, x, y, monsterMeta)
  base.Init(self, logic, mgr, guid, x, y, monsterMeta)
  self.currState = nil
  self.stateList = {}
  self.tombstone = nil
  self.attackTargetId = nil
  self.pathIndex = 2
  self.isVisible = true
  self.agent = nil
  self.sid = 0
  self.skillManager = SkillManager.New(self.logic, self)
  self.outOfRangeCD = 1
  self.isBoss = monsterMeta.is_boss == 1 or monsterMeta.monster_type == Const.MonsterType.Boss
  if self.isBoss then
    EventManager:GetInstance():Broadcast(EventId.ParkourBossEnterBattle)
  end
  if self.logic.battleType and self.logic.battleType == Const.ParkourBattleType.Defense then
    self.eulerY = 180
  end
  self.bloodDirty = false
  self.isCheckOutOfRenderRange = self.monsterMeta.monster_type ~= Const.MonsterType.Boss and not self:IsIgnoreOutOfRenderRange()
  self.layer = LayerMask.NameToLayer("Zombie")
  self.singleDamageLimitPercent = 0
end

function CommonAIMonster:DestroyView()
  base.DestroyView(self)
  if self.hpBar then
    self.hpBar:Destroy()
    self.hpBar = nil
  end
  if self.hpBarHandle then
    pveUnitViewUtil.DestroyHpBar(self.hpBarHandle)
    self.hpBarHandle = nil
  end
  if self.fsm then
    self.fsm:Delete()
    ObjectPool:GetInstance():Save(self.fsm)
    self.fsm = nil
  end
  if self.skillManager then
    self.skillManager:DestroyView()
  end
  if self.agent then
    CS.UnityEngine.GameObject.Destroy(self.agent)
    self.agent = nil
  end
  self.anim = nil
  self.singleDamageLimitPercent = 0
end

function CommonAIMonster:DestroyData()
  base.DestroyData(self)
  if self.skillManager then
    self.skillManager:DestroyData()
    ObjectPool:GetInstance():Save(self.skillManager)
    self.skillManager = nil
  end
  self.isAlert = nil
  self.speedPercent = nil
  self.buffPropertyDirty = nil
  self.curAnimSpeed = nil
end

function CommonAIMonster:ComponentDefine()
  base.ComponentDefine(self)
  self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
  if not self.anim then
    Logger.LogError("\232\175\165\229\141\149\228\189\141\228\184\139\233\157\162\230\178\161\230\140\130SimpleAnimation\232\132\154\230\156\172\239\188\140gameObject:" .. self.gameObject.name)
  end
  self.collider.gameObject.layer = LayerMask.NameToLayer("Zombie")
end

function CommonAIMonster:OnLoadComplete()
  local externalControl = self.monsterMeta.monster_type ~= Const.MonsterType.Boss
  self.agent = pveUnitViewUtil.AddAgent(self.mgr.logic.rvoMgr, self.viewHandle, 5.0, self.monsterMeta.collide_radius * 1.0, externalControl)
  self:InitSkills()
  self:InitFsm()
  if self.monsterMeta.monster_type == Const.MonsterType.Boss then
    self:InitHpBar()
  end
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
  if self.viewHandle then
    UnitViewFacade.MPBResetGray(self.viewHandle)
  else
    for _, v in pairs(self.renders) do
      CS.AppearenceUtils.GrayEffect(v.renderer, false)
    end
  end
end

function CommonAIMonster:InitHpBar()
  ProfilerUtil.BeginSample("CommonAIMonster.InitHpBar")
  if self.isBoss and self.logic.useViewBossHpBar then
    EventManager:GetInstance():Broadcast(EventId.ParkourBossHpViewChanged)
    return
  end
  if self.monsterMeta.hp_bar_num > 1 then
    if not self.hpBar then
      self.hpBar = MultHpBarCell.New(Const.HPBarStyle.Enemy, self.transform, self.monsterMeta.hp_bar_height, self.monsterMeta.hp_bar_num)
      self.hpBar:LoadAndSetHp(self.curBlood, self.maxBlood)
    end
  elseif not self.hpBarHandle then
    local hpBarType = self.monsterMeta.hp_type
    if hpBarType == 0 then
      hpBarType = ParkourHpBarType.Enemy
    end
    if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
      pveUnitViewUtil.CreateHpBarListWithHandleRequest(self, self.viewHandle, self.monsterMeta.hp_bar_height * 1.0, nil, self.curBlood, self.maxBlood, self:GetShieldValue(), hpBarType)
    else
      self.hpBarHandle = pveUnitViewUtil.CreateEnemyHpBarWithHandle(self.viewHandle, self.monsterMeta.hp_bar_height * 1.0, nil, self.curBlood, self.maxBlood, self:GetShieldValue(), nil, hpBarType)
    end
  end
  ProfilerUtil.EndSample()
end

function CommonAIMonster:InitSkills()
  if self.monsterMeta.skill then
    for _, skillId in pairs(self.monsterMeta.skill) do
      local skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
      if skillMeta == nil then
        Logger.LogError("\230\138\128\232\131\189\232\161\168\228\184\173\230\178\161\230\156\137id\228\184\186" .. skillId .. "\231\154\132\230\138\128\232\131\189")
      end
      self.skillManager:AddSkill(skillMeta)
    end
  end
end

function CommonAIMonster:TriggerSkill(triggerType, param)
  if self.skillManager then
    self.skillManager:PassiveCast(triggerType, param)
  end
end

function CommonAIMonster:InitFsm()
  self.fsm = ObjectPool:GetInstance():Load(FSM)
  self.fsm:Init(self)
  local isHasBornState = self:IsHasBornState()
  if isHasBornState then
    local bornState = ObjectPool:GetInstance():Load(BornState)
    bornState:Init(self)
    self.fsm:AddState(ZombieState.Born, bornState)
  end
  local stateCls
  if self.logic.battleType and self.logic.battleType == Const.ParkourBattleType.Defense then
    stateCls = DefenseRunState
  else
    stateCls = IdleAndSearchState
  end
  local stateObj = ObjectPool:GetInstance():Load(stateCls)
  stateObj:Init(self)
  self.fsm:AddState(ZombieState.Idle, stateObj)
  local runState = ObjectPool:GetInstance():Load(RunState)
  runState:Init(self)
  self.fsm:AddState(ZombieState.Run, runState)
  local actionType = self.monsterMeta.action_type
  if actionType == nil then
    actionType = 0
  end
  if actionType == 1 then
    stateCls = AttackToIdleState
  else
    stateCls = AttackState
  end
  stateObj = ObjectPool:GetInstance():Load(stateCls)
  stateObj:Init(self)
  self.fsm:AddState(ZombieState.Attack, stateObj)
  local dieStateObj
  if self.logic and self.logic.data and self.logic.data.deathGray then
    dieStateObj = ObjectPool:GetInstance():Load(GrayDieState)
  else
    dieStateObj = ObjectPool:GetInstance():Load(DieState)
  end
  dieStateObj:Init(self)
  self.fsm:AddState(ZombieState.Die, dieStateObj)
  local hardControlState = ObjectPool:GetInstance():Load(ZombieStateHardControl)
  hardControlState:Init(self)
  self.fsm:AddState(ZombieState.HardControl, hardControlState)
  if isHasBornState then
    self.fsm:ChangeState(ZombieState.Born)
  else
    self.fsm:ChangeState(ZombieState.Idle)
  end
end

function CommonAIMonster:SetVisible(visible)
  self.isVisible = visible
  if self.gameObject then
    self.gameObject:SetActive(visible)
  end
end

function CommonAIMonster:OnUpdate(deltaTime)
  if self.bloodDirty then
    self.bloodDirty = false
    if self.curBlood > 0 then
      if self.hpBar then
        self.hpBar:SetHp(self.curBlood, self.maxBlood, self:GetShieldValue())
      elseif self.hpBarHandle then
        pveUnitViewUtil.SetHpBar(self.hpBarHandle, self.curBlood, self.maxBlood, self:GetShieldValue())
      else
        self:InitHpBar()
      end
    end
  end
  self:UpdateBuffManager()
  self:UpdateFlashCountdown(deltaTime)
  if self.fsm then
    self.fsm:OnUpdate(deltaTime)
  end
  if self.skillManager then
    self.skillManager:OnUpdate(deltaTime)
  end
  if self.hpBar then
    self.hpBar:Update()
  end
  if self.isCheckOutOfRenderRange then
    self.outOfRangeCD = self.outOfRangeCD - deltaTime
    if 0 > self.outOfRangeCD then
      self.outOfRangeCD = 1
      self:CheckOutOfRenderRange()
    end
  end
end

function CommonAIMonster:CheckOutOfRenderRange()
  if self.battleMgr.team:GetPosition().z - self:GetPosition().z > ZOMBIE_REMOVE_DISTANCE_Z then
    self.mgr:RemoveMonster(self.guid)
  end
end

function CommonAIMonster:GetCurBlood()
  return self.curBlood
end

function CommonAIMonster:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, dir, hitEff)
  local hpPercentBefore = self.curBlood / self.maxBlood
  base.BeAttack(self, hurt, hitPoint, hitDir, whiteTime, stiffTime, dir, hitEff)
  local hpPercentAfter = self.curBlood / self.maxBlood
  if not self.logic.battleType or self.logic.battleType == Const.ParkourBattleType.Attack then
    self.isAlert = true
  end
  if 0 < hurt and self.curBlood > 0 then
    self.bloodDirty = true
  end
  self:BeAttackEffect(stiffTime, dir)
  local param = {
    hpPercentBefore = hpPercentBefore,
    hpPercentAfter = hpPercentAfter,
    hurt = hurt
  }
  self:TriggerSkill(SkillTriggerType.BeHitNew, param)
  if self.curBlood <= 0 then
    self:TriggerSkill(SkillTriggerType.Death)
    if self.logic and self.logic.detailLog then
      Logger.LogInfo("parkour monsterDeath metaId : " .. self.monsterMetaId .. ". maxBlood : " .. (self.maxBlood or 0) .. ". hitCounter : " .. (self.hitCounter or 0))
    end
  end
end

function CommonAIMonster:BeAttackEffect(stiffTime, dir)
  if dir and self.meta.ignore_hit_back == 0 then
    if 0 < self.curBlood then
      self.fsm:ChangeState(ZombieState.HardControl, HardControlType.HitBack, 0.5, self.transform.position + dir)
    end
  elseif stiffTime and 0 < stiffTime and self.meta.ignore_hit_stiff == 0 and 0 < self.curBlood then
    self.fsm:ChangeState(ZombieState.HardControl, HardControlType.Stiff, stiffTime)
  end
end

function CommonAIMonster:Death()
  if self.fsm then
    self.fsm:ChangeState(ZombieState.Die)
  end
  if self.hpBar then
    self.hpBar:Destroy()
    self.hpBar = nil
  end
  if self.hpBarHandle then
    pveUnitViewUtil.DestroyHpBar(self.hpBarHandle)
    self.hpBarHandle = nil
  end
  if self.isBoss and self.logic.useViewBossHpBar then
    EventManager:GetInstance():Broadcast(EventId.ParkourBossHpViewDead)
    return
  end
end

function CommonAIMonster:CreateBeHitEffect()
end

function CommonAIMonster:HitBackMove(pos, time)
  self:StopHitBackMove()
  if self.curBlood > 0 and self.transform then
    self.hitBackTween = self.transform:DOMove(pos, time):SetEase(CS.DG.Tweening.Ease.OutCirc)
  end
end

function CommonAIMonster:StopHitBackMove()
  if self.hitBackTween then
    self.hitBackTween:Kill()
    self.hitBackTween = nil
  end
end

function CommonAIMonster:ShowFrozen()
  UnitViewFacade.MPBFrozen(self.viewHandle)
end

function CommonAIMonster:HideFrozen()
  UnitViewFacade.MPBResetFrozen(self.viewHandle)
end

function CommonAIMonster:SetDestination(x, z)
  return self.agent:SetTargetPosition(x, z)
end

function CommonAIMonster:RemoveDestination()
  if self.logic.rvoSyncMode then
    return self.agent:SetActive(false)
  end
  return self.agent:Hide()
end

function CommonAIMonster:StopAgent()
  if self.logic.rvoSyncMode then
    return self.agent:Stop()
  end
  return self.agent:Hide()
end

function CommonAIMonster:CheckEnemyInAlertRange()
  local posZ = self.mgr.logic.team:GetPositionZ()
  return math.abs(self.transform.position.z - posZ) <= self.meta.alert_range
end

function CommonAIMonster:GetFirePointById(id)
  if self.hasExtFirePath then
    local point = UnitViewFacade.GetFirePointById(self.viewHandle, id)
    if point ~= nil then
      return point, false
    end
  end
  return self:GetFirePoint()
end

function CommonAIMonster:GetFirePoint()
  return self.transform, false
end

function CommonAIMonster:OnBuffAdded(buff)
  local buffType = buff.meta.type
  if buffType == BuffType.Imprison and self.agent then
    self.agent.speed = 0
  end
  if buffType == BuffType.SingleSkillDamageLimit then
    self.singleDamageLimitPercent = tonumber(buff.meta.rawPara) / 10000
  elseif buffType == BuffType.Tornado then
    local sourceType = buff.sourceType
    local sourceId = buff.sourceId
    if sourceType == BuffFromSourceType.Bullet and 0 < sourceId and self.logic.GetBullet then
      local bullet = self.logic:GetBullet(sourceId)
      if bullet and bullet.TryGetTornadoSlot then
        local tornadoSlot = bullet:TryGetTornadoSlot(self.guid)
        if 0 < tornadoSlot then
          if self.tornadoSlot and self.tornadoSlot ~= tornadoSlot then
            Logger.LogError("Tornado Buff Add guid : " .. self.guid .. " . slot : " .. tornadoSlot .. " . bulletId : " .. sourceId .. " . curSlot : " .. self.tornadoSlot .. ". buffId : " .. buff.meta.id)
          end
          self.tornadoSlot = tornadoSlot
          self.tornadoSourceBullet = bullet
          self.tornadoSourceBulletId = sourceId
          if 0 < self.curBlood then
            self.fsm:ChangeState(ZombieState.HardControl, HardControlType.Tornado, -1)
          end
        end
      end
    end
  elseif buffType == BuffType.Property then
    self.buffPropertyDirty = true
    self:OnBuffPropertyChanged()
  elseif buffType == BuffType.Frozen and 0 < self.curBlood then
    self.fsm:ChangeState(ZombieState.HardControl, HardControlType.Frozen, -1)
  end
  base.OnBuffAdded(self, buff)
end

function CommonAIMonster:OnBuffRemoved(buff)
  local buffType = buff.meta.type
  if buffType == BuffType.Imprison then
    self:OnBuffPropertyChanged()
  elseif buffType == BuffType.SingleSkillDamageLimit then
    self.singleDamageLimitPercent = 0
  elseif buffType == BuffType.Tornado then
    local sourceType = buff.sourceType
    local sourceId = buff.sourceId
    if sourceType == BuffFromSourceType.Bullet and 0 < sourceId and self.logic and self.logic.GetBullet then
      local bullet = self.logic:GetBullet(sourceId)
      if bullet then
        if bullet.TryReleaseTornadoSlot and self.tornadoSlot then
          bullet:TryReleaseTornadoSlot(self.guid, self.tornadoSlot)
          self.tornadoSlot = nil
          self.tornadoSourceBullet = nil
          self.tornadoSourceBulletId = nil
          if 0 < self.curBlood then
            self.fsm:ChangeState(ZombieState.HardControl, HardControlType.TornadoDown, TornadoDownTime)
          end
        end
      else
        self.tornadoSlot = nil
        self.tornadoSourceBullet = nil
        self.tornadoSourceBulletId = nil
        if 0 < self.curBlood then
          self.fsm:ChangeState(ZombieState.HardControl, HardControlType.TornadoDown, TornadoDownTime)
        end
      end
    end
  elseif buffType == BuffType.Property then
    self.buffPropertyDirty = true
    self:OnBuffPropertyChanged()
  elseif buffType == BuffType.Frozen and 0 < self.curBlood then
    self.fsm:ChangeState(ZombieState.HardControl, HardControlType.Frozen, 0.01)
  end
  base.OnBuffRemoved(self, buff)
end

function CommonAIMonster:OnBuffPropertyChanged()
  if not self:IsImprisoning() and self.agent and self.logic and self.fsm then
    if self.fsm:GetStateIndex() == ZombieState.Idle then
      if self.logic.battleType and self.logic.battleType == Const.ParkourBattleType.Defense then
        self.agent.speed = self.logic:GetMoveSpeedZ() * self:GetMoveSpeedPercent()
      else
        self.agent.speed = 1 * self:GetMoveSpeedPercent()
      end
    else
      self.agent.speed = self.meta.move_speed * self:GetMoveSpeedPercent()
    end
    if self.curAnimName and (self.curAnimName == ZombieAnim.Walk or self.curAnimName == ZombieAnim.Run) and self.anim then
      self.anim:SetStateSpeed(self.curAnimName, self.curAnimSpeed or self:GetMoveAnimPercent())
    end
  end
end

function CommonAIMonster:GetMoveSpeedPercent()
  if self.speedPercent == nil or self.buffPropertyDirty then
    self.speedPercent = 1 + self:GetProperty(HeroEffectDefine.BattleHeroMoveSpeed)
    self.buffPropertyDirty = nil
    return self.speedPercent
  end
  return self.speedPercent
end

function CommonAIMonster:GetMoveAnimPercent()
  return self:GetMoveSpeedPercent()
end

function CommonAIMonster:PlaySimpleAnim(name, speed)
  local newSpeed = speed
  if speed and (name == ZombieAnim.Run or name == ZombieAnim.Walk) then
    newSpeed = speed * self:GetMoveAnimPercent()
    self.curAnimSpeed = newSpeed
  end
  base.PlaySimpleAnim(self, name, newSpeed)
end

function CommonAIMonster:GetFreezeXAxisMoveMinDistance()
  return self.logic and self.logic:GetFreezeXAxisMoveMinDistance() or nil
end

function CommonAIMonster:GetDieStayTime()
  local stayTime = 2
  if self.logic and self.logic.data then
    if self.isBoss and self.logic.data.bossStayTime then
      stayTime = self.logic.data.bossStayTime
    elseif self.logic.data.monsterStayTime then
      stayTime = self.logic.data.monsterStayTime
    end
  end
  return stayTime
end

function CommonAIMonster:IsIgnoreOutOfRenderRange()
  local isIgnore = false
  if self.logic and self.logic.GetPVEType and self.logic:GetPVEType() == PVEType.LastStand then
    isIgnore = true
  end
  return isIgnore
end

function CommonAIMonster:AfterCreateHpBarList(viewHandle)
  self.hpBarHandle = viewHandle
end

function CommonAIMonster:IsHasBornState()
  if self.isFromSummon == true then
    return true
  end
  if self.logic ~= nil and self.logic.IsMonsterHasBornState ~= nil then
    return self.logic:IsMonsterHasBornState(self)
  end
  return false
end

function CommonAIMonster:UpdateTornado()
  if self.tornadoSourceBullet == nil or self.tornadoSourceBullet.objId == nil or self.tornadoSourceBulletId == nil or self.tornadoSourceBullet.objId ~= self.tornadoSourceBulletId then
    return
  end
  local bulletPos = self.tornadoSourceBullet:GetPosition()
  local offX, offY, offZ = self.tornadoSourceBullet:TryCalcTornado(self.tornadoSlot)
  if offX then
    self:SetPositionXYZ(bulletPos.x + offX, bulletPos.y + offY, bulletPos.z + offZ)
  end
end

function CommonAIMonster:ResetTornado()
  if self.curBlood <= 0 then
    return
  end
  local curPos = self:GetPosition()
  self:SetPositionXYZ(curPos.x, 0, curPos.z)
end

function CommonAIMonster:SetTornadoDown(y)
  local curPos = self:GetPosition()
  self:SetPositionXYZ(curPos.x, y, curPos.z)
end

return CommonAIMonster
