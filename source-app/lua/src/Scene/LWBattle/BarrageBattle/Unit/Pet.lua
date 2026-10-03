local Resource = CS.GameEntry.Resource
local FSM = require("Framework.Common.FSM")
local Const = require("Scene.LWBattle.Const")
local MemberStateStay = require("Scene.LWBattle.BarrageBattle.MemberState.MemberStateStay")
local MemberStateMove = require("Scene.LWBattle.BarrageBattle.MemberState.MemberStateMove")
local MemberStateDie = require("Scene.LWBattle.BarrageBattle.MemberState.MemberStateDie")
local MemberStateBorn = require("Scene.LWBattle.BarrageBattle.MemberState.MemberStateBorn")
local MemberUpStateNoAttack = require("Scene.LWBattle.BarrageBattle.MemberState.MemberUpStateNoAttack")
local MemberUpStateAutoAttack = require("Scene.LWBattle.BarrageBattle.MemberState.MemberUpStateAutoAttack")
local MemberUpStateUltimate = require("Scene.LWBattle.BarrageBattle.MemberState.MemberUpStateUltimate")
local MemberUpStateStationAttack = require("Scene.LWBattle.BarrageBattle.MemberState.MemberUpStateStationAttack")
local HPBarCell = require("DataCenter.ZombieBattle.HpBar.HpBarCell")
local MemberEffect = "Assets/_Art_LastWar/Effect/Prefab/Common/Eff_ring_blue.prefab"
local ColliderComponent = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.Component.ColliderComponent")
local base = require("Scene.LWBattle.BarrageBattle.Unit.BarrageUnit")
local Pet = BaseClass("Pet", base)

function Pet:Init(battleManager, squad, guid, req, index, unitMeta, master)
  base.Init(self, battleManager, guid, unitMeta)
  self.meta = unitMeta
  if PVE_TEST_MODE then
    local GameFramework = CS.UnityEngine.GameObject.Find("GameFramework")
    self.bulletMotionEditor = GameFramework.transform:GetComponent(typeof(CS.BulletMotionEditor))
  end
  self.battleMgr = battleManager
  self.squad = squad
  self.m_req = req
  self.guid = guid
  self.unitType = UnitType.Pet
  self.fsm = nil
  self.upFsm = nil
  self.gameObject = nil
  self.colliderArray = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Collider), 20)
  self.index = index
  self.master = master
  self.targetdRule = self.meta.target_rule
  self.heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(self.meta.heroId)
  local selfAttr = self.meta.attribute_self
  local heritAttr = self.meta.attribute_inherit
  local duration = self.meta.lifetime / 1000
  self.searchType, self.layer, self.showHpBar = PveUtil.GetPetInfo(self.targetdRule)
  self:InitProperty(selfAttr, heritAttr)
  self.remainAliveTime = duration or -1
  self.needCheckDeath = self.remainAliveTime > 0
  self.startCheckDeath = false
  self.localPosition = self.squad.formation:GetOffsetByIndex(self.index)
end

function Pet:DestroyView()
  base.DestroyView(self)
  if self.transform then
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.transform:Set_eulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  end
  if self.cannon then
    self.cannon:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.cannon = nil
  end
  if self.colliderComponent then
    self.colliderComponent:Destroy()
    self.colliderComponent = nil
  end
  self.gameObject = nil
  self.transform = nil
  if self.m_req ~= nil then
    self.m_req:Destroy()
    self.m_req = nil
  end
  if self.fsm then
    self.fsm:Delete()
    self.fsm = nil
  end
  if self.upFsm then
    self.upFsm:Delete()
    self.upFsm = nil
  end
  if self.hpBar then
    self.hpBar:Destroy()
    self.hpBar = nil
  end
  if self.effReq ~= nil then
    self.effReq:Destroy()
    self.effReq = nil
  end
  self.firePoint = nil
  self.curBlood = 0
  self.anim = nil
end

function Pet:DestroyData()
  self.squad = nil
  self.bulletMotionEditor = nil
  self.curBlood = 0
  self.localPosition = nil
  self.isHuman = nil
  self.localForward = nil
  self.angular_speed_deg = nil
  self.superArmor = nil
  base.DestroyData(self)
end

function Pet:OnCreate()
  if self.m_req ~= nil then
    self.gameObject = self.m_req.gameObject
    self.transform = self.gameObject.transform
  end
  self.transform:SetParent(self.squad.transform)
  self:ResetPosition()
  self.transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  self:ComponentDefine()
  self:InitFSM()
  self.startCheckDeath = false
  if self.needCheckDeath then
    self.startCheckDeath = true
  end
end

function Pet:GetPosition()
  if not IsNull(self.transform) then
    self.curWorldPos.x, self.curWorldPos.y, self.curWorldPos.z = self.transform:Get_position()
    return self.curWorldPos
  elseif self.squad and self.squad:GetPosition() then
    return self.squad:GetPosition() + self.localPosition
  else
    return self.curWorldPos
  end
end

function Pet:ResetPosition()
  self:SetLocalPosition(self.squad.formation:GetOffsetByIndex(self.index))
end

function Pet:MoveToIndex(dstIndex, time)
  self.localPosition = self.squad.formation:GetOffsetByIndex(dstIndex)
  if time <= 0 then
    self:SetLocalPosition(self.localPosition)
  else
    self.transform:DOLocalMove(self.localPosition, time)
  end
end

function Pet:SetLocalPosition(pos)
  self.localPosition = pos
  if not IsNull(self.transform) then
    self.transform:DOKill()
    self.transform:Set_localPosition(self.localPosition.x, self.localPosition.y, self.localPosition.z)
  end
end

function Pet:SetPosition(pos)
  if not IsNull(self.transform) then
    self.transform:DOKill()
    self.transform.position = pos
  end
end

function Pet:SetProperty(type, value)
  if not self.property then
    self.property = {}
  end
  self.property[type] = value
end

function Pet:GetProperty(type)
  if not self.property then
    return 0
  end
  return self.property[type] or 0
end

function Pet:GetRawProperty(type)
  return self:GetProperty(type)
end

function Pet:InitProperty(selfAttr, inheritAttr)
  if not self.heroTemplate then
    return
  end
  self.isHuman = self.heroTemplate.is_human
  self.property = {}
  for k, v in pairs(selfAttr) do
    self:SetProperty(k, v + self:GetProperty(k))
  end
  if self.master and inheritAttr then
    for k, v in pairs(inheritAttr) do
      local baseProp = self:GetRawProperty(k)
      local masterProp = self.master:GetRawProperty(k) or 0
      self:SetProperty(k, baseProp + masterProp * v)
    end
  end
  self.curBlood = math.floor(self:GetProperty(HeroEffectDefine.HealPoint_Result))
  if 0 >= self.curBlood then
    self.curBlood = 1
  end
  self.maxBlood = self.curBlood
end

function Pet:InitFSM()
  self.fsm = FSM.New()
  self.fsm:AddState(MemberState.Born, MemberStateBorn.New(self))
  self.fsm:AddState(MemberState.Stay, MemberStateStay.New(self))
  self.fsm:AddState(MemberState.Move, MemberStateMove.New(self))
  self.fsm:AddState(MemberState.Dead, MemberStateDie.New(self))
  self.fsm:ChangeState(MemberState.Born)
  self.upFsm = FSM.New()
  self.upFsm:AddState(AttackState.AutoAttack, MemberUpStateAutoAttack.New(self))
  self.upFsm:AddState(AttackState.Ultimate, MemberUpStateUltimate.New(self))
  self.upFsm:AddState(AttackState.StationAttack, MemberUpStateStationAttack.New(self))
  self.upFsm:AddState(AttackState.HoldFire, MemberUpStateNoAttack.New(self))
  self.upFsm:ChangeState(AttackState.AutoAttack)
end

function Pet:HandleInput(command, param)
  if command == MemberCommand.Move then
    self.fsm:ChangeState(MemberState.Move, param)
  elseif command == MemberCommand.Stay then
    self.fsm:ChangeState(MemberState.Stay, param)
  elseif command == MemberCommand.AutoAttack then
    if self.upFsm:GetStateIndex() ~= AttackState.Ultimate and self.upFsm:GetStateIndex() ~= AttackState.HoldFire then
      self.upFsm:ChangeState(AttackState.AutoAttack, param)
    end
  elseif command == MemberCommand.StationAttack and self.upFsm:GetStateIndex() ~= AttackState.Ultimate and self.upFsm:GetStateIndex() ~= AttackState.HoldFire then
    self.upFsm:ChangeState(AttackState.StationAttack, param)
  end
end

function Pet:ComponentDefine()
  base.ComponentDefine(self)
  self.collider.gameObject.layer = LayerMask.NameToLayer(self.layer)
  self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
  if not IsNull(self.anim) then
    self.anim.transform:Set_localPosition(0, 0, 0)
  end
  if not self.anim then
    Logger.LogError("\232\175\165\229\141\149\228\189\141\228\184\139\233\157\162\230\178\161\230\140\130SimpleAnimation\232\132\154\230\156\172\239\188\140gameObject:" .. self.gameObject.name)
  end
  if not self.heroTemplate then
    return
  end
  local appearanceId = self.heroTemplate.appearance
  local appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
  self.transform:Set_localScale(appearanceMeta.model_size, appearanceMeta.model_size, appearanceMeta.model_size)
  local fire_paths = appearanceMeta.fire_paths
  self.firePoints = {}
  for i = 1, #fire_paths do
    local firePoint = self.transform:Find(fire_paths[i])
    if not firePoint or string.IsNullOrEmpty(fire_paths[i]) then
      Logger.LogError("\229\188\128\231\129\171\231\130\185\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\232\183\175\229\190\132\228\184\141\229\186\148\229\140\133\229\144\171\233\162\132\229\136\182\228\189\147\229\144\141\239\188\140\229\164\150\232\167\130id\239\188\154" .. appearanceId .. "\239\188\140\229\188\128\231\129\171\231\130\185\232\183\175\229\190\132\239\188\154" .. fire_paths[i])
    end
    table.insert(self.firePoints, firePoint)
  end
  self.firePoint = self.firePoints[1]
  self.firePointNull = IsNull(self.firePoint)
  if self.isHuman then
    self.cannon = self.transform
  else
    local canon_path = appearanceMeta.canon_path
    self.cannon = self.transform:Find(canon_path)
    if not self.cannon then
      self.cannon = self.transform
      Logger.LogError("\231\130\174\229\143\176\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\230\179\168\230\132\143\232\183\175\229\190\132\228\184\141\229\186\148\229\140\133\229\144\171\233\162\132\229\136\182\228\189\147\229\144\141\239\188\140\229\164\150\232\167\130id\239\188\154" .. appearanceId .. "\239\188\140\231\130\174\229\143\176\232\183\175\229\190\132\239\188\154" .. canon_path)
    else
      self.cannon:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    end
    local canonFix = appearanceMeta.canon_rotation
    if canonFix and #canonFix == 3 then
      self.localForward = Vector3.forward * Quaternion.Euler(canonFix[1], canonFix[2], canonFix[3])
    end
  end
  self.angular_speed_deg = self.heroTemplate.angular_speed * 60
  self.buffPoints = {}
  if not table.IsNullOrEmpty(appearanceMeta.buff_path) then
    for i = 1, #appearanceMeta.buff_path do
      if string.IsNullOrEmpty(appearanceMeta.buff_path[i]) then
        self.buffPoints[i] = nil
      else
        local buffPoint = self.transform:Find(appearanceMeta.buff_path[i])
        if IsNull(buffPoint) then
          Logger.LogError("buff\231\130\185\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\229\164\150\232\167\130id\239\188\154" .. appearanceId .. "\239\188\140buff\231\130\185\232\183\175\229\190\132\239\188\154" .. appearanceMeta.buff_path[i])
        end
        self.buffPoints[i] = buffPoint
      end
    end
  end
  self.uiPoint = nil
  if not string.IsNullOrEmpty(appearanceMeta.ui_path) then
    self.uiPoint = self.transform:Find(appearanceMeta.ui_path)
    if not self.uiPoint then
      Logger.LogError("\228\184\173\229\191\131\231\130\185\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\229\164\150\232\167\130id\239\188\154" .. appearanceId .. "\239\188\140\228\184\173\229\191\131\231\130\185\232\183\175\229\190\132\239\188\154" .. appearanceMeta.ui_path)
    end
  end
  local uiParentTransform = self.uiPoint ~= nil and self.uiPoint or self.transform
  local effectParentTransform = self:GetBuffTransform()
  if self.showHpBar then
    self.hpBar = HPBarCell.New(Const.HPBarStyle.Self, uiParentTransform, 2)
    self.hpBar:LoadAndSetHp(self.curBlood, self.maxBlood)
  end
  self.effReq = Resource:InstantiateAsync(MemberEffect)
  self.effReq:completed("+", function(effreq)
    local effGo = effreq.gameObject
    effGo.transform:SetParent(effectParentTransform)
    effGo.transform:Set_localPosition(0, 0, 0)
    effGo.transform:Set_localScale(1, 1, 1)
  end)
  self:InitSkill()
end

function Pet:InitSkill()
  if not self.heroTemplate then
    return
  end
  for k, id in pairs(self.heroTemplate.skills) do
    local skillInfo = SkillInfo.New()
    skillInfo:CreateFromTemplate(id, true, 1, 0)
    if skillInfo.skillTemplateData == nil then
      Logger.LogError("\230\183\187\229\138\160\230\138\128\232\131\189\230\151\182\239\188\140\230\138\128\232\131\189\233\133\141\231\189\174\230\137\190\228\184\141\229\136\176,\230\138\128\232\131\189Id\239\188\154" .. id)
    end
    self.skillManager:AddSkill(skillInfo.skillTemplateData, skillInfo, false)
  end
  if CS.CommonUtils.IsDebug() and INVINCIBLE then
    self:SetInvincible(true)
    self:AddHaloBuff(string.format("%s/%s", self:GetGuid(), -1), {
      [HeroEffectDefine.BuffAttackAddRate] = 99999
    })
  end
end

function Pet:TryCheckAliveTime(deltaTime)
  if self.startCheckDeath then
    self.remainAliveTime = self.remainAliveTime - deltaTime
    if self.remainAliveTime <= 0 then
      self.curBlood = 0
      self.fsm:ChangeState(MemberState.Dead)
      self.upFsm:ChangeState(AttackState.HoldFire)
      if self.hpBar then
        self.hpBar:SetHp(0, self.maxBlood, 0)
      end
      self.startCheckDeath = false
    end
  end
end

function Pet:OnUpdate(deltaTime)
  base.OnUpdate(self, deltaTime)
  if self.fsm then
    self.fsm:OnUpdate()
  end
  if self.upFsm then
    self.upFsm:OnUpdate()
  end
  if self.hpBar then
    self.hpBar:Update()
  end
  self:TryCheckAliveTime(deltaTime)
end

function Pet:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, dir, hitEff)
  if self.invincible then
    return
  end
  base.BeAttack(self, hurt, hitPoint, hitDir, whiteTime, stiffTime, dir, hitEff)
  EventManager:GetInstance():Broadcast(EventId.MemberBeAttack, {
    index = self.index,
    hp = self.curBlood / self.maxBlood
  })
  if self.curBlood <= 0 then
    self.fsm:ChangeState(MemberState.Dead)
    self.upFsm:ChangeState(AttackState.HoldFire)
  end
  if 0 < hurt and self.hpBar then
    self.hpBar:SetHp(self.curBlood, self.maxBlood, self:GetShieldValue())
  end
end

function Pet:AfterBeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill, deathEff)
  if self.invincible then
    return
  end
  base.AfterBeAttack(self, hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill, deathEff)
end

function Pet:CheckEnemyInAlertRange()
  return self.battleMgr and PveUtil.CheckHasUnitInSphereRange(self.battleMgr, self:GetPosition(), Const.MEMBER_ALERT_RADIUS, LayerMask.GetMask("Zombie"), nil, 1)
end

function Pet:GetFirePoint()
  return self.firePoint, self.firePointNull
end

function Pet:GetFirePointById(id)
  if self.firePoints and self.firePoints[id] then
    return self.firePoints[id], false
  end
  return self:GetFirePoint()
end

function Pet:GetMoveSpeed()
  local metaSpeed = 0
  if self.heroTemplate then
    metaSpeed = self.heroTemplate.speed_battle
  end
  return metaSpeed * (1 + self:GetProperty(HeroEffectDefine.BattleHeroMoveSpeed))
end

function Pet:IsMoving()
  return self.fsm and self.fsm:GetStateIndex() == MemberState.Move
end

function Pet:IsSuperArmor()
  self.superArmor = false
  local buff = self:GetPropertyBuff(HeroEffectDefine.SuperArmor)
  if 0 < buff then
    self.superArmor = true
  end
  return self.superArmor
end

function Pet:InitColliderComponent(layerMask, OnCollision)
  if not self.colliderComponent and self.transform then
    self.colliderComponent = ColliderComponent.New()
    self.colliderComponent:InitCollider(self.transform, 10, layerMask)
    self.colliderComponent:SetOnCollide(OnCollision)
  end
end

function Pet:GetCurAndMaxHp()
  return self.curBlood, self.maxBlood
end

function Pet:GetLocationType()
  return self.index > 2 and LocationType.Back or LocationType.Front
end

function Pet:UltimateIsReady()
  local ultimateSkill = self.skillManager:GetUltimateSkill()
  if not ultimateSkill then
    return false
  end
  if ultimateSkill.lock then
    return false
  end
  local curCD = ultimateSkill:GetCurAndMaxCD()
  if 0 < curCD then
    return false
  end
  if 0 >= self.curBlood then
    return false
  end
  if self:IsSuperArmor() then
    return false
  end
  if self.upFsm:GetStateIndex() == AttackState.Ultimate or self.upFsm:GetStateIndex() == AttackState.HoldFire then
    return false
  end
  return true
end

function Pet:UltimateIsLock()
  if self.skillManager then
    local ultimateSkill = self.skillManager:GetUltimateSkill()
    return ultimateSkill and ultimateSkill.lock
  else
    return false
  end
end

function Pet:GetUltimateTimeStopDuration()
  return self.skillManager:GetUltimateTimeStopDuration()
end

function Pet:ChangeStage(stage)
  if stage == BarrageState.PreExit then
    self:SetInvincible(true)
  elseif stage == BarrageState.Exit then
    self:SetInvincible(true)
    if self.transform then
      self.battleMgr:ShowEffectObj("Assets/Main/Prefabs/LWBattle/Effect_Lod/Eff_duiwujiasu_lod.prefab", self.transform.localPosition, nil, -1, self.transform.parent)
    end
  end
end

function Pet:OnBuffAdded(buff)
  base.OnBuffAdded(self, buff)
  if buff.meta.type == BuffType.Stun then
    self.upFsm:ChangeState(AttackState.HoldFire)
  end
end

function Pet:OnBuffRemoved(buff)
  if buff.meta.type == BuffType.Stun and not self:IsStunning() then
    self.upFsm:ChangeState(AttackState.AutoAttack)
  end
end

function Pet:InterruptSkill()
  if self.skillManager then
    self.skillManager:Interrupt()
  end
end

function Pet:GetUnitPositionInTeam()
  if self.squad and self.squad.formation and self.index then
    return self.squad.formation:GetOffsetByIndex(self.index)
  end
  return Vector3.zero
end

function Pet:IsBattleLostCondition()
  return self.targetdRule and self.targetdRule == 3
end

function Pet:IsDead()
  return self.curBlood <= 0
end

function Pet:GetHeroCamp()
  if self.heroTemplate then
    return self.heroTemplate.type
  end
  return HeroType.None
end

return Pet
