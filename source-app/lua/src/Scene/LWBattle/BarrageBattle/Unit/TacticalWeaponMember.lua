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
local MemberEffect = "Assets/_Art_LastWar/Effect/Prefab/Common/Eff_ring_blue.prefab"
local base = require("Scene.LWBattle.BarrageBattle.Unit.BarrageUnit")
local TacticalWeaponMember = BaseClass("TacticalWeaponMember", base)

function TacticalWeaponMember:Init(battleManager, squad, guid, req, weaponData, appearanceMeta, campBuff, skillChips, initShow)
  base.Init(self, battleManager, guid)
  if PVE_TEST_MODE then
    local GameFramework = CS.UnityEngine.GameObject.Find("GameFramework")
    self.bulletMotionEditor = GameFramework.transform:GetComponent(typeof(CS.BulletMotionEditor))
  end
  self.battleMgr = battleManager
  self.squad = squad
  self.m_req = req
  self.guid = guid
  self.unitType = UnitType.TacticalWeapon
  self.searchType = BattleSearchType.TacticalWeapon
  self.fsm = nil
  self.upFsm = nil
  self.gameObject = nil
  self.weaponData = weaponData
  self.campBuff = campBuff
  self.skillChips = skillChips
  self.propertyData = nil
  self:InitWeaponData()
  self.timeCount = 0
  self.maxBlood = 1
  self.curBlood = 1
  self.modelVisible = false
  if initShow then
    self.modelVisible = initShow
  end
  self.modelValid = false
  self.delayShow = 0
  if weaponData and appearanceMeta == nil then
    self.appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(weaponData:GetAppearance())
  else
    self.appearanceMeta = appearanceMeta
  end
  self.appearanceId = self.appearanceMeta.id
  self.localPosition = self.squad.formation:GetWeaponOffset()
end

function TacticalWeaponMember:DestroyView()
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
end

function TacticalWeaponMember:DestroyData()
  base.DestroyData(self)
  self.squad = nil
  self.weaponData = nil
  self.appearanceMeta = nil
  self.propertyData = nil
  self.bulletMotionEditor = nil
  self.curBlood = 0
  self.skillChips = nil
  self.campBuff = nil
end

function TacticalWeaponMember:OnCreate()
  if self.m_req ~= nil then
    self.gameObject = self.m_req.gameObject
    self.transform = self.gameObject.transform
  end
  self.transform:SetParent(self.squad.transform)
  self:ResetPosition()
  self.transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  self:ComponentDefine()
  self:InitFSM()
end

function TacticalWeaponMember:GetPosition()
  if not IsNull(self.transform) then
    self.curWorldPos.x, self.curWorldPos.y, self.curWorldPos.z = self.transform:Get_position()
    return self.curWorldPos
  elseif self.squad and self.squad:GetPosition() then
    return self.squad:GetPosition() + self.localPosition
  else
    return self.curWorldPos
  end
end

function TacticalWeaponMember:ResetPosition()
  self:SetLocalPosition(self.squad.formation:GetWeaponOffset())
end

function TacticalWeaponMember:SetLocalPosition(pos)
  self.localPosition = pos
  if not IsNull(self.transform) then
    self.transform:DOKill()
    self.transform:Set_localPosition(self.localPosition.x, self.localPosition.y, self.localPosition.z)
  end
end

function TacticalWeaponMember:SetPosition(pos)
  if not IsNull(self.transform) then
    self.transform:DOKill()
    self.transform.position = pos
  end
end

function TacticalWeaponMember:InitUnitProperties(campBuff, skillChips)
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
  if campBuff and campBuff.camp_effect then
    for k, v in pairs(campBuff.camp_effect) do
      self:AddHaloBuff(string.format("%s/-%s", self:GetGuid(), k), {
        [k] = v
      })
    end
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

function TacticalWeaponMember:InitWeaponData()
  if not self.weaponData then
    Logger.LogError("\232\142\183\229\143\150\230\136\152\230\156\175\230\173\166\229\153\168\230\149\176\230\141\174\229\164\177\232\180\165\239\188\140heroUuid\239\188\154")
    return
  end
  self.levelTemplate = self.weaponData.levelTemplate
  self.curBlood = 1
  self.maxBlood = 1
  self:InitUnitProperties(self.campBuff, self.skillChips)
end

function TacticalWeaponMember:GetRawProperty(theType)
  if not self.propertyData then
    return 0
  end
  return self.propertyData:GetProperty(theType)
end

function TacticalWeaponMember:InitFSM()
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

function TacticalWeaponMember:ComponentDefine()
  base.ComponentDefine(self)
  self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
  if not IsNull(self.anim) then
    self.anim.transform:Set_localPosition(0, 0, 0)
  end
  if not self.anim then
    Logger.LogError("\232\175\165\229\141\149\228\189\141\228\184\139\233\157\162\230\178\161\230\140\130SimpleAnimation\232\132\154\230\156\172\239\188\140gameObject:" .. self.gameObject.name)
  end
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
  if self.appearanceMeta then
    self.transform:Set_localScale(self.appearanceMeta.model_size, self.appearanceMeta.model_size, self.appearanceMeta.model_size)
    local fire_paths = self.appearanceMeta.fire_paths
    self.firePoints = {}
    if fire_paths then
      for i = 1, #fire_paths do
        local firePoint = self.transform:Find(fire_paths[i])
        if firePoint then
          table.insert(self.firePoints, firePoint)
        end
      end
    end
    self.firePoint = self.firePoints[1]
    self.firePointNull = IsNull(self.firePoint)
    if self.isHuman then
      self.cannon = self.transform
    else
      local canon_path = self.appearanceMeta.canon_path
      self.cannon = self.transform:Find(canon_path)
      if not self.cannon then
        self.cannon = self.transform
      else
        self.cannon:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      end
      local canonFix = self.appearanceMeta.canon_rotation
      if canonFix and #canonFix == 3 then
        self.localForward = Vector3.forward * Quaternion.Euler(canonFix[1], canonFix[2], canonFix[3])
      end
    end
    self.angular_speed_deg = 360
    self.buffPoints = {}
    if not table.IsNullOrEmpty(self.appearanceMeta.buff_path) then
      for i = 1, #self.appearanceMeta.buff_path do
        if string.IsNullOrEmpty(self.appearanceMeta.buff_path[i]) then
          self.buffPoints[i] = nil
        else
          local buffPoint = self.transform:Find(self.appearanceMeta.buff_path[i])
          if IsNull(buffPoint) then
            Logger.LogError("buff\231\130\185\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\229\164\150\232\167\130id\239\188\154" .. self.appearanceMeta.id .. "\239\188\140buff\231\130\185\232\183\175\229\190\132\239\188\154" .. self.appearanceMeta.buff_path[i])
          end
          self.buffPoints[i] = buffPoint
        end
      end
    end
    self.uiPoint = nil
    if not string.IsNullOrEmpty(self.appearanceMeta.ui_path) then
      self.uiPoint = self.transform:Find(self.appearanceMeta.ui_path)
      if not self.uiPoint then
        Logger.LogError("\228\184\173\229\191\131\231\130\185\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\229\164\150\232\167\130id\239\188\154" .. self.hero.modelId .. "\239\188\140\228\184\173\229\191\131\231\130\185\232\183\175\229\190\132\239\188\154" .. self.appearanceMeta.ui_path)
      end
    end
  end
  local _objTransform = self.gameObject.transform
  self.vfxCollide = _objTransform:Find("VFX_Collide")
  self:InitSkill(self.skillChips)
end

function TacticalWeaponMember:InitSkill()
  if not self.levelTemplate then
    return
  end
  if self.skillManager then
    self.skillManager:RemoveAllSkills()
  end
  local skills = self.levelTemplate:GetSkillInfos()
  for _, skillInfo in pairs(skills) do
    if skillInfo.skillTemplateData == nil then
      Logger.LogError("\230\183\187\229\138\160\230\138\128\232\131\189\230\151\182\239\188\140\230\138\128\232\131\189\233\133\141\231\189\174\230\137\190\228\184\141\229\136\176,\230\138\128\232\131\189Id\239\188\154" .. skillInfo.id)
    else
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

function TacticalWeaponMember:GetCannonTransform()
  return self.cannon
end

function TacticalWeaponMember:GetTransform()
  return self.transform
end

function TacticalWeaponMember:GetGameObject()
  return self.gameObject
end

function TacticalWeaponMember:GetFirePoint()
  if self.firePoint ~= nil then
    return self.firePoint, self.firePointNull
  end
  if self.transform ~= nil then
    return self.transform, false
  end
  return Vector3.New(0, 0, 0), false
end

function TacticalWeaponMember:GetFirePointById(id)
  if self.firePoints and self.firePoints[id] then
    return self.firePoints[id], false
  end
  return self:GetFirePoint()
end

function TacticalWeaponMember:OnUpdate(deltaTime)
  base.OnUpdate(self, deltaTime)
  if self.fsm then
    self.fsm:OnUpdate()
  end
  if self.upFsm then
    self.upFsm:OnUpdate()
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
  if 0 < self.delayShow then
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
end

function TacticalWeaponMember:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, dir, hitEff)
  return
end

function TacticalWeaponMember:AfterBeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill, deathEff)
  return
end

function TacticalWeaponMember:CheckEnemyInAlertRange()
  return self.battleMgr and PveUtil.CheckHasUnitInSphereRange(self.battleMgr, self:GetPosition(), Const.MEMBER_ALERT_RADIUS, LayerMask.GetMask("Zombie"), nil, 1)
end

function TacticalWeaponMember:IsMoving()
  return self.fsm and self.fsm:GetStateIndex() == MemberState.Move
end

function TacticalWeaponMember:IsSuperArmor()
  self.superArmor = false
  local buff = self:GetPropertyBuff(HeroEffectDefine.SuperArmor)
  if 0 < buff then
    self.superArmor = true
  end
  return self.superArmor
end

function TacticalWeaponMember:GetCurAndMaxHp()
  return self.curBlood, self.maxBlood
end

function TacticalWeaponMember:GetLocationType()
  return LocationType.None
end

function TacticalWeaponMember:GetHeroCamp()
  return HeroType.NONE
end

function TacticalWeaponMember:UltimateIsReady()
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

function TacticalWeaponMember:UltimateIsLock()
  if self.skillManager then
    local ultimateSkill = self.skillManager:GetUltimateSkill()
    return ultimateSkill and ultimateSkill.lock
  else
    return false
  end
end

function TacticalWeaponMember:GetUltimateTimeStopDuration()
  return self.skillManager:GetUltimateTimeStopDuration()
end

function TacticalWeaponMember:ChangeStage(stage)
  if stage == BarrageState.PreExit then
    self:SetInvincible(true)
  elseif stage == BarrageState.Exit then
    self:SetInvincible(true)
    if self.transform then
      self.battleMgr:ShowEffectObj("Assets/Main/Prefabs/LWBattle/Effect_Lod/Eff_duiwujiasu_lod.prefab", self.transform.localPosition, nil, -1, self.transform.parent)
    end
  end
end

function TacticalWeaponMember:OnBuffAdded(buff)
  base.OnBuffAdded(self, buff)
  return
end

function TacticalWeaponMember:OnBuffRemoved(buff)
  return
end

function TacticalWeaponMember:InterruptSkill()
  if self.skillManager then
    self.skillManager:Interrupt()
  end
end

function TacticalWeaponMember:HandleInput(command, param)
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

function TacticalWeaponMember:ChangeSkillChips(skillChips)
  skillChips = skillChips ~= nil and skillChips or {}
  self.skillChips = skillChips
  self:InitUnitProperties(self.campBuff, self.skillChips)
  self:InitSkill(self.skillChips)
end

function TacticalWeaponMember:OnPassiveSkillCast(skill)
  base.OnPassiveSkillCast(self, skill)
  EventManager:GetInstance():Broadcast(EventId.OnPVETacticalWeaponCastSkill, skill)
end

function TacticalWeaponMember:GetUnitPositionInTeam()
  if self.squad and self.squad.formation then
    return self.squad.formation:GetWeaponOffset()
  end
  return Vector3.zero
end

return TacticalWeaponMember
