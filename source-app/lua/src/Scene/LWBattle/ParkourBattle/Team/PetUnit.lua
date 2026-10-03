local base = require("Scene.LWBattle.ParkourBattle.Team.MemberUnit")
local PetUnit = BaseClass("PetUnit", base)
local Resource = CS.GameEntry.Resource
local FSM = require("Framework.Common.FSM")
local StayState = require("Scene.LWBattle.ParkourBattle.Team.FSM.StayState")
local FireStateStraight = require("Scene.LWBattle.ParkourBattle.Team.FSM.FireStateStraight")
local FireStateDefenseStraight = require("Scene.LWBattle.ParkourBattle.Team.FSM.FireStateDefenseStraight")
local FireStateAuto = require("Scene.LWBattle.BarrageBattle.MemberState.MemberUpStateAutoAttack")
local FireStateHold = require("Scene.LWBattle.ParkourBattle.Team.FSM.FireStateHold")
local PetDieState = require("Scene.LWBattle.ParkourBattle.Team.FSM.PetDieState")
local BornState = require("Scene.LWBattle.ParkourBattle.Team.FSM.BornState")
local Const = require("Scene.LWBattle.Const")
local SkillManager = require("Scene.LWBattle.Skill.SkillManager")
local pveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local UnitViewFacade = CS.PVEBattleLogic.Unit.UnitViewFacade
local ModelScaleDuration = 0.4
local VIEW_INVALID_HANDLE = -1

function PetUnit:Init(logic, team, parent, localPos, meta, forceIsHuman, owner)
  base.Init(self, logic, team, parent, localPos)
  self.type = Const.ParkourUnitType.Pet
  self.meta = meta
  self.unitType = UnitType.Pet
  self.searchType = BattleSearchType.InvisiblePet
  local path = "Assets/Main/Prefabs/LWBattle/Hero/army_t1_01.prefab"
  self.leftRightAction = false
  self.rectRVOAgentId = 0
  self.appearanceId = 0
  local baseAttr, inheritAttr
  local duration = -1
  if self.meta then
    local heroId = self.meta.heroId
    self.heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroId)
    local appearanceId = self.heroTemplate.appearance
    local appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
    path = appearanceMeta.model_path
    self.appearanceMeta = appearanceMeta
    self.appearanceId = appearanceId
    self.leftRightAction = self.appearanceMeta.left_right_action
    local isHuman = self.heroTemplate.is_human
    self.isHuman = forceIsHuman or isHuman
    local targetdRule = self.meta.target_rule
    self.searchType, self.layer, self.showHPBar = PveUtil.GetPetInfo(targetdRule)
    baseAttr = self.meta.attribute_self
    inheritAttr = self.meta.attribute_inherit
    duration = self.meta.lifetime / 1000
    self.movable = self.meta.movable
    if self.movable then
      self.velocity = Vector2.New(self.meta.moveVelocityX, self.meta.moveVelocityY)
      self.selfMoveSpeed = self.meta.moveSpeed
      self.selfMoveTime = self.meta.moveDuration
      self.selfMoveTimer = 0
      self.posOffset = Vector2.zero
    end
    self.useCollider = self.meta.useCollider
    if self.useCollider then
      self.collierType = self.meta.collider_type
    end
    self.useTaunt = self.meta.useTaunt
    self.bornRotationFlow = self.meta.bornRotationFlow
  else
    self.movable = false
    self.useCollider = false
    self.useTaunt = false
    self.bornRotationFlow = false
  end
  self.heroEffectMeta = DataCenter.PveHeroEffectTemplateManager:GetTemplate(self.heroTemplate.hero_effect)
  self.owner = owner
  self.ownerSkillId = nil
  self:InitPetData(baseAttr, inheritAttr)
  self.remainAliveTime = duration or -1
  self.needCheckDeath = 0 < self.remainAliveTime
  self.startCheckDeath = false
  self.energy = 0
  self.MPB = nil
  self.MPBColor = nil
  self.modelScaleStart = 1
  self.modelScaleEnd = 1
  self.modelScaleTimer = -1
  self.summonBornForward = nil
  self.summonBornDis = nil
  self.viewLoaded = false
  self.viewHandle = VIEW_INVALID_HANDLE
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    pveUnitViewUtil.CreateUnitViewListRequest(self, self.guid, path, self.parent, 1, self.localPosition.x, self.localPosition.y, self.localPosition.z, ResetPosition.x, ResetPosition.y, ResetPosition.z, self.layer)
  else
    self.viewHandle, self.viewLoaded = pveUnitViewUtil.CreateUnitView(self.guid, path, self.parent, 1, self.localPosition.x, self.localPosition.y, self.localPosition.z, ResetPosition.x, ResetPosition.y, ResetPosition.z, self.layer)
    if self.viewLoaded then
      self:OnViewLoaded(true)
    end
  end
  self.slot = 0
  self.triggerdDeathSkill = false
end

function PetUnit:OnViewLoaded(force, objHandle)
  if self.viewLoaded and not force then
    return
  end
  self.viewLoaded = true
  self.gameObject = UnitViewFacade.GetGameObject(self.viewHandle)
  self.transform = UnitViewFacade.GetTransform(self.viewHandle)
  if self.summonBornDis then
    self.summonBornForward = self:GetBornForward()
    if self.summonBornForward then
      self:SetBornRotationAndPosition(self.summonBornDis, self.summonBornForward)
    end
    self.bornRotationFlow = false
  end
  self:ComponentDefine()
  self:InitFSM()
  local appearanceMeta = self.appearanceMeta
  local scale = appearanceMeta.model_size * self:GetModelScaleValue()
  self.transform:Set_localScale(scale, scale, scale)
  local fire_paths = appearanceMeta.fire_paths
  self.firePoints = {}
  for i = 1, #fire_paths do
    local fire_path = fire_paths[i]
    local firePoint = self.transform:Find(fire_path)
    if not firePoint or string.IsNullOrEmpty(fire_path) then
      Logger.LogError("\229\188\128\231\129\171\231\130\185\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\232\183\175\229\190\132\228\184\141\229\186\148\229\140\133\229\144\171\233\162\132\229\136\182\228\189\147\229\144\141\239\188\140\229\164\150\232\167\130id\239\188\154" .. self.appearanceId .. "\239\188\140\229\188\128\231\129\171\231\130\185\232\183\175\229\190\132\239\188\154" .. fire_path)
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
      Logger.LogError("\231\130\174\229\143\176\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\230\179\168\230\132\143\232\183\175\229\190\132\228\184\141\229\186\148\229\140\133\229\144\171\233\162\132\229\136\182\228\189\147\229\144\141\239\188\140\229\164\150\232\167\130id\239\188\154" .. self.appearanceId .. "\239\188\140\231\130\174\229\143\176\232\183\175\229\190\132\239\188\154" .. canon_path)
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
          Logger.LogError("buff\231\130\185\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\229\164\150\232\167\130id\239\188\154" .. appearanceMeta.id .. "\239\188\140buff\231\130\185\232\183\175\229\190\132\239\188\154" .. appearanceMeta.buff_path[i])
        end
        self.buffPoints[i] = buffPoint
      end
    end
  end
  if not string.IsNullOrEmpty(appearanceMeta.ui_path) then
    UnitViewFacade.InitUIPoint(self.viewHandle, appearanceMeta.ui_path)
  end
  local hpBarType = ParkourHpBarType.Self
  if appearanceMeta.hp_type then
    hpBarType = appearanceMeta.hp_type
  end
  local hpBarHeight = 2
  if appearanceMeta.hp_height then
    hpBarHeight = appearanceMeta.hp_height
  end
  if self.showHPBar and not self.hpBarHandle then
    if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
      pveUnitViewUtil.CreateHpBarListWithHandleRequest(self, self.viewHandle, hpBarHeight, nil, self.curBlood, self.maxBlood, self:GetShieldValue(), hpBarType)
    else
      self.hpBarHandle = pveUnitViewUtil.CreateHpBarWithHandleByType(hpBarType, self.viewHandle, hpBarHeight, nil, self.curBlood, self.maxBlood, self:GetShieldValue())
    end
  end
  self:ShowBornEffect()
  self:InitSkill()
  if self.isExiting then
    self:StartExiting()
  end
  self.startCheckDeath = false
  if self.needCheckDeath then
    self.startCheckDeath = true
  end
  if self.useCollider then
    if self.collierType == 0 then
      self.rectRVOAgentId = self.logic.rvoMgr:CreateRectAgents(self.gameObject)
    elseif self.collierType == 1 then
    end
  end
end

function PetUnit:SetSlot(slot)
  self.slot = slot
end

function PetUnit:ComponentDefine()
  base.ComponentDefine(self)
  self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
  if not IsNull(self.anim) then
    self.anim.transform:Set_localPosition(0, 0, 0)
  end
  self.collider.gameObject.layer = LayerMask.NameToLayer(self.layer)
end

function PetUnit:SetProperty(type, value)
  if not self.property then
    self.property = {}
  end
  self.property[type] = value
end

function PetUnit:GetProperty(type)
  if self.property then
    return self.property[type] or 0
  end
  return 0
end

function PetUnit:InitPetData(selfAttr, inheritAttr)
  self.skillManager = SkillManager.New(self.logic, self)
  self.skillManager.battleMgr = DataCenter.LWBattleManager.logic
  self.property = {}
  if not selfAttr and not inheritAttr then
    self.curBlood = 1
    self.maxBlood = 1
    return
  end
  for k, v in pairs(selfAttr) do
    self:SetProperty(k, v + self:GetRawProperty(k))
  end
  if self.owner and inheritAttr then
    for k, v in pairs(inheritAttr) do
      local baseProp = self:GetRawProperty(k)
      local masterProp = self.owner:GetRawProperty(k) or 0
      self:SetProperty(k, baseProp + masterProp * v)
    end
  end
  self.curBlood = math.floor(self:GetProperty(HeroEffectDefine.HealPoint_Result))
  if self.curBlood <= 0 then
    self.curBlood = 1
  end
  self.maxBlood = self.curBlood
end

function PetUnit:InitSkill()
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

function PetUnit:InitFSM()
  self.fsm = FSM.New()
  self.fsm:AddState(Const.ParkourFireState.Born, BornState.New(self))
  self.fsm:AddState(Const.ParkourFireState.Stay, StayState.New(self))
  if self.logic.battleType and self.logic.battleType == Const.ParkourBattleType.Defense then
    self.fsm:AddState(Const.ParkourFireState.Straight, FireStateDefenseStraight.New(self))
  else
    self.fsm:AddState(Const.ParkourFireState.Straight, FireStateStraight.New(self))
  end
  self.fsm:AddState(Const.ParkourFireState.RotateAndShoot, FireStateAuto.New(self))
  self.fsm:AddState(Const.ParkourFireState.HoldFire, FireStateHold.New(self))
  self.fsm:AddState(Const.ParkourFireState.Dead, PetDieState.New(self))
  self.fsm:ChangeState(Const.ParkourFireState.Stay)
  base.InitFSM(self)
end

function PetUnit:TryCheckAliveTime(deltaTime)
  if self.startCheckDeath then
    self.remainAliveTime = self.remainAliveTime - deltaTime
    if self.remainAliveTime <= 0 then
      self.curBlood = 0
      if self.hpBarHandle then
        pveUnitViewUtil.SetHpBar(self.hpBarHandle, 0, self.maxBlood, 0)
      end
      self.startCheckDeath = false
      if not string.IsNullOrEmpty(self.heroEffectMeta.death_effect_nomal) then
        local rot = self:GetDeadEffectRotation()
        self.logic:ShowEffectObj(self.heroEffectMeta.death_effect_nomal, self.curWorldPos, rot, nil)
      end
      if self.fsm then
        self.fsm:ChangeState(Const.ParkourFireState.Dead)
      elseif self.logic then
        self.logic:RemoveUnit(self.guid)
      end
    end
  end
end

function PetUnit:UpdatePosOffset(deltaTime)
  if not self.movable then
    return
  end
  if self.selfMoveTime == -1 or self.selfMoveTimer < self.selfMoveTime then
    self.selfMoveTimer = self.selfMoveTimer + deltaTime
    if self.selfMoveTime > 0 and self.selfMoveTimer > self.selfMoveTime then
      self.selfMoveTimer = self.selfMoveTime
    end
    local delta = self.selfMoveTimer * self.selfMoveSpeed
    local lastX = self.posOffset.x
    local lastY = self.posOffset.y
    self.posOffset.x = self.velocity.x * delta
    self.posOffset.y = self.velocity.y * delta
    self.localPosition.x = self.localPosition.x + self.posOffset.x - lastX
    self.localPosition.z = self.localPosition.z + self.posOffset.y - lastY
    self:SetLocalPosition(self.localPosition)
    if self.rectRVOAgentId and 0 < self.rectRVOAgentId and self.gameObject then
      self.logic.rvoMgr:UpdateRectAgents(self.gameObject, self.rectRVOAgentId)
    end
  elseif self.rectRVOAgentId and 0 < self.rectRVOAgentId and self.gameObject then
    self.logic.rvoMgr:UpdateRectAgents(self.gameObject, self.rectRVOAgentId)
  end
end

function PetUnit:OnUpdate(deltaTime)
  base.OnUpdate(self, deltaTime)
  if self.fsm then
    self.fsm:OnUpdate()
  end
  if self.skillManager then
    self.skillManager:OnUpdate(deltaTime)
  end
  if self.bloodDirty then
    self.bloodDirty = false
    if self.curBlood > 0 and self.hpBarHandle then
      pveUnitViewUtil.SetHpBar(self.hpBarHandle, self.curBlood, self.maxBlood, self:GetShieldValue())
    end
  end
  if self.energyBar then
    self.energyBar:Update()
  end
  self:UpdateModelScale(deltaTime)
  self:TryCheckAliveTime(deltaTime)
  self:UpdatePosOffset(deltaTime)
end

function PetUnit:GetFirePoint()
  return self.firePoint, self.firePointNull
end

function PetUnit:GetFirePointById(id)
  if self.firePoints and self.firePoints[id] then
    return self.firePoints[id], false
  end
  return self:GetFirePoint()
end

function PetUnit:GetMoveVelocity()
  if self.fsm and self.fsm:GetStateIndex() == Const.ParkourFireState.Straight then
    return Vector3.New(0, 0, self.team.speedZ)
  else
    return Vector3.zero
  end
end

function PetUnit:HideHpBar()
  if self.hpBarHandle then
    pveUnitViewUtil.DestroyHpBar(self.hpBarHandle)
    self.hpBarHandle = nil
  end
  if self.skillBar then
    self.skillBar:Delete()
    self.skillBar = nil
  end
  if self.energyBar then
    self.energyBar:Delete()
    self.energyBar = nil
  end
end

function PetUnit:DestroyView()
  self:ClearModelScaleEffect()
  self.MPB = nil
  self.MPBColor = nil
  self.modelScaleTimer = -1
  base.DestroyView(self)
  if self.hpBarHandle then
    pveUnitViewUtil.DestroyHpBar(self.hpBarHandle)
    self.hpBarHandle = nil
  end
  if self.viewHandle and self.viewHandle > VIEW_INVALID_HANDLE then
    self.viewHandle = UnitViewFacade.DestroyUnitView(self.viewHandle)
  end
  if self.skillBar then
    self.skillBar:Delete()
    self.skillBar = nil
  end
  if self.energyBar then
    self.energyBar:Delete()
    self.energyBar = nil
  end
  if self.fsm then
    self.fsm:Delete()
    self.fsm = nil
  end
  if self.cannon then
    self.cannon:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  end
  if self.skillManager then
    self.skillManager:DestroyView()
  end
  self.firePoint = nil
  if not IsNull(self.newAppearanceReq) then
    self.newAppearanceReq:Destroy()
    self.newAppearanceReq = nil
  end
  self.summonSlot = nil
  self.summonBornDis = nil
  self.bornRotationFlow = nil
  if self.rectRVOAgentId and self.rectRVOAgentId > 0 then
    self.logic.rvoMgr:RemoveRectAgents(self.rectRVOAgentId)
    self.rectRVOAgentId = nil
  end
  self.movable = false
  self.velocity = nil
  self.selfMoveSpeed = 0
  self.selfMoveTime = 0
  self.selfMoveTimer = 0
  self.posOffset = nil
  self.useCollider = false
  self.useTaunt = false
end

function PetUnit:DestroyData()
  base.DestroyData(self)
  if self.skillManager then
    self.skillManager:DestroyData()
    self.skillManager = nil
  end
  self.owner = nil
  self.ownerSkillId = nil
end

function PetUnit:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff)
  if self.invincible then
    return
  end
  base.BeAttack(self, hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff)
  if 0 < hurt then
    hurt = self:ReduceShieldValue(hurt)
    self.curBlood = math.max(self.curBlood - hurt, 0)
    if 0 < self.curBlood then
      self.bloodDirty = true
    end
    if 0 >= self.curBlood then
      if self.fsm then
        self.fsm:ChangeState(Const.ParkourFireState.Dead)
      elseif self.logic then
        self.logic:RemoveUnit(self.guid)
      end
      if not self.triggerdDeathSkill then
        self:TriggerSkill(SkillTriggerType.Death)
        self.triggerdDeathSkill = true
      end
    end
  end
end

function PetUnit:AfterBeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill, deathEff)
  if self.invincible then
    return
  end
  base.AfterBeAttack(self, hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill, deathEff)
end

function PetUnit:GetRawProperty(type)
  return self:GetProperty(type)
end

function PetUnit:ChangeStage(stage)
  base.ChangeStage(self, stage)
  if stage == Const.ParkourBattleState.Boss then
    if self.fsm then
      self.fsm:ChangeState(Const.ParkourFireState.RotateAndShoot)
    end
  elseif stage == Const.ParkourBattleState.BossStay then
    if self.fsm then
      self.fsm:ChangeState(Const.ParkourFireState.RotateAndShoot)
    end
  elseif stage == Const.ParkourBattleState.BossHorizontal then
    if self.fsm then
      self.fsm:ChangeState(Const.ParkourFireState.RotateAndShoot)
    end
  elseif stage == Const.ParkourBattleState.PreExit then
    self:SetInvincible(true)
    self:HideHpBar()
    if self.skillManager then
      self.skillManager:DestroyView()
    end
  elseif stage == Const.ParkourBattleState.Exit then
    self:SetInvincible(true)
    if self.fsm then
      self.fsm:ChangeState(Const.ParkourFireState.HoldFire)
    end
  elseif stage == Const.ParkourBattleState.Farm and self.fsm then
    self.fsm:ChangeState(Const.ParkourFireState.Straight)
  end
end

function PetUnit:GetMoveSpeed()
  return self.heroTemplate.speed_control * (1 + self:GetProperty(HeroEffectDefine.BattleHeroMoveSpeed))
end

function PetUnit:GetLocationType()
  return self.slot > 2 and LocationType.Back or LocationType.Front
end

function PetUnit:GetHeroCamp()
  if self.heroTemplate then
    return self.heroTemplate.type
  end
  return HeroType.None
end

function PetUnit:TriggerSkill(triggerType, param)
  if self.skillManager then
    self.skillManager:PassiveCast(triggerType, param)
  end
end

function PetUnit:AddEnergy(fromPos)
end

function PetUnit:ShowEnergyEffect()
  if self.skillBar then
    self.skillBar:ShowPowerEffect()
  end
end

function PetUnit:OnBuffAdded(buff)
  base.OnBuffAdded(self, buff)
  if buff.meta.type == BuffType.ModelScale and self.curBlood > 0 and self.transform and self.appearanceMeta then
    local scale = self.appearanceMeta.model_size * self:GetModelScaleValue()
    self.modelScaleEnd = scale
    self.modelScaleTimer = 0
    self.modelScaleStart, _, _ = self.transform:Get_localScale()
    if IsNull(self.MPBColor) then
      local intensity = 1.4169
      intensity = Mathf.Pow(2, intensity)
      local color = CS.UnityEngine.Color(0.7490196078431373 * intensity, 0.24313725490196078 * intensity, 0.0392156862745098 * intensity, 0)
      self.MPBColor = color
    end
    for _, v in pairs(self.renders) do
      CS.AppearenceUtils.ModelScaleEffect(v.renderer, true)
    end
  end
end

function PetUnit:OnBuffRemoved(buff)
  if buff.meta.type == BuffType.ModelScale then
    if self.curBlood > 0 then
      local scale = self.appearanceMeta.model_size * self:GetModelScaleValue()
      self.modelScaleEnd = scale
      self.modelScaleTimer = 0
      self.modelScaleStart, _, _ = self.transform:Get_localScale()
    end
    self:ClearModelScaleEffect()
  end
  base.OnBuffRemoved(self, buff)
end

function PetUnit:ClearModelScaleEffect()
  UnitViewFacade.MPBResetModelScale(self.viewHandle)
end

function PetUnit:UpdateModelScale(deltaTime)
  if self.modelScaleTimer >= 0 then
    self.modelScaleTimer = self.modelScaleTimer + deltaTime
    local scale = self.modelScaleEnd
    if self.modelScaleTimer >= ModelScaleDuration then
      self.modelScaleTimer = -1
    else
      scale = Mathf.Lerp(self.modelScaleStart, self.modelScaleEnd, self.modelScaleTimer / ModelScaleDuration)
    end
    self.transform:Set_localScale(scale, scale, scale)
  end
end

function PetUnit:ForceCastUltimate(ultimateSkill)
  if ultimateSkill.cd <= 0 then
    self.skillManager:Interrupt()
    local isBuffSkill = ultimateSkill:IsBuffSkill()
    if isBuffSkill then
      self.skillManager:ActiveCast(ultimateSkill, ultimateSkill:SearchTarget())
    else
      local target = ultimateSkill:SearchTargetPriorRange()
      local targetPos = ultimateSkill:LegalizeTarget(target)
      self.skillManager:ActiveCast(ultimateSkill, targetPos)
    end
  end
end

function PetUnit:LeftRightActionValid()
  return self.leftRightAction
end

function PetUnit:ForbidSkillAnim()
  if not self.leftRightAction then
    return base.ForbidSkillAnim(self)
  end
  if self.team and self.team:IsHorizontalMoving() then
    return true
  end
  return base.ForbidSkillAnim(self)
end

function PetUnit:GetUnitPositionInTeam()
  if self.team then
    return self.team:GetUnitPosition(self.guid)
  end
  return Vector3.zero
end

function PetUnit:Die()
  if self.fsm and self.fsm:GetStateIndex() ~= Const.ParkourFireState.Dead then
    self.curBlood = 0
    self.fsm:ChangeState(Const.ParkourFireState.Dead)
  end
end

function PetUnit:IsBattleLostCondition()
  return self.targetdRule and self.targetdRule == 3
end

function PetUnit:IsFormationUnit()
  return not self.meta.useSkillFormation
end

function PetUnit:SetSummonSlot(slot, offsetX, offsetZ, summonSkillId)
  self.summonSlot = slot
  self.ownerSkillId = summonSkillId
  if self:NeedBornRotationFlow() then
    local summonBornDis = math.sqrt(offsetX * offsetX + offsetZ * offsetZ)
    if self.transform then
      self.summonBornForward = self:GetBornForward()
      if self.summonBornForward then
        self:SetBornRotationAndPosition(summonBornDis, self.summonBornForward)
      else
        self:SetSummonLocalPositionByOffset(offsetX, offsetZ)
      end
      self.bornRotationFlow = false
    else
      self.summonBornDis = summonBornDis
      self:SetSummonLocalPositionByOffset(offsetX, offsetZ)
    end
  else
    self:SetSummonLocalPositionByOffset(offsetX, offsetZ)
  end
end

function PetUnit:SetSummonLocalPositionByOffset(offsetX, offsetZ)
  if self.parent then
    if self.owner then
      if self.owner.GetLocalPosition then
        local ownerPos = self.owner:GetLocalPosition()
        self.localPosition.x = ownerPos.x + offsetX
        self.localPosition.z = ownerPos.z + offsetZ
        self:SetLocalPosition(self.localPosition)
      end
    else
      self.localPosition.x = offsetX
      self.localPosition.z = offsetZ
      self:SetLocalPosition(self.localPosition)
    end
  elseif self.owner then
    if self.owner.GetPosition then
      local ownerPos = self.owner:GetPosition()
      self.localPosition.x = ownerPos.x + offsetX
      self.localPosition.z = ownerPos.z + offsetZ
      self:SetLocalPosition(self.localPosition)
    end
  else
    self.localPosition.x = offsetX
    self.localPosition.z = offsetZ
    self:SetLocalPosition(self.localPosition)
  end
end

function PetUnit:NeedBornRotationFlow()
  if self.bornRotationFlow and self.owner and self.owner.fsm and self.owner.fsm:GetStateIndex() == Const.ParkourFireState.RotateAndShoot then
    return true
  end
  return false
end

function PetUnit:GetBornForward()
  local bornForward
  if self.transform and self:NeedBornRotationFlow() then
    if self.owner.cannon then
      if self.owner.localForward then
        bornForward = self.owner.cannon:TransformDirection(self.owner.localForward)
      else
        bornForward = self.owner.cannon.forward
      end
    elseif self.owner.transform then
      bornForward = self.owner.transform.forward
    end
  end
  return bornForward
end

function PetUnit:SetBornRotationAndPosition(summonBornDis, bornForward)
  self.transform.forward = bornForward
  if self.velocity then
    self.velocity.x = bornForward.x
    self.velocity.y = bornForward.z
  end
  self:SetSummonLocalPositionByOffset(summonBornDis * bornForward.x, summonBornDis * bornForward.z)
end

function PetUnit:GetDeadEffectRotation()
  if self.transform and self.summonBornForward then
    return self.transform.rotation
  end
  return nil
end

function PetUnit:AfterCreateUnitViewList(viewHandle, viewLoaded)
  self.viewHandle = viewHandle
  self.viewLoaded = viewLoaded
  if self.viewLoaded then
    self:OnViewLoaded(true)
  end
end

function PetUnit:AfterCreateHpBarList(viewHandle)
  self.hpBarHandle = viewHandle
end

function PetUnit:SetLocalPosition(localPos)
  if not self.viewLoaded and self.viewHandle then
    UnitViewFacade.SetLocalPosition(self.viewHandle, localPos.x, localPos.y, localPos.z)
  end
  base.SetLocalPosition(self, localPos)
end

return PetUnit
