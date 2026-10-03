local base = require("Scene.LWBattle.Skirmish.Unit.SkirmishUnit")
local TacticalWeaponUnit = BaseClassCache("TacticalWeaponUnit", base)
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local SkillManager = require("Scene.LWBattle.PVP.SkillManagerPVP")
local Resource = CS.GameEntry.Resource

function TacticalWeaponUnit:Init(logic, army, weaponData, index)
  base.Init(self, logic, army, weaponData, Vector3.zero, index)
  self.index = index
  self.army = army
  self.logic = logic
  self.sceneData = self.logic.sceneData
  self.battleData = self.logic.battleData
  self.weapon = TacticalWeaponInfo.New()
  if weaponData and weaponData.skillInfos then
    local skillInfoList = TacticalWeaponUtils.ConvertSkillInfoServerToLocal(weaponData.skillInfos)
    self.weapon:CreateFromTemplate(weaponData.heroId, weaponData.heroLevel, nil, nil, skillInfoList)
  else
    self.weapon:CreateFromTemplate(weaponData.heroId, weaponData.heroLevel)
  end
  self.weaponData = weaponData
  self.meta = self.weapon.template
  if index == 11 then
    self.unitType = UnitType.TacticalWeapon
    self.searchType = BattleSearchType.TacticalWeapon
  elseif index == 12 then
    self.unitType = UnitType.TacticalWeapon
    self.searchType = BattleSearchType.TacticalWeapon
  end
  self.appearanceMeta = nil
  local skinId = weaponData.skinId
  local appearanceId = DataCenter.TacticalWeaponManager:GetDefaultSkinRealAppearanceId(self.weapon, skinId)
  self.appearanceId = appearanceId
  self.appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
  local path = ""
  if self.appearanceMeta then
    path = self.appearanceMeta.model_path
  end
  self.skillChips = self.weaponData.skillChips
  self.maxBlood = 1
  self.curBlood = 1
  self.initBlood = 1
  self.totalHurt = 0
  self.skillManager = SkillManager.New(self.logic, self)
  self.localPosition = self.sceneData.platoonLocalPos[index]
  self.modelVisible = false
  self.modelValid = false
  self.delayShow = 0
  self.req = Resource:InstantiateAsync(path, ObjectPoolTag.Battle)
  self.req:completed("+", function(request)
    self.gameObject = request.gameObject
    self.transform = request.gameObject.transform
    self.transform:SetParent(self.platoon.transform)
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.transform:Set_localPosition(self.localPosition.x, self.localPosition.y, self.localPosition.z)
    self:ComponentDefine()
    self:InitFSM()
    self.rendererArray = self.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.Renderer))
    self.modelValid = not IsNull(self.rendererArray)
    if self.modelValid then
      local length = self.rendererArray.Length - 1
      for i = 0, length do
        self.rendererArray[i].enabled = self.modelVisible
      end
    end
    if self.anim then
      self.anim.cullingMode = CS.UnityEngine.AnimatorCullingMode.AlwaysAnimate
    end
    local appearanceMeta = self.appearanceMeta
    if appearanceMeta then
      self.transform:Set_localScale(appearanceMeta.model_size, appearanceMeta.model_size, appearanceMeta.model_size)
      local fire_paths = appearanceMeta.fire_paths
      self.firePoints = {}
      for i, v in ipairs(fire_paths) do
        local firePoint = self.transform:Find(v)
        if not firePoint then
          Logger.LogError("\229\188\128\231\129\171\231\130\185\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\232\183\175\229\190\132\228\184\141\229\186\148\229\140\133\229\144\171\233\162\132\229\136\182\228\189\147\229\144\141\239\188\140\229\164\150\232\167\130id\239\188\154" .. (self.weaponData.heroId or "") .. "\239\188\140\229\188\128\231\129\171\231\130\185\232\183\175\229\190\132\239\188\154" .. v)
        end
        table.insert(self.firePoints, firePoint)
      end
      self.firePoint = self.firePoints[1]
      self.firePointNull = IsNull(self.firePoint)
      self.firePointOffset = 0
      if self.firePoint then
        self.firePointOffset = Vector3.HorizonDistance(self.firePoint.position, self.transform.position)
      end
      local canon_path = appearanceMeta.canon_path
      self.cannon = self.transform:Find(canon_path)
      if not self.cannon then
        self.cannon = self.transform
        Logger.LogError("\231\130\174\229\143\176\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\230\179\168\230\132\143\232\183\175\229\190\132\228\184\141\229\186\148\229\140\133\229\144\171\233\162\132\229\136\182\228\189\147\229\144\141\239\188\140\229\164\150\232\167\130id\239\188\154" .. (self.weaponData.heroId or "") .. "\239\188\140prefab\232\183\175\229\190\132\239\188\154" .. path .. "\239\188\140\231\130\174\229\143\176\232\183\175\229\190\132\239\188\154" .. canon_path)
      else
        self.cannon:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      end
      local canonFix = appearanceMeta.canon_rotation
      if canonFix and #canonFix == 3 then
        self.localForward = Vector3.forward * Quaternion.Euler(canonFix[1], canonFix[2], canonFix[3])
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
    end
    self.angular_speed_deg = 60
    self:InitSkill()
    if self.logic then
      self.logic:AddCaptain(self.index, self)
      self.logic:AddUnit(self)
      EventManager:GetInstance():Broadcast(EventId.SkirmishTacticalWeaponLoadDone)
    end
  end)
end

function TacticalWeaponUnit:ComponentDefine()
  base.ComponentDefine(self)
end

function TacticalWeaponUnit:InitSkill()
  local skillInfos = self.weapon:GetSkillInfos()
  for _, skillInfo in pairs(skillInfos) do
    if skillInfo.skillTemplateData == nil then
      Logger.LogError("\230\183\187\229\138\160\230\138\128\232\131\189\230\151\182\239\188\140\230\138\128\232\131\189\233\133\141\231\189\174\230\137\190\228\184\141\229\136\176,\230\138\128\232\131\189Id\239\188\154" .. skillInfo.id)
    end
    if skillInfo.skillTemplateData:GetSkillCatType() == HeroSkillCatType.Unit then
      self.skillManager:AddSkill(skillInfo.skillTemplateData, skillInfo, true)
    end
  end
  if self.skillChips then
    for _, skillChip in pairs(self.skillChips) do
      local skillInfo = skillChip:GetSkillInfo()
      if skillInfo ~= nil then
        if skillInfo.skillTemplateData == nil then
          Logger.LogError("\230\183\187\229\138\160\230\138\128\232\131\189\230\151\182\239\188\140\230\138\128\232\131\189\233\133\141\231\189\174\230\137\190\228\184\141\229\136\176,\230\138\128\232\131\189Id\239\188\154" .. skillInfo.id)
        end
        self.skillManager:AddSkill(skillInfo.skillTemplateData, skillInfo, false)
      end
      local additionalSkillInfo = skillChip:GetAdditionalSkillInfo()
      if additionalSkillInfo ~= nil then
        if additionalSkillInfo.skillTemplateData == nil then
          Logger.LogError("\230\183\187\229\138\160\230\138\128\232\131\189\230\151\182\239\188\140\230\138\128\232\131\189\233\133\141\231\189\174\230\137\190\228\184\141\229\136\176,\230\138\128\232\131\189Id\239\188\154" .. additionalSkillInfo.id)
        end
        self.skillManager:AddSkill(additionalSkillInfo.skillTemplateData, additionalSkillInfo, false)
      end
    end
  end
end

function TacticalWeaponUnit:OnUpdate(deltaTime)
  base.OnUpdate(self, deltaTime)
  if self.delayShow > 0 then
    self.delayShow = self.delayShow - 1
    if self.delayShow == 0 then
      local length = self.rendererArray.Length - 1
      for i = 0, length do
        self.rendererArray[i].enabled = true
      end
    end
  end
  local skillManagerValid = self.skillManager
  if skillManagerValid then
    local casting = self.skillManager:GetCastingSkill() ~= nil
    if casting then
      if not self.modelVisible then
        self.modelVisible = true
        if self.modelValid then
          self.delayShow = 1
        end
      end
    elseif self.modelVisible then
      self.modelVisible = false
      self.delayShow = 0
      if self.modelValid then
        local length = self.rendererArray.Length - 1
        for i = 0, length do
          self.rendererArray[i].enabled = false
        end
      end
    end
  end
  if skillManagerValid and self.logic.stage == SkirmishStage.Fight then
    self.skillManager:OnUpdate(deltaTime)
  end
end

function TacticalWeaponUnit:DestroyView()
  if self.modelValid and self.gameObject then
    local length = self.rendererArray.Length - 1
    for i = 0, length do
      self.rendererArray[i].enabled = true
    end
  end
  self.modelValid = false
  if self.anim then
    self.anim.cullingMode = CS.UnityEngine.AnimatorCullingMode.CullCompletely
  end
  base.DestroyView(self)
  if self.cannon then
    self.cannon:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  end
  if self.skillManager then
    self.skillManager:DestroyView()
  end
end

function TacticalWeaponUnit:DestroyData()
  if self.skillManager then
    self.skillManager:DestroyData()
    self.skillManager = nil
  end
  base.DestroyData(self)
end

function TacticalWeaponUnit:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff)
end

function TacticalWeaponUnit:AfterBeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill, deathEff)
end

function TacticalWeaponUnit:GetRawProperty(type)
  if self.weaponData == nil then
    return 0
  end
  return self.weaponData.effect[type] or 0
end

function TacticalWeaponUnit:DoAction(action, param)
  if action.phase == ActionPhase.SkillCast then
    local skill = self.skillManager:GetSkillById(action.skillId)
    if not skill then
      Logger.LogInfo(self.index .. "\229\143\183\228\189\141" .. "\230\136\152\230\156\175\230\173\166\229\153\168" .. self.weaponData.heroId .. "\230\178\161\230\156\137\230\138\128\232\131\189" .. action.skillId)
      return
    end
    if not skill:IsActiveSkill() then
      local targets = {}
      for _, v in pairs(action.targets) do
        table.insert(targets, self.logic:GetCaptain(v.index))
      end
      skill:Cast(targets, true)
      if self.index == 11 then
        EventManager:GetInstance():Broadcast(EventId.OnPVPTacticalWeaponCastSkill, skill)
      end
    end
  elseif action.phase == ActionPhase.Cast then
    local skill = self.skillManager:GetSkillById(action.skillId)
    if not skill then
      Logger.LogInfo(self.index .. "\229\143\183\228\189\141" .. "\230\136\152\230\156\175\230\173\166\229\153\168" .. self.weaponData.heroId .. "\230\178\161\230\156\137\230\138\128\232\131\189" .. action.skillId)
      return
    end
    if skill:IsActiveSkill() then
      local skillEffect = skill:GetEffect(action.effectId)
      if not skillEffect then
        Logger.LogInfo(self.index .. "\229\143\183\228\189\141" .. "\230\136\152\230\156\175\230\173\166\229\153\168" .. self.weaponData.heroId .. "\230\178\161\230\156\137\230\149\136\230\158\156Id:" .. action.effectId)
        return
      end
      if skillEffect:IsBuff() then
        local targets = {}
        for _, v in pairs(action.targets) do
          table.insert(targets, self.logic:GetCaptain(v.index))
        end
        self:CastSkill(skill, targets)
      elseif action.targets[1] then
        local target = self.logic:GetCaptain(action.targets[1].index)
        if target:GetCurBlood() <= 0 then
          self.logic:ErrorAction(action)
        end
        skillEffect:ForceLifeTime(self:GetCaptainDistance(action.targets[1].index))
        if action.targets[2] then
          local redirectTarget = {}
          for i = #action.targets, 2, -1 do
            local unit = self.logic:GetCaptain(action.targets[i].index)
            table.insert(redirectTarget, unit)
          end
          skillEffect:SetRedirectTarget(redirectTarget)
        end
        self:CastSkill(skill, target)
      end
    end
  elseif action.phase == ActionPhase.FIRE_BULLET then
    local skill = self.skillManager:GetSkillById(action.skillId)
    if not skill then
      Logger.LogInfo(self.index .. "\229\143\183\228\189\141" .. "\230\136\152\230\156\175\230\173\166\229\153\168" .. self.weaponData.heroId .. "\230\178\161\230\156\137\230\138\128\232\131\189" .. action.skillId)
      return
    end
    local skillEffect = skill:GetEffect(action.effectId)
    if not skillEffect then
      Logger.LogInfo(self.index .. "\229\143\183\228\189\141" .. "\230\136\152\230\156\175\230\173\166\229\153\168" .. self.weaponData.heroId .. "\230\178\161\230\156\137\230\149\136\230\158\156Id:" .. action.effectId)
      return
    end
    local targetData = action.targets[1]
    if targetData then
      local target = self.logic:GetCaptain(targetData.index)
      if target:GetCurBlood() <= 0 then
        self.logic:ErrorAction(action)
      end
      skillEffect:ForceLifeTime(self:GetCaptainDistance(targetData.index))
      skillEffect:CreateBullet(target)
    end
  elseif action.phase == ActionPhase.SPLASH_DAMAGE then
    local skill = self.skillManager:GetSkillById(action.skillId)
    if not skill then
      Logger.LogInfo(self.index .. "\229\143\183\228\189\141" .. "\232\139\177\233\155\132" .. self.hero.heroId .. "\230\178\161\230\156\137\230\138\128\232\131\189" .. action.skillId)
      return
    end
    local skillEffect = skill:GetEffect(action.effectId)
    if not skillEffect then
      Logger.LogInfo(self.index .. "\229\143\183\228\189\141" .. "\230\136\152\230\156\175\230\173\166\229\153\168" .. self.weaponData.heroId .. "\230\178\161\230\156\137\230\149\136\230\158\156Id:" .. action.effectId)
      return
    end
    if action.targets then
      for i = 1, #action.targets do
        local targetData = action.targets[i]
        local target = self.logic:GetCaptain(targetData.index)
        if target:GetCurBlood() <= 0 then
          self.logic:ErrorAction(action)
        end
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
    local shieldChange = false
    for _, v in pairs(param.buffChanges) do
      local meta = DataCenter.LWBuffTemplateManager:GetTemplate(v.buffId)
      if meta.type == BuffType.Shield then
        shieldChange = true
      end
      if self.RemoveBuffTimeOrder then
        self:RemoveBuffTimeOrder(v.buffId, 1)
      end
    end
    if shieldChange then
      local shieldRemain = param.shieldTotal or 0
      local percent = self.curBlood / self.maxBlood
      local shieldPercent = shieldRemain / self.maxBlood
      if self.hpBar then
        self.hpBar:SetHp(percent, shieldPercent)
      end
    end
  end
end

function TacticalWeaponUnit:UnDoAction(action, param)
  if action.phase == ActionPhase.Cast then
  elseif action.phase == ActionPhase.Damage then
  end
end

function TacticalWeaponUnit:GoDie()
  base.GoDie(self)
end

function TacticalWeaponUnit:Revive()
  base.Revive(self)
end

function TacticalWeaponUnit:DestroyTinyHead()
end

function TacticalWeaponUnit:ChangeStage(stage)
  base.ChangeStage(self, stage)
  if stage == SkirmishStage.Load then
  elseif stage == SkirmishStage.Opening then
  elseif stage == SkirmishStage.Fight then
  elseif stage == SkirmishStage.End and self.skillManager then
    self.skillManager:Interrupt()
  end
end

function TacticalWeaponUnit:GetCaptainDistance(targetIndex)
  return self.sceneData:GetCaptainDistance(self.index, targetIndex) - self.firePointOffset
end

function TacticalWeaponUnit:GetPosition()
  if self.transform then
    self.curWorldPos.x, self.curWorldPos.y, self.curWorldPos.z = self.transform:Get_position()
    return self.curWorldPos
  else
    return self.army:GetPosition() + self.localPosition * self.dirMultiplier
  end
end

function TacticalWeaponUnit:OnPassiveSkillCast(skill)
  base.OnPassiveSkillCast(self, skill)
  if self.index == 11 then
    EventManager:GetInstance():Broadcast(EventId.OnPVPTacticalWeaponCastSkill, skill)
  end
end

function TacticalWeaponUnit:GetTeamZeroWorldPos()
  if self.army then
    return self.army:GetZeroWorldPos()
  end
  return Vector3.zero
end

function TacticalWeaponUnit:GetUnitPositionInTeam()
  if self.sceneData and self.sceneData.platoonLocalPos and self.index then
    return self.sceneData.platoonLocalPos[self.index]
  end
  return Vector3.zero
end

function TacticalWeaponUnit:CastSkill(skill, target)
  base.CastSkill(self, skill, target)
  if self.index and self.index == 11 then
    EventManager:GetInstance():Broadcast(EventId.OnPVPTacticalWeaponCastSkill, skill)
  end
end

return TacticalWeaponUnit
