local LWGateDefenceManager = BaseClass("LWGateDefenceManager")
local Hero = require("DataCenter.LWGateDefenceManager.LWGateDefenceHero")
local Zombie = require("DataCenter.LWGateDefenceManager.LWGateDefenceZombie")
local utils = require("DataCenter.LWGateDefenceManager.LWGateDefenceUtils")
local MNs = require("DataCenter.LWGateDefenceManager.LWGateDefenceMagicNumbers")
local ActorHero = require("DataCenter.LWBeginnerDirectorManager.LWBeginnerZombieSeaActorHero")

function LWGateDefenceManager:__init()
  EventManager:GetInstance():AddListener(EventId.GF_enter_city, self.OnEnable)
  EventManager:GetInstance():AddListener(EventId.GF_building_upgrade_done, self.OnEnable)
  EventManager:GetInstance():AddListener(EventId.BeforeReleaseCity, self.OnDisable)
  EventManager:GetInstance():AddListener(EventId.HeroModelInFormationLoaded, self.OnLWHeroLoaded)
  EventManager:GetInstance():AddListener(EventId.GF_guide_start, self.OnGuideFlowStart)
  EventManager:GetInstance():AddListener(EventId.GF_guide_done, self.OnGuideFlowDone)
  EventManager:GetInstance():AddListener(EventId.GF_play_timeline_loaded, self.OnTimelineLoaded)
  EventManager:GetInstance():AddListener(EventId.GF_guide_step_done, self.OnGuideFlowStepDone)
  EventManager:GetInstance():AddListener(EventId.NewbiesChapterVfxPlay, self.NewbiesChapterVfxPlay)
  UpdateManager:GetInstance():AddUpdate(self.OnUpdate)
end

function LWGateDefenceManager:__delete()
  EventManager:GetInstance():RemoveListener(EventId.GF_enter_city, self.OnEnable)
  EventManager:GetInstance():RemoveListener(EventId.GF_building_upgrade_done, self.OnEnable)
  EventManager:GetInstance():RemoveListener(EventId.BeforeReleaseCity, self.OnDisable)
  EventManager:GetInstance():RemoveListener(EventId.HeroModelInFormationLoaded, self.OnLWHeroLoaded)
  EventManager:GetInstance():RemoveListener(EventId.GF_guide_start, self.OnGuideFlowStart)
  EventManager:GetInstance():RemoveListener(EventId.GF_guide_done, self.OnGuideFlowDone)
  EventManager:GetInstance():RemoveListener(EventId.GF_play_timeline_loaded, self.OnTimelineLoaded)
  EventManager:GetInstance():RemoveListener(EventId.GF_guide_step_done, self.OnGuideFlowStepDone)
  EventManager:GetInstance():RemoveListener(EventId.NewbiesChapterVfxPlay, self.NewbiesChapterVfxPlay)
  UpdateManager:GetInstance():RemoveUpdate(self.OnUpdate)
  self:OnDisable()
  Zombie.ReleaseAll()
  ActorHero.ReleaseAll()
  if self.delaySound then
    self.delaySound:Stop()
    self.delaySound = nil
  end
end

function LWGateDefenceManager.NewbiesChapterVfxPlay(params)
  if params.resPath == "Assets/_Art_LastWar/Effect/Prefab/Common/Eff_chengqiang_jzwc_glow.prefab" then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.NoviceGuide_BaseOccupied_Firework_TL, false)
  end
end

local _specialEventFlag = false
local _specialEventSpawnFlag = false
local _timelineTruckTrans

function LWGateDefenceManager:Starup()
  self.heroInsts = {}
  self.standedHeroInsts = {}
  self.zombieInsts = {}
  self.zombieInstsGrid = {}
  self.zombieAmount = 0
  self.zombieSpawnCD = 0
  self.bullets = {}
  self._tempTruckHandle = nil
  self._tempTruckEffectHandle = nil
end

function LWGateDefenceManager:OnEnable()
  local self = DataCenter.LWGateDefenceManager
  self:ReCheckSelfSpawnCondition()
  self.active = CS.SceneManager:IsInCity()
  if self.active then
    self.zombieSpawnCD = 0
  end
end

function LWGateDefenceManager:ReCheckSelfSpawnCondition()
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType == SeasonMapType.Darkness or seasonType == SeasonMapType.NineNation then
    self.seasonType = seasonType
    self.canSelfSpawnZombie = false
    return
  end
  local truckBuilding = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_BATTLE_HANGUP_REWARD)
  truckBuilding = truckBuilding and truckBuilding[1]
  local beginnerDirectorCurEventId = DataCenter.LWBeginnerDirectorManager:GetCurCityEventID()
  local beginnerDirectorEvent = DataCenter.LWBeginnerDirectorManager:GetCurCityEvent()
  local beginnerDirectorEventStart = beginnerDirectorEvent and beginnerDirectorEvent.start or false
  local beginnerDirectorEventOverTime = beginnerDirectorEvent and beginnerDirectorEvent.overTime or false
  local cityBeginnerZombieSeaOpen = beginnerDirectorCurEventId == BeginnerDirectorEvent.ZombieSeaFirstStage or beginnerDirectorCurEventId == BeginnerDirectorEvent.ZombieSeaSecondStage
  local inCityEventZombieSea = cityBeginnerZombieSeaOpen and beginnerDirectorEventStart and not beginnerDirectorEventOverTime
  self.canSelfSpawnZombie = truckBuilding and truckBuilding.level > 0 and not inCityEventZombieSea
end

function LWGateDefenceManager:OnDisable()
  local self = DataCenter.LWGateDefenceManager
  if not self.active then
    return
  end
  self.active = false
  self.canSelfSpawnZombie = false
  for _, heroInst in ipairs(self.heroInsts) do
    if heroInst.heroType == GateDefenceHeroType.LWHero then
      heroInst:Delete()
    elseif heroInst.heroType == GateDefenceHeroType.ChapterActor then
      heroInst:Return()
    end
  end
  self.heroInsts = {}
  self.standedHeroInsts = {}
  self:CleanAllZombies()
  self:CleanAllBullets()
  self:CleanForceTarget()
  self:CleanTempTruck()
  self:CleanTempTruckEffect()
  utils.ClearSceneColliders()
end

function LWGateDefenceManager:CleanAllHeroActors()
  for i = #self.heroInsts, 1, -1 do
    local heroInst = self.heroInsts[i]
    if heroInst and heroInst.heroType == GateDefenceHeroType.ChapterActor then
      table.remove(self.heroInsts, i)
      for j, standHeroInst in ipairs(self.standedHeroInsts) do
        if standHeroInst.heroUuid == heroInst.heroUuid then
          table.remove(self.standedHeroInsts, j)
          self.herosDirty = true
          break
        end
      end
      heroInst:Return()
    end
  end
end

function LWGateDefenceManager:CleanAllZombies()
  for _, zombieInst in pairs(self.zombieInsts) do
    Zombie.Return(zombieInst)
  end
  self.zombieInsts = {}
  self.zombieInstsGrid = {}
  self.zombieAmount = 0
end

function LWGateDefenceManager:CleanAllBullets()
  for _, bullet in ipairs(self.bullets) do
    if not IsNull(bullet.handle) then
      bullet.handle:Destroy()
    end
  end
  self.bullets = {}
end

function LWGateDefenceManager:CleanForceTarget()
  self.forceTarget = nil
  if self.forceTargetArrow then
    self.forceTargetArrow:Destroy()
    self.forceTargetArrow = nil
  end
  self.forceTargetArrowGO = nil
end

function LWGateDefenceManager.OnUpdate()
  local self = DataCenter.LWGateDefenceManager
  local dt = Time.deltaTime
  if self.herosDirty then
    self.herosDirty = false
    utils.UpdateDestGrids(self.standedHeroInsts)
  end
  if not self.active or self.seasonType == SeasonMapType.Darkness or self.seasonType == SeasonMapType.NineNation then
    return
  end
  if self.canSelfSpawnZombie or _specialEventFlag then
    if self.zombieSpawnCD <= 0 then
      if _specialEventFlag then
        local zombieCapacity = _specialEventSpawnFlag and 16 or 0
        if zombieCapacity > self.zombieAmount then
          local spawnGrid = utils.GetSpecialEventSpawnGrid()
          local destGrid = utils.GetNearestDestGrid(spawnGrid)
          if spawnGrid and destGrid then
            self:SpawnZombie(spawnGrid, destGrid, MNs.TIMELINE_RAGDOLL_ZOMBIE_SPAWN_CHANCE)
            self.zombieSpawnCD = 0.1
          end
        end
        if _timelineTruckTrans then
          for _, zombieInst in pairs(self.zombieInsts) do
            if zombieInst and zombieInst.transform then
              local vec = zombieInst.transform.position - _timelineTruckTrans.position
              if vec and vec.sqrMagnitude < 50 then
                local dir = vec.normalized
                zombieInst:OnCrashed(dir + Vector3.up)
              end
            end
          end
        end
      else
        local zombieCapacity = math.min(#self.standedHeroInsts * MNs.ZOMBIE_AMOUNT_CAPACITY_PER_HERO, MNs.ZOMBIE_AMOUNT_CAPACITY_IN_TOTAL)
        if zombieCapacity > self.zombieAmount then
          local spawnGrid = utils.GetSpawnGrid(self.standedHeroInsts[math.random(#self.standedHeroInsts)])
          local destGrid = utils.GetNearestDestGrid(spawnGrid)
          if spawnGrid and destGrid then
            self:SpawnZombie(spawnGrid, destGrid, MNs.RAGDOLL_ZOMBIE_SPAWN_CHANCE)
            self.zombieSpawnCD = MNs.ZOMBIE_SPAWN_INTERVAL
          end
        end
      end
    else
      self.zombieSpawnCD = self.zombieSpawnCD - dt
    end
  end
  for i = #self.bullets, 1, -1 do
    local bullet = self.bullets[i]
    local dstPos = bullet.dstPos
    local trans = bullet.trans
    local deltaMove = MNs.BULLET_SPEED * dt
    if (trans.position - dstPos).sqrMagnitude <= deltaMove * deltaMove then
      table.remove(self.bullets, i)
      self:OnBulletHit(bullet)
    else
      trans.position = trans.position + bullet.dir * deltaMove
    end
  end
  for _, heroInst in ipairs(self.heroInsts) do
    local lastFrameHeroStandAlready = heroInst.standAlready
    heroInst:Update(dt)
    local curFrameHeroStandAlready = heroInst.standAlready
    if not lastFrameHeroStandAlready and curFrameHeroStandAlready then
      self.herosDirty = true
      table.insert(self.standedHeroInsts, heroInst)
    elseif lastFrameHeroStandAlready and not curFrameHeroStandAlready then
      for i = 1, #self.standedHeroInsts do
        local standHeroInst = self.standedHeroInsts[i]
        if standHeroInst.heroUUid == heroInst.heroUUid then
          table.remove(self.standedHeroInsts, i)
          self.herosDirty = true
          break
        end
      end
    end
  end
  local hasRagdollZombie = false
  for _, zombieInst in pairs(self.zombieInsts) do
    zombieInst:Update(dt)
    if zombieInst.fsm and zombieInst.fsm.currStateName == "Ragdoll" then
      hasRagdollZombie = true
    end
  end
  if hasRagdollZombie then
    CS.UnityEngine.Physics.Simulate(dt)
  end
  if self.forceTarget and self.forceTarget.transform then
    if self.forceTargetArrowGO then
      if self.forceTargetArrowGO.activeSelf == false then
        self.forceTargetArrowGO:SetActive(true)
        DataCenter.LWSoundManager:PlaySound(62303, false)
      end
      self.forceTargetArrowGO.transform.position = self.forceTarget.transform.position + Vector3.up * 2.5
    end
  elseif self.forceTargetArrowGO and self.forceTargetArrowGO.activeSelf == true then
    self.forceTargetArrowGO:SetActive(false)
  end
end

function LWGateDefenceManager.OnLWHeroLoaded(params)
  local self = DataCenter.LWGateDefenceManager
  local heroUuid = params[3]
  local gameObject = params[4]
  local hero = Hero.New({heroUuid, gameObject})
  local cacheHeroUuid
  if self.heroInsts then
    for i, v in ipairs(self.heroInsts) do
      if v and v.heroUuid == hero.heroUuid then
        cacheHeroUuid = hero.heroUuid
        break
      end
    end
  end
  if cacheHeroUuid then
    self:DestroyHero(cacheHeroUuid)
  end
  table.insert(self.heroInsts, hero)
  if hero.standAlready then
    table.insert(self.standedHeroInsts, hero)
    self.herosDirty = true
  end
end

function LWGateDefenceManager:SpawnActorHero(params)
  local self = DataCenter.LWGateDefenceManager
  local hero = ActorHero.Create(params)
  table.insert(self.heroInsts, hero)
  if hero.standAlready then
    table.insert(self.standedHeroInsts, hero)
    self.herosDirty = true
  end
end

function LWGateDefenceManager:DestroyHero(heroUuid)
  for i, heroInst in ipairs(self.heroInsts) do
    if heroInst.heroUuid == heroUuid then
      table.remove(self.heroInsts, i)
      for j, standHeroInst in ipairs(self.standedHeroInsts) do
        if standHeroInst.heroUuid == heroUuid then
          table.remove(self.standedHeroInsts, j)
          self.herosDirty = true
          break
        end
      end
      if heroInst.heroType == GateDefenceHeroType.LWHero then
        heroInst:Delete()
        break
      end
      if heroInst.heroType == GateDefenceHeroType.ChapterActor then
        heroInst:Return()
      end
      break
    end
  end
end

function LWGateDefenceManager:SpawnZombie(spawnGrid, destGrid, ragdollChance, lifeTime, bigZombie, hp)
  local zombieInst = Zombie.Create(spawnGrid, destGrid, lifeTime, bigZombie, hp)
  self.zombieInsts[zombieInst.id] = zombieInst
  self.zombieAmount = self.zombieAmount + 1
  if self.zombieInstsGrid[spawnGrid.row] == nil then
    self.zombieInstsGrid[spawnGrid.row] = {}
  end
  if self.zombieInstsGrid[spawnGrid.row][spawnGrid.col] == nil then
    self.zombieInstsGrid[spawnGrid.row][spawnGrid.col] = {}
  end
  self.zombieInstsGrid[spawnGrid.row][spawnGrid.col][zombieInst.id] = zombieInst
end

function LWGateDefenceManager:ChangeZombieGrid(zombieId, oldGrid, newGrid)
  local zombieInst
  local zombieGridRow = self.zombieInstsGrid[oldGrid.row]
  assert(zombieGridRow ~= nil, "ChangeZombieGrid:zombieGridRow is nil: " .. oldGrid.row)
  local zombieGridCol = zombieGridRow[oldGrid.col]
  assert(zombieGridCol ~= nil, "ChangeZombieGrid:zombieGridCol is nil: " .. oldGrid.col)
  zombieInst = zombieGridCol[zombieId]
  assert(zombieInst ~= nil, "ChangeZombieGrid:zombieInst is nil: " .. zombieId)
  if self.zombieInstsGrid[newGrid.row] == nil then
    self.zombieInstsGrid[newGrid.row] = {}
  end
  if self.zombieInstsGrid[newGrid.row][newGrid.col] == nil then
    self.zombieInstsGrid[newGrid.row][newGrid.col] = {}
  end
  self.zombieInstsGrid[newGrid.row][newGrid.col][zombieId] = zombieInst
  zombieInst.grid = newGrid
end

function LWGateDefenceManager:GetZombiesByGrid(grid)
  local zombieGridRow = self.zombieInstsGrid[grid.row]
  if not zombieGridRow then
    return nil
  end
  return zombieGridRow[grid.col]
end

function LWGateDefenceManager:SetForceTarget(zombieId)
  local zombieInst = self.zombieInsts[zombieId]
  self.forceTarget = zombieInst
  if not self.forceTargetArrow then
    self.forceTargetArrow = CS.GameEntry.Resource:InstantiateAsync("Assets/_Art_LastWar/Effect/Prefab/xinshou/Eff_xinshou_monster_zhunxin.prefab")
    self.forceTargetArrow:completed("+", function(handle)
      self.forceTargetArrowGO = handle.gameObject
      handle.gameObject.transform.localScale = Vector3.one
      handle.gameObject:SetActive(false)
    end)
  end
end

function LWGateDefenceManager:OnZombieDead(zombieId)
  local zombieInst = self.zombieInsts[zombieId]
  if self.forceTarget == zombieInst then
    self.forceTarget = nil
  end
  local dropPosition = zombieInst:GetDropPosition()
  if math.random() < MNs.DROP_GOODS_RATE then
    local num = math.random(MNs.DROP_GOODS_NUM_MIN, MNs.DROP_GOODS_NUM_MAX)
    for i = 1, num do
      DataCenter.LWGateTruckGoodsManager:DropGoods(dropPosition, math.random(1, 3))
    end
  end
end

function LWGateDefenceManager:DestroyZombie(zombieId)
  local zombieInst = self.zombieInsts[zombieId]
  local zombieGrid = zombieInst.grid
  local zombieGridRow = self.zombieInstsGrid[zombieGrid.row]
  assert(zombieGridRow ~= nil, "DestroyZombie:zombieGridRow is nil: " .. zombieGrid.row)
  local zombieGridCol = zombieGridRow[zombieGrid.col]
  assert(zombieGridCol ~= nil, "DestroyZombie:zombieGridCol is nil: " .. zombieGrid.col)
  assert(zombieInst == zombieGridCol[zombieId], "DestroyZombie:zombieInst not same: " .. zombieId)
  zombieGridCol[zombieId] = nil
  self.zombieInsts[zombieId] = nil
  self.zombieAmount = self.zombieAmount - 1
  Zombie.Return(zombieInst)
end

function LWGateDefenceManager:CreateBullet(srcPos, dstPos, zombieId)
  local vec = dstPos - srcPos
  local handle = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/LWGateDefence/Bullet.prefab", ObjectPoolTag.Normal, LoadPriority.Low)
  handle:completed("+", function(handle)
    if handle.isError or IsNull(handle.gameObject) then
      return
    end
    local trans = handle.gameObject.transform
    trans.position = srcPos
    trans:Set_localScale(1, 1, 0.01)
    trans.forward = vec
    trans:DOScale(Vector3(1, 1, 3), 0.1)
    table.insert(self.bullets, {
      handle = handle,
      tarId = zombieId,
      trans = trans,
      dstPos = dstPos,
      dir = vec.normalized,
      hit = false
    })
  end)
end

function LWGateDefenceManager:OnBulletHit(bullet)
  if not IsNull(bullet.handle) then
    bullet.handle:Destroy()
  end
  local zombieInst = self.zombieInsts[bullet.tarId]
  if zombieInst then
    zombieInst:OnHurt()
  end
end

function LWGateDefenceManager.OnGuideFlowStart(flowId)
  if flowId == 1004 or flowId == 1005 then
    _specialEventFlag = true
    _specialEventSpawnFlag = true
    DataCenter.LWGateDefenceManager.delaySound = TimerManager:GetInstance():DelayInvoke(function()
      DataCenter.LWSoundManager:PlaySound(62250, false)
    end, 0.7)
    DataCenter.LWGateDefenceManager:SpawnTempTruck()
  elseif flowId == 1017 then
    DataCenter.LWGateDefenceManager.delaySound = TimerManager:GetInstance():DelayInvoke(function()
      DataCenter.LWGateDefenceManager.delaySound = nil
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.NoviceGuide_Boss_BullDog_Runaway_TL, false)
    end, 0.7)
  elseif flowId == 1015 then
    DataCenter.LWGateDefenceManager.delaySound = TimerManager:GetInstance():DelayInvoke(function()
      DataCenter.LWGateDefenceManager.delaySound = nil
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.NoviceGuide_BaseOccupied_FlagRaising_TL, false)
    end, 3.5)
  elseif flowId == 1001 then
    DataCenter.LWGateDefenceManager.delaySound = TimerManager:GetInstance():DelayInvoke(function()
      DataCenter.LWGateDefenceManager.delaySound = nil
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.NoviceGuide_BaseOccupied_FlagRaising_TL, false)
    end, 3.5)
  elseif flowId == 1024 then
    DataCenter.LWGateDefenceManager.delaySound = TimerManager:GetInstance():DelayInvoke(function()
      DataCenter.LWGateDefenceManager.delaySound = nil
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.NoviceGuide_Boss_BullDog_Attack_TL, false)
    end, 2.5)
  end
end

function LWGateDefenceManager.OnGuideFlowDone(flowId)
  if flowId == 1004 or flowId == 1005 then
    _specialEventFlag = false
    _specialEventSpawnFlag = false
    _timelineTruckTrans = nil
  end
end

function LWGateDefenceManager.OnTimelineLoaded(params)
  local resPath = params[1]
  if resPath == "Assets/Main/Prefabs/LWGuide/TimeLinePerfabs/transportcar_Timeline.prefab" then
    local timelineGO = params[2]
    if not IsNull(timelineGO) then
      _specialEventSpawnFlag = false
      _timelineTruckTrans = timelineGO.transform:Find("Weizhi/A_build@transportcar/A_build@transportcar_skin/To_unity/DeformationSystem/Root/Root_M")
    end
  elseif params.buildingId == BuildingTypes.LW_BUILD_COUNT_BATTLE then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.NoviceGuide_TransHeli_TL, false)
  end
end

function LWGateDefenceManager.OnGuideFlowStepDone(behaviour)
  if not _specialEventFlag then
    return
  end
  local name = behaviour.name
  if name == "play_timeline" then
    DataCenter.LWGateDefenceManager:ShowTempTruck()
  elseif name == "upgrade_building" then
    DataCenter.LWGateDefenceManager:CleanTempTruck()
  end
end

function LWGateDefenceManager:SpawnTempTruck()
  local Resource = CS.GameEntry.Resource
  if not self._tempTruckHandle then
    self._tempTruckHandle = Resource:InstantiateAsync("Assets/Main/Prefabs/Building/building_10115000.prefab")
    self._tempTruckHandle:completed("+", function(handle)
      local go = handle.gameObject
      local trans = go.transform
      self.tempTruckGo = go
      trans.position = Vector3(101, 0, 65)
      trans.localScale = Vector3.one
      go:SetActive(false)
    end)
  end
  if not self._tempTruckEffectHandle then
    self._tempTruckEffectHandle = Resource:InstantiateAsync("Assets/Main/Prefabs/Effect/Eff_building_10115000_chuxian.prefab")
    self._tempTruckEffectHandle:completed("+", function(handle)
      local go = handle.gameObject
      local trans = go.transform
      self.tempTruckEffectGo = go
      trans.position = Vector3(99, 0, 63)
      trans.localScale = Vector3.one
      go:SetActive(false)
    end)
  end
end

function LWGateDefenceManager:ShowTempTruck()
  if IsNotNull(self.tempTruckGo) then
    self.tempTruckGo:SetActive(true)
  end
  if IsNotNull(self.tempTruckEffectGo) then
    self.tempTruckEffectGo:SetActive(true)
    self.tempTruckEffectTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.tempTruckEffectTimer = nil
      self:CleanTempTruckEffect()
    end, 2)
  end
end

function LWGateDefenceManager:CleanTempTruck()
  if self._tempTruckHandle then
    self._tempTruckHandle:Destroy()
    self._tempTruckHandle = nil
  end
  self.tempTruckGo = nil
end

function LWGateDefenceManager:CleanTempTruckEffect()
  if self.tempTruckEffectTimer then
    self.tempTruckEffectTimer:Stop()
    self.tempTruckEffectTimer = nil
  end
  if self._tempTruckEffectHandle then
    self._tempTruckEffectHandle:Destroy()
    self._tempTruckEffectHandle = nil
  end
  self.tempTruckEffectGo = nil
end

function LWGateDefenceManager:AddBlockRangeForGameRange(pointId, tileX, tileY)
  utils.AddBlockRangeForGameRange(pointId, tileX, tileY)
end

function LWGateDefenceManager:RemoveBlockRangeForGameRange(pointId, tileX, tileY)
  utils.RmoveBlockRangeForGameRange(pointId, tileX, tileY)
end

return LWGateDefenceManager
