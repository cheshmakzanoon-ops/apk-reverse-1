local Resource = CS.GameEntry.Resource
local GameObject = CS.UnityEngine.GameObject
local Const = require("Scene.LWBattle.Const")
local HeroUnit = require("Scene.LWBattle.ParkourBattle.Team.HeroUnit")
local WorkerUnit = require("Scene.LWBattle.ParkourBattle.Team.WorkerUnit")
local WeaponUnit = require("Scene.LWBattle.ParkourBattle.Team.WeaponUnit")
local PetUnit = require("Scene.LWBattle.ParkourBattle.Team.PetUnit")
local fingerDir = Vector3.zero
local ParkourTeam = BaseClass("ParkourTeam")
local FSM = require("Framework.Common.FSM")
local TeamStateFarm = require("Scene.LWBattle.ParkourBattle.Team.TeamFSM.TeamStateFarm")
local TeamStateDefense = require("Scene.LWBattle.ParkourBattle.Team.TeamFSM.TeamStateDefense")
local TeamStateBoss = require("Scene.LWBattle.ParkourBattle.Team.TeamFSM.TeamStateBoss")
local TeamStateExit = require("Scene.LWBattle.ParkourBattle.Team.TeamFSM.TeamStateExit")
local TeamStateBossStay = require("Scene.LWBattle.ParkourBattle.Team.TeamFSM.TeamStateBossStay")
local TeamStateDash = require("Scene.LWBattle.ParkourBattle.Team.TeamFSM.TeamStateDash")
local ParkourTeamFormation = require("Scene.LWBattle.ParkourBattle.Team.ParkourTeamFormation")
local ParkourCircleTeamFormation = require("Scene.LWBattle.ParkourBattle.Team.ParkourCircleTeamFormation")
local ParkourSpecialCircleTeamFormation = require("Scene.LWBattle.ParkourBattle.Team.ParkourSpecialCircleTeamFormation")
local ParkourDynamicTeamFormation = require("Scene.LWBattle.ParkourBattle.Team.ParkourDynamicTeamFormation")
local TeamHorizontalIdle = require("Scene.LWBattle.ParkourBattle.Team.TeamHorizontalFSM.TeamHorizontalIdle")
local TeamHorizontalLeft = require("Scene.LWBattle.ParkourBattle.Team.TeamHorizontalFSM.TeamHorizontalLeft")
local TeamHorizontalRight = require("Scene.LWBattle.ParkourBattle.Team.TeamHorizontalFSM.TeamHorizontalRight")
local guideArrow = require("DataCenter.LWBattle.Logic.LastStand.LastStandGuideArrow")
local HorizontalMoveState = {
  Idle = 1,
  Left = 2,
  Right = 3
}

function ParkourTeam:__init(x, z, logic, defaultHero, appearanceMap)
  local go = GameObject("ParkourTeamRoot")
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
  self.appearanceMap = appearanceMap
  local hasDefaultHero = not string.IsNullOrEmpty(defaultHero)
  if logic.data and logic.data.dynamicPos and 0 < logic.data.dynamicPos then
    self.formation = ParkourDynamicTeamFormation.New(logic.data:GetDynamicFormationPosMax(self.logic.param.enterType), defaultHero)
  elseif logic.data and logic.data.circlePos then
    self.formation = ParkourCircleTeamFormation.New(logic.data.circlePos)
  elseif logic.data and logic.data.specialCirclePos then
    self.formation = ParkourSpecialCircleTeamFormation.New(logic.data.specialCirclePos)
  else
    self.formation = ParkourTeamFormation.New(logic.data and logic.data.specialPos or nil)
  end
  local defense = logic.battleType and logic.battleType == Const.ParkourBattleType.Defense
  self.formationSpecialType = logic.data.formationSpecialType
  self.formation:Init(hasDefaultHero, defense, defense, self.formationSpecialType)
  self.teamUnits = {}
  self.teamInitUnitIndexes = {}
  self.cacheTeamUnitIndexMap = {}
  self.teamInitUnitIds = {}
  self.teamInitHeroId2UuidMap = {}
  self.teamUnitCount = 0
  self.overflowUnitCount = 0
  self.teamWorkerCount = 0
  self.teamInvisiblePetCount = 0
  self.formationMaxPosCount = self.formation.posCount
  self.qualitySlots = {}
  self.indexRecommendSlots = {}
  self.hummerHero = nil
  self.defaultHeroIds = {}
  self.defaultHeroUidDic = {}
  if hasDefaultHero then
    local heroIds = string.split(defaultHero, "|")
    for _, heroId in ipairs(heroIds) do
      local defaultHeroId = tonumber(heroId)
      local hero = self:AddMember(defaultHeroId)
      if defaultHeroId == Const.TRUCK_HERO_ID then
        self.hummerHero = hero
      end
      if self.logic.detailLog then
        Logger.LogInfo("parkour Init AddMember : " .. heroId)
      end
      table.insert(self.defaultHeroIds, defaultHeroId)
      if hero.guid then
        self.defaultHeroUidDic[hero.guid] = true
      end
    end
  end
  self:InitFSM()
  self.oldZ = 0
  self.oldX = 0
  self.weaponUnit = nil
  self.lastTeamCount = 0
  self.petUnits = {}
  self.petUnitsCount = 0
  if self.logic.detailLog then
    self.shotManager = self.gameObject:AddComponent(typeof(CS.PVEScShotManager))
    if self.shotManager then
      local timeStr = os.date("%Y-%m-%d-%H-%M-%S")
      self.shotManager:Init(LuaEntry.Player.uid, true, timeStr)
    end
  end
end

function ParkourTeam:__delete()
  self:Destroy()
end

function ParkourTeam:Update(deltaTime)
  if self.fsm then
    self.fsm:OnUpdate(deltaTime)
  end
  if self:IsExiting() then
    return
  end
  for key, unit in pairs(self.teamUnits) do
    unit:OnUpdate(deltaTime)
  end
  if self.petUnits then
    for _, pet in pairs(self.petUnits) do
      pet:OnUpdate(deltaTime)
    end
  end
  if self.weaponUnit then
    self.weaponUnit:OnUpdate(deltaTime)
  end
  if self:IsSuperArmor() then
    self:UpdateMemberCollision()
  end
end

function ParkourTeam:GetMinKey(team)
  local minKey
  for k, _ in pairs(team) do
    if minKey == nil or k < minKey then
      minKey = k
    end
  end
  return minKey
end

function ParkourTeam:Destroy()
  self.hummerHero = nil
  if self.teamUnits then
    for _, unit in pairs(self.teamUnits) do
      self.logic:RemoveUnit(unit.guid)
    end
    self.teamUnits = nil
  end
  if self.weaponUnit then
    self.logic:RemoveUnit(self.weaponUnit.guid)
    self.weaponUnit = nil
  end
  if self.gameObject then
    GameObject.Destroy(self.gameObject)
    self.gameObject = nil
    self.transform = nil
    self.shotManager = nil
  end
  if self.fsm then
    self.fsm:Delete()
    self.fsm = nil
  end
  if self.horizontalMoveFsm then
    self.horizontalMoveFsm:Delete()
    self.horizontalMoveFsm = nil
  end
  self:DestroyQualitySlots()
  self:DestroyHeroIndexRecommendSlots()
  self:ClearBonusDashEffect()
  self:ClearBonusDashFinishEffect()
  self:ClearFailFlag()
  if self.guideArrow then
    self.guideArrow:Delete()
    self.guideArrow = nil
  end
end

function ParkourTeam:InitFSM()
  self.fsm = FSM.New()
  self.fsm:AddState(Const.ParkourMoveState.Auto, TeamStateExit.New(self))
  if self.logic.battleType and self.logic.battleType == Const.ParkourBattleType.Defense then
    self.fsm:AddState(Const.ParkourMoveState.LeftRight, TeamStateDefense.New(self))
  else
    self.fsm:AddState(Const.ParkourMoveState.LeftRight, TeamStateFarm.New(self))
  end
  self.fsm:AddState(Const.ParkourMoveState.AllDirection, TeamStateBoss.New(self))
  self.fsm:AddState(Const.ParkourMoveState.BossStay, TeamStateBossStay.New(self))
  self.fsm:AddState(Const.ParkourMoveState.BonusDash, TeamStateDash.New(self))
  self.fsm:AddState(Const.ParkourMoveState.BossHorizontal, TeamStateDefense.New(self))
  self.fsm:ChangeState(Const.ParkourMoveState.LeftRight)
  self.horizontalMoveFsm = FSM.New()
  self.horizontalMoveFsm:AddState(HorizontalMoveState.Idle, TeamHorizontalIdle.New(self))
  self.horizontalMoveFsm:AddState(HorizontalMoveState.Left, TeamHorizontalLeft.New(self))
  self.horizontalMoveFsm:AddState(HorizontalMoveState.Right, TeamHorizontalRight.New(self))
  self.horizontalMoveFsm:ChangeState(HorizontalMoveState.Idle)
end

function ParkourTeam:InitHeroes(heroes, hideQualitySlot)
  for slot, heroData in pairs(heroes) do
    if self:IsShowSlotIndex(slot) then
      local hero = ObjectPool:GetInstance():Load(HeroUnit)
      hero:Init(self.logic, self, self.transform, Vector3.zero, heroData, nil, heroData.heroId)
      self.logic:AddUnit(hero)
      self.teamUnits[slot] = hero
      hero:SetSlot(slot)
      self.teamUnitCount = self.teamUnitCount + 1
    end
  end
  self:ResetPos()
  if not hideQualitySlot then
    self:RefreshHeroQualitySlot()
    self:RefreshHeroIndexRecommendSlots()
  end
end

function ParkourTeam:InitWeapon(weaponData, skillChips)
  if not weaponData then
    return
  end
  local appearanceMetaId = DataCenter.TacticalWeaponManager:GetWeaponAppearance(weaponData.id)
  local appearanceTemplate = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceMetaId)
  local weapon = ObjectPool:GetInstance():Load(WeaponUnit)
  weapon:Init(self.logic, self, self.transform, Vector3.zero, weaponData, appearanceTemplate, skillChips)
  self.logic:AddUnit(weapon)
  local pos = self.formation:GetWeaponPos()
  weapon:SetLocalPosition(pos)
  self.weaponUnit = weapon
  self.weaponData = weaponData
  self.weaponAppearanceId = appearanceMetaId
end

function ParkourTeam:SaveHero(heroId)
  local heroCfg = self:GenHeroCfg(heroId, nil, false)
  if not heroCfg then
    Logger.LogError("no hero ", heroId)
    return
  end
  self:RealAddMember(heroCfg)
end

function ParkourTeam:AddMember(heroId, heroLevel, showBornTween, bornEffectPath)
  local valid, emptySlot, resetPos = self:TryAddUnitToTeam(true)
  if not valid then
    return
  end
  local newHeroId = heroId
  if self.logic.GetReplaceAppearance then
    local id = self.logic:GetReplaceAppearance(heroId)
    if 0 < id then
      newHeroId = id
    end
  end
  local heroCfg = self:GenHeroCfg(newHeroId, heroLevel or 1, true)
  if not heroCfg then
    Logger.LogError("no hero ", newHeroId)
    return nil
  end
  return self:RealAddMemberInner(heroCfg, heroId, heroLevel, showBornTween, emptySlot, resetPos, bornEffectPath)
end

function ParkourTeam:RealAddMember(heroCfg, originalHeroId, heroLevel, showBornTween)
  local valid, emptySlot, resetPos = self:TryAddUnitToTeam(true)
  if not valid then
    return
  end
  return self:RealAddMemberInner(heroCfg, originalHeroId, heroLevel, showBornTween, emptySlot, resetPos)
end

function ParkourTeam:RealAddMemberInner(heroCfg, originalHeroId, heroLevel, showBornTween, emptySlot, resetPos, bornEffectPath)
  local hero = ObjectPool:GetInstance():Load(HeroUnit)
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    hero:Init(self.logic, self, self.transform, Vector3.zero, heroCfg, nil, originalHeroId, true, function()
      self:ResetUnitTeamPos(hero, emptySlot, resetPos)
      if showBornTween then
        hero:BornValidFlag()
      end
    end, bornEffectPath)
    self.logic:AddUnit(hero)
    self:AddUnitToTeam(hero, emptySlot, resetPos, true)
  else
    hero:Init(self.logic, self, self.transform, Vector3.zero, heroCfg, nil, originalHeroId, nil, nil, bornEffectPath)
    self.logic:AddUnit(hero)
    self:AddUnitToTeam(hero, emptySlot, resetPos)
    if showBornTween then
      hero:BornValidFlag()
    end
  end
  if self.logic.GetHeroGlobalBuffList then
    local buffList = self.logic:GetHeroGlobalBuffList(hero.originalHeroId)
    if buffList then
      for _, buffId in ipairs(buffList) do
        hero:AddBuff(buffId)
      end
    end
  end
  return hero
end

function ParkourTeam:AddTrialHero(heroId, heroLevel, heroRank)
  local hero = HeroInfo.New()
  hero:UpdateFromTemplate(heroId, heroLevel, heroRank)
  hero.uuid = DataCenter.LWBattleManager:GetTmpHeroUuid()
  local unit = self:RealAddMember(hero)
  self.logic:AddTrialHero(hero)
  table.insert(self.teamInitUnits, unit)
  return unit
end

function ParkourTeam:GenHeroCfg(heroId, heroLv, useCache)
  useCache = useCache or false
  if not DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    useCache = false
  end
  local needInit = false
  local hero
  if useCache then
    hero, needInit = self.logic:GetSharedHeroInfo(heroId)
  else
    hero = HeroInfo.New()
    needInit = true
  end
  if needInit then
    local level = heroLv or 1
    hero:UpdateFromTemplate(heroId, level)
    hero:ReplaceAppearance(self.appearanceMap)
  end
  return hero
end

function ParkourTeam:RemoveMemberWithoutUnit(hero)
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
    if hero.unitType == UnitType.Pet and hero:IsFormationUnit() and not hero:IsBattleLostCondition() then
      self.teamInvisiblePetCount = self.teamInvisiblePetCount - 1
      if 0 > self.teamInvisiblePetCount then
        self.teamInvisiblePetCount = 0
      end
    end
  elseif hero.unitType == UnitType.Pet then
    local pet = hero
    local petGuid = pet:GetGuid()
    if pet.summonSlot and 0 < pet.summonSlot and pet.owner and pet.owner.skillManager and pet.ownerSkillId then
      local summonSkill = pet.owner.skillManager:GetSkillById(pet.ownerSkillId)
      if summonSkill and summonSkill.ReleaseSlot then
        summonSkill:ReleaseSlot(pet.summonSlot, petGuid)
      end
    end
    if self.petUnits[petGuid] then
      self.petUnits[petGuid] = nil
      self.petUnitsCount = self.petUnitsCount - 1
      if 0 > self.petUnitsCount then
        self.petUnitsCount = 0
      end
    end
  end
  if self.logic and self.logic.detailLog then
    Logger.LogInfo("parkour RemoveMemberWithoutUnit memberCount : " .. self:GetMemberCount())
  end
end

function ParkourTeam:RemoveMember(hero)
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
    if hero.unitType == UnitType.Pet and hero:IsFormationUnit() and not hero:IsBattleLostCondition() then
      self.teamInvisiblePetCount = self.teamInvisiblePetCount - 1
      if 0 > self.teamInvisiblePetCount then
        self.teamInvisiblePetCount = 0
      end
    end
  else
    Logger.LogError("ParkourTeam.RemoveMember error ! guid:" .. hero.guid)
  end
end

function ParkourTeam:ResetPos()
  for slotIndex, unit in pairs(self.teamUnits) do
    if unit ~= nil then
      local pos = self.formation:GetOffsetByIndex(slotIndex)
      if unit.CanChangePosition == nil or unit.CanChangePosition and unit:CanChangePosition() then
        unit:SetLocalPosition(pos)
      end
    end
  end
  if self.weaponUnit then
    local pos = self.formation:GetWeaponPos()
    self.weaponUnit:UpdateRelativePosition(pos.x, self.curPos.z)
  end
end

function ParkourTeam:GetMemberCount()
  return self.teamUnitCount - self.teamWorkerCount - self.teamInvisiblePetCount
end

function ParkourTeam:GetLastUnit()
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

function ParkourTeam:GetCurInitHeroAndSoliderCount()
end

function ParkourTeam:GetRemainUnitCount()
  local memberCount = self:GetMemberCount()
  memberCount = Mathf.Max(0, memberCount)
  return memberCount + Mathf.Max(self.overflowUnitCount, 0)
end

function ParkourTeam:TryReduceOverflowUnit(base)
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

function ParkourTeam:SetPosition(x, z)
  self.curPos.x = x
  self.curPos.z = z
  self.transform:Set_position(x, 0, z)
  if self.weaponUnit then
    local pos = self.formation:GetWeaponPos()
    self.weaponUnit:UpdateRelativePosition(x, z)
  end
end

function ParkourTeam:GetPosition()
  return self.curPos
end

function ParkourTeam:GetPositionZ()
  return self.curPos.z
end

function ParkourTeam:MoveHorizontalTo(x)
  local curState = self.fsm:GetStateIndex()
  if curState == Const.ParkourMoveState.BossHorizontal then
    self.fsm:ChangeState(Const.ParkourMoveState.BossHorizontal, x)
  else
    self.fsm:ChangeState(Const.ParkourMoveState.LeftRight, x)
  end
end

function ParkourTeam:MoveHorizontal(delta)
  if 0 < delta then
    self.horizontalMoveFsm:ChangeState(HorizontalMoveState.Right)
  elseif delta < 0 then
    self.horizontalMoveFsm:ChangeState(HorizontalMoveState.Left)
  end
end

function ParkourTeam:StopHorizontalMove()
  self.horizontalMoveFsm:ChangeState(HorizontalMoveState.Idle)
end

function ParkourTeam:IsHorizontalMoving()
  return self.horizontalMoveFsm:GetStateIndex() ~= HorizontalMoveState.Idle
end

function ParkourTeam:PlayTeamHorizontalAnim(anim)
  if self.logic and (self.logic.state == Const.ParkourBattleState.PreExit or self.logic.state == Const.ParkourBattleState.Exit) then
    return
  end
  for _, unit in pairs(self.teamUnits) do
    if unit.LeftRightActionValid and unit:LeftRightActionValid() then
      local cur = unit:GetCurAnimName()
      if cur ~= anim then
        unit:CrossFadeSimpleAnim(anim, 1, 0.2)
      end
    end
  end
end

function ParkourTeam:PlayTeamAnim(anim)
  for _, unit in pairs(self.teamUnits) do
    local cur = unit:GetCurAnimName()
    if cur ~= anim then
      unit:CrossFadeSimpleAnim(anim, 1, 0.2)
    end
  end
end

function ParkourTeam:OnFingerDown(pos)
  for _, unit in pairs(self.teamUnits) do
    unit:OnFingerDown(fingerDir)
  end
end

function ParkourTeam:OnFingerUp()
  self.fsm:HandleInput(Const.ParkourInput.FingerUp)
  for _, unit in pairs(self.teamUnits) do
    unit:OnFingerUp(fingerDir)
  end
end

function ParkourTeam:OnFingerHold(x, z, deltaTime)
  local oldPos = self:GetPosition()
  local distance = self:GetMoveSpeed() * deltaTime
  local deltaX = x * distance
  local deltaZ = z * distance
  local newX = oldPos.x + deltaX
  local newZ = oldPos.z + deltaZ
  if self.logic.data:Contains(newX, newZ) then
    self:SetPosition(newX, newZ)
  elseif self.logic.data:Contains(oldPos.x, newZ) then
    self:SetPosition(oldPos.x, newZ)
  elseif self.logic.data:Contains(newX, oldPos.z) then
    self:SetPosition(newX, oldPos.z)
  end
  if x == 0 and z == 0 then
    return
  end
  if math.abs(self.oldX - x) > 0.01 or 0.01 < math.abs(self.oldZ - z) then
    fingerDir.x = oldPos.x + x * 1024
    fingerDir.z = oldPos.z + z * 1024
    for _, unit in pairs(self.teamUnits) do
      unit:OnFingerHold(fingerDir)
    end
  end
  self.oldX = x
  self.oldZ = z
end

function ParkourTeam:SetActive(isOn)
  if self.gameObject then
    self.gameObject:SetActive(isOn)
  end
end

function ParkourTeam:GetMoveSpeedZ()
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

function ParkourTeam:GetBonusDashSpeedZ()
  if self.logic and self.logic.dashBonusSpeed then
    return self:GetMoveSpeedZ() * self.logic.dashBonusSpeed
  end
  return self:GetMoveSpeedZ()
end

function ParkourTeam:IsSuperArmor()
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

function ParkourTeam:UpdateMemberCollision()
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

function ParkourTeam:OnCollision(colliderCnt, colliderComponentArray)
  for i = 0, colliderCnt - 1 do
    self:Hit(colliderComponentArray[i])
  end
end

local HitDamageCD = 100
local deathEffPath = "Assets/_Art_LastWar/Effect/Prefab/Common/Eff_shiti_boom.prefab"

function ParkourTeam:Hit(otherObj)
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

function ParkourTeam:AddWorker(workerId)
  local workerCfg = LocalController:instance():getLine(TableName.LW_Worker, tonumber(workerId))
  if not workerCfg then
    Logger.LogError("no worker Config ", workerId)
    return
  end
  self.logic:OnWorkerSave()
  local resetPos = false
  local emptySlot = 0
  local newCount = self.teamUnitCount + 1
  if newCount <= self.formationMaxPosCount then
    for i = 1, self.formationMaxPosCount do
      if self.teamUnits[i] == nil then
        emptySlot = i
        break
      end
    end
    if emptySlot == 0 then
      Logger.LogError("ParkourTeam.AddWorker find empty slot error !")
      if not self.formation.canResize then
        self.overflowUnitCount = self.overflowUnitCount + 1
        return
      end
      self.formation:ReSize(self.formationMaxPosCount + 1)
      emptySlot = self.formationMaxPosCount + 1
      if self.formation.posCount > self.formationMaxPosCount then
        self.formationMaxPosCount = self.formation.posCount
      else
        self.overflowUnitCount = self.overflowUnitCount + 1
        return
      end
      resetPos = true
    end
  else
    if not self.formation.canResize then
      self.overflowUnitCount = self.overflowUnitCount + 1
      return
    end
    self.formation:ReSize(self.formationMaxPosCount + 1)
    emptySlot = self.formationMaxPosCount + 1
    if self.formation.posCount > self.formationMaxPosCount then
      self.formationMaxPosCount = self.formation.posCount
    else
      self.overflowUnitCount = self.overflowUnitCount + 1
      return
    end
    resetPos = true
  end
  if self.teamUnits[emptySlot] ~= nil then
    Logger.LogError("ParkourTeam.AddWorker invalid empty slot !")
    return
  end
  local worker = ObjectPool:GetInstance():Load(WorkerUnit)
  worker:Init(self.logic, self, self.transform, Vector3.zero, workerCfg)
  self.logic:AddUnit(worker)
  self.teamWorkerCount = self.teamWorkerCount + 1
  self.teamUnits[emptySlot] = worker
  self.teamUnitCount = self.teamUnitCount + 1
  if resetPos then
    self:ResetPos()
  else
    local pos = self.formation:GetOffsetByIndex(emptySlot)
    worker:SetLocalPosition(pos)
  end
end

function ParkourTeam:IsExiting()
  return self.logic.state == Const.ParkourBattleState.Exit
end

function ParkourTeam:ChangeStage(stage)
  if stage == Const.ParkourBattleState.Boss then
    self.fsm:ChangeState(Const.ParkourMoveState.AllDirection)
  elseif stage == Const.ParkourBattleState.BossStay then
    self.fsm:ChangeState(Const.ParkourMoveState.BossStay)
  elseif stage == Const.ParkourBattleState.BossHorizontal then
    self.fsm:ChangeState(Const.ParkourMoveState.BossHorizontal, self:GetPosition().x)
  elseif stage == Const.ParkourBattleState.Exit then
    local curPos = self:GetPosition()
    local rushXvalue = self.logic:GetParkourRushX()
    local controlPoint1 = curPos
    local controlPoint2 = Vector3.New(rushXvalue, 0, curPos.z + EXIT_CTRL_POINT_OFFSET)
    local controlPoint3 = Vector3.New(rushXvalue, 0, curPos.z + EXIT_CTRL_POINT_OFFSET + math.abs(rushXvalue - curPos.x))
    self.fsm:ChangeState(Const.ParkourMoveState.Auto, controlPoint1, controlPoint2, controlPoint3)
    self:ClearBonusDashEffect()
  elseif stage == Const.ParkourBattleState.DashBonusExit then
    self:ClearBonusDashEffect()
    self:ShowBonusDashFinishEffect()
    if self:GetMemberCount() == 0 then
      self:ShowFailFlag()
    end
    self.fsm:ChangeState(Const.ParkourMoveState.BossStay)
  elseif stage == Const.ParkourBattleState.GoldMonsterBonus or stage == Const.ParkourBattleState.ProgressMonsterBonus then
    self.fsm:ChangeState(Const.ParkourMoveState.LeftRight, self:GetPosition().x)
  elseif stage == Const.ParkourBattleState.DashBonus then
    self.fsm:ChangeState(Const.ParkourMoveState.BonusDash)
    self.horizontalMoveFsm:ChangeState(HorizontalMoveState.Idle)
  elseif stage == Const.ParkourBattleState.PreDashBonus then
  elseif stage == Const.ParkourBattleState.Lose then
    self:ClearBonusDashEffect()
  end
  local convertedStage = Const.ParkourBattleState2TeamState[stage] or stage
  for _, unit in pairs(self.teamUnits) do
    unit:ChangeStage(convertedStage)
  end
  for _, unit in pairs(self.petUnits) do
    unit:ChangeStage(convertedStage)
  end
  if self.weaponUnit then
    self.weaponUnit:ChangeStage(convertedStage)
  end
end

function ParkourTeam:GetMoveSpeed()
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

function ParkourTeam:ReturnMemberPositions()
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

function ParkourTeam:ChangeHeroes(heroes)
  if self.teamUnits then
    for _, unit in pairs(self.teamUnits) do
      self.logic:RemoveUnit(unit.guid)
      unit:DestroyData()
    end
  end
  self.teamUnits = {}
  self.teamUnitCount = 0
  self.teamWorkerCount = 0
  self:InitHeroes(heroes)
end

function ParkourTeam:ResetHeroPosition()
  self:ResetPos()
end

function ParkourTeam:SetHeroPosition(index, worldPos)
  for slot, unit in pairs(self.teamUnits) do
    if index == slot then
      unit:SetPosition(worldPos)
    end
  end
end

function ParkourTeam:MoveHeroToIndex(index, dstIndex, time)
  for slot, unit in pairs(self.teamUnits) do
    if slot == index then
      local localPos = self.formation:GetOffsetByIndex(dstIndex)
      unit:MoveToLocalPos(localPos, time)
    end
  end
end

function ParkourTeam:OnStartBattle(changeFormation)
  self:DestroyQualitySlots()
  self:DestroyHeroIndexRecommendSlots()
  self.teamInitUnitIndexes = {}
  self.cacheTeamUnitIndexMap = {}
  self.teamInitUnitIds = {}
  self.teamInitUnits = {}
  for index, unit in pairs(self.teamUnits) do
    if unit.hero then
      table.insert(self.teamInitUnitIds, unit.hero.uuid)
      table.insert(self.teamInitUnitIndexes, index)
      self.teamInitHeroId2UuidMap[unit.hero.heroId] = unit.hero.uuid
      table.insert(self.teamInitUnits, unit)
    end
  end
  self.formation:ChangeToBattleFormation(self.teamUnits)
  if changeFormation then
    for slot, unit in pairs(self.teamUnits) do
      local localPos = self.formation:GetOffsetByIndex(slot)
      unit:MoveToLocalPos(localPos, 0.5)
    end
    if self.weaponUnit then
      local pos = self.formation:GetWeaponPos()
      self.weaponUnit:UpdateRelativePosition(pos.x, self.curPos.z)
    end
  end
end

function ParkourTeam:DestroyQualitySlots()
  for _, v in pairs(self.qualitySlots) do
    if not IsNull(v) then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
end

function ParkourTeam:RefreshHeroQualitySlot()
  if table.IsNullOrEmpty(self.qualitySlots) then
    for i = 1, 5 do
      if self:IsShowSlotIndex(i) then
        local obj = CS.UnityEngine.GameObject("QualitySlot" .. i)
        obj.transform:SetParent(self.transform, false)
        local offset = self.formation:GetOffsetByIndex(i)
        offset.y = 0.2
        obj.transform:Set_localEulerAngles(90, 0, 0)
        obj.transform.localPosition = offset
        local tempPos = Vector3.New(1.5, 1.5, 1)
        obj.transform.localScale = tempPos
        tempPos:ReturnPool()
        local sprite = obj:AddComponent(typeof(CS.UnityEngine.SpriteRenderer))
        table.insert(self.qualitySlots, sprite)
      end
    end
  end
  for i = 1, 5 do
    local sprite = self.qualitySlots[i]
    if not IsNull(sprite) and self:IsShowSlotIndex(i) then
      if not table.IsNullOrEmpty(self.teamUnits) then
        local hasHero = self.teamUnits[i] ~= nil
        if hasHero then
          sprite:LoadSprite(string.format("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_dige_%d.png", self.teamUnits[i].hero.quality))
        else
          sprite:LoadSprite("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_dige_kong.png")
        end
      else
        sprite:LoadSprite("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_dige_kong.png")
      end
    end
  end
  if self.logic.param.enterType == PVEEnterType.StageFeatureBuilding then
    local featureTemp = DataCenter.StageFeatureBuildingManager:GetStageFeatureBuildingTemplate(self.logic.param.featureId)
    if featureTemp.limit_hero and 0 < #featureTemp.limit_hero then
      for i = 1, #self.qualitySlots do
        if i ~= 4 then
          self.qualitySlots[i].gameObject:SetActive(false)
        end
      end
    end
  end
end

function ParkourTeam:RefreshHeroIndexRecommendSlots()
  local showRecommendAtIndex = 0
  if self.logic.param.enterType == PVEEnterType.HeroTryOut then
    local tryOutTemplate = DataCenter.HeroTryOutManager:GetLWHeroTryOutTemplateById(self.logic.param.extraData.cfgId)
    if tryOutTemplate ~= nil and 0 < tryOutTemplate.target then
      local isTargetHeroAtTargetIndex = false
      if self.teamUnits then
        for index, unit in pairs(self.teamUnits) do
          if unit and unit.hero and unit.hero.heroId == tryOutTemplate.hero_id and index == tryOutTemplate.target then
            isTargetHeroAtTargetIndex = true
            break
          end
        end
      end
      if not isTargetHeroAtTargetIndex then
        showRecommendAtIndex = tryOutTemplate.target
      end
    end
  end
  if not table.IsNullOrEmpty(self.indexRecommendSlots) then
    for index, recommendSlot in pairs(self.indexRecommendSlots) do
      if index ~= showRecommendAtIndex then
        recommendSlot.gameObject:SetActive(false)
      end
    end
  end
  if showRecommendAtIndex <= 0 then
    return
  end
  if self.indexRecommendSlots == nil then
    return
  end
  if not self.indexRecommendSlots[showRecommendAtIndex] then
    local sprite = self.qualitySlots[showRecommendAtIndex]
    if not IsNull(sprite) then
      local obj = CS.UnityEngine.GameObject("IndexRecommendSlot" .. showRecommendAtIndex)
      obj.transform:SetParent(sprite.gameObject.transform, false)
      obj.transform:Set_localEulerAngles(-31.273, 0, 0)
      obj.transform:Set_localPosition(0.815, -0.698, -0.43)
      obj.transform:Set_localScale(1.3, 1.3, 1.3)
      local spriteRecommend = obj:AddComponent(typeof(CS.UnityEngine.SpriteRenderer))
      spriteRecommend:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite2/LRB_pailian_tuijian.png")
      self.indexRecommendSlots[showRecommendAtIndex] = spriteRecommend
    end
  else
    self.indexRecommendSlots[showRecommendAtIndex].gameObject:SetActive(true)
  end
end

function ParkourTeam:DestroyHeroIndexRecommendSlots()
  if self.indexRecommendSlots then
    for _, v in pairs(self.indexRecommendSlots) do
      if not IsNull(v) then
        CS.UnityEngine.GameObject.Destroy(v.gameObject)
      end
    end
    self.indexRecommendSlots = nil
  end
end

function ParkourTeam:ChangeWeaponSkillChips(skillChips)
  if self.weaponUnit then
    self.weaponUnit:ChangeSkillChips(skillChips)
  end
end

function ParkourTeam:GetRandomInitUuid()
  local heroes = self.teamInitUnitIds
  local count = #heroes
  if 0 < count then
    return heroes[math.random(count)]
  end
  return 0
end

function ParkourTeam:GetInitUuidAuto(index)
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

function ParkourTeam:GetInitUuidByHeroIdOrIndex(heroId, index)
  local uuid = self.teamInitHeroId2UuidMap[heroId]
  if uuid then
    return uuid
  end
  return self:GetInitUuidAuto(index)
end

function ParkourTeam:GetZeroWorldPos()
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

function ParkourTeam:GetUnitPosition(guid)
  if self.formation and guid then
    for index, unit in pairs(self.teamUnits) do
      if unit.guid == guid then
        return self.formation:GetOffsetByIndex(index)
      end
    end
  end
  return Vector3.zero
end

function ParkourTeam:GetWeaponPosition()
  if self.formation then
    return self.formation:GetWeaponPos()
  end
  return Vector3.zero
end

function ParkourTeam:TryAddUnitToTeam(counter, preferPos)
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

function ParkourTeam:AddUnitToTeam(unit, emptySlot, resetPos, skipViewPos)
  self.teamUnits[emptySlot] = unit
  self.teamUnitCount = self.teamUnitCount + 1
  if unit.SetSlot then
    unit:SetSlot(emptySlot)
  end
  if skipViewPos ~= true then
    self:ResetUnitTeamPos(unit, emptySlot, resetPos)
  end
end

function ParkourTeam:ResetUnitTeamPos(unit, emptySlot, resetPos)
  if resetPos then
    self:ResetPos()
  else
    local pos = self.formation:GetOffsetByIndex(emptySlot)
    if unit.CanChangePosition == nil or unit.CanChangePosition and unit:CanChangePosition() then
      unit:SetLocalPosition(pos)
    end
  end
end

function ParkourTeam:CreatePet(metaId, master)
  local petTemplate = DataCenter.CommonSimpleTemplateManager:GetTemplate(TableName.LW_SUMMONS, metaId)
  if not petTemplate then
    Logger.LogError("ParkourTeam.CreatePet petTemplate is nil")
    return
  end
  if not master then
    Logger.LogError("ParkourTeam.CreatePet master is nil")
    return
  end
  if petTemplate.useSkillFormation then
    local pet = ObjectPool:GetInstance():Load(PetUnit)
    local parent = petTemplate.follow and self.transform or nil
    pet:Init(self.logic, self, parent, Vector3.zero, petTemplate, nil, master)
    self.logic:AddUnit(pet)
    local petGuid = pet:GetGuid()
    self.petUnits[petGuid] = pet
    self.petUnitsCount = self.petUnitsCount + 1
    if pet.useTaunt and self.logic.AddGlobalTauntUnit then
      self.logic:AddGlobalTauntUnit(pet)
    end
    return pet
  end
  local master = master
  local slot
  if petTemplate.index_type == 2 then
    if master.slot then
      slot = master.slot
    else
      Logger.LogError("master.index is nil")
      return
    end
  else
  end
  local isBattleLostCondition = petTemplate.target_rule and petTemplate.target_rule == 3
  local valid, emptySlot, resetPos = self:TryAddUnitToTeam(isBattleLostCondition, slot)
  if not valid then
    return
  end
  local pet = ObjectPool:GetInstance():Load(PetUnit)
  pet:Init(self.logic, self, self.transform, Vector3.zero, petTemplate, nil, master)
  self.logic:AddUnit(pet)
  self:AddUnitToTeam(pet, emptySlot, resetPos)
  if not isBattleLostCondition then
    self.teamInvisiblePetCount = self.teamInvisiblePetCount + 1
  end
  return pet
end

function ParkourTeam:CreatePetNoTeam(metaId, master, worldPos)
  local petTemplate = DataCenter.CommonSimpleTemplateManager:GetTemplate(TableName.LW_SUMMONS, metaId)
  if not petTemplate then
    Logger.LogError("ParkourTeam.CreatePetNoTeam petTemplate is nil")
    return
  end
  if not master then
    Logger.LogError("ParkourTeam.CreatePetNoTeam master is nil")
    return
  end
  local pet = ObjectPool:GetInstance():Load(PetUnit)
  local initPos = worldPos or Vector3.zero
  pet:Init(self.logic, self, nil, initPos, petTemplate, nil, master)
  self.logic:AddUnit(pet)
  local petGuid = pet:GetGuid()
  self.petUnits[petGuid] = pet
  self.petUnitsCount = self.petUnitsCount + 1
  if worldPos then
    pet:SetLocalPosition(worldPos)
    pet:SetPosition(worldPos)
  end
  if pet.useTaunt and self.logic.AddGlobalTauntUnit then
    self.logic:AddGlobalTauntUnit(pet)
  end
  return pet
end

function ParkourTeam:CheckHasPetUnit()
  return self.petUnitsCount > 0
end

function ParkourTeam:CheckIsPetUnit(guid)
  return self.petUnits[guid] ~= nil
end

function ParkourTeam:IsShowSlotIndex(slotIndex)
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

function ParkourTeam:ShowBonusDashEffect(effName)
  if string.IsNullOrEmpty(effName) then
    return
  end
  self:ClearBonusDashEffect()
  local tempPos = Vector3.New(0, 0, 7)
  self.bonusDashEffectId = self.logic:ShowEffectObj(effName, tempPos, nil, -1, self.transform)
  tempPos:ReturnPool()
end

function ParkourTeam:ClearBonusDashEffect()
  if self.bonusDashEffectId then
    self.logic:RemoveEffectObj(self.bonusDashEffectId)
    self.bonusDashEffectId = nil
  end
end

function ParkourTeam:ShowBonusDashFinishEffect()
  self:ClearBonusDashFinishEffect()
  local tempPos = Vector3.zero
  self.bonusDashFinishEffectId = self.logic:ShowEffectObj("Assets/_Art_LastWar/Effect/Prefab/Common/Eff_feiting_yanhua_02.prefab", tempPos, nil, -1, self.transform)
  tempPos:ReturnPool()
end

function ParkourTeam:ClearBonusDashFinishEffect()
  if self.bonusDashFinishEffectId then
    self.logic:RemoveEffectObj(self.bonusDashFinishEffectId)
    self.bonusDashFinishEffectId = nil
  end
end

function ParkourTeam:ShowFailFlag()
  self:ClearFailFlag()
  local tempPos = Vector3.zero
  self.failFlagId = self.logic:ShowEffectObj("Assets/Main/Prefabs/LWBattle/flag/A_build_flag_04.prefab", tempPos, nil, -1, self.transform)
  tempPos:ReturnPool()
end

function ParkourTeam:ClearFailFlag()
  if self.failFlagId then
    self.logic:RemoveEffectObj(self.failFlagId)
    self.failFlagId = nil
  end
end

function ParkourTeam:RefreshHummerHero(progress)
  if self.hummerHero == nil then
    return
  end
  self.hummerHero:RefreshTruckGoods(progress)
end

function ParkourTeam:OnReplaceAppearance(newHeroId)
  local needReset = self.formation:OnReplaceAppearance(newHeroId)
  if needReset then
    self:ResetPos()
  end
end

function ParkourTeam:OnFingerHoldCheckObstacle(x, z, deltaTime)
  local oldPos = self:GetPosition()
  local distance = self:GetMoveSpeed() * deltaTime
  local deltaX = x * distance
  local deltaZ = z * distance
  local newX = oldPos.x + deltaX
  local newZ = oldPos.z + deltaZ
  local finalX, finalZ = newX, newZ
  local radius = self.teamRadius or 1
  if self.logic.data:Contains(newX, newZ) and not self.logic.data:IsCircleInWallArea(newX, newZ, radius) and not self.logic.data:CheckBuildingCollision(newX, newZ, radius) then
    self:SetPosition(newX, newZ)
    finalX, finalZ = newX, newZ
  elseif self.logic.data:Contains(oldPos.x, newZ) and not self.logic.data:IsCircleInWallArea(oldPos.x, newZ, radius) and not self.logic.data:CheckBuildingCollision(oldPos.x, newZ, radius) then
    self:SetPosition(oldPos.x, newZ)
    finalX, finalZ = oldPos.x, newZ
  elseif self.logic.data:Contains(newX, oldPos.z) and not self.logic.data:IsCircleInWallArea(newX, oldPos.z, radius) and not self.logic.data:CheckBuildingCollision(newX, oldPos.z, radius) then
    self:SetPosition(newX, oldPos.z)
    finalX, finalZ = newX, oldPos.z
  end
  local doorIndex, direction = self.logic.data:CheckDoorContact(finalX, finalZ, 3)
  if doorIndex then
    if direction == LastStandDoorContactDirection.FromInside or direction == LastStandDoorContactDirection.FromOutside then
      self.logic:OpenDoor(doorIndex, direction)
    elseif direction == LastStandDoorContactDirection.Leave then
      self.logic:CloseDoor(doorIndex)
    end
  end
  if x == 0 and z == 0 then
    return
  end
  if math.abs(self.oldX - x) > 0.01 or 0.01 < math.abs(self.oldZ - z) then
    fingerDir.x = oldPos.x + x * 1024
    fingerDir.z = oldPos.z + z * 1024
    for _, unit in pairs(self.teamUnits) do
      unit:OnFingerHold(fingerDir)
    end
  end
  self.oldX = x
  self.oldZ = z
end

function ParkourTeam:ShowGuideArrow(targetPos)
  if not self.guideArrow then
    self.guideArrow = guideArrow.New()
    self.guideArrow:InitArrow(self, targetPos, 4)
  else
    self.guideArrow:SetTarget(targetPos)
  end
end

function ParkourTeam:HideGuideArrow()
  if self.guideArrow then
    self.guideArrow:Hide()
  end
end

function ParkourTeam:SetTeamRadius(radius)
  self.teamRadius = radius
end

function ParkourTeam:PreGetEmptyPos(count)
  count = count or 1
  local result = {}
  local emptySlots = self:GetAllEmptySlots()
  if count > #emptySlots and self.formation.canResize then
    local neededSlots = count - #emptySlots
    local newSize = self.formationMaxPosCount + neededSlots
    self.formation:ReSize(newSize)
    if self.formation.posCount > self.formationMaxPosCount then
      for i = 1, neededSlots do
        if count > #emptySlots then
          local newSlot = self.formationMaxPosCount + i
          table.insert(emptySlots, newSlot)
        end
      end
      self.formationMaxPosCount = self.formation.posCount
    end
  end
  for i = 1, math.min(count, #emptySlots) do
    local slotIndex = emptySlots[i]
    local slotPos = self:GetEmptySlotWorldPosition(slotIndex)
    table.insert(result, {pos = slotPos})
  end
  if count > #result then
    local neededDefaultCount = count - #result
    for i = 1, neededDefaultCount do
      table.insert(result, {
        pos = self:GetPosition()
      })
    end
  end
  return result
end

function ParkourTeam:GetAllEmptySlots()
  local emptySlots = {}
  for i = 1, self.formationMaxPosCount do
    if self.teamUnits[i] == nil then
      table.insert(emptySlots, i)
    end
  end
  return emptySlots
end

function ParkourTeam:GetEmptySlotWorldPosition(slotIndex)
  if not slotIndex then
    return Vector3.zero
  end
  local localOffset = self.formation:GetOffsetByIndex(slotIndex)
  local worldPos = self.transform:TransformPoint(localOffset)
  local targetPos = Vector3.New(worldPos.x, worldPos.y, worldPos.z)
  return targetPos
end

function ParkourTeam:GetTeamPosLog()
  if self.curPos == nil then
    return 0, 0
  end
  return self.curPos.x, self.curPos.z
end

function ParkourTeam:TryCapture()
  if self.shotManager then
    self.shotManager:CaptureNextFrame()
  end
end

function ParkourTeam:IsTeamDefaultUnit(uid)
  if table.IsNullOrEmpty(self.defaultHeroUidDic) then
    return false
  end
  return self.defaultHeroUidDic[uid] ~= nil
end

function ParkourTeam:GetHeroInfoByUuid(uuid)
  if self.teamUnits then
    for _, unit in pairs(self.teamUnits) do
      if unit and unit.hero and unit.hero.uuid == uuid then
        return unit.hero
      end
    end
  end
end

return ParkourTeam
