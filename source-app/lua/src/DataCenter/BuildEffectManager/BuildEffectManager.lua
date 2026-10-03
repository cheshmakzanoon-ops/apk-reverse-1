local BuildEffectManager = BaseClass("BuildEffectManager")
local BuildEffectObj = require("DataCenter.BuildEffectManager.BuildEffectObj")
local TWModelObj = require("DataCenter.BuildEffectManager.TWModelObj")
local LWDominatorCityBuilding = require("UI/UILWDominator/Main/City/LWDominatorCityBuilding")

function BuildEffectManager:__init()
  self.loadedConfig = false
  self.worldAllEffect = {}
  self.cityAllEffect = {}
  self.twEffect = nil
  self.dominatorEffect = nil
  self.delayEffectDic = {}
  self.delayEffectCount = 0
  self.delayEffectBi = {}
  self.delayEffectBi.delaySuc = 0
  self.delayEffectBi.delayFail = 0
  self.delayEffectBi.deviceLevel = GameQualitySettings.GetDeviceLevel()
  self:AddListener()
end

function BuildEffectManager:__delete()
  for i, effect in pairs(self.worldAllEffect) do
    if effect then
      effect:Delete()
      effect = nil
    end
  end
  for i, effect in pairs(self.cityAllEffect) do
    if effect then
      effect:Delete()
      effect = nil
    end
  end
  self.delayEffectDic = {}
  self.delayEffectCount = 0
  if self.twEffect then
    self.twEffect:Delete()
    self.twEffect = nil
  end
  if self.dominatorEffect then
    self.dominatorEffect:Delete()
    self.dominatorEffect = nil
  end
  if self.tickTimer then
    self.tickTimer:Stop()
    self.tickTimer = nil
  end
  self:RemoveListener()
end

function BuildEffectManager:Startup()
end

function BuildEffectManager:AddListener()
  EventManager:GetInstance():AddListener(EventId.WORLD_BUILD_IN_VIEW, self.OnWorldBuildInView)
  EventManager:GetInstance():AddListener(EventId.CheckDomeOpen, self.OnWorldBuildInView)
  EventManager:GetInstance():AddListener(EventId.WORLD_BUILD_OUT_VIEW, self.OnWorldBuildOutView)
  EventManager:GetInstance():AddListener(EventId.UserSkinUpdate, self.OnUserSkinUpdate)
  EventManager:GetInstance():AddListener(EventId.BUILD_IN_VIEW, self.OnCityBuildInView)
  EventManager:GetInstance():AddListener(EventId.BUILD_OUT_VIEW, self.OnCityBuildOutView)
  EventManager:GetInstance():AddListener(EventId.DominatorAppearanceUpdate, self.OnDominatorAppearanceUpdate)
  EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.OnEnterWorld)
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.OnEnterCity)
end

function BuildEffectManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.WORLD_BUILD_IN_VIEW, self.OnWorldBuildInView)
  EventManager:GetInstance():RemoveListener(EventId.CheckDomeOpen, self.OnWorldBuildInView)
  EventManager:GetInstance():RemoveListener(EventId.WORLD_BUILD_OUT_VIEW, self.OnWorldBuildOutView)
  EventManager:GetInstance():RemoveListener(EventId.UserSkinUpdate, self.OnUserSkinUpdate)
  EventManager:GetInstance():RemoveListener(EventId.BUILD_IN_VIEW, self.OnCityBuildInView)
  EventManager:GetInstance():RemoveListener(EventId.BUILD_OUT_VIEW, self.OnCityBuildOutView)
  EventManager:GetInstance():RemoveListener(EventId.DominatorAppearanceUpdate, self.OnDominatorAppearanceUpdate)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.OnEnterWorld)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.OnEnterCity)
end

function BuildEffectManager:GetWorldBuildModelByBUid(bUuid)
  if not CS.SceneManager.World then
    return
  end
  return CS.SceneManager.World:GetObjectByUuid(bUuid)
end

local function GetBuildModelByPointId(pointId)
  if not CS.SceneManager.World then
    return
  end
  return CS.SceneManager.World:GetBuildingByPoint(pointId)
end

function BuildEffectManager.OnCityBuildOutView(bUuid)
  local self = DataCenter.BuildEffectManager
  self.OnBuildOutView(bUuid, self.cityAllEffect)
end

function BuildEffectManager.OnWorldBuildInView(bUuid)
  local self = DataCenter.BuildEffectManager
  local info = CS.SceneManager.World:GetPointInfoByUuid(bUuid)
  if not info then
    return
  end
  self:OnWorldBaseRefresh(info)
end

function BuildEffectManager:OnWorldBaseRefresh(info)
  local cityModel, worldPoint
  local bUuid = info.uuid
  if info ~= nil and info.PointType == WorldPointType.PlayerBuilding then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local aosEndTime = info.aosEndTime or 0
    if aosEndTime ~= 0 and curTime <= aosEndTime then
      return
    end
    if info:IsFrozen() then
      return
    end
  end
  worldPoint = self:GetWorldBuildModelByBUid(bUuid)
  if not worldPoint then
    return
  end
  cityModel = worldPoint:GetGameObject()
  if IsNull(cityModel) then
    return
  end
  local effectObj = self.worldAllEffect[bUuid]
  if effectObj then
    effectObj:SetData(bUuid, info, cityModel, worldPoint)
  else
    self:TryDelayCreateEffect(bUuid, info, cityModel, worldPoint)
  end
end

function BuildEffectManager.OnWorldBuildOutView(bUuid)
  local self = DataCenter.BuildEffectManager
  local suc = self:TryDeleteDelayCreator(bUuid)
  if suc then
    self.delayEffectBi.delaySuc = self.delayEffectBi.delaySuc + 1
  end
  self.OnBuildOutView(bUuid, self.worldAllEffect)
  if self.twEffect and self.twEffect.bUuid == bUuid then
    self.twEffect:Delete()
    self.twEffect = nil
  end
  if self.dominatorEffect and self.dominatorEffect.bUuid == bUuid then
    self.dominatorEffect:Delete()
    self.dominatorEffect = nil
  end
end

function BuildEffectManager.OnUserSkinUpdate(type)
  if type == DecorationType.DecorationType_Main_Effect or type == DecorationType.DecorationType_Main_City then
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
    local self = DataCenter.BuildEffectManager
    self.OnCityBuildInView(buildData.uuid)
  end
  if type == DecorationType.DecorationType_TacticalWeapon then
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_TACTICAL_CENTER)
    if buildData == nil then
      return
    end
    local self = DataCenter.BuildEffectManager
    self.OnCityBuildInView(buildData.uuid)
  end
end

function BuildEffectManager.OnCityBuildInView(bUuid)
  local self = DataCenter.BuildEffectManager
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  local buildId
  if buildData then
    buildId = buildData.itemId
  end
  if buildId == BuildingTypes.FUN_BUILD_MAIN then
    if buildData:IsUpgradeFinish() then
      return
    end
    local mainEffectId = DataCenter.DecorationDataManager:GetCurrentSkinByType(DecorationType.DecorationType_Main_Effect)
    local template = DataCenter.DecorationTemplateManager:GetTemplate(mainEffectId)
    if template ~= nil then
      local cityObj = GetBuildModelByPointId(buildData.pointId)
      if cityObj == nil then
        return
      end
      local effectObj = self.cityAllEffect[bUuid]
      if effectObj then
        effectObj:SetData(bUuid, {effectId = mainEffectId}, cityObj)
      else
        self.cityAllEffect[bUuid] = BuildEffectObj:New()
        self.cityAllEffect[bUuid]:SetData(bUuid, {effectId = mainEffectId}, cityObj)
      end
    end
  elseif buildId == BuildingTypes.LW_BUILD_TACTICAL_CENTER then
    local templateId = DataCenter.TacticalWeaponManager:GetSelfWeaponAppearance()
    if templateId then
      local buildObj = GetBuildModelByPointId(buildData.pointId)
      if buildObj == nil then
        return
      end
      local effectObj = self.twEffect
      if effectObj then
        effectObj:SetData(bUuid, templateId, buildObj)
      else
        self.twEffect = TWModelObj:New()
        self.twEffect:SetData(bUuid, templateId, buildObj)
      end
    end
  elseif buildId == BuildingTypes.LW_BUILD_DOMINATOR_MAIN then
    local buildObj = GetBuildModelByPointId(buildData.pointId)
    if buildObj == nil then
      return
    end
    local effectObj = self.dominatorEffect
    if effectObj then
      effectObj:SetData(bUuid, buildObj)
    else
      self.dominatorEffect = LWDominatorCityBuilding:New()
      self.dominatorEffect:SetData(bUuid, buildObj)
    end
  elseif buildId == BuildingTypes.LW_BUILD_SEASON4_LIGHTHOUSE then
    DataCenter.SeasonPowerWorkerManager:SwitchBuildAnim(buildId, bUuid, buildData)
  elseif buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION1 or buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION2 or buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION3 or buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION4 then
    DataCenter.SeasonPowerWorkerManager:SwitchBuildAnim(buildId, bUuid, buildData)
  end
end

function BuildEffectManager.OnBuildOutView(bUuid, dic)
  if dic[bUuid] then
    dic[bUuid]:Delete()
    dic[bUuid] = nil
  end
end

function BuildEffectManager:IsDelayLoadEffEnable()
  return LuaEntry.DataConfig:CheckSwitch("world_entity_delayed_load")
end

local _delaySecRangeByDeviceId = {
  [0] = {1000, 1500},
  [1] = {1000, 1500},
  [2] = {800, 1500},
  [3] = {800, 1200},
  [4] = {600, 1000},
  [5] = {500, 800},
  [6] = {400, 600},
  [7] = {400, 600}
}

function BuildEffectManager:GetDelayMs(bUuid, info)
  if bUuid == LuaEntry.Player:GetMainBuildUUID() then
    return -1
  end
  local deviceLv = self.delayEffectBi and self.delayEffectBi.deviceLevel
  if not deviceLv then
    return -1
  end
  local range = _delaySecRangeByDeviceId[deviceLv] or _delaySecRangeByDeviceId[1]
  if not range then
    return -1
  end
  return Mathf.Random(range[1], range[2])
end

function BuildEffectManager:TryDelayCreateEffect(bUuid, info, cityModel, worldPoint)
  if not self:IsDelayLoadEffEnable() then
    self.worldAllEffect[bUuid] = BuildEffectObj:New()
    self.worldAllEffect[bUuid]:SetData(bUuid, info, cityModel, worldPoint)
    return
  end
  if self.delayEffectDic[bUuid] then
    self.delayEffectDic[bUuid].info = info
    self.delayEffectDic[bUuid].cityModel = cityModel
    self.delayEffectDic[bUuid].worldPoint = worldPoint
    return
  end
  local delayMs = self:GetDelayMs(bUuid, info)
  if 0 < delayMs then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    self.delayEffectDic[bUuid] = {
      info = info,
      cityModel = cityModel,
      worldPoint = worldPoint,
      time = curTime + delayMs
    }
    self.delayEffectCount = self.delayEffectCount + 1
    if not self.tickTimer then
      self.tickTimer = TimerManager:GetInstance():GetTimer(0.1, self.OnTimerUpdate, self, false, false, true)
      self.tickTimer:Start()
    end
  else
    self.delayEffectBi.delayFail = self.delayEffectBi.delayFail + 1
    self.worldAllEffect[bUuid] = BuildEffectObj:New()
    self.worldAllEffect[bUuid]:SetData(bUuid, info, cityModel, worldPoint)
  end
end

function BuildEffectManager:TryDeleteDelayCreator(bUuid)
  if not self.delayEffectDic[bUuid] then
    return false
  end
  self.delayEffectDic[bUuid] = nil
  self.delayEffectCount = self.delayEffectCount - 1
  if self.delayEffectCount <= 0 then
    self.delayEffectDic = {}
    if self.tickTimer then
      self.tickTimer:Stop()
      self.tickTimer = nil
    end
  end
  return true
end

function BuildEffectManager:OnTimerUpdate()
  if self.delayEffectCount > 0 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local _temp = {}
    for k, v in pairs(self.delayEffectDic) do
      if curTime >= v.time then
        local uuid = k
        self.worldAllEffect[uuid] = BuildEffectObj:New()
        self.worldAllEffect[uuid]:SetData(uuid, v.info, v.cityModel, v.worldPoint)
        self.delayEffectBi.delayFail = self.delayEffectBi.delayFail + 1
        table.insert(_temp, k)
      end
    end
    if 0 < #_temp then
      for _, v in ipairs(_temp) do
        self:TryDeleteDelayCreator(v)
      end
    end
    _temp = nil
  end
end

function BuildEffectManager.OnDominatorAppearanceUpdate()
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_DOMINATOR_MAIN)
  if buildData == nil then
    return
  end
  local self = DataCenter.BuildEffectManager
  self.OnCityBuildInView(buildData.uuid)
end

function BuildEffectManager.OnEnterCity()
  local self = DataCenter.BuildEffectManager
  self.delayEffectDic = {}
  self.delayEffectCount = 0
  if self.tickTimer then
    self.tickTimer:Stop()
    self.tickTimer = nil
  end
  if self:IsDelayLoadEffEnable() and self.delayEffectBi and (0 < self.delayEffectBi.delaySuc or 0 < self.delayEffectBi.delayFail) then
    PostEventLog.Track(PostEventLog.Defines.DelayLoadWorldCityEff, {
      completenum = self.delayEffectBi.delaySuc,
      computenum1 = self.delayEffectBi.delayFail,
      computenum2 = self.delayEffectBi.deviceLevel
    })
    self.delayEffectBi.delaySuc = 0
    self.delayEffectBi.delayFail = 0
  end
end

function BuildEffectManager.OnEnterWorld()
  local self = DataCenter.BuildEffectManager
  self.delayEffectDic = {}
  self.delayEffectCount = 0
end

return BuildEffectManager
