local BulletManager = BaseClass("BulletManager")
local BulletCreator = require("Scene.LWBattle.Bullet.BulletCreator")
local BattleColliderUtils = CS.BattleColliderUtils
local BulletViewFacade = CS.PVEBattleLogic.Bullet.BulletViewFacade
local BulletViewUtil = require("Scene.LWBattle.Bullet.BulletViewUtil")

function BulletManager:__init(battleMgr)
  self.battleMgr = battleMgr
  self.nextObjId = 0
  self.bullets = {}
  self.straightBullets = arrayV3.new()
  self.straightBulletObj2Index = {}
  self.creators = {}
  self.curves = {}
  self.colliderMap = {}
  self.colliderResultList = nil
  self.colliderResultCount = 0
  self.colliderResultTmpList = nil
  self.createBulletParamTable = {}
  self.updating = false
  self.toAddBulletList = {}
  self.toAddBulletListCount = 0
  self.toAddStraightBulletList = {}
  self.toAddStraightBulletListCount = 0
  self.straightBulletObj2Index = {}
  self.dealDamageParamTable = {}
  self.gatlingBulletReq = {}
  self.creatingGatlingCount = 0
  self.straightBulletReq = {}
  self.creatingStraightCount = 0
  BulletViewUtil.InitView()
end

function BulletManager:__delete()
  self:Destroy()
end

function BulletManager:Destroy()
  self:ResetData()
end

function BulletManager:ResetData()
  if self.bullets then
    for _, v in pairs(self.bullets) do
      v:Delete()
    end
    self.bullets = {}
  end
  if self.straightBullets then
    local array = self.straightBullets.array
    for _, v in ipairs(array) do
      if v.objId then
        v:Delete()
      end
    end
    self.straightBullets:clear()
  end
  if self.creators then
    for _, v in pairs(self.creators) do
      v:Delete()
    end
    self.creators = {}
  end
  self.curves = {}
  if self.toAddBulletListCount > 0 then
    self.toAddBulletListCount = 0
    for _, v in ipairs(self.toAddBulletList) do
      v:Delete()
    end
    self.toAddBulletList = {}
  end
  if 0 < self.toAddStraightBulletListCount then
    self.toAddStraightBulletListCount = 0
    for _, v in ipairs(self.toAddStraightBulletList) do
      v:Delete()
    end
    self.toAddStraightBulletList = {}
  end
  BattleColliderUtils.ClearBulletData()
  BulletViewUtil.ClearData()
  self.colliderResultList = nil
  self.colliderResultCount = 0
  self.colliderResultTmpList = nil
  self.gatlingBulletMetaData = nil
  self.gatlingBulletReq = {}
  self.creatingGatlingCount = 0
  self.straightBulletReq = {}
  self.creatingStraightCount = 0
  self.bulletCreateMap = nil
  self.detailBulletData = nil
end

function BulletManager:CreateBulletCreator(metaId, skill, context, criticalMetaId)
  local meta = DataCenter.PveBulletTemplateManager:GetTemplate(metaId)
  local criticalMeta
  if criticalMetaId ~= nil and 0 < criticalMetaId then
    criticalMeta = DataCenter.PveBulletTemplateManager:GetTemplate(criticalMetaId)
  end
  if not context.mother then
    context.mother = meta
  end
  if not context.index then
    context.index = 1
  end
  local objId = self:GetNextObjId()
  local bulletCreator = ObjectPool:GetInstance():Load(BulletCreator)
  local success = bulletCreator:Init(self.battleMgr, self, objId, meta, skill, context, criticalMeta)
  if success then
    self.creators[bulletCreator.objId] = bulletCreator
  end
end

function BulletManager:CreateBullet(class, logic, bulletMgr, objId, params, isStraight)
  ProfilerUtil.BeginSample("BulletManagerCreateBullet")
  local bullet = ObjectPool:GetInstance():Load(class)
  ProfilerUtil.BeginSample("BulletManagerBulletInit")
  bullet:Init(logic, bulletMgr, objId, params)
  ProfilerUtil.EndSample()
  bullet:Create()
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    self:TryAddBullet(bullet, false)
  else
    self:TryAddBullet(bullet, isStraight)
  end
  ProfilerUtil.EndSample()
end

function BulletManager:CreateBulletStraightRequest(class, logic, bulletMgr, objId, params)
  ProfilerUtil.BeginSample("BulletManagerCreateBullet")
  local bullet = ObjectPool:GetInstance():Load(class)
  ProfilerUtil.BeginSample("BulletManagerBulletInit")
  bullet:Init(logic, bulletMgr, objId, params)
  local noModel = bullet:Create()
  if noModel then
    self:TryAddBullet(bullet, true)
  else
    self.creatingStraightCount = self.creatingStraightCount + 1
    self.straightBulletReq[self.creatingStraightCount] = bullet
    BulletViewUtil.PreStraightViewList(bullet, self.creatingStraightCount)
  end
  ProfilerUtil.EndSample()
  ProfilerUtil.EndSample()
end

function BulletManager:CreateBulletGatling(class, logic, bulletMgr, objId, params)
  self:InitGatlingData(logic, params)
  ProfilerUtil.BeginSample("BulletManagerCreateBullet")
  local bullet = ObjectPool:GetInstance():Load(class)
  bullet:ReInit(logic, bulletMgr, objId, params)
  self:TryAddBullet(bullet, true)
  ProfilerUtil.EndSample()
end

function BulletManager:CreateBulletGatlingRequest(class, logic, bulletMgr, objId, params)
  self:InitGatlingData(logic, params)
  self.creatingGatlingCount = self.creatingGatlingCount + 1
  ProfilerUtil.BeginSample("BulletManagerCreateBullet")
  local bullet = ObjectPool:GetInstance():Load(class)
  bullet:ReInit(logic, bulletMgr, objId, params)
  self.gatlingBulletReq[self.creatingGatlingCount] = bullet
  BulletViewUtil.PreStraightGatlingViewList(bullet, self.creatingGatlingCount)
  ProfilerUtil.EndSample()
end

function BulletManager:GetGatlingData()
  return self.gatlingBulletMetaData
end

function BulletManager:InitGatlingData(logic, params)
  if self.gatlingBulletMetaData ~= nil then
    return
  end
  local data = {}
  local meta = params.meta
  local skill = params.skill
  local owner = skill.owner
  local forceLifeTime = params.forceLifeTime
  local noCollision = PVPType[logic:GetPVEType()]
  data.noCollision = noCollision
  local curve = meta.motion_curve
  if string.IsNullOrEmpty(curve) then
    curve = DEFAULT_BULLET_MOTION_STRING
  end
  data.curve = curve
  local flySpeed, lifetime
  if skill ~= nil and skill.isWorldTroopEffect then
    flySpeed = meta.bullet_fly_speed_world
    lifetime = meta.lifetime_world
  else
    flySpeed = meta.bullet_fly_speed
    lifetime = meta.lifetime
  end
  data.lifeTime = lifetime * 1.0
  local targetLayerMask, targetAllyExcludeSelf, targetSelfExcludeAlly, targetSearchType = PveUtil.GetTargetLayerBin(owner.searchType, meta.target_type_bin)
  data.targetLayerMask = targetLayerMask
  data.targetAllyExcludeSelf = targetAllyExcludeSelf
  data.targetSelfExcludeAlly = targetSelfExcludeAlly
  data.targetSearchType = targetSearchType
  local limit = noCollision and 1 or meta.bullet_damage_count
  local base_type = BulletDurabilityType.Collide
  if limit < 0 then
    base_type = BulletDurabilityType.CollideInfinity
  end
  data.limit = limit
  data.base_type = base_type
  data.dead_delay = meta.dead_delay or 0
  local bulletScale
  if skill.isWorldTroopEffect then
    bulletScale = meta.bullet_effect_size_world
  else
    bulletScale = meta.bullet_effect_size
  end
  data.bulletScale = bulletScale
  local duration
  if skill ~= nil and skill.isWorldTroopEffect then
    duration = meta.lifetime_world
  else
    duration = meta.lifetime
  end
  local speed = flySpeed
  if noCollision then
    if forceLifeTime then
      duration = forceLifeTime
    elseif skill and skill.forceLifeTime then
      duration = skill.forceLifeTime
    else
      duration = 0
    end
    speed = skill.meta.horizontal_speed
    if speed <= 0 then
      speed = 20
    end
  end
  data.duration = duration
  data.speed = speed
  local inertiaVelocity = owner:GetMoveVelocity()
  local inertiaVelocityX = inertiaVelocity.x
  local inertiaVelocityY = inertiaVelocity.y
  local inertiaVelocityZ = inertiaVelocity.z
  inertiaVelocity:ReturnPool()
  local bulletEffect, _ = meta:GetBulletEffect(owner.appearanceId)
  data.inertiaVelocityX = inertiaVelocityX
  data.inertiaVelocityY = inertiaVelocityY
  data.inertiaVelocityZ = inertiaVelocityZ
  data.bulletEffect = bulletEffect
  data.colliderRadius = meta.colliderRadius
  self.gatlingBulletMetaData = data
  data.needSetGrowShader = meta.bullet_born_scale
  BulletViewUtil.SyncStraightGatlingViewData(data)
end

function BulletManager:TryAddBullet(bullet, isStraight)
  if bullet.objId == nil then
    return
  end
  if self.updating then
    if isStraight then
      table.insert(self.toAddStraightBulletList, bullet)
      self.toAddStraightBulletListCount = self.toAddStraightBulletListCount + 1
    else
      table.insert(self.toAddBulletList, bullet)
      self.toAddBulletListCount = self.toAddBulletListCount + 1
    end
  elseif isStraight then
    local index = self.straightBullets:Add(bullet)
    bullet.arrayIndex = index
    self.straightBulletObj2Index[bullet.objId] = index
  else
    self.bullets[bullet.objId] = bullet
  end
end

function BulletManager:OnUpdate()
  local deltaTime = Time.deltaTime
  ProfilerUtil.BeginSample("BulletColliderUpdate")
  local resultList = PvePhysicsUtil.BulletCollider(deltaTime)
  self.colliderResultList = resultList
  self.colliderResultCount = 0
  if resultList then
    local length = #resultList
    local idPos = false
    local cacheId = 0
    local countPos = false
    local indexPos = 0
    if 0 < length and 0 < resultList[1] then
      table.clear(self.colliderMap)
      self.colliderResultCount = length
      idPos = true
      for i = 1, length do
        local data = resultList[i]
        if data < 0 then
          break
        end
        if idPos then
          cacheId = data
          idPos = false
          countPos = true
          indexPos = 0
        elseif countPos then
          idPos = false
          countPos = false
          indexPos = data
          self.colliderMap[cacheId] = i
        elseif 0 < indexPos then
          indexPos = indexPos - 1
          if indexPos == 0 then
            idPos = true
            countPos = false
            indexPos = 0
          end
        end
      end
    end
  end
  ProfilerUtil.EndSample()
  ProfilerUtil.BeginSample("BulletUpdate")
  if 0 < self.toAddBulletListCount then
    for i = self.toAddBulletListCount, 1, -1 do
      local bullet = self.toAddBulletList[i]
      local objId = bullet.objId
      if objId then
        self.bullets[objId] = bullet
      end
      table.remove(self.toAddBulletList, i)
    end
    self.toAddBulletListCount = 0
  end
  if 0 < self.toAddStraightBulletListCount then
    for i = self.toAddStraightBulletListCount, 1, -1 do
      local bullet = self.toAddStraightBulletList[i]
      if bullet.objId then
        local ind = self.straightBullets:Add(bullet)
        bullet.arrayIndex = ind
        self.straightBulletObj2Index[bullet.objId] = ind
      end
      table.remove(self.toAddStraightBulletList, i)
    end
    self.toAddStraightBulletListCount = 0
  end
  self.updating = true
  for _, v in pairs(self.bullets) do
    if v.objId then
      local collide = self.colliderMap[v.objId] ~= nil
      v:OnUpdate(collide, deltaTime)
    end
  end
  local straightLoadedCount = BulletViewUtil.CheckLoadedCount()
  if 0 < straightLoadedCount then
    for i = 1, straightLoadedCount do
      local guid, cd = BulletViewUtil.GetLoadedObjId(i)
      local arrayIndex = self.straightBulletObj2Index[guid]
      if arrayIndex then
        local bullet = self.straightBullets:Get(arrayIndex)
        if bullet and bullet.OnViewLoaded then
          bullet:OnViewLoaded(cd)
        end
      end
    end
  end
  for objId, _ in pairs(self.colliderMap) do
    local arrayIndex = self.straightBulletObj2Index[objId]
    if arrayIndex then
      local bullet = self.straightBullets:Get(arrayIndex)
      if bullet and bullet.OnStraightCollision then
        bullet:OnStraightCollision()
      end
    end
  end
  ProfilerUtil.EndSample()
  ProfilerUtil.BeginSample("BulletStraightUpdate")
  local straightCount = BulletViewUtil.UpdateStraightCount(deltaTime)
  if 0 < straightCount then
    for i = 1, straightCount do
      local objId, lifeEnd = BulletViewUtil.GetStraight(i)
      local arrayIndex = self.straightBulletObj2Index[objId]
      if arrayIndex then
        local bullet = self.straightBullets:Get(arrayIndex)
        if bullet and bullet.OnUpdateTransformFinish then
          bullet:OnUpdateTransformFinish(lifeEnd == 1)
        end
      end
    end
  end
  self.updating = false
  ProfilerUtil.EndSample()
  ProfilerUtil.BeginSample("BulletCreatorUpdate")
  for _, v in pairs(self.creators) do
    if v.objId then
      v:OnUpdate(deltaTime)
    end
  end
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    BulletViewUtil.CreateStraightViewList(self, self.straightBulletReq, self.creatingStraightCount)
    self.creatingStraightCount = 0
    BulletViewUtil.CreateStraightGatlingViewList(self, self.gatlingBulletReq, self.creatingGatlingCount)
    self.creatingGatlingCount = 0
  end
  ProfilerUtil.EndSample()
end

function BulletManager:TryGetCollideList(bulletObjId)
  if self.colliderResultCount > 0 then
    local countIndex = self.colliderMap[bulletObjId]
    if countIndex and 0 < countIndex then
      local count = self.colliderResultList[countIndex]
      if count == 1 then
        local value = self.colliderResultList[countIndex + 1]
        return count, value
      end
      if self.colliderResultTmpList == nil then
        self.colliderResultTmpList = {}
      end
      for i = 1, count do
        local value = self.colliderResultList[countIndex + i]
        self.colliderResultTmpList[i] = value
      end
      return count, self.colliderResultTmpList
    end
  end
  return nil, nil
end

function BulletManager:RemoveBullet(bullet)
  if bullet.arrayIndex then
    self.straightBullets:RemoveAt(bullet.arrayIndex)
    self.straightBulletObj2Index[bullet.objId] = nil
  else
    self.bullets[bullet.objId] = nil
  end
  bullet:Delete()
  ObjectPool:GetInstance():Save(bullet)
end

function BulletManager:RemoveCreator(creator)
  self.creators[creator.objId] = nil
  creator:Delete()
  ObjectPool:GetInstance():Save(creator)
end

function BulletManager:GetNextObjId()
  self.nextObjId = self.nextObjId + 1
  return self.nextObjId
end

function BulletManager:ShakeCameraWithParam(shakeCameraParam)
  self.battleMgr:ShakeCameraWithParam(shakeCameraParam)
end

function BulletManager:DealDamage(params)
  local bulletMeta = params.bulletMeta
  local defender = params.defender
  if bulletMeta.hit_clear_buff and defender then
    for buffId, count in pairs(bulletMeta.hit_clear_buff) do
      defender:RemoveBuffByMetaId(buffId, count)
    end
  end
  return self.battleMgr:DealDamage(params)
end

function BulletManager:GetUnit(objId)
  return self.battleMgr:GetUnit(objId)
end

function BulletManager:StringToCurve(str)
  if string.IsNullOrEmpty(str) then
    str = DEFAULT_BULLET_MOTION_STRING
  end
  local curve = self.curves[str]
  if not curve then
    ProfilerUtil.BeginSample("BulletManager.StringToCurve")
    curve = CS.CSUtils.StringToCurve(str)
    ProfilerUtil.EndSample()
    self.curves[str] = curve
  end
  return curve
end

function BulletManager:AppendSyncTransform(handle, x, y, z)
  local start = 1 + self.syncBulletTransformListCount * 4
  self.syncBulletTransformList[start + 1] = handle
  self.syncBulletTransformList[start + 2] = x
  self.syncBulletTransformList[start + 3] = y
  self.syncBulletTransformList[start + 4] = z
  self.syncBulletTransformListCount = self.syncBulletTransformListCount + 1
end

function BulletManager:AppendCheckLoaded(handle)
  self.checkLoadedListCount = self.checkLoadedListCount + 1
  self.checkLoadedList[self.checkLoadedListCount + 1] = handle
end

function BulletManager:CheckLoaded(handle)
  if self.checkLoadedResultMap == nil then
    return false
  end
  return self.checkLoadedResultMap[handle] or false
end

function BulletManager:PreloadStraight(preloadType, preloadAsset)
  if preloadAsset and 0 < preloadAsset then
    local template = DataCenter.LWFeaturePreloadAssetTemplateManager:GetTemplate(preloadAsset)
    if template then
      local bulletCount = template.bulletPreloadCount
      local totalCount = 0
      for i = 1, bulletCount do
        local asset = template.bullet_name[i]
        local count = template.bullet_number[i]
        totalCount = totalCount + count
        if not string.IsNullOrEmpty(asset) and 0 < count then
          BulletViewFacade.PreloadStraight(asset, count)
        end
      end
      local boomCount = template.boomPreloadCount
      for i = 1, boomCount do
        local asset = template.boom_name[i]
        local count = template.boom_number[i]
        totalCount = totalCount + count
        if not string.IsNullOrEmpty(asset) and 0 < count then
          BulletViewFacade.PreloadBullet(asset, count)
        end
      end
      if 1300 < totalCount then
        Logger.LogError("BulletManager:PreloadStraight too much : " .. totalCount)
      end
      return
    end
  end
  if preloadType == 3 then
    BulletViewFacade.PreloadStraight("Assets/_Art_LastWar/Effect/Prefab/Arms/AK/Eff_hero_AK_zidan_new.prefab", 360)
    BulletViewFacade.PreloadStraight("Assets/_Art_LastWar/Effect/Prefab/Arms/Fuchouzhe/Eff_hero_fuchouzhe_zidan.prefab", 900)
  elseif preloadType == 2 then
    BulletViewFacade.PreloadStraight("Assets/_Art_LastWar/Effect/Prefab/Arms/AK/Eff_hero_AK_zidan_new.prefab", 180)
    BulletViewFacade.PreloadStraight("Assets/_Art_LastWar/Effect/Prefab/Arms/Fuchouzhe/Eff_hero_fuchouzhe_zidan.prefab", 450)
  else
    BulletViewFacade.PreloadStraight("Assets/_Art_LastWar/Effect/Prefab/Arms/AK/Eff_hero_AK_zidan_new.prefab", 36)
    BulletViewFacade.PreloadStraight("Assets/_Art_LastWar/Effect/Prefab/Arms/Fuchouzhe/Eff_hero_fuchouzhe_zidan.prefab", 90)
  end
end

function BulletManager:GetDealDamageParamTable()
  if not self.dealDamageParamTable then
    self.dealDamageParamTable = {}
  end
  return self.dealDamageParamTable
end

function BulletManager:LogBulletData(metaId, waveCount, rowCount)
  if self.detailBulletData == nil then
    self.detailBulletData = {}
  end
  if self.detailBulletData[metaId] then
    return
  end
  self.detailBulletData[metaId] = true
  Logger.LogInfo(string.format("parkour bulletCreator metaId : %s. waveCount : %s. rowCount : %s", metaId, waveCount, rowCount))
end

function BulletManager:RecordBulletCreate(metaId, count)
  if self.bulletCreateMap == nil then
    self.bulletCreateMap = {}
  end
  local cur = self.bulletCreateMap[metaId] or 0
  self.bulletCreateMap[metaId] = cur + count
end

function BulletManager:GetTotalBulletCreate()
  if self.bulletCreateMap == nil then
    return 0
  end
  local count = 0
  for _, c in pairs(self.bulletCreateMap) do
    count = count + c
  end
  return count
end

function BulletManager:GetShowBulletCount()
  local count = 0
  if self.bullets then
    count = count + table.count(self.bullets)
  end
  if self.straightBulletObj2Index then
    count = count + table.count(self.straightBulletObj2Index)
  end
  return count
end

function BulletManager:GetBullet(bulletObjId)
  local bullet = self.bullets[bulletObjId]
  if bullet then
    return bullet
  end
  local arrayIndex = self.straightBulletObj2Index[bulletObjId]
  if arrayIndex then
    bullet = self.straightBullets:Get(arrayIndex)
  end
  return bullet
end

function BulletManager:UpdateBulletLogicAfterBuffRemove(bulletObjId, buffId)
  local bullet
  if self.bullets[bulletObjId] then
    bullet = self.bullets[bulletObjId]
  end
  if not bullet then
    local arrayIndex = self.straightBulletObj2Index[bulletObjId]
    if arrayIndex then
      bullet = self.straightBullets:Get(arrayIndex)
    end
  end
  if bullet then
    bullet:UpdateTriggerNewBuffCountAfterBuffRemove(buffId)
  end
end

return BulletManager
