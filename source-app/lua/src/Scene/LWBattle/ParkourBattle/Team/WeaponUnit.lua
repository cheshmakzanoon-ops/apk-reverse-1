local base = require("Scene.LWBattle.ParkourBattle.Team.MemberUnit")
local WeaponUnit = BaseClass("WeaponUnit", base)
local Resource = CS.GameEntry.Resource
local FSM = require("Framework.Common.FSM")
local StayState = require("Scene.LWBattle.ParkourBattle.Team.FSM.StayState")
local FireStateStraight = require("Scene.LWBattle.ParkourBattle.Team.FSM.FireStateStraight")
local FireStateDefenseStraight = require("Scene.LWBattle.ParkourBattle.Team.FSM.FireStateDefenseStraight")
local FireStateAuto = require("Scene.LWBattle.BarrageBattle.MemberState.MemberUpStateAutoAttack")
local FireStateHold = require("Scene.LWBattle.ParkourBattle.Team.FSM.FireStateHold")
local StateDead = require("Scene.LWBattle.ParkourBattle.Team.FSM.DeathState")
local Const = require("Scene.LWBattle.Const")
local SkillManager = require("Scene.LWBattle.Skill.SkillManager")
local SkillBarCell = require("DataCenter.ZombieBattle.HpBar.WeaponSkillBarCell")

function WeaponUnit:Init(logic, team, parent, localPos, weapon, appearanceMeta, skillChips)
  base.Init(self, logic, team, parent, localPos)
  self.type = Const.ParkourUnitType.Weapon
  self.isHuman = false
  self.unitType = UnitType.TacticalWeapon
  self.searchType = BattleSearchType.TacticalWeapon
  self.weaponData = weapon
  local path = "Assets/Main/Prefabs/LWBattle/Hero/army_t1_01.prefab"
  self.appearanceMeta = appearanceMeta
  if self.appearanceMeta then
    path = self.appearanceMeta.model_path
    self.appearanceId = self.appearanceMeta.id
  end
  self.skillChips = skillChips
  self:InitWeaponData(skillChips)
  self.maxBlood = 1
  self.curBlood = 1
  self.modelVisible = false
  self.modelValid = false
  self.delayShow = 0
  self.curPosX = self.localPosition.x
  self.curPosY = self.localPosition.y
  self.curPosZ = self.localPosition.z
  self.req = Resource:InstantiateAsync(path)
  self.req:completed("+", function(request)
    self.gameObject = request.gameObject
    self.transform = request.gameObject.transform
    self.transform:SetParent(self.parent)
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.transform:Set_eulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.transform:Set_localPosition(self.localPosition.x, self.localPosition.y, self.localPosition.z)
    self.transform:SetParent(nil)
    self.curPosX, self.curPosY, self.curPosZ = self.transform:Get_position()
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
    self.angular_speed_deg = 360
    self:ShowBornEffect()
    self:InitSkill(self.skillChips)
    if self.isExiting then
      self:StartExiting()
    end
  end)
end

function WeaponUnit:ComponentDefine()
  base.ComponentDefine(self)
  self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
  if not IsNull(self.anim) then
    self.anim.transform:Set_localPosition(0, 0, 0)
  end
end

function WeaponUnit:InitUnitProperties(skillChips)
  if not self.weaponData then
    return
  end
  if not self.propertyData then
    self.propertyData = HeroPropertyData.New()
  else
    self.propertyData:Clear()
  end
  local weaponPropData = self.weaponData:GetPropetyData()
  if weaponPropData then
    weaponPropData:WalkAllProperties(function(id, value)
      self.propertyData:SetProperty(id, value)
    end)
  end
  local weaponAtk = self.propertyData:GetProperty(HeroEffectDefine.TacticalWeaponAtk)
  weaponAtk = weaponAtk + self.propertyData:GetProperty(HeroEffectDefine.TacticalWeaponAtk_Battle_Add) * (1 + self.propertyData:GetProperty(50088))
  self.propertyData:SetProperty(HeroEffectDefine.PhysicalAttack, weaponAtk)
  local weaponHp = self.propertyData:GetProperty(HeroEffectDefine.TacticalWeaponHp)
  weaponHp = weaponHp + self.propertyData:GetProperty(HeroEffectDefine.TacticalWeaponHp_Battle_Add) * (1 + self.propertyData:GetProperty(50087))
  local tmeplate = self.weaponData.template
  if tmeplate and not table.IsNullOrEmpty(tmeplate.base_attr) then
    for id, value in pairs(tmeplate.base_attr) do
      self.propertyData:SetProperty(id, value)
    end
  end
  self.maxBlood = weaponHp
  self.curBlood = self.maxBlood
end

function WeaponUnit:InitWeaponData()
  self.skillManager = SkillManager.New(self.logic, self)
  self.skillManager.battleMgr = DataCenter.LWBattleManager.logic
  self.propertyData = DeepCopy(self.weaponData:GetPropetyData())
  self:InitUnitProperties(self.skillChips)
end

function WeaponUnit:InitSkill(skillChips)
  if not self.weaponData then
    return
  end
  if self.skillManager then
    self.skillManager:RemoveAllSkills()
  end
  local skillInfos = self.weaponData:GetSkillInfos()
  for _, skillInfo in pairs(skillInfos) do
    self.skillManager:AddSkill(skillInfo.skillTemplateData, skillInfo, false)
    break
  end
  if skillChips then
    for _, skillChip in pairs(skillChips) do
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

function WeaponUnit:InitFSM()
  self.fsm = FSM.New()
  self.fsm:AddState(Const.ParkourFireState.Stay, StayState.New(self))
  if self.logic.battleType and self.logic.battleType == Const.ParkourBattleType.Defense then
    self.fsm:AddState(Const.ParkourFireState.Straight, FireStateDefenseStraight.New(self))
  else
    self.fsm:AddState(Const.ParkourFireState.Straight, FireStateStraight.New(self))
  end
  self.fsm:AddState(Const.ParkourFireState.RotateAndShoot, FireStateAuto.New(self))
  self.fsm:AddState(Const.ParkourFireState.HoldFire, FireStateHold.New(self))
  self.fsm:AddState(Const.ParkourFireState.Dead, StateDead.New(self))
  self.fsm:ChangeState(Const.ParkourFireState.Stay)
  base.InitFSM(self)
end

function WeaponUnit:OnUpdate(deltaTime)
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
  if self.fsm then
    self.fsm:OnUpdate()
  end
  if skillManagerValid then
    self.skillManager:OnUpdate(deltaTime)
  end
end

function WeaponUnit:GetFirePoint()
  return self.firePoint, self.firePointNull
end

function WeaponUnit:GetFirePointById(id)
  if self.firePoints and self.firePoints[id] then
    return self.firePoints[id], false
  end
  return self:GetFirePoint()
end

function WeaponUnit:GetMoveVelocity()
  if self.fsm and self.fsm:GetStateIndex() == Const.ParkourFireState.Straight then
    return Vector3.New(0, 0, self.team.speedZ)
  else
    return Vector3.zero
  end
end

function WeaponUnit:DestroyView()
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
  if self.skillBar then
    self.skillBar:Delete()
    self.skillBar = nil
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
end

function WeaponUnit:DestroyData()
  base.DestroyData(self)
  if self.skillManager then
    self.skillManager:DestroyData()
    self.skillManager = nil
  end
end

function WeaponUnit:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff)
end

function WeaponUnit:AfterBeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill, deathEff)
end

function WeaponUnit:GetRawProperty(type)
  if self.propertyData == nil then
    return 0
  end
  return self.propertyData:GetProperty(type)
end

function WeaponUnit:ChangeStage(stage)
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
  elseif stage == Const.ParkourBattleState.Exit then
    self:SetInvincible(true)
    if self.fsm then
      self.fsm:ChangeState(Const.ParkourFireState.HoldFire)
    end
  elseif stage == Const.ParkourBattleState.Farm then
    if self.fsm then
      self.fsm:ChangeState(Const.ParkourFireState.RotateAndShoot)
    end
    if not self.logic.battleType or self.logic.battleType == Const.ParkourBattleType.Defense then
    end
  elseif stage == Const.ParkourBattleState.Lose and self.skillBar then
    self.skillBar:SetActive(false)
  end
end

function WeaponUnit:GetMoveSpeed()
  return 1
end

function WeaponUnit:OnFingerDown(pos)
  base.OnFingerDown(self)
  if self:GetState(AnimName.Run) then
    self:PlaySimpleAnim(AnimName.Run)
  elseif self:GetState(AnimName.Walk) then
    self:PlaySimpleAnim(AnimName.Walk)
  end
end

function WeaponUnit:OnFingerUp()
  base.OnFingerUp(self)
  if self:GetState(AnimName.Idle) then
    self:PlaySimpleAnim(AnimName.Idle)
  end
end

function WeaponUnit:ChangeSkillChips(skillChips)
  skillChips = skillChips ~= nil and skillChips or {}
  self.skillChips = skillChips
  self:InitUnitProperties(self.skillChips)
  self:InitSkill(self.skillChips)
end

function WeaponUnit:OnPassiveSkillCast(skill)
  base.OnPassiveSkillCast(self, skill)
  EventManager:GetInstance():Broadcast(EventId.OnPVETacticalWeaponCastSkill, skill)
end

function WeaponUnit:UpdateRelativePosition(x, z)
  if self.transform then
    self.curPosZ = z
    self.transform:Set_position(self.curPosX, self.curPosY, self.curPosZ)
  end
end

function WeaponUnit:SetLocalPosition(pos)
  self.localPosition = pos
  if self.transform then
    self.transform:DOKill()
    self:UpdateRelativePosition(self.localPosition.x, self.localPosition.z)
  end
end

return WeaponUnit
