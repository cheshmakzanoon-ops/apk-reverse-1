local base = require("Scene.LWBattle.Skirmish.Unit.SkirmishUnit")
local Captain = BaseClassCache("Captain", base)
local Localization = CS.GameEntry.Localization
local Const = require("Scene.LWBattle.Const")
local SkillManagerPVP = require("Scene.LWBattle.PVP.SkillManagerPVP")
local Resource = CS.GameEntry.Resource
local DelayHpBarCell = require("DataCenter.ZombieBattle.HpBar.DelayHpBarCell")
local TinyHead = require("DataCenter.ZombieBattle.HpBar.TinyHead")
local BattleEnumType = require("DataCenter.LWBattle.BattleEnumType")
local HP_BAR_OFFSET = {
  [1] = -1.5,
  [2] = -1.2
}

function Captain:DataDefine()
  self.hasTinyHead = false
end

function Captain:Init(logic, platoon, heroData, localPos, index, initShowState)
  base.Init(self, logic, platoon, heroData, localPos, index)
  self:DataDefine(heroData)
  if self.heroId == nil then
    self.heroId = heroData.heroId
  end
  self.hero = HeroInfo.New()
  self.hero:UpdateFromMailData(self.heroId, heroData.heroLevel, heroData.skillInfos, heroData.weaponLevel, heroData.rankLv, heroData.awakenLv, heroData.heroSkinId)
  self.meta = self.hero.meta
  self.isHuman = self.meta.is_human
  self.isDominator = self.meta.heroData_type == HeroTemplateType.Dominator
  self.unitType = UnitType.Member
  self.searchType = BattleSearchType.Member
  self.layer = LayerType.Member
  if self.sceneData.IsSelfUnitsPVPSlot(index) then
    self.unitType = UnitType.Member
    self.searchType = BattleSearchType.Member
    self.layer = LayerType.Member
  else
    self.unitType = UnitType.Zombie
    self.searchType = BattleSearchType.Zombie
    self.layer = LayerMask.NameToLayer("Zombie")
  end
  if self.showHPBar == nil then
    self.showHPBar = true
  end
  local path, appearanceId = self.hero:GetHeroModelData(HeroModelType.Battle)
  self.heroEffectMeta = DataCenter.PveHeroEffectTemplateManager:GetTemplate(self.meta.hero_effect)
  self.maxBlood = heroData.maxHp
  self.initBlood = heroData.initHp
  self.curBlood = self.initBlood
  self.totalHurt = 0
  Logger.Log(self.index .. "\229\143\183  name:" .. CS.GameEntry.Localization:GetString(self.hero.meta.name))
  self.skillManager = SkillManagerPVP.New(self.logic, self)
  self.initShowState = initShowState
  self.modelVisible = initShowState
  self.modelValid = false
  self.expireTime = heroData.expireTime or -1
  if appearanceId ~= self.hero.modelId then
    Logger.LogError("Captain appearanceId not match, heroId=" .. self.heroId .. " appearanceId=" .. appearanceId .. " modelId=" .. self.hero.modelId)
  end
  self.req = Resource:InstantiateAsync(path, ObjectPoolTag.Battle)
  self.req:completed("+", function(request)
    self.initFinish = true
    self.gameObject = request.gameObject
    self.transform = request.gameObject.transform
    self.transform:SetParent(self.platoon.transform)
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.transform:Set_localPosition(self.localPosition.x, self.localPosition.y, self.localPosition.z)
    self:ComponentDefine()
    self:InitFSM()
    local hpTargetTransform
    if self.isDominator then
      hpTargetTransform = self.transform
    elseif self.platoon and not IsNull(self.platoon.transform) then
      hpTargetTransform = self.platoon.transform
    else
      hpTargetTransform = self.transform
    end
    if self.showHPBar then
      self.hpBar = DelayHpBarCell.New(Const.HPBarStyle.Self, hpTargetTransform, HP_BAR_OFFSET[self.platoon.army.index])
      self.hpBar:LoadAndSetHp(self.curBlood / self.maxBlood)
      self.tinyHead = TinyHead.New(self.transform, HP_BAR_OFFSET[self.platoon.army.index])
      self.tinyHead:LoadAndSetHead(HeroUtils.GetHeroIconPath(self.meta.appearance, HeroIconType.small_icon, self.hero:GetSkinId()))
      self.hasTinyHead = true
    end
    local appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
    self.transform:Set_localScale(appearanceMeta.model_size, appearanceMeta.model_size, appearanceMeta.model_size)
    local fire_paths = appearanceMeta.fire_paths
    self.firePoints = {}
    for i = 1, #fire_paths do
      local firePoint = self.transform:Find(fire_paths[i])
      if not firePoint then
        Logger.LogError("\229\188\128\231\129\171\231\130\185\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\232\183\175\229\190\132\228\184\141\229\186\148\229\140\133\229\144\171\233\162\132\229\136\182\228\189\147\229\144\141\239\188\140\229\164\150\232\167\130id\239\188\154" .. self.hero.modelId .. "\239\188\140\229\188\128\231\129\171\231\130\185\232\183\175\229\190\132\239\188\154" .. fire_paths[i])
      else
        table.insert(self.firePoints, firePoint)
      end
    end
    self.firePoint = self.firePoints[1]
    self.firePointNull = IsNull(self.firePoint)
    self.firePointOffset = 0
    if self.firePoint then
      self.firePointOffset = Vector3.HorizonDistance(self.firePoint.position, self.transform.position)
    end
    if self.isHuman then
      self.cannon = self.transform
    else
      local canon_path = appearanceMeta.canon_path
      self.cannon = self.transform:Find(canon_path)
      if not self.cannon then
        self.cannon = self.transform
        Logger.LogError("\231\130\174\229\143\176\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\230\179\168\230\132\143\232\183\175\229\190\132\228\184\141\229\186\148\229\140\133\229\144\171\233\162\132\229\136\182\228\189\147\229\144\141\239\188\140\229\164\150\232\167\130id\239\188\154" .. self.hero.modelId .. "\239\188\140prefab\232\183\175\229\190\132\239\188\154" .. path .. "\239\188\140\231\130\174\229\143\176\232\183\175\229\190\132\239\188\154" .. canon_path)
      else
        self.cannon:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      end
      local canonFix = appearanceMeta.canon_rotation
      if canonFix and #canonFix == 3 then
        self.localForward = Vector3.forward * Quaternion.Euler(canonFix[1], canonFix[2], canonFix[3])
      end
    end
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
    self.uiPoint = nil
    if not string.IsNullOrEmpty(appearanceMeta.ui_path) then
      self.uiPoint = self.transform:Find(appearanceMeta.ui_path)
      if not self.uiPoint then
        Logger.LogError("\228\184\173\229\191\131\231\130\185\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\229\164\150\232\167\130id\239\188\154" .. self.hero.modelId .. "\239\188\140\228\184\173\229\191\131\231\130\185\232\183\175\229\190\132\239\188\154" .. appearanceMeta.ui_path)
      end
    end
    self.angular_speed_deg = self.meta.angular_speed * 60
    self:InitSkill()
    if not IsNull(self.gameObject) then
      self.rendererArray = self.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.Renderer))
      self.modelValid = not IsNull(self.rendererArray)
      local length = self.rendererArray.Length - 1
      for i = 0, length do
        self.rendererArray[i].enabled = self.modelVisible
      end
    end
  end)
  self.initFinish = false
end

function Captain:ComponentDefine()
  base.ComponentDefine(self)
  if IsNull(self.collider) then
    Logger.LogError("Captain:ComponentDefine() collider is nil")
    return
  end
  if self.index <= 5 then
    self.collider.gameObject.layer = LayerMask.NameToLayer("Member")
  else
    self.collider.gameObject.layer = LayerMask.NameToLayer("Zombie")
  end
end

function Captain:InitSkill()
  local ultimateSkill, skillInfos
  if self.hero.meta.heroData_type == HeroTemplateType.Dominator then
    local dominatorMainTemplate = DataCenter.DominatorTemplateManager:GetMainTemplateById(self.hero.heroId, false)
    if dominatorMainTemplate then
      local skill = self.hero:GetSkillBySkillGroupId(dominatorMainTemplate:GetCenterSkillGroupId())
      if skill then
        ultimateSkill = skill
      end
      local allSkills = self.hero:GetAllUnlockSkills()
      skillInfos = {}
      for _, v in pairs(allSkills) do
        if ultimateSkill and ultimateSkill.skillId == v.skillId then
        else
          table.insert(skillInfos, v)
        end
      end
    end
  else
    ultimateSkill = self.hero:GetUltimateSkill()
    skillInfos = self.hero:GetAllUnlockSkillsExcludeUltimate()
  end
  for _, skillInfo in pairs(skillInfos) do
    if skillInfo.skillTemplateData == nil then
      Logger.LogError("\230\183\187\229\138\160\230\138\128\232\131\189\230\151\182\239\188\140\230\138\128\232\131\189\233\133\141\231\189\174\230\137\190\228\184\141\229\136\176,\230\138\128\232\131\189Id\239\188\154" .. skillInfo.id)
    end
    self.skillManager:AddSkill(skillInfo.skillTemplateData, skillInfo)
  end
  if ultimateSkill then
    self.skillManager:AddSkill(ultimateSkill.skillTemplateData, ultimateSkill, true)
  end
end

function Captain:OnUpdate(deltaTime)
  base.OnUpdate(self, deltaTime)
  if self.skillManager and self.logic.stage == SkirmishStage.Fight then
    self.skillManager:OnUpdate(deltaTime)
  end
  if self.hpBar then
    self.hpBar:Update()
  end
  if self.hasTinyHead then
    self.tinyHead:Update()
  end
end

function Captain:DestroyView()
  base.DestroyView(self)
  if self.hpBar then
    self.hpBar:Destroy()
    self.hpBar = nil
  end
  if self.tinyHead then
    self.tinyHead:Destroy()
    self.tinyHead = nil
  end
  self.hasTinyHead = false
  if self.cannon then
    self.cannon:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  end
  if self.skillManager then
    self.skillManager:DestroyView()
  end
  if self.modelValid then
    local length = self.rendererArray.Length - 1
    for i = 0, length do
      if not IsNull(self.rendererArray[i]) then
        self.rendererArray[i].enabled = true
      end
    end
  end
  self.modelValid = false
end

function Captain:DestroyData()
  self.hero = nil
  self.meta = nil
  self.isHuman = nil
  self.cannon = nil
  self.angular_speed_deg = nil
  if self.skillManager then
    self.skillManager:DestroyData()
    self.skillManager = nil
  end
  base.DestroyData(self)
end

function Captain:GetRawProperty(type)
  if self.heroData == nil then
    return 0
  end
  return self.heroData.effect[type] or 0
end

function Captain.GetDamageType(action, param)
  if not action or not param then
    return DamageType.None
  end
  if action.phase == ActionPhase.Damage or action.phase == ActionPhase.SPLASH_DAMAGE or action.phase == ActionPhase.Bounce then
    local damageType = DamageType.None
    local effectId = action.effectId
    if not effectId or effectId <= 0 then
      effectId = action.skillId * 10
    end
    local skillEffectTemplate = DataCenter.SkillEffectPvpTemplateManager:GetTemplate(effectId)
    if skillEffectTemplate then
      damageType = skillEffectTemplate.pvp_damage_type
    end
    if action.actionParamType == FightActionParamType.RealDamage then
      damageType = DamageType.RealDamage
    end
    return damageType
  end
  return DamageType.None
end

function Captain.GetDamageCastType(skillId)
  if not skillId then
    return SkillCastType.AutoAttack
  end
  local skillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
  if not skillTemplate then
    return SkillCastType.AutoAttack
  end
  return skillTemplate:GetSkillCastType()
end

function Captain:DoAction(action, param, param2)
  if action.phase == ActionPhase.SkillCast then
    local skill = self.skillManager:GetSkillById(action.skillId)
    if not skill then
      if self.initFinish then
        local allSkillStr = ""
        local allSkills = self.skillManager:GetAllSkills()
        for _, v in pairs(allSkills) do
          allSkillStr = allSkillStr .. "_" .. v.meta.id
        end
        Logger.LogError(self.index .. "\229\143\183\228\189\141" .. "\232\139\177\233\155\132" .. self.hero.heroId .. "\230\178\161\230\156\137\230\138\128\232\131\189" .. action.skillId .. "\229\189\147\229\137\141\230\138\128\232\131\189\229\136\151\232\161\168" .. allSkillStr)
      end
      return
    end
    if action.casterState == BattleEnumType.ActionCasterState.stunned then
      if skill then
        skill:RestartCD()
      end
      return
    end
    local isSelfHero = self.index <= PVPBattleSlot.SelfHero5
    if isSelfHero then
      if skill:IsUltimate() then
        EventManager:GetInstance():Broadcast(EventId.SkirmishCastUltimate, action)
      end
    else
      local isSelfDominator = self.index == PVPBattleSlot.SelfDominator
      if isSelfDominator and skill:IsActiveSkill() and skill:IsUltimate() then
        EventManager:GetInstance():Broadcast(EventId.OnPVPDominatorCastSkill, skill)
      end
    end
    self:SetVisible(true)
  elseif action.phase == ActionPhase.Cast then
    local skill = self.skillManager:GetSkillById(action.skillId)
    if not skill then
      if self.initFinish then
        local allSkillStr = ""
        local allSkills = self.skillManager:GetAllSkills()
        for _, v in pairs(allSkills) do
          allSkillStr = allSkillStr .. "_" .. v.meta.id
        end
        Logger.LogError(self.index .. "\229\143\183\228\189\141" .. "\232\139\177\233\155\132" .. self.hero.heroId .. "\230\178\161\230\156\137\230\138\128\232\131\189" .. action.skillId .. "\229\189\147\229\137\141\230\138\128\232\131\189\229\136\151\232\161\168" .. allSkillStr)
      end
      return
    end
    local skillEffect = skill:GetEffect(action.effectId)
    if not skillEffect then
      Logger.LogError(self.index .. "\229\143\183\228\189\141" .. "\232\139\177\233\155\132" .. self.hero.heroId .. "\230\178\161\230\156\137\230\138\128\232\131\189\230\149\136\230\158\156Id:" .. action.effectId .. "\230\138\128\232\131\189id:" .. skill.meta.id)
      return
    end
    if skillEffect:IsBuff() then
      local targets = {}
      for _, v in pairs(action.targets) do
        table.insert(targets, self.logic:GetCaptain(v.index))
      end
      self:CastSkill(skill, targets)
      if skillEffect:HasBuffBullet() and action.targets[1] then
        skillEffect:ForceLifeTime(self:GetCaptainDistance(action.targets[1].index))
        skillEffect:SetRedirectTarget(targets)
      end
    elseif action.targets[1] then
      local target = self.logic:GetCaptain(action.targets[1].index)
      skillEffect:ForceLifeTime(self:GetCaptainDistance(action.targets[1].index))
      if action.targets[2] then
        local redirectTarget = {}
        for i = #action.targets, 2, -1 do
          local unit = self.logic:GetCaptain(action.targets[i].index)
          table.insert(redirectTarget, unit)
        end
        skillEffect:SetRedirectTarget(redirectTarget)
      end
      if skill:HasMovingLogic() then
        self:CastSkill(skill, target)
      else
        self:AimAndCastSkill(skill, target)
      end
    end
  elseif action.phase == ActionPhase.FIRE_BULLET then
    local skill = self.skillManager:GetSkillById(action.skillId)
    if not skill then
      if self.initFinish then
        Logger.LogError(self.index .. "\229\143\183\228\189\141" .. "\232\139\177\233\155\132" .. self.hero.heroId .. "\230\178\161\230\156\137\230\138\128\232\131\189" .. action.skillId)
      end
      return
    end
    local skillEffect = skill:GetEffect(action.effectId)
    if not skillEffect then
      Logger.LogError(self.index .. "\229\143\183\228\189\141" .. "\232\139\177\233\155\132" .. self.hero.heroId .. "\230\178\161\230\156\137\230\138\128\232\131\189\230\149\136\230\158\156Id:" .. action.effectId)
      return
    end
    local targetData = action.targets[1]
    if targetData then
      local target = self.logic:GetCaptain(targetData.index)
      skillEffect:ForceLifeTime(self:GetCaptainDistance(targetData.index))
      skillEffect:CreateBullet(target)
    end
  elseif action.phase == ActionPhase.Buff then
    local shieldChange = false
    local buffs = {}
    local skillLv = param2
    skillLv = skillLv or 1
    for _, v in pairs(param.buffChanges) do
      local meta = DataCenter.LWBuffTemplateManager:GetTemplate(v.buffId)
      local buffId = v.buffId
      local param = v.param
      if meta.type == BuffType.Property then
        param = v.skillLevel
      elseif meta.type == BuffType.BeTaunt then
        param = self.logic:GetCaptain(action.casterIndex)
      elseif meta.type == BuffType.Shield then
        param = self.logic:GetCaptain(action.casterIndex)
        shieldChange = true
      elseif meta.type == BuffType.Dot then
        param = action.targets[1].dotDamageOnce
      end
      buffs[#buffs + 1] = {
        id = buffId,
        param = param,
        lv = skillLv
      }
    end
    self:AddBuffs(buffs)
    if shieldChange then
      local shieldRemain = param.shieldTotal or 0
      local percent = self.curBlood / self.maxBlood
      local shieldPercent = shieldRemain / self.maxBlood
      if self.hpBar then
        self.hpBar:SetHp(percent, shieldPercent)
      end
    end
  elseif action.phase == ActionPhase.Damage or action.phase == ActionPhase.Dot then
    self:DoDamageAction(action, param)
  elseif action.phase == ActionPhase.SPLASH_DAMAGE then
    local skill = self.skillManager:GetSkillById(action.skillId)
    if not skill then
      if self.initFinish then
        Logger.LogError(self.index .. "\229\143\183\228\189\141" .. "\232\139\177\233\155\132" .. self.hero.heroId .. "\230\178\161\230\156\137\230\138\128\232\131\189" .. action.skillId)
      end
      return
    end
    local skillEffect = skill:GetEffect(action.effectId)
    if not skillEffect then
      Logger.LogError(self.index .. "\229\143\183\228\189\141" .. "\232\139\177\233\155\132" .. self.hero.heroId .. "\230\178\161\230\156\137\230\138\128\232\131\189\230\149\136\230\158\156Id:" .. action.effectId)
      return
    end
    if action.targets then
      for i = 1, #action.targets do
        local targetData = action.targets[i]
        local target = self.logic:GetCaptain(targetData.index)
        local bulletStartUnit = self.logic:GetCaptain(action.bulletIndex)
        local bulletLifeTime = skillEffect:GetForceLifeTime(self:GetCaptainDistance(targetData.index))
        local param = {
          bulletLifeTime = bulletLifeTime,
          action,
          pos = bulletStartUnit:GetPosition(),
          angle = 0,
          source = bulletStartUnit
        }
        skillEffect:ForceLifeTime(self:GetCaptainDistance(targetData.index))
        local bulletId = skillEffect.bulletId
        local buffBulletId = self:GetSplashDamageBullet()
        if buffBulletId and 0 < buffBulletId then
          bulletId = buffBulletId
        end
        skillEffect:CreateBullet(target, param, bulletId)
      end
    end
  elseif action.phase == ActionPhase.REMOVE_BUFF then
    local skillEffectTemplate = DataCenter.SkillEffectPvpTemplateManager:GetTemplate(action.effectId)
    local isDisperseEffect = skillEffectTemplate and skillEffectTemplate.pvp_actionType == SkillActionType.DisperseEffect
    local disperseCount = 0
    local shieldChange = false
    for _, v in pairs(param.buffChanges) do
      local meta = DataCenter.LWBuffTemplateManager:GetTemplate(v.buffId)
      if meta.type == BuffType.Shield then
        shieldChange = true
      end
      if self.RemoveBuffTimeOrder then
        self:RemoveBuffTimeOrder(v.buffId, 1)
      end
      if isDisperseEffect then
        disperseCount = disperseCount + 1
      end
    end
    if isDisperseEffect and skillEffectTemplate then
      local isDeBuff = skillEffectTemplate.dispel_type == 0 or false
      self.logic:ShowEffectText("", self:GetPosition(), DamageTextType.DisperseEffect, isDeBuff, 1, disperseCount)
    end
    if shieldChange then
      local shieldRemain = param.shieldTotal or 0
      local percent = self.curBlood / self.maxBlood
      local shieldPercent = shieldRemain / self.maxBlood
      if self.hpBar then
        self.hpBar:SetHp(percent, shieldPercent)
      end
    end
  elseif action.phase == ActionPhase.ShieldDamage then
    self:DoDamageShieldAction(param)
  elseif action.phase == ActionPhase.Bounce then
    local skill = self.skillManager:GetSkillById(action.skillId)
    if not skill then
      if self.initFinish then
        Logger.LogError(self.index .. "\229\143\183\228\189\141" .. "\232\139\177\233\155\132" .. self.hero.heroId .. "\230\178\161\230\156\137\230\138\128\232\131\189" .. action.skillId)
      end
      return
    end
    local skillEffect = skill:GetEffect(action.effectId)
    if not skillEffect then
      Logger.LogError(self.index .. "\229\143\183\228\189\141" .. "\232\139\177\233\155\132" .. self.hero.heroId .. "\230\178\161\230\156\137\230\138\128\232\131\189\230\149\136\230\158\156Id:" .. action.effectId)
      return
    end
    if action.targets then
      for i = 1, #action.targets do
        local targetData = action.targets[i]
        local target = self.logic:GetCaptain(targetData.index)
        local bulletStartUnit = self.logic:GetCaptain(action.bulletIndex)
        local bulletLifeTime = skillEffect:GetForceLifeTime(self:GetCaptainDistance(targetData.index))
        local param = {
          bulletLifeTime = bulletLifeTime,
          action,
          pos = bulletStartUnit:GetPosition(),
          angle = 0,
          source = bulletStartUnit
        }
        skillEffect:ForceLifeTime(self:GetCaptainDistance(targetData.index))
        local bulletId = skillEffect.bulletId
        if skillEffect.meta and not string.IsNullOrEmpty(skillEffect.meta.pvp_actionParam) then
          local paramList = string.split(skillEffect.meta.pvp_actionParam, "|")
          if 2 <= #paramList then
            bulletId = tonumber(paramList[2])
          end
        end
        skillEffect:CreateBullet(target, param, bulletId)
      end
    end
  elseif action.phase == ActionPhase.BeforeHeroAwakenSkillCast then
    self.logic:ShowEffectObj(HeroUtils.HeroAwakenPVPSkillCastEffectAssetPath, self:GetPosition(), nil, nil)
  end
end

function Captain:DoDamageShieldAction(target)
  local shieldAbsorbed = target.shieldChange or 0
  local shieldRemain = target.shieldTotal or 0
  local shieldPercent = (shieldRemain - shieldAbsorbed) / self.maxBlood
  local percent = self.curBlood / self.maxBlood
  if self.hpBar then
    self.hpBar:SetHp(percent, shieldPercent)
  end
  if 0 < shieldAbsorbed then
    self.logic:ShowDamageText(shieldAbsorbed, self:GetPosition(), DamageTextType.ShieldDamage)
  end
  if 0 < shieldRemain and shieldRemain - shieldAbsorbed <= 0 then
    self:RemoveAllShieldBuff()
  end
end

function Captain:DoDamageAction(action, target)
  local hurt = target.damageDouble == 0 and target.damage or target.damageDouble
  local shieldAbsorbed = target.shieldChange or 0
  local shieldRemain = target.shieldTotal or 0
  local realHurt = math.max(hurt - shieldAbsorbed, 0)
  self.totalHurt = self.totalHurt + hurt
  if 0 >= self.curBlood then
    return
  end
  if realHurt >= self.curBlood then
    self.bloodBeforeDie = self.curBlood
  end
  self.curBlood = math.max(self.curBlood - realHurt, 0)
  local percent = self.curBlood / self.maxBlood
  local shieldPercent = (shieldRemain - shieldAbsorbed) / self.maxBlood
  if self.hpBar then
    self.hpBar:SetHp(percent, shieldPercent)
  end
  if 0 >= self.curBlood then
    self:GoDie()
  end
  self.platoon:OnCaptainTakeDamage(self.curBlood)
  if self.index <= 5 or self.index == PVPBattleSlot.SelfDominator then
    EventManager:GetInstance():Broadcast(EventId.SkirmishChangeHp, {
      self.index,
      percent
    })
  end
  if action.phase == ActionPhase.Damage then
    local damageTextType
    local num = hurt
    if 0 < target.miss then
      damageTextType = DamageTextType.Miss
    elseif action.casterIndex == PVPBattleSlot.SelfUav or action.casterIndex == PVPBattleSlot.EnemyUav then
      damageTextType = DamageTextType.Drone
    elseif action.actionParamType == FightActionParamType.Splash then
      damageTextType = DamageTextType.Splash
    else
      local castType = self.GetDamageCastType(action.skillId)
      if castType == SkillCastType.Active then
        damageTextType = DamageTextType.HeroUltimate
      else
        damageTextType = DamageTextType.HeroNormalAttack
      end
    end
    local damageType = self.GetDamageType(action, target)
    self.logic:ShowDamageText(num, self:GetPosition(), damageTextType, damageType, 0 < target.crit)
  end
  if 0 < shieldRemain and shieldRemain - shieldAbsorbed <= 0 then
    self:RemoveAllShieldBuff()
  end
end

function Captain:UnDoAction(action, param)
  if action.phase == ActionPhase.Cast then
  elseif action.phase == ActionPhase.Damage or action.phase == ActionPhase.Dot then
    self:UnDoDamageAction(action, param)
  end
end

function Captain:UnDoDamageAction(action, target)
  local hurt = target.damageDouble == 0 and target.damage or target.damageDouble
  local shieldAbsorbed = target.shieldChange or 0
  local shieldRemain = target.shieldTotal or 0
  local realHurt = math.max(hurt - shieldAbsorbed, 0)
  if 0 < realHurt then
    if 0 >= self.curBlood then
      self:Revive()
    else
      self.curBlood = self.curBlood + realHurt
    end
    local percent = self.curBlood / self.maxBlood
    local shieldPercent = shieldRemain / self.maxBlood
    if self.hpBar then
      self.hpBar:SetHp(percent, shieldPercent)
    end
    self.platoon:OnCaptainHeal(self.curBlood)
    if self.index <= 5 or self.index == PVPBattleSlot.SelfDominator then
      EventManager:GetInstance():Broadcast(EventId.SkirmishChangeHp, {
        self.index,
        percent
      })
    end
  elseif 0 < shieldAbsorbed then
    local percent = self.curBlood / self.maxBlood
    local shieldPercent = shieldRemain / self.maxBlood
    if self.hpBar then
      self.hpBar:SetHp(percent, shieldPercent)
    end
  end
end

function Captain:GoDie()
  base.GoDie(self)
  self.platoon.army:OnCaptainDie(self.index)
end

function Captain:Revive()
  base.Revive(self)
  self.platoon.army:OnCaptainRevive(self.index)
  if self.hpBar then
    self.hpBar:SetActive(true)
  end
end

function Captain:DestroyTinyHead()
  if self.tinyHead then
    self.tinyHead:Destroy()
    self.tinyHead = nil
  end
  self.hasTinyHead = false
end

function Captain:ChangeStage(stage)
  base.ChangeStage(self, stage)
  if stage == SkirmishStage.Load then
  elseif stage == SkirmishStage.Opening then
  elseif stage == SkirmishStage.Fight then
    self:DestroyTinyHead()
  elseif stage == SkirmishStage.End then
  end
end

function Captain:GetCaptainDistance(targetIndex)
  return self.sceneData:GetCaptainDistance(self.index, targetIndex) - self.firePointOffset
end

function Captain:GetPosition()
  if self.transform then
    self.curWorldPos.x, self.curWorldPos.y, self.curWorldPos.z = self.transform:Get_position()
    return self.curWorldPos
  elseif self.platoon then
    return self.platoon:GetPosition()
  end
  return Vector3.zero
end

function Captain:GetTeamZeroWorldPos()
  if self.platoon then
    return self.platoon:GetTeamZeroWorldPos()
  end
  return Vector3.zero
end

function Captain:GetTeamRootTransform()
  if self.platoon and self.platoon.GetTeamRootTransform then
    return self.platoon:GetTeamRootTransform()
  end
  return nil
end

function Captain:GetUnitPositionInTeam()
  if self.platoon then
    return self.platoon:GetCapatinPosition(self.index)
  end
  return Vector3.zero
end

function Captain:SetVisible(visible)
  if visible == nil then
    return
  end
  if self.modelVisible == visible then
    return
  end
  self.modelVisible = visible
  if self.modelValid then
    self.modelVisible = visible
    if not IsNull(self.rendererArray) then
      local length = self.rendererArray.Length - 1
      for i = 0, length do
        self.rendererArray[i].enabled = visible
      end
    end
  end
end

local SKILL_PVP_DEATH_TRIGGER = 4

function Captain:HasDeathTriggerSkill()
  if not self.skillManager then
    return false
  end
  local allSkills = self.skillManager:GetAllSkills()
  if not allSkills then
    return false
  end
  for _, skill in pairs(allSkills) do
    if skill.meta.pvp_triggerType and skill.meta.pvp_triggerType == SKILL_PVP_DEATH_TRIGGER then
      return true
    end
  end
  return false
end

local BattleTimelineEnum = require("Scene.LWBattle.Skirmish.BattleTimeline.BattleTimelineEnum")
local ClipInfoUtils = require("Scene.LWBattle.Skirmish.BattleTimeline.ClipInfoUtils")

function Captain:AimAndCastSkill(skill, target)
  if self:IsMoving() then
    self:Tl_CrossFadeSimpleAnim(AnimName.Run, 0, 1, 0.2)
  else
    self:Tl_CrossFadeSimpleAnim(AnimName.Idle, 0, 1, 0.2)
  end
  local rotateClipInfo = ClipInfoUtils.GetClipInfo(BattleTimelineEnum.BattleTimelineClipType.RotateToTargetAndCast, 0, 0, true, 0, skill, target)
  local clipId = self.timeline:AddClip(rotateClipInfo)
  if not clipId then
    self:CastSkill(skill, target)
  end
end

function Captain:GetUltimateSkill()
  if self.skillManager then
    return self.skillManager:GetUltimateSkill()
  end
  return nil
end

function Captain:GetHeroAwakenSkill()
  if self.skillManager then
    return self.skillManager:GetHeroAwakenSkill()
  end
  return nil
end

return Captain
