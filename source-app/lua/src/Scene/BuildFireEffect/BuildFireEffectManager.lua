local BuildFireEffectManager = BaseClass("BuildFireEffectManager", Singleton)
local ResourceManager = CS.GameEntry.Resource
local BuildFireEffect = require("Scene.BuildFireEffect.BuildFireEffect")
local BuildIceEffect = require("Scene.BuildFireEffect.BuildIceEffect")
local FirePrefabPath = "Assets/Main/Prefabs/UI/Build/SceneBuildBloodTip1.prefab"
local IcePrefabPath = "Assets/Main/Prefabs/UI/Build/SceneBuildIceTip.prefab"
local MAX_CITY_DEFENCE = 10000

function BuildFireEffectManager:__init()
  self.fireEffectReqs = {}
  self.fireEffectScripts = {}
  self.fireEffectDataList = {}
  self.iceEffectReqs = {}
  self.iceEffectScripts = {}
  self.WorldAllianceBuilding = {}
  self:AddListener()
end

function BuildFireEffectManager:__delete()
  self:ClearAllEffect()
  self:RemoveListener()
end

function BuildFireEffectManager:ClearAllEffect()
  for k, v in pairs(self.fireEffectScripts) do
    v:OnDestroy()
  end
  self.fireEffectScripts = {}
  for k, v in pairs(self.fireEffectReqs) do
    v:Destroy()
  end
  self.fireEffectReqs = {}
  self.fireEffectDataList = {}
  for k, v in pairs(self.iceEffectScripts) do
    v:OnDestroy()
  end
  self.iceEffectScripts = {}
  for k, v in pairs(self.iceEffectReqs) do
    v:Destroy()
  end
  self.iceEffectReqs = {}
  self.WorldAllianceBuilding = {}
end

function BuildFireEffectManager:AddListener()
  EventManager:GetInstance():AddListenerWithSelf(EventId.ShowIsOnFire, self.ShowIsOnFireSignal, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.WORLD_BUILD_OUT_VIEW, self.BuildOutViewSignal, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.CheckDomeOpen, self.CheckDomeOpen, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.ChangeCameraLod, self.OnLodChange, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.WorldCityBuildObjUpdate, self.OnWorldCityBuildObjUpdate, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.OnEnterCrossServer, self.ClearAllEffect, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.OnEnterCity, self.ClearAllEffect, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.IcePointObjectIn, self.IceObjectIn, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.IcePointObjectOut, self.IceObjectOut, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.PointObjectUpdate, self.PointObjectUpdate, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.MonsterIceEffectRefresh, self.MonsterIceEffectRefresh, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.OnCounterAttackActInfo, self.OnCounterAttackActInfo, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.PointThermalRefresh, self.OnPointThermalRefresh, self)
end

function BuildFireEffectManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.ShowIsOnFire, self.ShowIsOnFireSignal)
  EventManager:GetInstance():RemoveListener(EventId.WORLD_BUILD_OUT_VIEW, self.BuildOutViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.CheckDomeOpen, self.CheckDomeOpen)
  EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.OnLodChange)
  EventManager:GetInstance():RemoveListener(EventId.WorldCityBuildObjUpdate, self.OnWorldCityBuildObjUpdate)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCrossServer, self.ClearAllEffect)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.ClearAllEffect)
  EventManager:GetInstance():RemoveListener(EventId.IcePointObjectIn, self.IceObjectIn)
  EventManager:GetInstance():RemoveListener(EventId.IcePointObjectOut, self.IceObjectOut)
  EventManager:GetInstance():RemoveListener(EventId.PointObjectUpdate, self.PointObjectUpdate)
  EventManager:GetInstance():RemoveListener(EventId.MonsterIceEffectRefresh, self.MonsterIceEffectRefresh)
  EventManager:GetInstance():RemoveListener(EventId.OnCounterAttackActInfo, self.OnCounterAttackActInfo)
  EventManager:GetInstance():RemoveListener(EventId.PointThermalRefresh, self.OnPointThermalRefresh)
end

function BuildFireEffectManager:OnCounterAttackActInfo(data)
  local mainBuildId = SeasonUtil.GetSeasonMilitaryCenterId()
  if data ~= mainBuildId then
    return
  end
  local theStoveCenter = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
  if theStoveCenter and theStoveCenter.uuid then
    self:OnWorldCityBuildObjUpdate(theStoveCenter.uuid)
  end
end

function BuildFireEffectManager:OnWorldCityBuildObjUpdate(data)
  local theWorld = CS.SceneManager.World
  if theWorld == nil then
    return
  end
  local uuid = tonumber(data)
  local info = theWorld:GetPointInfoByUuid(uuid)
  if info == nil or info.PointType ~= WorldPointType.WORLD_ALLIANCE_BUILD then
    return
  end
  local maxHp = 0
  local pointId = info.mainIndex
  local gameObject
  local obj = CS.SceneManager.World:GetObjectByUuid(uuid)
  if obj ~= nil then
    gameObject = obj:GetGameObject()
    if gameObject == nil then
      return
    end
  else
    return
  end
  local detailInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.AllianceBuildingPointInfo")
  if detailInfo == nil then
    return
  end
  local mgr = DataCenter.AllianceMineManager
  local mgrSkill = DataCenter.AllianceGovernmentSkillManager
  local seasonType = SeasonUtil.GetCurWorldSeasonType(true)
  local buildId = toInt(detailInfo.buildId)
  local templateId = buildId
  local level = toInt(detailInfo.level)
  local skill_cfg
  if detailInfo.buildId ~= BuildingTypes.LW_ALLIANCE_WAR_CAMP_2 then
    templateId = templateId + level
  end
  local template = mgr:GetAllianceMineTemplate(templateId)
  if template == nil then
    template = mgr:GetAllianceMineTemplate(buildId)
  end
  if template == nil then
    local tmp = mgr:GetAlCenterByPointIndex(pointId)
    if tmp then
      template = mgr:GetAllianceMineTemplate(tmp.buildId)
    end
  end
  if template ~= nil then
    maxHp = template.resDurable
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local isGuardianTower = false
  local shieldSkillInfo = info.shieldSkillInfo
  if seasonType == SeasonMapType.Darkness and shieldSkillInfo ~= nil and now < shieldSkillInfo.OverTime then
    skill_cfg = mgrSkill:GetTemplatesById(shieldSkillInfo.SkillId)
    if skill_cfg ~= nil and skill_cfg.skill_flag == AlOfficialSkillType.GuardianTower then
      isGuardianTower = true
    end
  end
  local fightState = detailInfo.fightState
  local curHp = detailInfo.durability or 0
  local lastHpTime = (detailInfo.lastDurabilityTime or 0) * 0.001
  local state = detailInfo.state or 0
  local coverSpeed = detailInfo.durabilitySpeed or 0
  local fireEndTime = detailInfo.fireEndTime or 0
  if state == AllianceMineStatus.Ruin then
    coverSpeed = 0
  end
  local ModelGoNode = gameObject.transform:Find("ModelGo")
  local UpgradeNode = gameObject.transform:Find("ModelGo/Upgrade")
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local nowHp = math.min((curTime - lastHpTime) * coverSpeed + curHp, maxHp)
  if maxHp <= nowHp then
    lastHpTime = 0
    curHp = nowHp
  end
  if state ~= AllianceMineStatus.Build then
    if IsNotNull(UpgradeNode) then
      UpgradeNode.gameObject:SetActive(false)
    end
    if self.WorldAllianceBuilding[uuid] then
      local dataAllianceBuilding = self.WorldAllianceBuilding[uuid]
      self.WorldAllianceBuilding[uuid] = nil
      if dataAllianceBuilding and dataAllianceBuilding.up then
        dataAllianceBuilding.up:Delete()
        dataAllianceBuilding.up = nil
      elseif dataAllianceBuilding and dataAllianceBuilding.upGo then
        if IsNotNull(dataAllianceBuilding.upGo) then
          dataAllianceBuilding.upGo.gameObject:SetActive(false)
        end
        dataAllianceBuilding.upGo = nil
      end
    end
  end
  if ModelGoNode and state == AllianceMineStatus.Build then
    if UpgradeNode then
      UpgradeNode.gameObject:SetActive(state == AllianceMineStatus.Build and toInt(self.theLod) < 4)
      self.WorldAllianceBuilding[uuid] = {
        go = gameObject,
        upGo = UpgradeNode,
        maxHp = maxHp,
        info = detailInfo
      }
    elseif SeasonUtil.SeasonHasMilitaryCenterAttachment(seasonType) then
      local dataAllianceBuilding = self.WorldAllianceBuilding[uuid]
      if dataAllianceBuilding == nil or dataAllianceBuilding.up == nil then
        local effectPath = "Assets/Main/SeasonRes/Shared/Prefabs/AllianceBuilding/Upgrade.prefab"
        UpgradeNode = UIAsyncNode.New("UpgradeNode", ModelGoNode.transform, effectPath, function(go)
          if IsNotNull(go) and GameObjectIsValid(ModelGoNode) then
            go.transform:Set_localScale(1.2, 1.2, 1.2)
            go.transform:Set_localPosition(1, 0, -2)
            go.transform:Set_localEulerAngles(0, 0, 0)
            go:SetActive(toInt(self.theLod) < 4)
          end
        end)
        self.WorldAllianceBuilding[uuid] = {
          go = gameObject,
          up = UpgradeNode,
          maxHp = maxHp,
          info = detailInfo
        }
      end
    end
  end
  if isGuardianTower == true or fightState == 1 or 0 < curHp and maxHp > curHp and lastHpTime ~= 0 then
    self:ShowBuildFireEffect(uuid, {
      PointType = WorldPointType.WORLD_ALLIANCE_BUILD,
      unavailableTime = fireEndTime,
      tileSize = 3,
      mainIndex = pointId,
      itemId = buildId,
      lastHpTime = lastHpTime,
      curHp = curHp,
      state = state,
      forceShowHpBar = isGuardianTower == true or fightState == 1,
      fightState = fightState,
      isGuardianTower = isGuardianTower,
      shieldSkillInfo = shieldSkillInfo
    }, fireEndTime, coverSpeed, maxHp, false)
  elseif DataCenter.CounterAttackDataManager:CheckStoveIsBeingAttack(uuid) then
    self:ShowBuildFireEffect(uuid, {
      PointType = WorldPointType.WORLD_ALLIANCE_BUILD,
      unavailableTime = fireEndTime,
      tileSize = 3,
      mainIndex = pointId,
      itemId = buildId,
      lastHpTime = lastHpTime,
      curHp = curHp,
      state = state,
      fightState = 0,
      isGuardianTower = false,
      shieldSkillInfo = nil,
      forceShowHpBar = true
    }, fireEndTime, coverSpeed, maxHp, false)
  else
    self:RemoveOneEffect(uuid)
  end
end

function BuildFireEffectManager:ShowBuildFireEffect(bUuid, info, endTime, recoverSpeed, maxHp, isFakePlayer)
  local param = {}
  param.tileX = info.tileSize
  param.tileY = info.tileSize
  param.posIndex = info.mainIndex
  param.endTime = endTime
  param.buildId = info.itemId
  param.recoverSpeed = recoverSpeed
  param.maxHp = maxHp
  param.lastHpTime = info.lastHpTime
  param.curHp = info.curHp
  param.info = info
  param.serverId = info.serverId
  param.uuid = bUuid
  param.isFakePlayer = isFakePlayer
  param.fireSpeed = info.fireSpeed
  param.unavailableTime = info.unavailableTime
  param.isGuardianTower = info.isGuardianTower
  param.shieldSkillInfo = info.shieldSkillInfo
  param.fightState = info.fightState
  param.forceShowHpBar = not info.forceShowHpBar and info.wallBarInfo and info.wallBarInfo:IsValid()
  self.fireEffectDataList[bUuid] = param
  if self.fireEffectReqs[bUuid] == nil then
    local modelName = FirePrefabPath
    local request = ResourceManager:InstantiateAsync(modelName)
    self.fireEffectReqs[bUuid] = request
    request:completed("+", function()
      if request.isError then
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local effect = BuildFireEffect.New()
      self.fireEffectScripts[bUuid] = effect
      effect:OnCreate(request)
      effect:ReInit(param)
      effect:OnLodChange(self.theLod)
    end)
  elseif self.fireEffectScripts[bUuid] ~= nil then
    self.fireEffectScripts[bUuid]:OnUpdateTime(endTime, recoverSpeed, info.unavailableTime, param)
  end
end

function BuildFireEffectManager:ShowBuildIceEffect(bUuid, info)
  local tileSize = info.tileSize
  local param = {
    tileX = tileSize,
    tileY = tileSize,
    posIndex = info.mainIndex,
    info = info,
    isBuilding = true,
    uuid = bUuid
  }
  if self.iceEffectReqs[bUuid] == nil then
    local request = ResourceManager:InstantiateAsync(IcePrefabPath)
    self.iceEffectReqs[bUuid] = request
    request:completed("+", function()
      request.gameObject:SetActive(true)
      request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local effect = BuildIceEffect.New()
      effect:OnCreate(request)
      effect:ReInit(param)
      effect:OnLodChange(self.theLod)
      self.iceEffectScripts[bUuid] = effect
    end)
  elseif self.iceEffectScripts[bUuid] ~= nil then
    self.iceEffectScripts[bUuid]:Refresh(info)
  end
end

function BuildFireEffectManager:RemoveOneEffect(bUuid)
  local dataAllianceBuilding = self.WorldAllianceBuilding[bUuid]
  self.WorldAllianceBuilding[bUuid] = nil
  if dataAllianceBuilding and dataAllianceBuilding.up then
    dataAllianceBuilding.up:Delete()
    dataAllianceBuilding.up = nil
  elseif dataAllianceBuilding and dataAllianceBuilding.upGo then
    if IsNotNull(dataAllianceBuilding.upGo) then
      dataAllianceBuilding.upGo.gameObject:SetActive(false)
    end
    dataAllianceBuilding.upGo = nil
  end
  self:RemoveFireEffect(bUuid)
  self:RemoveIceEffect(bUuid)
end

function BuildFireEffectManager:RemoveFireEffect(bUuid)
  if self.fireEffectDataList[bUuid] then
    self.fireEffectDataList[bUuid] = nil
  end
  if self.fireEffectScripts[bUuid] ~= nil then
    self.fireEffectScripts[bUuid]:OnDestroy()
    self.fireEffectScripts[bUuid] = nil
  end
  if self.fireEffectReqs[bUuid] ~= nil then
    self.fireEffectReqs[bUuid]:Destroy()
    self.fireEffectReqs[bUuid] = nil
  end
end

function BuildFireEffectManager:RemoveIceEffect(bUuid)
  if self.iceEffectScripts[bUuid] ~= nil then
    self.iceEffectScripts[bUuid]:OnDestroy()
    self.iceEffectScripts[bUuid] = nil
  end
  if self.iceEffectReqs[bUuid] ~= nil then
    self.iceEffectReqs[bUuid]:Destroy()
    self.iceEffectReqs[bUuid] = nil
  end
end

function BuildFireEffectManager:ShowIsOnFireSignal(uuid)
  self:CheckShowEffect(tonumber(uuid))
end

function BuildFireEffectManager:BuildOutViewSignal(uuid)
  self:RemoveOneEffect(tonumber(uuid))
end

function BuildFireEffectManager:CheckDomeOpen(uuid)
  self:CheckShowEffect(tonumber(uuid))
end

function BuildFireEffectManager:CheckShowEffect(bUuid)
  local info = CS.SceneManager.World:GetPointInfoByUuid(bUuid)
  if info ~= nil then
    self:OnWorldBaseRefresh(info)
  end
end

function BuildFireEffectManager:OnWorldBaseRefresh(info)
  local bUuid = info.uuid
  if info.destroyStartTime > 0 then
    self:RemoveOneEffect(bUuid)
  else
    if info:IsFrozen() then
      self:RemoveFireEffect()
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local aosEndTime = info.aosEndTime or 0
      if aosEndTime ~= 0 and curTime <= aosEndTime then
        self:RemoveIceEffect(bUuid)
      else
        self:ShowBuildIceEffect(bUuid, info)
      end
      return
    end
    if self.iceEffectScripts[bUuid] then
      self.iceEffectScripts[bUuid]:ShowReduceEffect()
    end
    self:RemoveIceEffect(bUuid)
    local recoverSpeed = LuaEntry.DataConfig:TryGetNum("building_attack", "k2")
    local infoItemId = info.itemId
    local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(infoItemId, info.level)
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(infoItemId)
    local isFakePlayer = false
    local isSeasonPlayerBuilding = false
    if buildLevelTemplate ~= nil and buildTemplate ~= nil then
      if infoItemId == BuildingTypes.FUN_BUILD_MAIN then
        if 0 < info.recoverSpeed then
          recoverSpeed = info.recoverSpeed
        else
          recoverSpeed = buildLevelTemplate:GetDefenceWallCoverSpeed()
        end
      end
      local inDragonWorld = BattleFieldUtil.InBattleField()
      local curTime = UITimeManager:GetInstance():GetServerSeconds()
      local maxHp = buildLevelTemplate.max_hp
      if buildLevelTemplate and buildLevelTemplate.tab_type == UIBuildListTabType.SeasonBuild then
        if info.recoverSpeed ~= nil and info.recoverSpeed ~= 0 then
          recoverSpeed = info.recoverSpeed
        end
        isSeasonPlayerBuilding = true
      elseif inDragonWorld then
        if info.curMaxHp and 0 < info.curMaxHp then
          maxHp = info.curMaxHp
        else
          maxHp = BattleFieldUtil.GetPlayerMaxHp(BattleFieldUtil.GetCurBattleFieldType())
        end
      elseif SeasonUtil.IsSeasonPlayerBuildingInt(infoItemId) then
      elseif infoItemId == BuildingTypes.WORM_HOLE_CROSS then
        maxHp = LuaEntry.Effect:GetGameEffect(EffectDefine.MAX_MY_CITY_DEFENCE)
      elseif info:IsNormalType() then
        if infoItemId == BuildingTypes.FUN_BUILD_MAIN then
          maxHp = MAX_CITY_DEFENCE
        elseif infoItemId == BuildingTypes.LW_CITY_RUIN or infoItemId == BuildingTypes.LW_CITY_RUIN_2 then
          maxHp = LuaEntry.DataConfig:TryGetNum("ruin_destruction", "k3")
          recoverSpeed = 1.0E-9
        end
      else
        local eventUuid = info.uuid
        local eventInfo = DataCenter.RadarCenterDataManager:GetDetectEventInfo(eventUuid)
        if eventInfo then
          local eventId = eventInfo.eventId
          local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(eventId)
          if template.type == DetectEventType.FAKE_PLAYER then
            local simplayerId = tonumber(template.para)
            local playerConfig = LocalController:instance():getLine(TableName.LW_SIMPLAYER, simplayerId)
            if playerConfig then
              isFakePlayer = true
              maxHp = tonumber(playerConfig.defense_value)
              recoverSpeed = 1.0E-9
            end
          end
        end
      end
      if maxHp == nil or maxHp == "" or maxHp == 0 then
        self:RemoveOneEffect(bUuid)
        return
      end
      local statusList = info.status
      if not inDragonWorld and statusList ~= nil and 0 < statusList.Count then
        local count = statusList.Count
        local now = UITimeManager:GetInstance():GetServerTime()
        for i = 0, count - 1 do
          local oneStatus = statusList[i]
          if oneStatus and oneStatus.Id == EffectDefine.SEASON_MUMMY_Status_Id_CURSE2 and now < oneStatus.ExpireTime then
            local num = 1000
            local meta = LocalController:instance():getLine(TableName.StatusTab, EffectDefine.SEASON_MUMMY_Status_Id_CURSE2)
            if meta then
              num = math.min(toInt(meta.effect_num), 0)
            end
            maxHp = math.min(maxHp + math.min(toInt(oneStatus.Layer), 5) * num, maxHp)
          end
        end
      end
      local curHp = info.curHp
      local deltaHp = math.max(maxHp - curHp, 0)
      local param = {}
      param.state = WorldLifebaState.Normal
      param.showEffect = false
      local needTime = isFakePlayer and curTime + math.max(0, math.ceil(deltaHp / recoverSpeed)) or math.max(0, math.ceil(deltaHp / recoverSpeed)) + info.lastHpTime
      local showEffect = false
      if BattleFieldUtil.InBattleField() then
        showEffect = maxHp > curHp
      elseif isSeasonPlayerBuilding then
        showEffect = maxHp > curHp and curTime < needTime
      elseif info.wallBarInfo and info.wallBarInfo:IsValid() then
        showEffect = true
      else
        showEffect = curTime < info.unavailableTime / 1000 or curTime < needTime
      end
      if SeasonUtil.IsInAndAfterSeasonSnowMode() and info:IsOverHeat() then
        showEffect = true
        needTime = 4098245047000
      end
      if showEffect then
        self:ShowBuildFireEffect(bUuid, info, needTime, recoverSpeed, maxHp, isFakePlayer)
        EventManager:GetInstance():Broadcast(EventId.PlayerHPChanged, bUuid)
      else
        self:RemoveOneEffect(bUuid)
      end
    end
  end
end

function BuildFireEffectManager:TimeCallBack(bUuid)
  BuildFireEffectManager:GetInstance():RemoveOneEffect(bUuid)
end

function BuildFireEffectManager:OnLodChange(lod)
  self.theLod = lod
  for k, v in pairs(self.fireEffectScripts) do
    v:OnLodChange(lod)
  end
  for k, v in pairs(self.iceEffectScripts) do
    v:OnLodChange(lod)
  end
  for k, v in pairs(self.WorldAllianceBuilding) do
    if v and v.go and v.info then
      if v.up == nil and v.upGo == nil then
        v.go = nil
        v.up = nil
        v.upGo = nil
      elseif toInt(lod) > 3 or v.info.state ~= AllianceMineStatus.Build then
        if v.up and v.up.gameObject then
          v.up.gameObject:SetActive(false)
        elseif v.upGo and v.upGo.gameObject then
          v.upGo.gameObject:SetActive(false)
        end
      elseif v.info and v.maxHp then
        local curTime = UITimeManager:GetInstance():GetServerSeconds()
        local curHp = v.info.durability or 0
        local lastHpTime = (v.info.lastDurabilityTime or 0) * 0.001
        local coverSpeed = v.info.durabilitySpeed or 0
        if (curTime - lastHpTime) * coverSpeed + curHp >= v.maxHp then
          if v.up then
            v.up:Delete()
          end
          v.up = nil
          v.go = nil
          v.upGo = nil
        elseif v.up and v.up.gameObject then
          v.up.gameObject:SetActive(true)
        elseif v.upGo and v.upGo.gameObject then
          v.upGo.gameObject:SetActive(true)
        end
      end
    end
  end
end

function BuildFireEffectManager:GetBuildIsFire(bUuid)
  local isFire = false
  local info = CS.SceneManager.World:GetPointInfoByUuid(bUuid)
  if info ~= nil and not BattleFieldUtil.InBattleField() then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < info.unavailableTime then
      isFire = true
    end
  end
  return isFire
end

function BuildFireEffectManager:IceObjectIn(bUuid)
  local info = CS.SceneManager.World:GetPointInfoByUuid(bUuid)
  if info ~= nil and info:IsFrozen() then
    local tileSize = info.tileSize
    local param = {
      tileX = tileSize,
      tileY = tileSize,
      posIndex = info.mainIndex,
      info = info,
      isBuilding = true,
      uuid = bUuid
    }
    if self.iceEffectReqs[bUuid] == nil then
      local request = ResourceManager:InstantiateAsync(IcePrefabPath)
      self.iceEffectReqs[bUuid] = request
      request:completed("+", function()
        request.gameObject:SetActive(true)
        request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
        request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local effect = BuildIceEffect.New()
        effect:OnCreate(request)
        effect:ReInit(param)
        effect:OnLodChange(self.theLod)
        self.iceEffectScripts[bUuid] = effect
      end)
    elseif self.iceEffectScripts[bUuid] ~= nil then
      self.iceEffectScripts[bUuid]:Refresh(info)
    end
  end
end

function BuildFireEffectManager:IceObjectOut(bUuid)
  self:RemoveIceEffect(bUuid)
end

function BuildFireEffectManager:PointObjectUpdate(bUuid)
  local info = CS.SceneManager.World:GetPointInfoByUuid(bUuid)
  if info ~= nil then
    if info:IsFrozen() then
      local tileSize = info.tileSize
      local param = {
        tileX = tileSize,
        tileY = tileSize,
        posIndex = info.mainIndex,
        info = info,
        isBuilding = true,
        uuid = bUuid
      }
      if self.iceEffectReqs[bUuid] == nil then
        local request = ResourceManager:InstantiateAsync(IcePrefabPath)
        self.iceEffectReqs[bUuid] = request
        request:completed("+", function()
          request.gameObject:SetActive(true)
          request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
          request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          local effect = BuildIceEffect.New()
          effect:OnCreate(request)
          effect:ReInit(param)
          effect:OnLodChange(self.theLod)
          self.iceEffectScripts[bUuid] = effect
        end)
      elseif self.iceEffectScripts[bUuid] ~= nil then
        self.iceEffectScripts[bUuid]:Refresh(info)
      end
    else
      if self.iceEffectScripts[bUuid] then
        self.iceEffectScripts[bUuid]:ShowReduceEffect()
      end
      self:RemoveIceEffect(bUuid)
    end
  end
end

function BuildFireEffectManager:MonsterIceEffectRefresh(uuid)
  local marchData = CS.SceneManager.World:GetMarch(uuid)
  if marchData == nil then
    return
  end
  if marchData:IsFrozen() then
    local param = {
      posIndex = marchData.startPos,
      info = marchData,
      isMarch = true,
      uuid = uuid
    }
    if self.iceEffectReqs[uuid] == nil then
      local request = ResourceManager:InstantiateAsync(IcePrefabPath)
      self.iceEffectReqs[uuid] = request
      request:completed("+", function()
        if request.isError then
          return
        end
        request.gameObject:SetActive(true)
        request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
        request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local effect = BuildIceEffect.New()
        effect:OnCreate(request)
        effect:ReInit(param)
        effect:OnLodChange(self.theLod)
        self.iceEffectScripts[uuid] = effect
      end)
    elseif self.iceEffectScripts[uuid] ~= nil then
      self.iceEffectScripts[uuid]:Refresh(marchData)
    end
  else
    if self.iceEffectScripts[marchData.uuid] then
      self.iceEffectScripts[marchData.uuid]:ShowReduceEffect()
    end
    self:RemoveIceEffect(marchData.uuid)
  end
end

function BuildFireEffectManager:OnPointThermalRefresh(uuid)
  local info = CS.SceneManager.World:GetPointInfoByUuid(uuid)
  if not info then
    return
  end
  if info.itemId == BuildingTypes.FUN_BUILD_MAIN then
    self:CheckShowEffect(uuid)
  else
    self:PointObjectUpdate(uuid)
  end
end

return BuildFireEffectManager
