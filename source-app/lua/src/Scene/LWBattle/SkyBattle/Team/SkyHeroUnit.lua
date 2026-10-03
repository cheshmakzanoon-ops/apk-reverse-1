local base = require("Scene.LWBattle.ParkourBattle.Team.MemberUnit")
local SkyHeroUnit = BaseClass("SkyHeroUnit", base)
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local FSM = require("Framework.Common.FSM")
local StayState = require("Scene.LWBattle.ParkourBattle.Team.FSM.StayState")
local FireStateMultiSkillStraight = require("Scene.LWBattle.ParkourBattle.Team.FSM.FireStateMultiSkillStraight")
local FireStateAuto = require("Scene.LWBattle.BarrageBattle.MemberState.MemberUpStateAutoAttack")
local FireStateHold = require("Scene.LWBattle.ParkourBattle.Team.FSM.FireStateHold")
local HeroDieState = require("Scene.LWBattle.ParkourBattle.Team.FSM.HeroDieState")
local PreDashBonus = require("Scene.LWBattle.ParkourBattle.Team.FSM.PreDashBonus")
local Const = require("Scene.LWBattle.Const")
local SkillManager = require("Scene.LWBattle.Skill.SkillManager")
local EnergyBarCell = require("DataCenter.ZombieBattle.HpBar.EnergyBarCell")
local TriggerEnum = require("Scene.LWBattle.ParkourBattle.TriggerEvent.TriggerEnum")
local ModelScaleDuration = 0.4
local pveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local UnitViewFacade = CS.PVEBattleLogic.Unit.UnitViewFacade
local VIEW_INVALID_HANDLE = -1
local HP_BAR_VISIBLE_TIME = 3
local MEMBER_GET_EFFECT_PATH = "Assets/Main/Prefabs/LWBattle/Plane/Effect/skill/Eff_Mat_Plane_Levelup.prefab"

function SkyHeroUnit:Init(logic, team, parent, localPos, hero, forceIsHuman, originalHeroId)
  base.Init(self, logic, team, parent, localPos)
  self.type = Const.ParkourUnitType.Hero
  self.meta = hero.meta
  self.originalHeroId = originalHeroId or hero.heroId
  local metaIsHuman = self.meta.is_human
  self.isHuman = forceIsHuman or metaIsHuman
  self.unitType = UnitType.Member
  self.searchType = BattleSearchType.Member
  local path = "Assets/Main/Prefabs/LWBattle/Hero/army_t1_01.prefab"
  self.leftRightAction = false
  if hero then
    local modelPath, appearanceId, modelSourceType = hero:GetHeroModelData(HeroModelType.Battle)
    path = modelPath
    self.appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
    self.leftRightAction = self.appearanceMeta.left_right_action
  end
  self.heroEffectMeta = DataCenter.PveHeroEffectTemplateManager:GetTemplate(self.meta.hero_effect)
  self:InitHeroData(hero)
  self.maxBlood = self.hero:GetMaxHp()
  self.curBlood = self.maxBlood
  self.energy = 0
  self.MPB = nil
  self.MPBColor = nil
  self.modelScaleStart = 1
  self.modelScaleEnd = 1
  self.modelScaleTimer = -1
  self.triggerdDeathSkill = false
  self.delayFrameToLoadComps = 0
  self.viewLoaded = false
  self.viewHandle = VIEW_INVALID_HANDLE
  local appearanceMeta = hero.appearanceMeta
  local scale = appearanceMeta.model_size * self:GetModelScaleValue()
  self.viewHandle, self.viewLoaded = pveUnitViewUtil.CreateUnitView(self.guid, path, self.parent, scale, self.localPosition.x, self.localPosition.y, self.localPosition.z, ResetPosition.x, ResetPosition.y, ResetPosition.z, LayerMask.NameToLayer("Member"))
  if self.viewLoaded then
    self:OnViewLoaded(true)
  end
  self.isNew = false
  self.slot = 0
end

function SkyHeroUnit:OnViewLoaded(force)
  if self.appearanceReplacing then
    self:OnReplaceViewLoaded()
    return
  end
  if self.viewLoaded and not force then
    return
  end
  self.viewLoaded = true
  self.gameObject = UnitViewFacade.GetGameObject(self.viewHandle)
  self.transform = UnitViewFacade.GetTransform(self.viewHandle)
  self.rotateRoot = UnitViewFacade.GetRotateRoot(self.viewHandle)
  self.rotateRoot:Set_eulerAngles(0, 0, 0)
  if tonumber(self.originalHeroId) == Const.TRUCK_HERO_ID then
    self.dummyTrans = self.transform:Find(Const.TRUCK_GOODS_GROUP_DUMMY)
  end
  self:ComponentDefineWithoutView()
  self:InitFSM()
  if 0 >= self.curBlood then
    self:Die()
    return
  end
  local appearanceMeta = self.appearanceMeta
  local fire_paths = appearanceMeta.fire_paths
  local firePathCount = #fire_paths
  local append = UnitViewFacade.InitFirePoints(self.viewHandle, appearanceMeta.id, firePathCount)
  if append then
    for i = 1, firePathCount do
      UnitViewFacade.AppendFirePoint(self.viewHandle, fire_paths[i])
    end
  end
  self.firePoint = UnitViewFacade.GetFirePointById(self.viewHandle, 1)
  self.firePointNull = IsNull(self.firePoint)
  if not self.meta.is_human then
    self.cannon = UnitViewFacade.InitCannon(self.viewHandle, appearanceMeta.canon_path)
    if self.cannon == nil then
      self.cannon = self.transform
    end
    local canonFix = appearanceMeta.canon_rotation
    if canonFix and #canonFix == 3 then
      self.localForward = Vector3.forward * Quaternion.Euler(canonFix[1], canonFix[2], canonFix[3])
    end
  else
    self.cannon = self.transform
  end
  self.angular_speed_deg = self.meta.angular_speed * 60
  if not table.IsNullOrEmpty(appearanceMeta.buff_path) then
    local buffCount = #appearanceMeta.buff_path
    UnitViewFacade.InitBuffPoints(self.viewHandle, buffCount)
    for i = 1, buffCount do
      UnitViewFacade.AppendBuffPoint(self.viewHandle, appearanceMeta.buff_path[i])
    end
  end
  if not string.IsNullOrEmpty(appearanceMeta.ui_path) then
    UnitViewFacade.InitUIPoint(self.viewHandle, appearanceMeta.ui_path)
  end
  self.delayFrameToLoadComps = 2
  self:InitSkill()
  self:TryReplaceSkill()
  if self.isExiting then
    self:StartExiting()
  end
  self:ShowBornTween()
  self:ShowBornEffect(MEMBER_GET_EFFECT_PATH)
end

function SkyHeroUnit:SetSlot(slot)
  self.slot = slot
end

function SkyHeroUnit:ComponentDefine()
  base.ComponentDefine(self)
  self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
  if not IsNull(self.anim) then
    self.anim.transform:Set_localPosition(0, 0, 0)
  end
  self.collider.gameObject.layer = LayerMask.NameToLayer("Member")
end

function SkyHeroUnit:InitHeroData(hero)
  self.skillManager = SkillManager.New(self.logic, self)
  self.skillManager.battleMgr = DataCenter.LWBattleManager.logic
  self.hero = hero
end

function SkyHeroUnit:InitSkill()
  if CS.CommonUtils.IsDebug() and LOCAL_HERO_SKILL_OVERRIDE then
    for k, id in pairs(self.meta.skills) do
      local skillData = SkillInfo.New()
      local message = {}
      message.skillId = id
      message.heroUuid = 0
      message.slot = k
      message.state = 1
      message.uuid = 0
      skillData:UpdateSkillInfo(message)
      if skillData.skillTemplateData == nil then
        Logger.LogError("\230\183\187\229\138\160\230\138\128\232\131\189\230\151\182\239\188\140\230\138\128\232\131\189\233\133\141\231\189\174\230\137\190\228\184\141\229\136\176,\230\138\128\232\131\189Id\239\188\154" .. id)
      end
      self.skillManager:AddSkill(skillData.skillTemplateData, skillData)
      break
    end
  else
    local skills = self.hero:GetAllUnlockSkills()
    for _, skillInfo in pairs(skills) do
      if skillInfo.skillTemplateData == nil then
        Logger.LogError("\230\183\187\229\138\160\230\138\128\232\131\189\230\151\182\239\188\140\230\138\128\232\131\189\233\133\141\231\189\174\230\137\190\228\184\141\229\136\176,\230\138\128\232\131\189Id\239\188\154" .. skillInfo.id)
      end
      self.skillManager:AddSkill(skillInfo.skillTemplateData, skillInfo)
    end
  end
  self.skillManager:CheckSpecialStraightBulletType()
  if CS.CommonUtils.IsDebug() and INVINCIBLE then
    self:SetInvincible(true)
    self:AddHaloBuff(string.format("%s/%s", self:GetGuid(), -1), {
      [HeroEffectDefine.BuffAttackAddRate] = 99999
    })
  end
end

function SkyHeroUnit:TryReplaceSkill()
  if self.logic.GetReplaceNormalSkill then
    local replaceSkill = self.logic:GetReplaceNormalSkill(self.meta.id)
    if 0 < replaceSkill then
      local skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(replaceSkill)
      if skillMeta ~= nil then
        self.skillManager:ReplaceNormalAttack(skillMeta)
        self.skillManager:CheckSpecialStraightBulletType()
      end
    end
  end
end

function SkyHeroUnit:InitFSM()
  if self.fsm then
    return
  end
  self.fsm = FSM.New()
  self.fsm:AddState(Const.ParkourFireState.Stay, StayState.New(self))
  self.fsm:AddState(Const.ParkourFireState.Straight, FireStateMultiSkillStraight.New(self))
  self.fsm:AddState(Const.ParkourFireState.RotateAndShoot, FireStateAuto.New(self))
  self.fsm:AddState(Const.ParkourFireState.HoldFire, FireStateHold.New(self))
  self.fsm:AddState(Const.ParkourFireState.Dead, HeroDieState.New(self))
  self.fsm:AddState(Const.ParkourFireState.PreDashBonus, PreDashBonus.New(self))
  self.fsm:ChangeState(Const.ParkourFireState.Stay)
  base.InitFSM(self)
end

function SkyHeroUnit:OnUpdate(deltaTime, new)
  base.OnUpdate(self, deltaTime)
  if self.fsm then
    self.fsm:OnUpdate()
  end
  if self.skillManager then
    self.skillManager:OnUpdate(deltaTime)
  end
  if self.energyBar then
    self.energyBar:Update()
  end
  self:UpdateModelScale(deltaTime)
  if self.bloodDirty then
    self.bloodDirty = false
    self.hpBarVisibleTime = HP_BAR_VISIBLE_TIME
    if self.curBlood > 0 then
      if self.hpBarHandle then
        pveUnitViewUtil.SetHpBar(self.hpBarHandle, self.curBlood, self.maxBlood, self:GetShieldValue())
      else
        local offsetX
        if self.skillBar ~= nil then
          offsetX = 35.0
        end
        self.hpBarHandle = pveUnitViewUtil.CreateSelfHpBarWithHandle(self.viewHandle, 2.0, offsetX, self.curBlood, self.maxBlood, nil)
      end
      pveUnitViewUtil.EnableHpBar(self.hpBarHandle, true)
    end
  end
  if 0 < self.delayFrameToLoadComps then
    self.delayFrameToLoadComps = self.delayFrameToLoadComps - 1
    if self.delayFrameToLoadComps == 0 and self.curBlood > 0 then
      self:ShowBornEffect()
    end
  end
  if self.hpBarHandle and self.hpBarVisibleTime and self.hpBarVisibleTime > 0 then
    self.hpBarVisibleTime = self.hpBarVisibleTime - deltaTime
    if self.hpBarVisibleTime <= 0 then
      pveUnitViewUtil.EnableHpBar(self.hpBarHandle, false)
    end
  end
end

function SkyHeroUnit:GetFirePoint()
  return self.firePoint, self.firePointNull
end

function SkyHeroUnit:GetFirePointById(id)
  local point = UnitViewFacade.GetFirePointById(self.viewHandle, id)
  if point ~= nil then
    return point, false
  end
  return self:GetFirePoint()
end

function SkyHeroUnit:GetMoveVelocity()
  if self.fsm and self.fsm:GetStateIndex() == Const.ParkourFireState.Straight then
    return Vector3.New(0, 0, self.team.speedZ)
  else
    return Vector3.zero
  end
end

function SkyHeroUnit:HideHpBar()
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

function SkyHeroUnit:DestroyView()
  self:ClearModelScaleEffect()
  self.MPB = nil
  self.MPBColor = nil
  self.modelScaleTimer = -1
  self.isNew = nil
  self.rotateRoot = nil
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
  if self.fsm then
    self.fsm:Delete()
    self.fsm = nil
  end
  if self.directionRotateSequence then
    self.directionRotateSequence:Kill()
    self.directionRotateSequence = nil
  end
  UnitViewFacade.ResetCannon(self.viewHandle)
  if self.skillManager then
    self.skillManager:DestroyView()
  end
  self.firePoint = nil
  if self.viewLoaded then
    self.curWorldPos.x, self.curWorldPos.y, self.curWorldPos.z = UnitViewFacade.GetPositionXYZ(self.viewHandle)
  end
  self.appearanceReplacing = false
  UnitViewFacade.DestroyUnitView(self.viewHandle)
  self.viewHandle = VIEW_INVALID_HANDLE
  self.viewLoaded = false
  if self.newAppearanceViewHandle then
    UnitViewFacade.DestroyUnitView(self.newAppearanceViewHandle)
    self.newAppearanceViewHandle = nil
    self.newAppearanceViewLoaded = false
  end
  base.DestroyView(self)
end

function SkyHeroUnit:DestroyData()
  base.DestroyData(self)
  if self.skillManager then
    self.skillManager:DestroyData()
    self.skillManager = nil
  end
  self.originalHeroId = nil
  self.lastUnitMoveDirectionState = nil
end

function SkyHeroUnit:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff)
  if self.invincible then
    return
  end
  base.BeAttack(self, hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff)
  if 0 < hurt then
    hurt = self:ReduceShieldValue(hurt)
    self.curBlood = math.max(self.curBlood - hurt, 0)
    if 0 < hurt and 0 < self.curBlood then
      self.bloodDirty = true
    end
    if self.fsm and 0 >= self.curBlood then
      self.fsm:ChangeState(Const.ParkourFireState.Dead)
      if not self.triggerdDeathSkill then
        self:TriggerSkill(SkillTriggerType.Death)
        self.triggerdDeathSkill = true
      end
    end
  end
end

function SkyHeroUnit:AfterBeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill, deathEff)
  if self.invincible then
    return
  end
  base.AfterBeAttack(self, hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill, deathEff)
end

function SkyHeroUnit:GetRawProperty(type)
  if self.hero == nil then
    return 0
  end
  return self.hero:GetHeroProperty(type)
end

function SkyHeroUnit:ChangeStage(stage)
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
    if self.fsm then
      self.fsm:ChangeState(Const.ParkourFireState.HoldFire)
    end
  elseif stage == Const.ParkourBattleState.Exit then
    self:SetInvincible(true)
    if self.fsm then
      self.fsm:ChangeState(Const.ParkourFireState.HoldFire)
    end
  elseif stage == Const.ParkourBattleState.DashBonusExit then
    self:SetInvincible(true)
    if self.fsm then
      self.fsm:ChangeState(Const.ParkourFireState.HoldFire)
    end
  elseif stage == Const.ParkourBattleState.Farm then
    if self.fsm then
      self.fsm:ChangeState(Const.ParkourFireState.Straight)
    end
    local skillBarTransform = self:GetBuffTransform()
    if self.logic.showHeroEnergy and not self.energyBar then
      self.energyBar = EnergyBarCell.New()
      self.energyBar:Load(self, skillBarTransform, 2)
      self.energyBar:SetEnergy(self.energy)
    end
  elseif stage == Const.ParkourBattleState.DashBonus then
    if self.fsm then
      self.fsm:ChangeState(Const.ParkourFireState.Stay)
    end
    if self.skillManager then
      self.skillManager:Interrupt()
    end
  elseif stage == Const.ParkourBattleState.PreDashBonus then
    if self.fsm then
      self.fsm:ChangeState(Const.ParkourFireState.PreDashBonus)
    end
    if self.skillManager then
      self.skillManager:Interrupt()
    end
  end
end

function SkyHeroUnit:GetMoveSpeed()
  return self.meta.speed_control * (1 + self:GetProperty(HeroEffectDefine.BattleHeroMoveSpeed))
end

function SkyHeroUnit:GetLocationType()
  return self.slot > 2 and LocationType.Back or LocationType.Front
end

function SkyHeroUnit:GetHeroCamp()
  return self.hero.heroType
end

function SkyHeroUnit:ReplaceAppearance(newHeroId)
  if self.newAppearanceViewHandle and self.newAppearanceViewHandle ~= VIEW_INVALID_HANDLE then
    self.newAppearanceViewHandle = UnitViewFacade.DestroyUnitView(self.newAppearanceViewHandle)
  end
  local newHeroInfo = HeroInfo.New()
  newHeroInfo:UpdateFromTemplate(newHeroId)
  self.newHeroInfo = newHeroInfo
  local modelPath, appearanceId, modelSourceType = newHeroInfo:GetHeroModelData(HeroModelType.Battle)
  local path = modelPath
  local appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
  local scale = appearanceMeta.model_size * self:GetModelScaleValue()
  self.appearanceReplacing = true
  self.newAppearanceViewHandle, self.newAppearanceViewLoaded = pveUnitViewUtil.CreateUnitView(self.guid, path, self.parent, scale, self.localPosition.x, self.localPosition.y, self.localPosition.z, ResetPosition.x, ResetPosition.y, ResetPosition.z, LayerMask.NameToLayer("Member"))
  if self.newAppearanceViewLoaded then
    self:OnReplaceViewLoaded(true)
  end
end

function SkyHeroUnit:OnReplaceViewLoaded(force)
  self.appearanceReplacing = false
  if self.newAppearanceViewLoaded and not force then
    return
  end
  self.newAppearanceViewLoaded = true
  self.hero = self.newHeroInfo
  self.meta = self.hero.meta
  self.appearanceMeta = self.hero.appearanceMeta
  self.heroEffectMeta = DataCenter.PveHeroEffectTemplateManager:GetTemplate(self.meta.hero_effect)
  local anim = self:GetCurAnimName()
  UnitViewFacade.DestroyUnitView(self.viewHandle)
  self.viewHandle = self.newAppearanceViewHandle
  self.viewLoaded = true
  self.newAppearanceViewHandle = VIEW_INVALID_HANDLE
  self:ComponentDefineWithoutView()
  self.gameObject = UnitViewFacade.GetGameObject(self.viewHandle)
  local transform = UnitViewFacade.GetTransform(self.viewHandle)
  self.transform = transform
  self.rotateRoot = UnitViewFacade.GetRotateRoot(self.viewHandle)
  if self.hpBarHandle then
    pveUnitViewUtil.ReplaceHpBarTargetWithHandle(self.hpBarHandle, self.viewHandle)
  else
    self.delayFrameToLoadComps = 2
  end
  local appearanceMeta = self.appearanceMeta
  local fire_paths = appearanceMeta.fire_paths
  local firePathCount = #fire_paths
  local append = UnitViewFacade.InitFirePoints(self.viewHandle, appearanceMeta.id, firePathCount)
  if append then
    for i = 1, firePathCount do
      UnitViewFacade.AppendFirePoint(self.viewHandle, fire_paths[i])
    end
  end
  self.firePoint = UnitViewFacade.GetFirePointById(self.viewHandle, 1)
  self.firePointNull = IsNull(self.firePoint)
  if not self.meta.is_human then
    self.cannon = UnitViewFacade.InitCannon(self.viewHandle, appearanceMeta.canon_path)
    if self.cannon == nil then
      self.cannon = self.transform
    end
    local canonFix = appearanceMeta.canon_rotation
    if canonFix and #canonFix == 3 then
      self.localForward = Vector3.forward * Quaternion.Euler(canonFix[1], canonFix[2], canonFix[3])
    end
  else
    self.cannon = self.transform
  end
  self.angular_speed_deg = self.meta.angular_speed * 60
  if not table.IsNullOrEmpty(appearanceMeta.buff_path) then
    local buffCount = #appearanceMeta.buff_path
    UnitViewFacade.InitBuffPoints(self.viewHandle, buffCount)
    for i = 1, buffCount do
      UnitViewFacade.AppendBuffPoint(self.viewHandle, appearanceMeta.buff_path[i])
    end
  end
  self.skillManager:RemoveAllSkills()
  self:ShowBornEffect()
  self:InitSkill()
  self:ShowBornTween()
  self:RewindAndPlaySimpleAnim(anim)
  self:InitFSM()
  self.maxBlood = self.hero:GetMaxHp()
  self.curBlood = Mathf.Max(self.curBlood, self.maxBlood)
  if self.hpBarHandle then
    pveUnitViewUtil.SetHpBar(self.hpBarHandle, self.curBlood, self.maxBlood, self:GetShieldValue())
  end
  self:OnBuffPropertyDirty()
end

function SkyHeroUnit:AddEnergy(fromPos)
  self.energy = self.energy + 1
  if self.energyBar then
    self.energyBar:SetEnergy(self.energy, fromPos)
  end
  self:TriggerEnergyEvent()
end

function SkyHeroUnit:ShowEnergyEffect()
  if self.skillBar then
    self.skillBar:ShowPowerEffect()
  end
end

function SkyHeroUnit:TriggerEnergyEvent()
  local heroId = self.hero.heroId
  local energyCount = self.energy
  local template = DataCenter.LWHeroEnergyLevelUpTemplateManager:GetTemplate(heroId)
  if template then
    local effectArray = template:GetEnergyEffect(energyCount)
    if effectArray then
      local triggerEventMgr = self.logic.triggerEventMgr
      if triggerEventMgr then
        for _, eventId in ipairs(effectArray) do
          local meta = DataCenter.LWTriggerItemTemplateManager:GetTemplate(eventId)
          if meta and meta.isUnAddEnergyType then
            triggerEventMgr:Trigger(meta.type, meta, heroId)
            if not string.IsNullOrEmpty(meta.desc) then
              self.logic:ShowDamageText(Localization:GetString(meta.desc), self:GetPosition(), DamageTextType.GetBuff, nil, false, meta.text_time)
            end
          end
        end
      end
    end
  end
end

function SkyHeroUnit:OnBuffAdded(buff)
  base.OnBuffAdded(self, buff)
  if buff.meta.type == BuffType.ModelScale and self.curBlood > 0 and self.viewHandle and self.appearanceMeta then
    local scale = self.appearanceMeta.model_size * self:GetModelScaleValue()
    self.modelScaleEnd = scale
    self.modelScaleTimer = 0
    self.modelScaleStart = UnitViewFacade.GetLocalScaleX(self.viewHandle)
    UnitViewFacade.MPBModelScale(self.viewHandle)
  end
end

function SkyHeroUnit:OnBuffRemoved(buff)
  if buff.meta.type == BuffType.ModelScale then
    if self.curBlood > 0 then
      local scale = self.appearanceMeta.model_size * self:GetModelScaleValue()
      self.modelScaleEnd = scale
      self.modelScaleTimer = 0
      self.modelScaleStart = UnitViewFacade.GetLocalScaleX(self.viewHandle)
    end
    self:ClearModelScaleEffect()
  end
  base.OnBuffRemoved(self, buff)
end

function SkyHeroUnit:ClearModelScaleEffect()
  UnitViewFacade.MPBResetModelScale(self.viewHandle)
end

function SkyHeroUnit:UpdateModelScale(deltaTime)
  if self.modelScaleTimer >= 0 then
    self.modelScaleTimer = self.modelScaleTimer + deltaTime
    local scale = self.modelScaleEnd
    if self.modelScaleTimer >= ModelScaleDuration then
      self.modelScaleTimer = -1
    else
      scale = Mathf.Lerp(self.modelScaleStart, self.modelScaleEnd, self.modelScaleTimer / ModelScaleDuration)
    end
    UnitViewFacade.SetLocalScaleX(self.viewHandle, scale)
  end
end

function SkyHeroUnit:ForceCastUltimate(ultimateSkill)
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

function SkyHeroUnit:LeftRightActionValid()
  return true
end

function SkyHeroUnit:GetUnitPositionInTeam()
  if self.team then
    return self.team:GetUnitPosition(self.guid)
  end
  return Vector3.zero
end

function SkyHeroUnit:Die()
  self.curBlood = 0
  if self.fsm and self.fsm:GetStateIndex() ~= Const.ParkourFireState.Dead then
    self.fsm:ChangeState(Const.ParkourFireState.Dead)
  end
end

function SkyHeroUnit:TriggerSkill(triggerType, param)
  if self.skillManager then
    self.skillManager:PassiveCast(triggerType, param)
  end
end

function SkyHeroUnit:SetLocalPosition(pos)
  self.localPosition = pos
  UnitViewFacade.SetLocalPosition(self.viewHandle, pos.x, pos.y, pos.z)
end

function SkyHeroUnit:SetPosition(worldPos)
  UnitViewFacade.SetPosition(self.viewHandle, worldPos.x, worldPos.y, worldPos.z)
end

function SkyHeroUnit:MoveToLocalPos(dstLocalPos, time)
  if time <= 0 then
    self:SetLocalPosition(dstLocalPos)
    return
  end
  UnitViewFacade.MoveToLocalPos(self.viewHandle, dstLocalPos.x, dstLocalPos.y, dstLocalPos.z, time)
end

local TweenSequence = CS.DG.Tweening.DOTween
local Ease = CS.DG.Tweening.Ease
local RotateMode = CS.DG.Tweening.RotateMode
local rollSpeed = 0.6
local settleTime = 0.35
local tiltAngleSide = 25
local tiltAngleForward = 8
local fullRollAngle = 320
local Vector3Zero = Vector3.New(0, 0, 0)

function SkyHeroUnit:DoDirectionRotate(skyBattleMoveDirectionState, rotationAngle)
  if not self.rotateRoot then
    return
  end
  if self.directionRotateSequence then
    self.directionRotateSequence:Kill()
  end
  local sequence = TweenSequence.Sequence()
  if skyBattleMoveDirectionState == SkyBattleMoveDirectionState.Idle then
    sequence:Append(self.rotateRoot:DOLocalRotate(Vector3Zero, settleTime):SetEase(Ease.InOutSine))
  elseif skyBattleMoveDirectionState == SkyBattleMoveDirectionState.Left or skyBattleMoveDirectionState == SkyBattleMoveDirectionState.Right then
    local dir = skyBattleMoveDirectionState == SkyBattleMoveDirectionState.Left and 1 or -1
    local finalAngle = dir * rotationAngle
    if self.lastUnitMoveDirectionState == SkyBattleMoveDirectionState.Left or self.lastUnitMoveDirectionState == SkyBattleMoveDirectionState.Right then
      sequence:Append(self.rotateRoot:DOLocalRotate(Vector3Zero, 0.1):SetEase(Ease.OutSine))
    end
    sequence:Append(self.rotateRoot:DOLocalRotate(Vector3.New(0, 0, finalAngle), rollSpeed * 0.5):SetEase(Ease.OutSine))
  elseif skyBattleMoveDirectionState == SkyBattleMoveDirectionState.Forward or skyBattleMoveDirectionState == SkyBattleMoveDirectionState.BackWard then
    local dir = skyBattleMoveDirectionState == SkyBattleMoveDirectionState.Forward and 1 or -1
    local pitchAngle = dir * rotationAngle
    if not self.lastUnitMoveDirectionState or self.lastUnitMoveDirectionState ~= skyBattleMoveDirectionState then
      sequence:Append(self.rotateRoot:DOLocalRotate(Vector3Zero, 0.1):SetEase(Ease.InOutSine))
      sequence:Append(self.rotateRoot:DOLocalRotate(Vector3.New(pitchAngle, 0, 0), rollSpeed * 0.8):SetEase(Ease.InOutSine))
    end
  end
  self.lastUnitMoveDirectionState = skyBattleMoveDirectionState
  self.directionRotateSequence = sequence
  sequence:Play()
end

return SkyHeroUnit
