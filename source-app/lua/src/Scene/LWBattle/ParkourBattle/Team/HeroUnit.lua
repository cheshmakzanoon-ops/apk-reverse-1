local base = require("Scene.LWBattle.ParkourBattle.Team.MemberUnit")
local HeroUnit = BaseClass("HeroUnit", base)
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local FSM = require("Framework.Common.FSM")
local StayState = require("Scene.LWBattle.ParkourBattle.Team.FSM.StayState")
local FireStateStraight = require("Scene.LWBattle.ParkourBattle.Team.FSM.FireStateStraight")
local FireStateDefenseStraight = require("Scene.LWBattle.ParkourBattle.Team.FSM.FireStateDefenseStraight")
local FireStateAuto = require("Scene.LWBattle.BarrageBattle.MemberState.MemberUpStateAutoAttack")
local FireStateHold = require("Scene.LWBattle.ParkourBattle.Team.FSM.FireStateHold")
local HeroDieState = require("Scene.LWBattle.ParkourBattle.Team.FSM.HeroDieState")
local PreDashBonus = require("Scene.LWBattle.ParkourBattle.Team.FSM.PreDashBonus")
local Const = require("Scene.LWBattle.Const")
local SkillManager = require("Scene.LWBattle.Skill.SkillManager")
local SkillBarCell = require("DataCenter.ZombieBattle.HpBar.SkillBarCell")
local EnergyBarCell = require("DataCenter.ZombieBattle.HpBar.EnergyBarCell")
local TriggerEnum = require("Scene.LWBattle.ParkourBattle.TriggerEvent.TriggerEnum")
local ModelScaleDuration = 0.4
local pveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local UnitViewFacade = CS.PVEBattleLogic.Unit.UnitViewFacade
local VIEW_INVALID_HANDLE = -1
local HpBarTypeByChangeMax = {
  [ParkourHpBarType.SoldierSmall] = ParkourHpBarType.Self
}

function HeroUnit:Init(logic, team, parent, localPos, hero, forceIsHuman, originalHeroId, createByList, viewLoadedCallback, bornEffectPath)
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
    if modelPath and appearanceId then
      path = modelPath
      self.appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
    else
      path = hero.appearanceMeta.model_path
      self.appearanceMeta = hero.appearanceMeta
    end
    local newAppearanceMeta, isReplace = self:TryGetHeroNewAppearance(hero)
    if isReplace then
      path = newAppearanceMeta.model_path
      self.appearanceMeta = newAppearanceMeta
    end
    self.leftRightAction = self.appearanceMeta.left_right_action
  end
  self.heroEffectMeta = DataCenter.PveHeroEffectTemplateManager:GetTemplate(self.meta.hero_effect)
  self:InitHeroData(hero)
  self.maxBlood = self.hero:GetMaxHp()
  self.originalMaxBlood = self.maxBlood
  self.curBlood = self.maxBlood
  self.isFreeMove = logic.GetPVEType and logic:GetPVEType() == PVEType.LastStand
  self.energy = 0
  self.MPB = nil
  self.MPBColor = nil
  self.modelScaleStart = 1
  self.modelScaleEnd = 1
  self.modelScaleTimer = -1
  self.triggerdDeathSkill = false
  self.delayHpBar = 0
  self.customBornEffectPath = bornEffectPath
  self.viewLoaded = false
  self.viewHandle = VIEW_INVALID_HANDLE
  local appearanceMeta = self.appearanceMeta and self.appearanceMeta or hero.appearanceMeta
  local scale = appearanceMeta.model_size * self:GetModelScaleValue()
  createByList = createByList or false
  if not DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    createByList = false
  end
  if createByList then
    self.viewLoadedCallback = viewLoadedCallback
    pveUnitViewUtil.CreateUnitViewListRequest(self, self.guid, path, self.parent, scale, self.localPosition.x, self.localPosition.y, self.localPosition.z, ResetPosition.x, ResetPosition.y, ResetPosition.z, LayerMask.NameToLayer("Member"))
    self.appearanceReplacing = false
  else
    self.viewHandle, self.viewLoaded = pveUnitViewUtil.CreateUnitView(self.guid, path, self.parent, scale, self.localPosition.x, self.localPosition.y, self.localPosition.z, ResetPosition.x, ResetPosition.y, ResetPosition.z, LayerMask.NameToLayer("Member"))
    if self.viewLoaded then
      self:OnViewLoaded(true)
    end
    self.isNew = false
    self.slot = 0
    self.bloodDirty = false
    self.isHideHpBar = false
  end
end

function HeroUnit:OnViewLoaded(force, objHandle)
  if self.appearanceReplacing and objHandle and self.newAppearanceViewHandle and objHandle == self.newAppearanceViewHandle then
    self:OnReplaceViewLoaded()
    return
  end
  if self.viewLoaded and not force then
    return
  end
  self.viewLoaded = true
  self.gameObject = UnitViewFacade.GetGameObject(self.viewHandle)
  self.transform = UnitViewFacade.GetTransform(self.viewHandle)
  if tonumber(self.originalHeroId) == Const.TRUCK_HERO_ID then
    self.dummyTrans = self.transform:Find(Const.TRUCK_GOODS_GROUP_DUMMY)
  end
  self:ComponentDefineWithoutView()
  self:InitFSM()
  if self.curBlood <= 0 then
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
  self.delayHpBar = 2
  self:InitSkill()
  self:TryReplaceSkill()
  if self.isExiting then
    self:StartExiting()
  end
  self:ShowBornTween()
  if self.viewHandle then
    UnitViewFacade.MPBResetGray(self.viewHandle)
  else
    for _, v in pairs(self.renders) do
      CS.AppearenceUtils.GrayEffect(v.renderer, false)
    end
  end
end

function HeroUnit:SetSlot(slot)
  self.slot = slot
end

function HeroUnit:ComponentDefine()
  base.ComponentDefine(self)
  self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
  if not IsNull(self.anim) then
    self.anim.transform:Set_localPosition(0, 0, 0)
  end
  self.collider.gameObject.layer = LayerMask.NameToLayer("Member")
end

function HeroUnit:InitHeroData(hero)
  self.skillManager = SkillManager.New(self.logic, self)
  self.skillManager.battleMgr = DataCenter.LWBattleManager.logic
  self.hero = hero
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    self.heroPropertyData = self.hero.propertyData:GetAllPropertyReadOnly()
  end
end

function HeroUnit:InitSkill()
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
      local newSkillInfo = skillInfo
      newSkillInfo = DataCenter.LWHeroUpgradePVEManager:GetHeroUpgradeSkillInfoData(self.hero, skillInfo)
      newSkillInfo = DataCenter.LWArmedUpgradeManager:GetArmedUpgradeSkillInfoData(self.hero, newSkillInfo, false)
      if newSkillInfo.skillTemplateData == nil then
        Logger.LogError("\230\183\187\229\138\160\230\138\128\232\131\189\230\151\182\239\188\140\230\138\128\232\131\189\233\133\141\231\189\174\230\137\190\228\184\141\229\136\176,\230\138\128\232\131\189Id\239\188\154" .. newSkillInfo.skillId)
      end
      self.skillManager:AddSkill(newSkillInfo.skillTemplateData, newSkillInfo)
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

function HeroUnit:TryReplaceSkill()
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
  if self.logic.GetReplaceActiveSkill then
    local replaceSkill = self.logic:GetReplaceActiveSkill(self.meta.id)
    if 0 < replaceSkill then
      local skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(replaceSkill)
      if skillMeta ~= nil then
        self.skillManager:ReplaceActiveAttack(skillMeta)
        self.skillManager:CheckSpecialStraightBulletType()
      end
    end
  end
end

function HeroUnit:InitFSM()
  self.fsm = FSM.New()
  self.fsm:AddState(Const.ParkourFireState.Stay, StayState.New(self))
  if self.logic.battleType and self.logic.battleType == Const.ParkourBattleType.Defense then
    self.fsm:AddState(Const.ParkourFireState.Straight, FireStateDefenseStraight.New(self))
  else
    self.fsm:AddState(Const.ParkourFireState.Straight, FireStateStraight.New(self))
  end
  self.fsm:AddState(Const.ParkourFireState.RotateAndShoot, FireStateAuto.New(self))
  self.fsm:AddState(Const.ParkourFireState.HoldFire, FireStateHold.New(self))
  self.fsm:AddState(Const.ParkourFireState.Dead, HeroDieState.New(self))
  self.fsm:AddState(Const.ParkourFireState.PreDashBonus, PreDashBonus.New(self))
  self.fsm:ChangeState(Const.ParkourFireState.Stay)
  base.InitFSM(self)
end

function HeroUnit:OnUpdate(deltaTime, new)
  base.OnUpdate(self, deltaTime)
  if self.fsm then
    self.fsm:OnUpdate()
  end
  if self.skillManager then
    self.skillManager:OnUpdate(deltaTime)
    if self.cacheReplaceNormalAttackSkillMeta ~= nil and self.skillManager:GetCastingSkill() == nil then
      local skillMeta = self.cacheReplaceNormalAttackSkillMeta
      self.cacheReplaceNormalAttackSkillMeta = nil
      self:ReplaceNormalAttackWithoutInterrupt(skillMeta)
      self.skillManager:CheckSpecialStraightBulletType()
    end
    if self.cacheReplaceActiveAttackSkillMeta ~= nil and self.skillManager:GetCastingSkill() == nil then
      local skillMeta = self.cacheReplaceActiveAttackSkillMeta
      self.cacheReplaceActiveAttackSkillMeta = nil
      self:ReplaceActiveAttackWithoutInterrupt(skillMeta)
      self.skillManager:CheckSpecialStraightBulletType()
    end
  end
  if self.energyBar then
    self.energyBar:Update()
  end
  self:UpdateModelScale(deltaTime)
  self:UpdateHpBarAndBornEffect()
end

function HeroUnit:GetFirePoint()
  return self.firePoint, self.firePointNull
end

function HeroUnit:GetFirePointById(id)
  local point = UnitViewFacade.GetFirePointById(self.viewHandle, id)
  if point ~= nil then
    return point, false
  end
  return self:GetFirePoint()
end

function HeroUnit:GetMoveVelocity()
  if self.fsm and self.fsm:GetStateIndex() == Const.ParkourFireState.Straight then
    return Vector3.New(0, 0, self.team.speedZ)
  else
    return Vector3.zero
  end
end

function HeroUnit:HideHpBar()
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

function HeroUnit:DestroyView()
  self:ClearModelScaleEffect()
  self.MPB = nil
  self.MPBColor = nil
  self.modelScaleTimer = -1
  self.isNew = nil
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
  self:DestroyTruckGoods()
  base.DestroyView(self)
end

function HeroUnit:DestroyData()
  base.DestroyData(self)
  if self.skillManager then
    self.skillManager:DestroyData()
    self.skillManager = nil
  end
  self.originalHeroId = nil
  self.cacheReplaceNormalAttackSkillMeta = nil
  self.cacheReplaceActiveAttackSkillMeta = nil
  self.originalMaxBlood = nil
  self.changeMaxBlood = false
end

function HeroUnit:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff)
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
        self:Die()
      end
      if not self.triggerdDeathSkill then
        self:TriggerSkill(SkillTriggerType.Death)
        self.triggerdDeathSkill = true
      end
    end
  end
end

function HeroUnit:AfterBeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill, deathEff)
  if self.invincible then
    return
  end
  base.AfterBeAttack(self, hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill, deathEff)
end

function HeroUnit:BeHeal(hp)
  base.BeAttack(self, hp)
  if self.curBlood > 0 and self.curBlood < self.maxBlood then
    self.curBlood = math.min(self.curBlood + hp, self.maxBlood)
    self.bloodDirty = true
  end
end

function HeroUnit:GetRawProperty(type)
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    if self.heroPropertyData == nil then
      return 0
    end
    return self.heroPropertyData[type] or 0
  else
    if self.hero == nil then
      return 0
    end
    return self.hero:GetHeroProperty(type)
  end
end

function HeroUnit:ChangeStage(stage)
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
    if self.logic.battleType and self.logic.battleType == Const.ParkourBattleType.Defense and (self.hero.uuid > 0 or self.hero.fromTemplate and self.hero.uuid < 0) then
      local skillBarTransform = self:GetBuffTransform()
      if not self.skillBar then
        self.skillBar = SkillBarCell.New()
        self.skillBar:Load(self, skillBarTransform, 2)
        if self.hpBarHandle then
          pveUnitViewUtil.SetHpBarOffsetX(self.viewHandle, 35.0)
        end
      end
      if self.logic.showHeroEnergy and not self.energyBar then
        self.energyBar = EnergyBarCell.New()
        self.energyBar:Load(self, skillBarTransform, 2)
        self.energyBar:SetEnergy(self.energy)
      end
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
  elseif stage == Const.ParkourBattleState.KatyushaSpecialBonus and self.fsm then
    self.fsm:ChangeState(Const.ParkourFireState.RotateAndShoot)
  end
end

function HeroUnit:GetMoveSpeed()
  return self.meta.speed_control * (1 + self:GetProperty(HeroEffectDefine.BattleHeroMoveSpeed))
end

function HeroUnit:GetLocationType()
  return self.slot > 2 and LocationType.Back or LocationType.Front
end

function HeroUnit:GetHeroCamp()
  return self.hero.heroType
end

function HeroUnit:ReplaceAppearance(newHeroId, appearanceMap, saveLv)
  if self.newAppearanceViewHandle and self.newAppearanceViewHandle ~= VIEW_INVALID_HANDLE then
    self.newAppearanceViewHandle = UnitViewFacade.DestroyUnitView(self.newAppearanceViewHandle)
  end
  local newLv
  if saveLv and self.hero then
    newLv = self.hero.level
  end
  local newHeroInfo, needInit
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    newHeroInfo, needInit = self.logic:GetSharedHeroInfo(newHeroId)
    if needInit then
      newHeroInfo:UpdateFromTemplate(newHeroId, newLv)
      if appearanceMap then
        newHeroInfo:ReplaceAppearance(appearanceMap)
      end
    end
  else
    newHeroInfo = HeroInfo.New()
    newHeroInfo:UpdateFromTemplate(newHeroId, newLv)
    if appearanceMap then
      newHeroInfo:ReplaceAppearance(appearanceMap)
    end
  end
  self.newHeroInfo = newHeroInfo
  local path = newHeroInfo.appearanceMeta.model_path
  local appearanceMeta = newHeroInfo.appearanceMeta
  local newAppearanceMeta, isReplace = self:TryGetHeroNewAppearance(newHeroInfo)
  if isReplace then
    appearanceMeta = newAppearanceMeta
    path = newAppearanceMeta.model_path
  end
  local scale = appearanceMeta.model_size * self:GetModelScaleValue()
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    pveUnitViewUtil.CreateUnitViewListRequest(self, self.guid, path, self.parent, scale, self.localPosition.x, self.localPosition.y, self.localPosition.z, ResetPosition.x, ResetPosition.y, ResetPosition.z, LayerMask.NameToLayer("Member"))
    self.appearanceReplacing = true
  else
    self.appearanceReplacing = true
    self.newAppearanceViewHandle, self.newAppearanceViewLoaded = pveUnitViewUtil.CreateUnitView(self.guid, path, self.parent, scale, self.localPosition.x, self.localPosition.y, self.localPosition.z, ResetPosition.x, ResetPosition.y, ResetPosition.z, LayerMask.NameToLayer("Member"))
    if self.newAppearanceViewLoaded then
      self:OnReplaceViewLoaded(true, false)
    end
  end
end

function HeroUnit:OnReplaceViewLoaded(force, showBornEffect)
  self.appearanceReplacing = false
  if self.newAppearanceViewLoaded and not force then
    return
  end
  self.newAppearanceViewLoaded = true
  self.hero = self.newHeroInfo
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    self.heroPropertyData = self.hero.propertyData:GetAllPropertyReadOnly()
  end
  self.meta = self.hero.meta
  self.appearanceMeta = self.hero.appearanceMeta
  local newAppearanceMeta, isReplace = self:TryGetHeroNewAppearance(self.hero)
  if isReplace then
    self.appearanceMeta = newAppearanceMeta
  end
  self.heroEffectMeta = DataCenter.PveHeroEffectTemplateManager:GetTemplate(self.meta.hero_effect)
  local anim = self:GetCurAnimName()
  UnitViewFacade.DestroyUnitView(self.viewHandle)
  self.viewHandle = self.newAppearanceViewHandle
  self.viewLoaded = true
  self.newAppearanceViewHandle = VIEW_INVALID_HANDLE
  self:ComponentDefineWithoutView()
  if self.fsm == nil then
    self:InitFSM()
  end
  self.gameObject = UnitViewFacade.GetGameObject(self.viewHandle)
  local transform = UnitViewFacade.GetTransform(self.viewHandle)
  self.transform = transform
  if self.hpBarHandle then
    pveUnitViewUtil.ReplaceHpBarTargetWithHandle(self.hpBarHandle, self.viewHandle)
  else
    self.delayHpBar = 2
  end
  local appearanceMeta = self.appearanceMeta
  self.leftRightAction = self.appearanceMeta.left_right_action
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
  if showBornEffect == nil or showBornEffect then
    self:ShowBornEffect()
  end
  self:InitSkill()
  self:RewindAndPlaySimpleAnim(anim)
  self.maxBlood = self.hero:GetMaxHp()
  self.originalMaxBlood = self.maxBlood
  self.curBlood = Mathf.Max(self.curBlood, self.maxBlood)
  if self.changeMaxBlood then
    local changeMaxBloodValue = self:GetChangeMaxBloodValue()
    local curPercentage = self.curBlood / self.maxBlood
    self.maxBlood = math.floor(self.originalMaxBlood * (1 + changeMaxBloodValue))
    self.curBlood = math.floor(self.maxBlood * curPercentage)
  end
  if self.hpBarHandle then
    local hpBarType = self:GetCurHpBarType()
    pveUnitViewUtil.SetHpBar(self.hpBarHandle, self.curBlood, self.maxBlood, self:GetShieldValue())
    pveUnitViewUtil.SetHpBarType(self.hpBarHandle, hpBarType)
  end
  self:OnBuffPropertyDirty()
  self.bornValidFlag = true
  self:ShowBornTween()
end

function HeroUnit:AddEnergy(fromPos)
  self.energy = self.energy + 1
  if self.energyBar then
    self.energyBar:SetEnergy(self.energy, fromPos)
  end
  self:TriggerEnergyEvent()
end

function HeroUnit:ShowEnergyEffect()
  if self.skillBar then
    self.skillBar:ShowPowerEffect()
  end
end

function HeroUnit:TriggerEnergyEvent()
  local heroId = self.hero.heroId
  local energyCount = self.energy
  local upgradeHeroId = heroId
  do
    local tHeroId = DataCenter.LWHeroUpgradePVEManager:GetHeroEnergyLevelUpId(heroId)
    if tHeroId then
      upgradeHeroId = tHeroId
    end
  end
  local template = DataCenter.LWHeroEnergyLevelUpTemplateManager:GetTemplate(upgradeHeroId)
  if template then
    local effectArray = DataCenter.LWArmedUpgradeManager:GetArmedUpgradeEnergyLevelUpData(heroId, energyCount, template:GetEnergyEffect(energyCount), false)
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

function HeroUnit:OnBuffAdded(buff)
  base.OnBuffAdded(self, buff)
  if buff.meta.type == BuffType.ModelScale then
    if self.curBlood > 0 and self.viewHandle and self.appearanceMeta then
      local scale = self.appearanceMeta.model_size * self:GetModelScaleValue()
      self.modelScaleEnd = scale
      self.modelScaleTimer = 0
      self.modelScaleStart = UnitViewFacade.GetLocalScaleX(self.viewHandle)
      UnitViewFacade.MPBModelScale(self.viewHandle)
    end
  elseif buff.meta.type == BuffType.ChangeMaxBlood and self.curBlood > 0 then
    self.changeMaxBlood = true
    local changeMaxBloodValue = self:GetChangeMaxBloodValue()
    local curPercentage = self.curBlood / self.maxBlood
    self.maxBlood = math.floor(self.originalMaxBlood * (1 + changeMaxBloodValue))
    self.curBlood = math.floor(self.maxBlood * curPercentage)
    if self.hpBarHandle then
      pveUnitViewUtil.SetHpBar(self.hpBarHandle, self.curBlood, self.maxBlood, self:GetShieldValue())
      local hpBarType = self:GetCurHpBarType()
      pveUnitViewUtil.SetHpBarType(self.hpBarHandle, hpBarType)
    end
  end
end

function HeroUnit:OnBuffRemoved(buff)
  if buff.meta.type == BuffType.ModelScale then
    if self.curBlood > 0 then
      local scale = self.appearanceMeta.model_size * self:GetModelScaleValue()
      self.modelScaleEnd = scale
      self.modelScaleTimer = 0
      self.modelScaleStart = UnitViewFacade.GetLocalScaleX(self.viewHandle)
    end
    self:ClearModelScaleEffect()
  elseif buff.meta.type == BuffType.ChangeMaxBlood then
    local changeMaxBloodValue = self:GetChangeMaxBloodValue()
    if changeMaxBloodValue == 0 then
      self.changeMaxBlood = false
    end
    local curPercentage = self.curBlood / self.maxBlood
    self.maxBlood = math.floor(self.originalMaxBlood * (1 + changeMaxBloodValue))
    self.curBlood = math.floor(self.maxBlood * curPercentage)
    if 0 < curPercentage and self.curBlood == 0 then
      Logger.LogError("[HeroUnit] \229\155\160\228\184\186\229\164\177\229\142\187\232\161\128\233\135\143\228\184\138\233\153\144buff\229\144\145\228\184\139\229\143\150\230\149\180\232\174\161\231\174\151\229\175\188\232\135\180\229\189\147\229\137\141\232\161\128\233\135\143\229\143\152\228\184\1860")
    end
    if self.hpBarHandle then
      pveUnitViewUtil.SetHpBar(self.hpBarHandle, self.curBlood, self.maxBlood, self:GetShieldValue())
      local hpBarType = self:GetCurHpBarType()
      pveUnitViewUtil.SetHpBarType(self.hpBarHandle, hpBarType)
    end
  end
  base.OnBuffRemoved(self, buff)
end

function HeroUnit:ClearModelScaleEffect()
  UnitViewFacade.MPBResetModelScale(self.viewHandle)
end

function HeroUnit:UpdateModelScale(deltaTime)
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

function HeroUnit:ForceCastUltimate(ultimateSkill)
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

function HeroUnit:LeftRightActionValid()
  return self.leftRightAction
end

function HeroUnit:ForbidSkillAnim()
  if not self.leftRightAction then
    return base.ForbidSkillAnim(self)
  end
  if self.team and self.team:IsHorizontalMoving() then
    return true
  end
  return base.ForbidSkillAnim(self)
end

function HeroUnit:GetUnitPositionInTeam()
  if self.team then
    return self.team:GetUnitPosition(self.guid)
  end
  return Vector3.zero
end

function HeroUnit:Die()
  self.curBlood = 0
  if self.fsm then
    if self.fsm:GetStateIndex() ~= Const.ParkourFireState.Dead then
      self.fsm:ChangeState(Const.ParkourFireState.Dead)
    end
  else
    self:ClearBornTween()
    self:HideHpBar()
    if IsNotNull(self.transform) then
      self.transform:SetParent(nil)
    end
    self.team:RemoveMember(self)
    self.logic:OnMemberDeath(self)
  end
end

function HeroUnit:TriggerSkill(triggerType, param)
  if self.skillManager then
    self.skillManager:PassiveCast(triggerType, param)
  end
end

function HeroUnit:SetLocalPosition(pos)
  if not self.localPosition:Equals(pos) then
    self:ClearBornTween()
  end
  self.localPosition = pos
  UnitViewFacade.SetLocalPosition(self.viewHandle, pos.x, pos.y, pos.z)
end

function HeroUnit:SetPosition(worldPos)
  self:ClearBornTween()
  UnitViewFacade.SetPosition(self.viewHandle, worldPos.x, worldPos.y, worldPos.z)
end

function HeroUnit:MoveToLocalPos(dstLocalPos, time)
  self:ClearBornTween()
  if time <= 0 then
    self:SetLocalPosition(dstLocalPos)
    return
  end
  UnitViewFacade.MoveToLocalPos(self.viewHandle, dstLocalPos.x, dstLocalPos.y, dstLocalPos.z, time)
end

function HeroUnit:RefreshTruckGoods(progress)
  if self.dummyTrans == nil then
    return
  end
  local setting = Const.TRUCK_GOODS_GROUP_SETTING[1]
  for i, v in ipairs(Const.TRUCK_GOODS_GROUP_SETTING) do
    if progress <= v.maxProgress then
      setting = v
      break
    end
  end
  if setting == self.truckGroupSetting then
    return
  end
  self.truckGroupSetting = setting
  if self.progressGroups == nil then
    self.progressGroups = {}
  end
  if self.progressGroups[setting.groupPath] == nil then
    self.progressGroups[setting.groupPath] = {}
  end
  local curGroups = self.progressGroups[setting.groupPath]
  for k, groups in pairs(self.progressGroups) do
    if k ~= setting.groupPath then
      for _, group in pairs(groups) do
        if not IsNull(group) and not IsNull(group.gameObject) then
          group.gameObject:SetActive(false)
        end
      end
    end
  end
  for i = 1, math.max(setting.groupNum, #curGroups) do
    local goodsGroup = curGroups[i]
    if not IsNull(goodsGroup) then
      if not IsNull(goodsGroup.gameObject) then
        goodsGroup.gameObject:SetActive(i <= setting.groupNum)
      end
    else
      local idx = i
      local handle = Resource:InstantiateAsync(setting.groupPath, ObjectPoolTag.Normal, LoadPriority.Low)
      local space = setting.space
      handle:completed("+", function(request)
        if not self.logic or IsNull(self.dummyTrans) then
          request:Destroy()
          return
        end
        local transform = request.gameObject.transform
        transform:SetParent(self.dummyTrans)
        transform:Set_localPosition(0, space * (idx - 1), 0)
        transform:Set_localEulerAngles(0, 180, 0)
        transform:Set_localScale(0.8, 0.8, 0.8)
        handle.gameObject:SetActive(self.truckGroupSetting.groupPath == setting.groupPath and idx <= setting.groupNum)
      end)
      curGroups[i] = handle
    end
  end
end

function HeroUnit:DestroyTruckGoods()
  self.truckGroupSetting = nil
  if self.progressGroups then
    for _, groups in pairs(self.progressGroups) do
      for _, group in pairs(groups) do
        if not IsNull(group) then
          group:Destroy()
        end
      end
    end
    self.progressGroups = nil
  end
end

function HeroUnit:UpdateHpBarAndBornEffect()
  if self.logic and self.logic.data then
    if self.delayHpBar > 0 then
      self.delayHpBar = self.delayHpBar - 1
      if self.delayHpBar == 0 and 0 < self.curBlood then
        if not self.logic.data.hideHp then
          self:InitHpBar()
          self.bloodDirty = false
        end
        self:ShowBornEffect()
      end
    end
    if 0 < self.curBlood and self.bloodDirty then
      self.bloodDirty = false
      if self.hpBarHandle then
        pveUnitViewUtil.SetHpBar(self.hpBarHandle, self.curBlood, self.maxBlood, self:GetShieldValue())
      else
        self:InitHpBar()
      end
    end
  end
end

function HeroUnit:InitHpBar()
  if self.isHideHpBar then
    return
  end
  if self.hpBarHandle == nil then
    local offsetX
    if self.skillBar ~= nil then
      offsetX = 35.0
    end
    local hpBarType = self:GetCurHpBarType()
    if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
      pveUnitViewUtil.CreateHpBarListWithHandleRequest(self, self.viewHandle, 2.0, offsetX, self.curBlood, self.maxBlood, nil, hpBarType)
    else
      self.hpBarHandle = pveUnitViewUtil.CreateHpBarWithHandleByType(hpBarType, self.viewHandle, 2, offsetX, self.curBlood, self.maxBlood, nil)
    end
  end
end

function HeroUnit:SetIsHideHpBar(isHide)
  self.isHideHpBar = isHide
end

function HeroUnit:AfterCreateUnitViewList(viewHandle, viewLoaded)
  if self.appearanceReplacing then
    self.newAppearanceViewHandle = viewHandle
    self.newAppearanceViewLoaded = viewLoaded
    if self.newAppearanceViewLoaded then
      self:OnReplaceViewLoaded(true, false)
    end
  else
    self.viewHandle = viewHandle
    self.viewLoaded = viewLoaded
    if self.viewLoaded then
      self:OnViewLoaded(true)
    end
    self.isNew = false
    self.slot = 0
    self.bloodDirty = false
    self.isHideHpBar = false
    if self.viewLoadedCallback then
      self.viewLoadedCallback()
      self.viewLoadedCallback = nil
    end
  end
end

function HeroUnit:AfterCreateHpBarList(viewHandle)
  self.hpBarHandle = viewHandle
end

function HeroUnit:CheckBulletCreate()
  if not self.hero or self.hero.uuid > 0 or self.hero.fromTemplate and self.hero.uuid < 0 then
    return 0
  end
  return self.hero.heroId
end

function HeroUnit:TryGetHeroNewAppearance(heroInfo)
  local heroId = heroInfo.heroId
  local modelPath, appearanceId, modelSourceType = heroInfo:GetHeroModelData(HeroModelType.Battle)
  local newAppearanceId = DataCenter.LWArmedUpgradeManager:GetArmedUpgradeAppearanceId(heroId, appearanceId, false)
  if newAppearanceId ~= appearanceId then
    local newAppearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(newAppearanceId)
    if newAppearanceMeta then
      return newAppearanceMeta, true
    else
      return nil, false
    end
  end
  return nil, false
end

function HeroUnit:IsViewLoaded()
  return self.viewLoaded
end

function HeroUnit:GetUltimateSkill()
  if self.hero ~= nil and self.hero.GetUltimateSkill ~= nil then
    return self.hero:GetUltimateSkill()
  end
  return nil
end

function HeroUnit:ReplaceNormalAttackWithoutInterrupt(skillMeta)
  local castingSkill = self.skillManager:GetCastingSkill()
  if castingSkill == nil or castingSkill.meta.id ~= skillMeta.id then
    return self.skillManager:ReplaceNormalAttack(skillMeta)
  end
  self.cacheReplaceNormalAttackSkillMeta = skillMeta
end

function HeroUnit:ReplaceActiveAttackWithoutInterrupt(skillMeta)
  local castingSkill = self.skillManager:GetCastingSkill()
  if castingSkill == nil or castingSkill.meta.id ~= skillMeta.id then
    local succeed = self.skillManager:ReplaceActiveAttack(skillMeta)
    if succeed and self.skillBar then
      self.skillBar:TryRefreshSkill()
    end
    return succeed
  end
  self.cacheReplaceActiveAttackSkillMeta = skillMeta
end

function HeroUnit:GetCurHpBarType()
  local hpBarType = DataCenter.LWCivilizationSparkExtend:HeroUnit_getBaseHpBarType(self.hero.meta.parkourType)
  if self.appearanceMeta and self.appearanceMeta.hp_type and self.appearanceMeta.hp_type ~= 0 then
    hpBarType = self.appearanceMeta.hp_type
  end
  if self.changeMaxBlood and HpBarTypeByChangeMax[hpBarType] then
    hpBarType = HpBarTypeByChangeMax[hpBarType]
  end
  return hpBarType
end

return HeroUnit
