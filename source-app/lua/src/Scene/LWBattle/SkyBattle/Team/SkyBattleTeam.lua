local Resource = CS.GameEntry.Resource
local GameObject = CS.UnityEngine.GameObject
local Const = require("Scene.LWBattle.Const")
local HeroUnit = require("Scene.LWBattle.SkyBattle.Team.SkyHeroUnit")
local fingerDir = Vector3.zero
local SkyBattleTeam = BaseClass("SkyBattleTeam")
local FSM = require("Framework.Common.FSM")
local SkyBattleTeamFormation = require("Scene.LWBattle.SkyBattle.Team.SkyBattleTeamFormation")
local TeamHorizontalIdle = require("Scene.LWBattle.SkyBattle.Team.TeamHorizontalFSM.TeamHorizontalIdle")
local TeamHorizontalLeft = require("Scene.LWBattle.SkyBattle.Team.TeamHorizontalFSM.TeamHorizontalLeft")
local TeamHorizontalRight = require("Scene.LWBattle.SkyBattle.Team.TeamHorizontalFSM.TeamHorizontalRight")
local TeamHorizontalForward = require("Scene.LWBattle.SkyBattle.Team.TeamHorizontalFSM.TeamHorizontalForward")
local TeamHorizontalBackward = require("Scene.LWBattle.SkyBattle.Team.TeamHorizontalFSM.TeamHorizontalBackward")

function SkyBattleTeam:__init(x, z, logic, defaultHero, defaultHeroOverrideProperty, defaultHeroOverrideSkill, initComplete)
  local go = GameObject("SKyBattleTeamRoot")
  self.gameObject = go
  self.transform = go.transform
  self.curPos = Vector3.New(x, 0, z)
  self:SetPosition(x, z)
  self.logic = logic
  self.moveSpeedDirty = true
  self.moveSpeedZDirty = true
  self.superArmorDirty = true
  self.superArmor = false
  self.isExiting = false
  self.defaultHeroStrs = defaultHero
  self.defaultHeroOverrideProperty = defaultHeroOverrideProperty
  self.defaultHeroOverrideSkill = defaultHeroOverrideSkill
  self.formationMaxPosCount = 0
  self.initComplete = initComplete
  self.formation = SkyBattleTeamFormation.New(logic.data and logic.data.specialPos or nil)
  self.formationSpecialType = 1
  self.formationInited = false
  self.formation:Init(self.formationSpecialType, self.transform, Bind(self, self.OnTeamFormationInited))
  self.teamUnits = {}
  self.teamInitUnitIndexes = {}
  self.cacheTeamUnitIndexMap = {}
  self.teamInitUnitIds = {}
  self.teamUnitCount = 0
  self.overflowUnitCount = 0
  self.teamWorkerCount = 0
  self.teamInvisiblePetCount = 0
  self:InitFSM()
  self.oldZ = 0
  self.oldX = 0
  self.lastTeamCount = 0
end

function SkyBattleTeam:OnTeamFormationInited()
  self.formationInited = true
  self.formationMaxPosCount = self.formation.posCount
  if not string.IsNullOrEmpty(self.defaultHeroStrs) then
    local heroIds = string.split(self.defaultHeroStrs, "|")
    for _, heroId in ipairs(heroIds) do
      local hero = self:AddMember(tonumber(heroId), 1, self.defaultHeroOverrideProperty, self.defaultHeroOverrideSkill, false)
      if not self.defaultHero then
        self.defaultHero = hero
      end
    end
  end
  if self.initComplete then
    self.initComplete()
  end
end

function SkyBattleTeam:GetDefaultHero()
  return self.defaultHero
end

function SkyBattleTeam:__delete()
  self:Destroy()
end

function SkyBattleTeam:Update(deltaTime)
  if self:IsExiting() then
    return
  end
  for key, unit in pairs(self.teamUnits) do
    unit:OnUpdate(deltaTime)
  end
  if self:IsSuperArmor() then
    self:UpdateMemberCollision()
  end
end

function SkyBattleTeam:GetMinKey(team)
  local minKey
  for k, _ in pairs(team) do
    if minKey == nil or k < minKey then
      minKey = k
    end
  end
  return minKey
end

function SkyBattleTeam:Destroy()
  self.defaultHero = nil
  self.formationInited = false
  self.hasDefaultHero = nil
  self.defaultHeroOverrideProperty = nil
  self.defaultHeroOverrideSkill = nil
  if self.formation then
    self.formation:Destroy()
    self.formation = nil
  end
  if self.teamUnits then
    for _, unit in pairs(self.teamUnits) do
      self.logic:RemoveUnit(unit.guid)
    end
    self.teamUnits = nil
  end
  if self.gameObject then
    GameObject.Destroy(self.gameObject)
    self.gameObject = nil
    self.transform = nil
  end
  if self.moveDirectionFSM then
    self.moveDirectionFSM:Delete()
    self.moveDirectionFSM = nil
  end
  self:ClearFailFlag()
end

function SkyBattleTeam:InitFSM()
  self.moveDirectionFSM = FSM.New()
  self.moveDirectionFSM:AddState(SkyBattleMoveDirectionState.Idle, TeamHorizontalIdle.New(self))
  self.moveDirectionFSM:AddState(SkyBattleMoveDirectionState.Left, TeamHorizontalLeft.New(self))
  self.moveDirectionFSM:AddState(SkyBattleMoveDirectionState.Right, TeamHorizontalRight.New(self))
  self.moveDirectionFSM:AddState(SkyBattleMoveDirectionState.Forward, TeamHorizontalForward.New(self))
  self.moveDirectionFSM:AddState(SkyBattleMoveDirectionState.BackWard, TeamHorizontalBackward.New(self))
  self.moveDirectionFSM:ChangeState(SkyBattleMoveDirectionState.Idle)
end

function SkyBattleTeam:AddMember(heroId, heroLevel, overrideProperties, overrideSkills, showBornTween)
  local newHeroId = heroId
  if self.logic.GetReplaceAppearance then
    local id = self.logic:GetReplaceAppearance(heroId)
    if 0 < id then
      newHeroId = id
    end
  end
  local heroCfg = self:GenHeroCfg(newHeroId, heroLevel or 1)
  if not heroCfg then
    Logger.LogError("no hero ", newHeroId)
    return nil
  end
  if overrideProperties then
    for i, property in ipairs(overrideProperties) do
      heroCfg.propertyData:SetProperty(property.key, property.value)
    end
  end
  local resetSkills = false
  if overrideSkills then
    for _, data in pairs(overrideSkills) do
      local skillId = data.skillId
      local realSkillId = tonumber(skillId)
      local skillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplate(realSkillId)
      if skillTemplate then
        if not resetSkills then
          heroCfg.skillDict = {}
          heroCfg.skillList = {}
          resetSkills = true
        end
        local skillData = SkillInfo.New()
        skillData:CreateFromTemplate(realSkillId, true)
        skillData.slotIndex = data.slot
        heroCfg.skillDict[realSkillId] = skillData
        heroCfg.skillList[data.slot] = skillData
      end
    end
  end
  return self:RealAddMember(heroCfg, heroId, heroLevel, showBornTween)
end

function SkyBattleTeam:RealAddMember(heroCfg, originalHeroId, heroLevel, showBornTween)
  local valid, emptySlot, resetPos = self:TryAddUnitToTeam(true)
  if not valid then
    return
  end
  local hero = ObjectPool:GetInstance():Load(HeroUnit)
  hero:Init(self.logic, self, self.transform, Vector3.zero, heroCfg, nil, originalHeroId)
  self.logic:AddUnit(hero)
  self:AddUnitToTeam(hero, emptySlot, resetPos)
  if showBornTween then
    hero:BornValidFlag()
  end
  return hero
end

function SkyBattleTeam:GenHeroCfg(heroId, heroLv)
  local hero = HeroInfo.New()
  local level = heroLv or 1
  hero:UpdateFromTemplate(heroId, level)
  return hero
end

function SkyBattleTeam:RemoveMemberWithoutUnit(hero)
  if self:GetMemberCount() < 1 or not hero then
    Logger.LogError("No member can be removed!")
    return
  end
  if self.logic.state == Const.ParkourBattleState.PreExit or self.logic.state == Const.ParkourBattleState.Exit then
    return
  end
  Logger.Log("Remove team member " .. hero.guid)
  local slot = 0
  for index, unit in pairs(self.teamUnits) do
    if unit == hero then
      slot = index
      break
    end
  end
  if 0 < slot then
    self.teamUnits[slot] = nil
    self.teamUnitCount = self.teamUnitCount - 1
    if hero.unitType == UnitType.Pet and not hero:IsBattleLostCondition() then
      self.teamInvisiblePetCount = self.teamInvisiblePetCount - 1
      if 0 > self.teamInvisiblePetCount then
        self.teamInvisiblePetCount = 0
      else
      end
    end
  end
end

function SkyBattleTeam:RemoveMember(hero)
  if self:GetMemberCount() < 1 or not hero then
    Logger.LogError("No member can be removed!")
    return
  end
  if self.logic.state == Const.ParkourBattleState.PreExit or self.logic.state == Const.ParkourBattleState.Exit then
    return
  end
  Logger.Log("Remove team member " .. hero.guid)
  hero.curBlood = 0
  self.logic:RemoveUnit(hero.guid)
  local slot = 0
  for index, unit in pairs(self.teamUnits) do
    if unit == hero then
      slot = index
      break
    end
  end
  if 0 < slot then
    self.teamUnits[slot] = nil
    self.teamUnitCount = self.teamUnitCount - 1
    if hero.unitType == UnitType.Pet and not hero:IsBattleLostCondition() then
      self.teamInvisiblePetCount = self.teamInvisiblePetCount - 1
      if 0 > self.teamInvisiblePetCount then
        self.teamInvisiblePetCount = 0
      end
    end
  else
    Logger.LogError("ParkourTeam.RemoveMember error ! guid:" .. hero.guid)
  end
end

function SkyBattleTeam:ResetPos()
  for slotIndex, unit in pairs(self.teamUnits) do
    if unit ~= nil then
      local pos = self.formation:GetOffsetByIndex(slotIndex)
      if unit.CanChangePosition == nil or unit.CanChangePosition and unit:CanChangePosition() then
        unit:SetLocalPosition(pos)
      end
    end
  end
end

function SkyBattleTeam:GetMemberCount()
  return self.teamUnitCount - self.teamWorkerCount - self.teamInvisiblePetCount
end

function SkyBattleTeam:GetLastUnit()
  if self.formationMaxPosCount > 0 and self.teamUnits then
    for i = self.formationMaxPosCount, 1, -1 do
      local unit = self.teamUnits[i]
      if unit ~= nil then
        return unit
      end
    end
  end
  return nil
end

function SkyBattleTeam:GetCurInitHeroAndSoliderCount()
end

function SkyBattleTeam:GetRemainUnitCount()
  local memberCount = self:GetMemberCount()
  memberCount = Mathf.Max(0, memberCount)
  return memberCount + Mathf.Max(self.overflowUnitCount, 0)
end

function SkyBattleTeam:TryReduceOverflowUnit(base)
  if self.overflowUnitCount > 0 then
    if base >= self.overflowUnitCount then
      base = base - self.overflowUnitCount
      self.overflowUnitCount = 0
      return base
    end
    self.overflowUnitCount = self.overflowUnitCount - base
    return 0
  end
  return base
end

function SkyBattleTeam:SetPosition(x, z)
  self.curPos.x = x
  self.curPos.z = z
  self.transform:Set_position(x, 0, z)
end

function SkyBattleTeam:GetPosition()
  return self.curPos
end

function SkyBattleTeam:GetPositionZ()
  return self.curPos.z
end

function SkyBattleTeam:MoveToPos(x, z, deltaTime)
  if not x or not z then
    return
  end
  self:SetPosition(x, z)
end

function SkyBattleTeam:MoveDirectionHorizontal(hDelta)
  if 0 < hDelta then
    self.moveDirectionFSM:ChangeState(SkyBattleMoveDirectionState.Right, hDelta)
  elseif hDelta < 0 then
    self.moveDirectionFSM:ChangeState(SkyBattleMoveDirectionState.Left, hDelta)
  end
end

function SkyBattleTeam:MoveDirectionVertical(vDelta)
  if 0 < vDelta then
    self.moveDirectionFSM:ChangeState(SkyBattleMoveDirectionState.Forward, vDelta)
  elseif vDelta < 0 then
    self.moveDirectionFSM:ChangeState(SkyBattleMoveDirectionState.BackWard, vDelta)
  end
end

function SkyBattleTeam:StopMoveDirection()
  self.moveDirectionFSM:ChangeState(SkyBattleMoveDirectionState.Idle)
end

function SkyBattleTeam:IsMoving()
  return self.moveDirectionFSM:GetStateIndex() ~= SkyBattleMoveDirectionState.Idle
end

function SkyBattleTeam:IsHorizontalMoving()
  return self:IsMoving()
end

function SkyBattleTeam:PlayTeamAnim(anim)
  for _, unit in pairs(self.teamUnits) do
    local cur = unit:GetCurAnimName()
    if cur ~= anim then
      unit:CrossFadeSimpleAnim(anim, 1, 0.2)
    end
  end
end

function SkyBattleTeam:SetActive(isOn)
  if self.gameObject then
    self.gameObject:SetActive(isOn)
  end
end

function SkyBattleTeam:GetMoveSpeedZ()
  if not self.moveSpeedZDirty then
    return self.finalSpeedZ
  end
  self.moveSpeedZDirty = false
  local addValue = 0
  for _, unit in pairs(self.teamUnits) do
    local bfValue = unit:GetProperty(HeroEffectDefine.BattleHeroMoveSpeed)
    if 0 < bfValue then
      addValue = self.speedZ * bfValue
      break
    end
  end
  self.finalSpeedZ = self.speedZ + addValue
  return self.finalSpeedZ
end

function SkyBattleTeam:GetBonusDashSpeedZ()
  if self.logic and self.logic.dashBonusSpeed then
    return self:GetMoveSpeedZ() * self.logic.dashBonusSpeed
  end
  return self:GetMoveSpeedZ()
end

function SkyBattleTeam:IsSuperArmor()
  if not self.superArmorDirty then
    return self.superArmor
  end
  local oldValue = self.superArmor
  self.superArmorDirty = false
  self.superArmor = false
  for _, unit in pairs(self.teamUnits) do
    local buff = unit:GetPropertyBuff(HeroEffectDefine.SuperArmor)
    if 0 < buff then
      self.superArmor = true
      break
    end
  end
  if oldValue ~= self.superArmor then
    self:SetInvincible(self.superArmor)
    EventManager:GetInstance():Broadcast(EventId.SquadSuperArmorStateChange)
  end
  return self.superArmor
end

function SkyBattleTeam:UpdateMemberCollision()
  for _, member in pairs(self.teamUnits) do
    if member.unitType ~= UnitType.Plot then
      if not member.colliderComponent then
        local function collision(colliderCnt, colliderComponentArray)
          self:OnCollision(colliderCnt, colliderComponentArray)
        end
        
        member:InitColliderComponent(LayerMask.GetMask("Zombie") | LayerMask.GetMask(LayerType.Junk), collision)
      end
      if member.colliderComponent then
        member.colliderComponent:CollisionDetect()
      end
    end
  end
end

function SkyBattleTeam:OnCollision(colliderCnt, colliderComponentArray)
  for i = 0, colliderCnt - 1 do
    self:Hit(colliderComponentArray[i])
  end
end

local HitDamageCD = 100
local deathEffPath = "Assets/_Art_LastWar/Effect/Prefab/Common/Eff_shiti_boom.prefab"

function SkyBattleTeam:Hit(otherObj)
  local now = UITimeManager:GetInstance():GetServerTime()
  local trigger = otherObj:GetComponent(typeof(CS.CitySpaceManTrigger))
  if trigger ~= nil and trigger.ObjectId ~= 0 then
    local tar = self.logic:GetUnit(trigger.ObjectId)
    if tar and 0 < (tar.curBlood or 0) and now - (tar.lastHitTime or 0) > HitDamageCD then
      tar.lastHitTime = now
      local hurt = 1
      local hitPoint = tar:GetPosition()
      local hitDir
      local whiteTime = 0.2
      local stiffTime = 0
      local hitBackDistance, hitEff
      if 0 < tar.meta.crash_kill then
        hurt = tar.maxBlood * (tar.meta.crash_kill / 100)
      else
        return
      end
      if hurt < tar.curBlood then
        hitBackDistance = Vector3.Normalize(hitPoint - self:GetPosition()) * 10
      end
      local m_deathEffPath = deathEffPath
      if tar.meta.monster_type == Const.MonsterType.Junk then
        m_deathEffPath = nil
      end
      tar:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff)
      tar:AfterBeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, nil, m_deathEffPath, true)
      if tar.meta.is_boss == 1 then
        local p = {}
        p.duration = 0.5
        p.strength = Vector3.New(1, 1, 0)
        p.vibrato = 20
        self.logic:ShakeCameraWithParam(p)
      end
    end
  end
end

function SkyBattleTeam:IsExiting()
  return self.logic.state == Const.ParkourBattleState.Exit
end

function SkyBattleTeam:ChangeStage(stage)
  for _, unit in pairs(self.teamUnits) do
    unit:ChangeStage(stage)
  end
end

function SkyBattleTeam:GetMoveSpeed()
  if self.moveSpeed and not self.moveSpeedDirty then
    return self.moveSpeed
  end
  self.moveSpeed = 99
  self.moveSpeedDirty = false
  for _, member in pairs(self.teamUnits) do
    local speed = member:GetMoveSpeed()
    self.moveSpeed = speed < self.moveSpeed and speed or self.moveSpeed
  end
  return self.moveSpeed
end

function SkyBattleTeam:ReturnMemberPositions()
  local pos = {}
  for i = 1, 5 do
    if self:IsShowSlotIndex(i) then
      local offset = self.formation:GetOffsetByIndex(i)
      local worldPos = self.transform:TransformPoint(offset)
      table.insert(pos, worldPos)
    end
  end
  return pos
end

function SkyBattleTeam:ResetHeroPosition()
  self:ResetPos()
end

function SkyBattleTeam:SetHeroPosition(index, worldPos)
  for slot, unit in pairs(self.teamUnits) do
    if index == slot then
      unit:SetPosition(worldPos)
    end
  end
end

function SkyBattleTeam:MoveHeroToIndex(index, dstIndex, time)
  for slot, unit in pairs(self.teamUnits) do
    if slot == index then
      local localPos = self.formation:GetOffsetByIndex(dstIndex)
      unit:MoveToLocalPos(localPos, time)
    end
  end
end

function SkyBattleTeam:OnStartBattle(changeFormation)
  self.teamInitUnitIndexes = {}
  self.cacheTeamUnitIndexMap = {}
  self.teamInitUnitIds = {}
  self.teamInitUnits = {}
  for index, unit in pairs(self.teamUnits) do
    if unit.hero then
      if not unit.hero.fromTemplate then
        table.insert(self.teamInitUnitIds, unit.hero.uuid)
        table.insert(self.teamInitUnitIndexes, index)
      end
      table.insert(self.teamInitUnits, unit)
    end
  end
  if changeFormation then
    for slot, unit in pairs(self.teamUnits) do
      local localPos = self.formation:GetOffsetByIndex(slot)
      unit:MoveToLocalPos(localPos, 0.5)
    end
  end
end

function SkyBattleTeam:GetRandomInitUuid()
  local heroes = self.teamInitUnitIds
  local count = #heroes
  if 0 < count then
    return heroes[math.random(count)]
  end
  return 0
end

function SkyBattleTeam:GetInitUuidAuto(index)
  if self.cacheTeamUnitIndexMap[index] then
    return self.cacheTeamUnitIndexMap[index]
  end
  local indexes = self.teamInitUnitIndexes
  local less = 0
  local equal = 0
  local great = 0
  for i, v in ipairs(indexes) do
    if 0 < v and v < index and less == 0 then
      less = i
    end
    if v == index then
      equal = i
      break
    end
    if 0 < v and index < v and great == 0 then
      great = i
    end
  end
  if 0 < equal then
    local uuid = self.teamInitUnitIds[equal]
    self.teamInitUnitIndexes[equal] = 0
    self.cacheTeamUnitIndexMap[index] = uuid
    return uuid
  end
  if 0 < great then
    local uuid = self.teamInitUnitIds[great]
    self.teamInitUnitIndexes[great] = 0
    self.cacheTeamUnitIndexMap[index] = uuid
    return uuid
  end
  if 0 < less then
    local uuid = self.teamInitUnitIds[less]
    self.teamInitUnitIndexes[less] = 0
    self.cacheTeamUnitIndexMap[index] = uuid
    return uuid
  end
  for _, v in pairs(self.cacheTeamUnitIndexMap) do
    return v
  end
  return 0
end

function SkyBattleTeam:GetZeroWorldPos()
  if not IsNull(self.transform) then
    if not self._cachePos then
      self._cachePos = Vector3.New()
    end
    local x, y, z = self.transform:Get_position()
    self._cachePos.x = x
    self._cachePos.y = y
    self._cachePos.z = z
    return self._cachePos
  end
  return Vector3.zero
end

function SkyBattleTeam:GetUnitPosition(guid)
  if self.formation and guid then
    for index, unit in pairs(self.teamUnits) do
      if unit.guid == guid then
        return self.formation:GetOffsetByIndex(index)
      end
    end
  end
  return Vector3.zero
end

function SkyBattleTeam:TryAddUnitToTeam(counter, preferPos)
  local resetPos = false
  local emptySlot = 0
  local newCount = self.teamUnitCount + 1
  if newCount <= self.formationMaxPosCount then
    if preferPos and 0 < preferPos and not self.teamUnits[preferPos] then
      emptySlot = preferPos
    else
      for i = 1, self.formationMaxPosCount do
        if self.teamUnits[i] == nil then
          emptySlot = i
          break
        end
      end
    end
    if emptySlot == 0 then
      Logger.LogError("ParkourTeam.AddUnitToTeam find empty slot error !")
      if not self.formation.canResize then
        if counter then
          self.overflowUnitCount = self.overflowUnitCount + 1
        end
        return false
      end
      self.formation:ReSize(self.formationMaxPosCount + 1)
      emptySlot = self.formationMaxPosCount + 1
      if self.formation.posCount > self.formationMaxPosCount then
        self.formationMaxPosCount = self.formation.posCount
      else
        if counter then
          self.overflowUnitCount = self.overflowUnitCount + 1
        end
        return false
      end
      resetPos = true
    end
  else
    if not self.formation.canResize then
      if counter then
        self.overflowUnitCount = self.overflowUnitCount + 1
      end
      return false
    end
    self.formation:ReSize(self.formationMaxPosCount + 1)
    emptySlot = self.formationMaxPosCount + 1
    if self.formation.posCount > self.formationMaxPosCount then
      self.formationMaxPosCount = self.formation.posCount
    else
      if counter then
        self.overflowUnitCount = self.overflowUnitCount + 1
      end
      return false
    end
    resetPos = true
  end
  if self.teamUnits[emptySlot] ~= nil then
    Logger.LogError("ParkourTeam.AddUnitToTeam invalid empty slot !")
    return false
  end
  return true, emptySlot, resetPos
end

function SkyBattleTeam:AddUnitToTeam(unit, emptySlot, resetPos)
  self.teamUnits[emptySlot] = unit
  self.teamUnitCount = self.teamUnitCount + 1
  if unit.SetSlot then
    unit:SetSlot(emptySlot)
  end
  if resetPos then
    self:ResetPos()
  else
    local pos = self.formation:GetOffsetByIndex(emptySlot)
    if unit.CanChangePosition == nil or unit.CanChangePosition and unit:CanChangePosition() then
      unit:SetLocalPosition(pos)
    end
  end
end

function SkyBattleTeam:IsShowSlotIndex(slotIndex)
  if self.formationSpecialType then
    local showSlotIndexList = ArmyFormationSlotPositionType[self.formationSpecialType]
    if showSlotIndexList then
      for _, v in ipairs(showSlotIndexList) do
        if v == slotIndex then
          return true
        end
      end
      return false
    end
  end
  return true
end

function SkyBattleTeam:ShowFailFlag()
  self:ClearFailFlag()
  self.failFlagId = self.logic:ShowEffectObj("Assets/Main/Prefabs/LWBattle/flag/A_build_flag_04.prefab", Vector3.zero, nil, -1, self.transform)
end

function SkyBattleTeam:ClearFailFlag()
  if self.failFlagId then
    self.logic:RemoveEffectObj(self.failFlagId)
    self.failFlagId = nil
  end
end

function SkyBattleTeam:DoDirectionRotate(skyBattleMoveDirectionState, moveDelta)
  for _, unit in pairs(self.teamUnits) do
    unit:DoDirectionRotate(skyBattleMoveDirectionState, moveDelta)
  end
end

function SkyBattleTeam:CheckNeedHorizontalRoll(hMoveDelta)
  return false
end

return SkyBattleTeam
