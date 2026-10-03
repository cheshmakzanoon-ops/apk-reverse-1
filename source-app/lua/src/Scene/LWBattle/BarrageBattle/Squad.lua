local Resource = CS.GameEntry.Resource
local FSM = require("Framework.Common.FSM")
local Member = require("Scene.LWBattle.BarrageBattle.Unit.Member")
local SquadStateStay = require("Scene.LWBattle.BarrageBattle.SquadState.SquadStateStay")
local SquadStateMove = require("Scene.LWBattle.BarrageBattle.SquadState.SquadStateMove")
local SquadStateExit = require("Scene.LWBattle.BarrageBattle.SquadState.SquadStateExit")
local Const = require("Scene.LWBattle.Const")
local Formation = require("Scene.LWBattle.Formation")
local TacticalWeaponMember = require("Scene.LWBattle.BarrageBattle.Unit.TacticalWeaponMember")
local Pet = require("Scene.LWBattle.BarrageBattle.Unit.Pet")
local Squad = BaseClass("Squad")

function Squad:__init(manager, guid, heroes, parent, scaleCtrl, tacWeaponInfo, tacWeaponAppearanceId, skillChips, showWeapon, positionType)
  self.heroes = heroes
  self.gameObject = CS.UnityEngine.GameObject("Squad")
  self.gameObject.transform:SetParent(parent, false)
  self.transform = self.gameObject.transform
  self.battleMgr = manager
  self.guid = guid
  self.members = {}
  self.cur_pos = Vector3.zero
  self.fsm = nil
  self.destination = nil
  self.formation = nil
  self.createdMember = 0
  self.lastTimeCheckNeedStop = 0
  self.scaleCtrl = scaleCtrl
  self.animNameCache = nil
  self.superArmor = false
  self.superArmorDirty = true
  self.qualitySlots = {}
  self.indexRecommendSlots = {}
  self.teamWeapon = nil
  self.tacWeaponInfo = tacWeaponInfo
  self.tacWeaponAppearanceId = tacWeaponAppearanceId
  self.skillChips = skillChips
  self.showWeapon = false
  if showWeapon then
    self.showWeapon = showWeapon
  end
  self.positionType = ArmyFormationPositionType.Normal
  if positionType then
    self.positionType = positionType
  end
  self.pets = {}
end

function Squad:__delete()
  self:Destroy()
end

function Squad:Destroy()
  self.members = {}
  self.teamWeapon = nil
  self.pets = {}
  self.cur_pos = nil
  self.fsm:Delete()
  self.fsm = nil
  self.destination = nil
  self.formation:Delete()
  self.createdMember = 0
  if self.gameObject then
    CS.UnityEngine.GameObject.Destroy(self.gameObject)
    self.gameObject = nil
    self.transform = nil
  end
  self.animNameCache = nil
  self.battleMgr = nil
  self.guid = nil
  self:DestroyQualitySlots()
  self:DestroyHeroIndexRecommendSlots()
end

function Squad:OnCreate()
  self:InitFSM()
  self.formation = Formation.New(self)
  self.formation:Init(false, self.positionType)
  self:CreateMembers()
  self:CreateWeaponMembers()
end

function Squad:InitFSM()
  self.fsm = FSM.New()
  self.fsm:AddState(SquadState.Stay, SquadStateStay.New(self))
  self.fsm:AddState(SquadState.Move, SquadStateMove.New(self))
  self.fsm:AddState(SquadState.Exit, SquadStateExit.New(self))
  self.fsm:ChangeState(SquadState.Stay)
end

function Squad:CreateMembers()
  if self.heroes == nil then
    Logger.LogError("heroes is nil")
    return
  end
  local heroInfos = {}
  for slotIndex, heroData in pairs(self.heroes) do
    if self:IsShowSlotIndex(slotIndex) and slotIndex ~= ArmyFormationSlot.Dominator then
      table.insert(heroInfos, heroData)
    end
  end
  local campBuff = HeroUtils.GetCampEffectConfigByHeroInfos(heroInfos)
  for slotIndex, heroData in pairs(self.heroes) do
    if self:IsShowSlotIndex(slotIndex) then
      local hero = heroData
      local path
      if hero then
        path = hero:GetHeroModelData(HeroModelType.Battle)
        if string.IsNullOrEmpty(path) then
          path = "Assets/_Art_LastWar/Models/Cars/tanke/prefab/tank.prefab"
        end
      else
        path = "Assets/_Art_LastWar/Models/Cars/tanke/prefab/tank.prefab"
      end
      local objId = self.battleMgr:GetNextObjId()
      local req = Resource:InstantiateAsync(path)
      local member = ObjectPool:GetInstance():Load(Member)
      member:Init(self.battleMgr, self, objId, req, slotIndex, hero, campBuff)
      table.insert(self.members, member)
      self.battleMgr:AddUnit(member)
      req:completed("+", function(request)
        if request.isError then
          return
        end
        member:OnCreate()
        self:OnCreateFinish()
      end)
    end
  end
  self:RefreshHeroQualitySlot()
  self:RefreshHeroIndexRecommendSlots()
end

function Squad:CreateWeaponMembers()
  if self.tacWeaponInfo == nil then
    self:OnCreateWeaponFinish()
    return
  end
  local appearanceId = self.tacWeaponAppearanceId
  if appearanceId == nil then
    appearanceId = self.tacWeaponInfo:GetAppearance()
  end
  local appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
  if not appearanceMeta then
    self:OnCreateWeaponFinish()
    Logger.LogError("tacWeapon appearanceMeta is nil")
    return
  end
  local path = appearanceMeta.model_path
  local objId = self.battleMgr:GetNextObjId()
  local req = Resource:InstantiateAsync(path)
  local member = ObjectPool:GetInstance():Load(TacticalWeaponMember)
  member:Init(self.battleMgr, self, objId, req, self.tacWeaponInfo, appearanceMeta, campBuff, self.skillChips, self.showWeapon)
  self.teamWeapon = member
  self.battleMgr:AddUnit(member)
  req:completed("+", function(request)
    if request.isError then
      return
    end
    member:OnCreate()
    self:OnCreateWeaponFinish()
  end)
end

function Squad:DestroyQualitySlots()
  for _, v in pairs(self.qualitySlots) do
    if not IsNull(v) then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
end

function Squad:RefreshHeroQualitySlotPos()
  if self.qualitySlots then
    for i, v in pairs(self.qualitySlots) do
      local offset = self.formation:GetOffsetByIndex(i)
      offset.y = 0.2
      v.transform:Set_localPosition(offset.x, offset.y, offset.z)
    end
  end
end

function Squad:RefreshHeroQualitySlot()
  if table.IsNullOrEmpty(self.qualitySlots) then
    for i = ArmyFormationSlot.Hero1, ArmyFormationSlot.Hero5 do
      if self:IsShowSlotIndex(i) then
        local obj = CS.UnityEngine.GameObject("QualitySlot" .. i)
        obj.transform:SetParent(self.transform, false)
        local offset = self.formation:GetOffsetByIndex(i)
        offset.y = 0.2
        obj.transform:Set_localEulerAngles(90, 0, 0)
        obj.transform:Set_localPosition(offset.x, offset.y, offset.z)
        obj.transform.localScale = Vector3.New(1.5, 1.5, 1)
        local sprite = obj:AddComponent(typeof(CS.UnityEngine.SpriteRenderer))
        self.qualitySlots[i] = sprite
      end
    end
  end
  for i = ArmyFormationSlot.Hero1, ArmyFormationSlot.Hero5 do
    if self:IsShowSlotIndex(i) then
      local sprite = self.qualitySlots[i]
      if not IsNull(sprite) then
        if not table.IsNullOrEmpty(self.heroes) then
          local hasHero = self.heroes[i] ~= nil
          if hasHero then
            sprite:LoadSprite(string.format("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_dige_%d.png", self.heroes[i].quality))
          else
            sprite:LoadSprite("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_dige_kong.png")
          end
        else
          sprite:LoadSprite("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_dige_kong.png")
        end
      end
    end
  end
end

function Squad:RefreshHeroIndexRecommendSlots()
  if not self.battleMgr or not self.battleMgr.param then
    return
  end
  local showRecommendAtIndex = 0
  if self.battleMgr.param.enterType == PVEEnterType.HeroTryOut then
    local tryOutTemplate = DataCenter.HeroTryOutManager:GetLWHeroTryOutTemplateById(self.battleMgr.param.extraData.cfgId)
    if tryOutTemplate ~= nil and 0 < tryOutTemplate.target then
      local isTargetHeroAtTargetIndex = false
      if self.heroes then
        for index, hero in pairs(self.heroes) do
          if hero and hero.heroId == tryOutTemplate.hero_id and index == tryOutTemplate.target then
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

function Squad:DestroyHeroIndexRecommendSlots()
  if self.indexRecommendSlots then
    for _, v in pairs(self.indexRecommendSlots) do
      if not IsNull(v) then
        CS.UnityEngine.GameObject.Destroy(v.gameObject)
      end
    end
    self.indexRecommendSlots = nil
  end
end

function Squad:ChangeHeroes(heroes)
  self.heroes = heroes
  for _, member in pairs(self.members) do
    self.battleMgr:RemoveUnit(member)
    member:DestroyData()
  end
  self.members = {}
  self.createdMember = 0
  self.moveSpeedDirty = true
  self.battleMgr:SetSquadCreateFinishFlag(false)
  self:CreateMembers()
  local hasDominator = heroes[ArmyFormationSlot.Dominator] ~= nil
  local changed = self.formation:RefreshPositions(hasDominator, self.positionType)
  if changed then
    self:OnPositionLayoutChange()
  end
end

function Squad:OnPositionLayoutChange()
  for _, member in pairs(self.members) do
    member:ResetPosition()
  end
  self:RefreshHeroQualitySlotPos()
  EventManager:GetInstance():Broadcast(EventId.DominatorFormationStateUpdate)
end

function Squad:SetHeroPosition(index, worldPos)
  for _, member in pairs(self.members) do
    if member.index == index then
      member:SetPosition(worldPos)
      break
    end
  end
end

function Squad:ResetHeroPosition()
  for _, member in pairs(self.members) do
    member:ResetPosition()
  end
end

function Squad:MoveHeroToIndex(index, dstIndex, time)
  for _, member in pairs(self.members) do
    if member.index == index then
      member:MoveToIndex(dstIndex, time)
      break
    end
  end
end

function Squad:OnAllCreateFinish()
  if self.createdMember >= #self.members and (self.tacWeaponInfo == nil or self.tacWeaponInfo ~= nil and self.teamWeapon) then
    if self.scaleCtrl then
      self.transform.localScale = Vector3.one * self.scaleCtrl
    end
    if self.animNameCache then
      self:PlayAnim(self.animNameCache)
    end
    self.battleMgr:OnSquadCreateFinish()
  end
end

function Squad:OnCreateFinish()
  self.createdMember = self.createdMember + 1
  if self.createdMember >= #self.members then
    self:OnAllCreateFinish()
  end
end

function Squad:OnCreateWeaponFinish()
  if self.teamWeapon then
    self:OnAllCreateFinish()
  end
end

function Squad:OnStartBattle()
  self:DestroyQualitySlots()
  self:DestroyHeroIndexRecommendSlots()
  for _, member in pairs(self.members) do
    member.skillManager:HaloCastAll()
  end
  if self.teamWeapon then
    self.teamWeapon.skillManager:HaloCastAll()
  end
end

function Squad:InitPosition(pos)
  self:SetPosition(pos)
  self:StartCameraFollow(pos)
end

function Squad:ReturnMemberPositions()
  local pos = {}
  for i = 1, ArmyFormationSlot.Dominator do
    local offsetPos = self.formation:GetOffsetByIndex(i)
    if offsetPos then
      local worldPos = self.transform:TransformPoint(offsetPos)
      pos[i] = worldPos
    end
  end
  return pos
end

function Squad:SetRotation(quat)
  self.transform.rotation = quat
end

function Squad:PlayAnim(anim, rewind)
  self.animNameCache = anim
  for _, v in pairs(self.members) do
    if rewind == true then
      v:RewindAndPlaySimpleAnim(anim)
    else
      v:PlaySimpleAnim(anim)
    end
  end
  if self.teamWeapon then
    if rewind == true then
      self.teamWeapon:RewindAndPlaySimpleAnim(anim)
    else
      self.teamWeapon:PlaySimpleAnim(anim)
    end
  end
end

function Squad:Attack(targetPos)
  for _, v in pairs(self.members) do
    local skill = v.skillManager:GetActiveSkillIgnoreRange()
    if skill then
      v.skillManager:ActiveCast(skill, targetPos)
    end
  end
end

function Squad:SetPosition(pos)
  self.cur_pos.x = pos.x
  self.cur_pos.z = pos.z
  self.transform:Set_position(self.cur_pos.x, self.cur_pos.y, self.cur_pos.z)
end

function Squad:SetPositionXZ(x, z)
  self.cur_pos.x = x
  self.cur_pos.z = z
  self.transform:Set_position(self.cur_pos.x, self.cur_pos.y, self.cur_pos.z)
end

function Squad:GetPosition()
  return self.cur_pos
end

function Squad:GetMemberCount()
  if not self.members then
    return 0
  end
  local cnt = 0
  for _, _ in pairs(self.members) do
    cnt = cnt + 1
  end
  return cnt
end

function Squad:OnSetDestination(destination)
  self.destination = destination
  if destination then
    self.fsm:ChangeState(SquadState.Move, destination.pos)
  else
    self.fsm:ChangeState(SquadState.Stay)
  end
end

function Squad:OnFingerDown(pos)
  self.stationAttackPos = pos
  for _, v in pairs(self.members) do
    v:HandleInput(MemberCommand.StationAttack, pos)
  end
end

function Squad:OnFingerHold(x, z)
  local pos = Vector3.New(x, 0, z)
  if not self.stationAttackPos then
    self:OnFingerDown(pos)
    return
  end
  local dis = self.stationAttackPos - pos
  local sqrDiff = Vector3.SqrMagnitude(dis)
  if 1.0E-4 < sqrDiff then
    self:OnFingerDown(pos)
  end
end

function Squad:OnFingerUp()
  self.stationAttackPos = nil
  for _, v in pairs(self.members) do
    v:HandleInput(MemberCommand.AutoAttack)
  end
end

function Squad:OnMemberArriveWayPoint()
  self.battleMgr:OnArriveWayPoint()
end

function Squad:CheckNeedStop()
  if self:IsSuperArmor() or self.battleMgr.state == BarrageState.Exit then
    self.needStop = false
    return self.needStop
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if now - self.lastTimeCheckNeedStop < 100 then
    return self.needStop
  end
  self.lastTimeCheckNeedStop = now
  self.needStop = PveUtil.CheckHasUnitInSphereRange(self.battleMgr, self.transform.position, Const.MEMBER_ALERT_RADIUS, LayerMask.GetMask("Zombie"), nil, 10) or PveUtil.CheckHasBossInSphereRange(self.battleMgr, self.transform.position, Const.MEMBER_ALERT_RADIUS, LayerMask.GetMask("Zombie"))
  return self.needStop
end

local velocity = Vector3.unity_vector3(0, 0, 0)
local smoothTime = 0.3
local tmpV1 = Vector3.New(0, 0, 0)
local tmpV2 = Vector3.New(0, 0, 0)
local tmpV3 = Vector3.New(0, 0, 0)

function Squad:OnUpdate()
  self.fsm:OnUpdate()
  if self.m_startCameraFollow and not self.battleMgr:IsPlayingShakeCamera() and self.battleMgr.state ~= BarrageState.Exit then
    self:UpdateCameraFollow()
  end
  if self:IsSuperArmor() or self.battleMgr.state == BarrageState.Exit then
    self:UpdateMemberCollision()
  end
end

function Squad:StartCameraFollow(spawnPos)
  self.m_startCameraFollow = true
  self:InitLevelCameraLookat(spawnPos)
end

function Squad:PauseCameraFollow()
  self.m_startCameraFollow = false
end

function Squad:ResumeCameraFollow()
  self.m_startCameraFollow = true
end

function Squad:InitLevelCameraLookat(playerPos)
  local v2 = playerPos
  local v3 = Vector3.forward
  if self.gameObject ~= nil then
    v2 = self.gameObject.transform.position
    v3 = self.gameObject.transform.forward
  end
  tmpV2:Set(v2.x, v2.y, v2.z)
  tmpV3:Set(v3.x, v3.y, v3.z)
  tmpV2.x = tmpV2.x + tmpV3.x * 0.3
  tmpV2.y = tmpV2.y + tmpV3.y * 0.3
  tmpV2.z = tmpV2.z + tmpV3.z * 0.3
  self.battleMgr:Lookat(tmpV2)
end

function Squad:UpdateCameraFollow()
  if self.gameObject == nil then
    return
  end
  if not DataCenter.GuideManager:InGuide() then
    local v1 = self.battleMgr:GetFollowCameraTarget()
    local v2 = self.gameObject.transform.position
    local v3 = self.gameObject.transform.forward
    tmpV1:Set(v1.x, v1.y, v1.z)
    tmpV2:Set(v2.x, v2.y, v2.z)
    tmpV3:Set(v3.x, v3.y, v3.z)
    tmpV2.x = tmpV2.x + tmpV3.x * 0.3
    tmpV2.y = tmpV2.y + tmpV3.y * 0.3
    tmpV2.z = tmpV2.z + tmpV3.z * 0.3
    local distance = true
    if math.abs(tmpV1.x - tmpV2.x) < 0.01 and math.abs(tmpV1.y - tmpV2.y) < 0.01 and math.abs(tmpV1.z - tmpV2.z) < 0.01 then
      distance = false
      velocity.x, velocity.y, velocity.z = 0, 0, 0
    end
    if distance then
      local targetPos, v = Vector3.SmoothDamp(v1, tmpV2, velocity, smoothTime)
      velocity = v
      self.battleMgr:CameraFollowLookat(targetPos)
    end
  end
end

function Squad:RemoveMember(member)
  for i, v in pairs(self.members) do
    if v.guid == member.guid then
      table.remove(self.members, i)
      break
    end
  end
end

function Squad:GetMoveSpeed()
  if self.moveSpeed and not self.moveSpeedDirty then
    return self.moveSpeed
  end
  self.moveSpeed = 99
  self.moveSpeedDirty = false
  for _, member in pairs(self.members) do
    local speed = member:GetMoveSpeed()
    self.moveSpeed = speed < self.moveSpeed and speed or self.moveSpeed
  end
  return self.moveSpeed
end

function Squad:IsSuperArmor()
  if not self.superArmorDirty then
    return self.superArmor
  end
  local oldValue = self.superArmor
  self.superArmorDirty = false
  self.superArmor = false
  for _, member in pairs(self.members) do
    if member:IsSuperArmor() then
      self.superArmor = true
      break
    end
  end
  if oldValue ~= self.superArmor then
    if self.superArmor then
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_speed_up)
      self.superArmorSound = DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_speed_up_bgm, true, true)
    else
      DataCenter.LWSoundManager:StopSound(self.superArmorSound)
    end
    EventManager:GetInstance():Broadcast(EventId.SquadSuperArmorStateChange)
  end
  return self.superArmor
end

function Squad:UpdateMemberCollision()
  for _, member in pairs(self.members) do
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

function Squad:OnCollision(colliderCnt, colliderComponentArray)
  for i = 0, colliderCnt - 1 do
    self:Hit(colliderComponentArray[i])
  end
end

local HitDamageCD = 100
local deathEffPath = "Assets/_Art_LastWar/Effect/Prefab/Common/Eff_shiti_boom.prefab"

function Squad:Hit(otherObj)
  local now = UITimeManager:GetInstance():GetServerTime()
  local trigger = otherObj:GetComponent(typeof(CS.CitySpaceManTrigger))
  if trigger ~= nil and trigger.ObjectId ~= 0 then
    local tar = self.battleMgr:GetUnit(trigger.ObjectId)
    if tar and 0 < (tar.curBlood or 0) and now - (tar.lastHitTime or 0) > HitDamageCD then
      tar.lastHitTime = now
      local hurt = 1
      local hitPoint = tar.transform.position
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
        hitBackDistance = Vector3.Normalize(hitPoint - self.transform.position) * 10
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
        self.battleMgr:ShakeCameraWithParam(p)
      end
    end
  end
end

function Squad:ChangeStage(stage)
  if stage == BarrageState.PreExit then
  elseif stage == BarrageState.Exit then
    local curPos = self:GetPosition()
    local controlPoint1 = curPos
    local controlPoint2 = Vector3.New(BARRAGE_SCENE_CENTER, 0, curPos.z + EXIT_CTRL_POINT_OFFSET)
    local controlPoint3 = Vector3.New(BARRAGE_SCENE_CENTER, 0, curPos.z + EXIT_CTRL_POINT_OFFSET + math.abs(BARRAGE_SCENE_CENTER - curPos.x))
    self.fsm:ChangeState(SquadState.Exit, controlPoint1, controlPoint2, controlPoint3)
  end
  for _, unit in pairs(self.members) do
    unit:ChangeStage(stage)
  end
  if self.teamWeapon then
    self.teamWeapon:ChangeStage(stage)
  end
end

function Squad:ChangeWeaponSkillChips(skillChips)
  if self.teamWeapon then
    self.teamWeapon:ChangeSkillChips(skillChips)
  end
end

function Squad:GetZeroWorldPos()
  if not IsNull(self.transform) then
    if not self._cachePos then
      self._cachePos = Vector3.New()
    end
    self._cachePos.x, self._cachePos.y, self._cachePos.z = self.transform:Get_position()
    return self._cachePos
  end
  return Vector3.zero
end

function Squad:CreatePet(metaId, master)
  local objId = self.battleMgr:GetNextObjId()
  if not master then
    return
  end
  local petTemplate = DataCenter.CommonSimpleTemplateManager:GetTemplate(TableName.LW_SUMMONS, metaId)
  if not petTemplate then
    Logger.LogError("petTemplate is nil")
    return
  end
  local heroId = petTemplate.heroId
  local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroId)
  local appearanceId = heroTemplate.appearance
  local appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
  local path = ""
  if appearanceMeta then
    path = appearanceMeta.model_path
  else
    path = "Assets/_Art_LastWar/Models/Cars/tanke/prefab/tank.prefab"
  end
  local req = Resource:InstantiateAsync(path)
  local pet = ObjectPool:GetInstance():Load(Pet)
  local index
  if petTemplate.index_type == 2 then
    if master.index then
      index = master.index
    else
      Logger.LogError("master.index is nil")
      return
    end
  else
  end
  pet:Init(self.battleMgr, self, objId, req, index, petTemplate, master)
  table.insert(self.pets, pet)
  self.battleMgr:AddUnit(pet)
  req:completed("+", function(request)
    if request.isError then
      return
    end
    pet:OnCreate()
  end)
end

function Squad:IsShowSlotIndex(slotIndex)
  if self.positionType then
    local showSlotIndexList = ArmyFormationSlotPositionType[self.positionType]
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

function Squad:GetFormationPosByIndex(index)
  if self.formation then
    return self.formation:GetOffsetByIndex(index)
  end
end

function Squad:GetHeroInfoByUuid(uuid)
  if self.heroes then
    for i, v in pairs(self.heroes) do
      if v.uuid == uuid then
        return v
      end
    end
  end
end

return Squad
