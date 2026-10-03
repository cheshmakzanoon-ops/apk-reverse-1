local Resource = CS.GameEntry.Resource
local FSM = require("Framework.Common.FSM")
local Const = require("Scene.LWBattle.Const")
local MemberStateStay = require("Scene.LWBattle.BarrageBattle.MemberState.MemberStateStay")
local MemberStateMove = require("Scene.LWBattle.BarrageBattle.MemberState.MemberStateMove")
local MemberStateDie = require("Scene.LWBattle.BarrageBattle.MemberState.MemberStateDie")
local MemberUpStateNoAttack = require("Scene.LWBattle.BarrageBattle.MemberState.MemberUpStateNoAttack")
local MemberUpStateAutoAttack = require("Scene.LWBattle.BarrageBattle.MemberState.MemberUpStateAutoAttack")
local MemberUpStateUltimate = require("Scene.LWBattle.BarrageBattle.MemberState.MemberUpStateUltimate")
local MemberUpStateStationAttack = require("Scene.LWBattle.BarrageBattle.MemberState.MemberUpStateStationAttack")
local HPBarCell = require("DataCenter.ZombieBattle.HpBar.HpBarCell")
local MemberEffect = "Assets/_Art_LastWar/Effect/Prefab/Common/Eff_ring_blue.prefab"
local ColliderComponent = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.Component.ColliderComponent")
local base = require("Scene.LWBattle.BarrageBattle.Unit.BarrageUnit")
local Member = BaseClass("Member", base)

function Member:Init(battleManager, squad, guid, req, index, heroData, campBuff)
  base.Init(self, battleManager, guid, heroData.meta)
  if PVE_TEST_MODE then
    local GameFramework = CS.UnityEngine.GameObject.Find("GameFramework")
    self.bulletMotionEditor = GameFramework.transform:GetComponent(typeof(CS.BulletMotionEditor))
  end
  self.battleMgr = battleManager
  self.squad = squad
  self.m_req = req
  self.guid = guid
  self.unitType = UnitType.Member
  self.searchType = BattleSearchType.Member
  self.fsm = nil
  self.upFsm = nil
  self.gameObject = nil
  self.colliderArray = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Collider), 20)
  self.index = index
  self.heroData = heroData
  self.hero = heroData
  self:InitHeroData(campBuff)
  self.timeCount = 0
  self.localPosition = self.squad.formation:GetOffsetByIndex(self.index)
end

function Member:DestroyView()
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

function Member:DestroyData()
  self.squad = nil
  self.hero = nil
  self.bulletMotionEditor = nil
  self.curBlood = 0
  self.localPosition = nil
  self.isHuman = nil
  self.localForward = nil
  self.angular_speed_deg = nil
  self.superArmor = nil
  base.DestroyData(self)
end

function Member:OnCreate()
  if self.m_req ~= nil then
    self.gameObject = self.m_req.gameObject
    self.transform = self.gameObject.transform
  end
  if not self.squad or not self.transform then
    return
  end
  self.transform:SetParent(self.squad.transform)
  self:ResetPosition()
  self.transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  self:ComponentDefine()
  self:InitFSM()
end

function Member:GetPosition()
  if not IsNull(self.transform) then
    self.curWorldPos.x, self.curWorldPos.y, self.curWorldPos.z = self.transform:Get_position()
    return self.curWorldPos
  elseif self.squad and self.squad:GetPosition() then
    return self.squad:GetPosition() + self.localPosition
  else
    return self.curWorldPos
  end
end

function Member:ResetPosition()
  self:SetLocalPosition(self.squad.formation:GetOffsetByIndex(self.index))
end

function Member:MoveToIndex(dstIndex, time)
  self.localPosition = self.squad.formation:GetOffsetByIndex(dstIndex)
  if time <= 0 then
    self:SetLocalPosition(self.localPosition)
  else
    self.transform:DOLocalMove(self.localPosition, time)
  end
end

function Member:SetLocalPosition(pos)
  self.localPosition = pos
  if not IsNull(self.transform) then
    self.transform:DOKill()
    self.transform:Set_localPosition(self.localPosition.x, self.localPosition.y, self.localPosition.z)
  end
end

function Member:SetPosition(pos)
  if not IsNull(self.transform) then
    self.transform:DOKill()
    self.transform.position = pos
  end
end

function Member:InitHeroData(campBuff)
  if not self.hero then
    Logger.LogError("\232\142\183\229\143\150\232\139\177\233\155\132\230\149\176\230\141\174\229\164\177\232\180\165\239\188\140heroUuid \239\188\154")
    return
  end
  self.meta = self.hero.meta
  self.isHuman = self.meta.is_human
  self.heroEffectMeta = DataCenter.PveHeroEffectTemplateManager:GetTemplate(self.meta.hero_effect)
  if campBuff and campBuff.camp_effect then
    for k, v in pairs(campBuff.camp_effect) do
      self:AddHaloBuff(string.format("%s/-%s", self:GetGuid(), k), {
        [k] = v
      })
    end
  end
  local HealPoint_Result = self:GetProperty(HeroEffectDefine.HealPoint_Result)
  local HealthPoint = self:GetProperty(HeroEffectDefine.HealthPoint)
  local LineupHpAddRate = self:GetProperty(HeroEffectDefine.LineupHpAddRate)
  local BuffHpAddRate = self:GetProperty(HeroEffectDefine.BuffHpAddRate)
  self.curBlood = math.floor((HealPoint_Result + HealthPoint) * (1 + BuffHpAddRate + LineupHpAddRate))
  self.maxBlood = self.curBlood
end

function Member:GetRawProperty(type)
  if self.hero == nil then
    return 0
  end
  return self.hero:GetHeroProperty(type)
end

function Member:InitFSM()
  self:PlaySimpleAnim(AnimName.Idle)
  self.fsm = FSM.New()
  self.fsm:AddState(MemberState.Stay, MemberStateStay.New(self))
  self.fsm:AddState(MemberState.Move, MemberStateMove.New(self))
  self.fsm:AddState(MemberState.Dead, MemberStateDie.New(self))
  self.fsm:ChangeState(MemberState.Stay)
  self.upFsm = FSM.New()
  self.upFsm:AddState(AttackState.AutoAttack, MemberUpStateAutoAttack.New(self))
  self.upFsm:AddState(AttackState.Ultimate, MemberUpStateUltimate.New(self))
  self.upFsm:AddState(AttackState.StationAttack, MemberUpStateStationAttack.New(self))
  self.upFsm:AddState(AttackState.HoldFire, MemberUpStateNoAttack.New(self))
  self.upFsm:ChangeState(AttackState.AutoAttack)
end

function Member:HandleInput(command, param)
  if command == MemberCommand.Move then
    self.fsm:ChangeState(MemberState.Move, param)
  elseif command == MemberCommand.Stay then
    self.fsm:ChangeState(MemberState.Stay, param)
  elseif command == MemberCommand.AutoAttack then
    if self.upFsm:GetStateIndex() ~= AttackState.Ultimate and self.upFsm:GetStateIndex() ~= AttackState.HoldFire then
      self.upFsm:ChangeState(AttackState.AutoAttack, param)
    end
  elseif command == MemberCommand.StationAttack then
    if self.upFsm:GetStateIndex() ~= AttackState.Ultimate and self.upFsm:GetStateIndex() ~= AttackState.HoldFire then
      self.upFsm:ChangeState(AttackState.StationAttack, param)
    end
  elseif command == MemberCommand.Ultimate then
    if self:UltimateIsReady() then
      self.upFsm:ChangeState(AttackState.Ultimate, param)
      return true
    else
      return false
    end
  end
end

function Member:ComponentDefine()
  base.ComponentDefine(self)
  self.collider.gameObject.layer = LayerMask.NameToLayer("Member")
  self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
  if not IsNull(self.anim) then
    self.anim.transform:Set_localPosition(0, 0, 0)
  end
  if not self.anim then
    Logger.LogError("\232\175\165\229\141\149\228\189\141\228\184\139\233\157\162\230\178\161\230\140\130SimpleAnimation \232\132\154\230\156\172\239\188\140gameObject:" .. self.gameObject.name)
  end
  local appearanceMeta = self.hero.appearanceMeta
  self.transform:Set_localScale(appearanceMeta.model_size, appearanceMeta.model_size, appearanceMeta.model_size)
  local fire_paths = appearanceMeta.fire_paths
  self.firePoints = {}
  for i = 1, #fire_paths do
    local firePoint = self.transform:Find(fire_paths[i])
    if not firePoint or string.IsNullOrEmpty(fire_paths[i]) then
      Logger.LogError("\229\188\128\231\129\171\231\130\185\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\232\183\175\229\190\132\228\184\141\229\186\148\229\140\133\229\144\171\233\162\132\229\136\182\228\189\147\229\144\141\239\188\140\229\164\150\232\167\130id\239\188\154" .. self.hero.modelId .. "\239\188\140\229\188\128\231\129\171\231\130\185\232\183\175\229\190\132\239\188\154" .. fire_paths[i])
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
      Logger.LogError("\231\130\174\229\143\176\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\230\179\168\230\132\143\232\183\175\229\190\132\228\184\141\229\186\148\229\140\133\229\144\171\233\162\132\229\136\182\228\189\147\229\144\141\239\188\140\229\164\150\232\167\130id\239\188\154" .. self.hero.modelId .. "\239\188\140\231\130\174\229\143\176\232\183\175\229\190\132\239\188\154" .. canon_path)
    else
      self.cannon:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    end
    local canonFix = appearanceMeta.canon_rotation
    if canonFix and #canonFix == 3 then
      self.localForward = Vector3.forward * Quaternion.Euler(canonFix[1], canonFix[2], canonFix[3])
    end
  end
  self.angular_speed_deg = self.meta.angular_speed * 60
  self.buffPoints = {}
  if not table.IsNullOrEmpty(appearanceMeta.buff_path) then
    for i = 1, #appearanceMeta.buff_path do
      if string.IsNullOrEmpty(appearanceMeta.buff_path[i]) then
        self.buffPoints[i] = nil
      else
        local buffPoint = self.transform:Find(appearanceMeta.buff_path[i])
        if IsNull(buffPoint) then
          Logger.LogError("buff\231\130\185\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\229\164\150\232\167\130id\239\188\154" .. self.hero.modelId .. "\239\188\140buff\231\130\185\232\183\175\229\190\132\239\188\154" .. appearanceMeta.buff_path[i])
        end
        self.buffPoints[i] = buffPoint
      end
    end
  end
  self.uiPoint = nil
  if not string.IsNullOrEmpty(appearanceMeta.ui_path) then
    self.uiPoint = self.transform:Find(appearanceMeta.ui_path)
    if not self.uiPoint then
      Logger.LogError("\228\184\173\229\191\131\231\130\185\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\229\164\150\232\167\130id\239\188\154" .. self.hero.modelId .. "\239\188\140\228\184\173\229\191\131\231\130\185\232\183\175\229\190\132\239\188\154" .. appearanceMeta.ui_path)
    end
  end
  local uiParentTransform = self.uiPoint ~= nil and self.uiPoint or self.transform
  local effectParentTransform = self:GetBuffTransform()
  self.hpBar = HPBarCell.New(Const.HPBarStyle.Self, uiParentTransform, 2)
  self.hpBar:LoadAndSetHp(self.curBlood, self.maxBlood)
  self.effReq = Resource:InstantiateAsync(MemberEffect)
  self.effReq:completed("+", function(effreq)
    local effGo = effreq.gameObject
    effGo.transform:SetParent(effectParentTransform)
    effGo.transform:Set_localPosition(0, 0, 0)
    effGo.transform:Set_localScale(1, 1, 1)
  end)
  self:InitSkill()
end

function Member:InitSkill()
  if CS.CommonUtils.IsDebug() and LOCAL_HERO_SKILL_OVERRIDE then
    for k, id in pairs(self.meta.skills) do
      local skillInfo = SkillInfo.New()
      local message = {}
      message.skillId = id
      message.heroUuid = 0
      message.slot = k
      message.state = 1
      message.uuid = 0
      skillInfo:UpdateSkillInfo(message)
      if skillInfo.skillTemplateData == nil then
        Logger.LogError("\230\183\187\229\138\160\230\138\128\232\131\189\230\151\182\239\188\140\230\138\128\232\131\189\233\133\141\231\189\174\230\137\190\228\184\141\229\136\176,\230\138\128\232\131\189Id\239\188\154" .. id)
      end
      self.skillManager:AddSkill(skillInfo.skillTemplateData, skillInfo)
    end
  else
    local skills = self.hero:GetAllUnlockSkillsExcludeUltimate()
    for _, skillInfo in pairs(skills) do
      if skillInfo.skillTemplateData == nil then
        Logger.LogError("\230\183\187\229\138\160\230\138\128\232\131\189\230\151\182\239\188\140\230\138\128\232\131\189\233\133\141\231\189\174\230\137\190\228\184\141\229\136\176,\230\138\128\232\131\189Id\239\188\154" .. skillInfo.id)
      else
        self.skillManager:AddSkill(skillInfo.skillTemplateData, skillInfo)
      end
    end
    local skillInfo = self.hero:GetUltimateSkill()
    if skillInfo then
      local ultimateSkill = self.skillManager:AddSkill(skillInfo.skillTemplateData, skillInfo, true)
      if self:UltimateIsLock() and self:UltimateCanUnlock() then
        self.skillManager:ResetCooldown(ultimateSkill)
      end
    end
  end
  if CS.CommonUtils.IsDebug() and INVINCIBLE then
    self:SetInvincible(true)
    self:AddHaloBuff(string.format("%s/%s", self:GetGuid(), -1), {
      [HeroEffectDefine.BuffAttackAddRate] = 99999
    })
  end
end

function Member:GetCannonTransform()
  return self.cannon
end

function Member:OnUpdate(deltaTime)
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
  if PVE_TEST_MODE and self.bulletMotionEditor then
    self.timeCount = self.timeCount - deltaTime
    if self.timeCount < 0 then
      self.timeCount = 1
      local id = self.bulletMotionEditor.SkillId
      local isUltimate = self.bulletMotionEditor.IsUltimate
      if id and 0 < id and not self.skillManager:HasSkill(id) then
        local skillTemplateData = DataCenter.HeroSkillTemplateManager:GetTemplate(id)
        if skillTemplateData then
          self.skillManager:RemoveAllSkills()
          local skillData = SkillInfo.New()
          local message = {}
          message.skillId = id
          message.heroUuid = 0
          message.slot = 1
          message.state = 1
          message.uuid = 0
          skillData:UpdateSkillInfo(message)
          if skillData.skillTemplateData == nil then
            Logger.LogError("\230\183\187\229\138\160\230\138\128\232\131\189\230\151\182\239\188\140\230\138\128\232\131\189\233\133\141\231\189\174\230\137\190\228\184\141\229\136\176,\230\138\128\232\131\189Id\239\188\154" .. id)
          end
          self.skillManager:AddSkill(skillData.skillTemplateData, skillData, isUltimate)
        end
      end
    end
  end
end

function Member:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, dir, hitEff)
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

function Member:AfterBeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill, deathEff)
  if self.invincible then
    return
  end
  base.AfterBeAttack(self, hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill, deathEff)
end

function Member:CheckEnemyInAlertRange()
  return self.battleMgr and PveUtil.CheckHasUnitInSphereRange(self.battleMgr, self:GetPosition(), Const.MEMBER_ALERT_RADIUS, LayerMask.GetMask("Zombie"), nil, 1)
end

function Member:SetWeaponActive(active)
end

function Member:GetFirePoint()
  return self.firePoint, self.firePointNull
end

function Member:GetFirePointById(id)
  if self.firePoints and self.firePoints[id] then
    return self.firePoints[id], false
  end
  return self:GetFirePoint()
end

function Member:GetMoveSpeed()
  return self.meta.speed_battle * (1 + self:GetProperty(HeroEffectDefine.BattleHeroMoveSpeed))
end

function Member:IsMoving()
  return self.fsm and self.fsm:GetStateIndex() == MemberState.Move
end

function Member:IsSuperArmor()
  self.superArmor = false
  local buff = self:GetPropertyBuff(HeroEffectDefine.SuperArmor)
  if 0 < buff then
    self.superArmor = true
  end
  return self.superArmor
end

function Member:InitColliderComponent(layerMask, OnCollision)
  if not self.colliderComponent and self.transform then
    self.colliderComponent = ColliderComponent.New()
    self.colliderComponent:InitCollider(self.transform, 10, layerMask)
    self.colliderComponent:SetOnCollide(OnCollision)
  end
end

function Member:GetCurAndMaxHp()
  return self.curBlood, self.maxBlood
end

function Member:GetLocationType()
  return self.index > 2 and LocationType.Back or LocationType.Front
end

function Member:GetHeroCamp()
  return self.hero.heroType
end

function Member:UltimateIsReady()
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

function Member:UltimateIsLock()
  if self.skillManager then
    local ultimateSkill = self.skillManager:GetUltimateSkill()
    return ultimateSkill and ultimateSkill.lock
  else
    return false
  end
end

function Member:GetUltimateTimeStopDuration()
  return self.skillManager:GetUltimateTimeStopDuration()
end

function Member:UltimateCanUnlock()
  return false
end

function Member:UnlockUltimate()
  if self:UltimateCanUnlock() then
    local ultimateSkill = self.skillManager:GetUltimateSkill()
    self.skillManager:SetUnlock(ultimateSkill)
    SFSNetwork.SendMessage(MsgDefines.HeroSkillUnlock, self.heroData.uuid, ultimateSkill.slotIndex)
  end
end

function Member:ChangeStage(stage)
  if stage == BarrageState.PreExit then
    self:SetInvincible(true)
  elseif stage == BarrageState.Exit then
    self:SetInvincible(true)
    if self.transform then
      self.battleMgr:ShowEffectObj("Assets/Main/Prefabs/LWBattle/Effect_Lod/Eff_duiwujiasu_lod.prefab", self.transform.localPosition, nil, -1, self.transform.parent)
    end
  end
end

function Member:OnBuffAdded(buff)
  base.OnBuffAdded(self, buff)
  if buff.meta.type == BuffType.Stun then
    self.upFsm:ChangeState(AttackState.HoldFire)
  end
end

function Member:OnBuffRemoved(buff)
  if buff.meta.type == BuffType.Stun and not self:IsStunning() then
    self.upFsm:ChangeState(AttackState.AutoAttack)
  end
end

function Member:InterruptSkill()
  if self.skillManager then
    self.skillManager:Interrupt()
  end
end

function Member:GetUnitPositionInTeam()
  if self.squad and self.squad.formation and self.index then
    return self.squad.formation:GetOffsetByIndex(self.index)
  end
  return Vector3.zero
end

return Member
