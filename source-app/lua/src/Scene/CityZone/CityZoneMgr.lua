local CityZoneMgr = BaseClass("CityZoneMgr")
local Resource = CS.GameEntry.Resource
local CityZone = require("Scene.CityZone.CityZone")
local CityZoneFog = require("Scene.CityZone.CityZoneFog")
local utils = require("DataCenter.LWGateDefenceManager.LWGateDefenceUtils")
local SeasonBuildGroundEasterEggs = require("UI.LWSeason.LWSeasonEasterEgg.Main.SeasonBuildGroundEasterEggs")

function CityZoneMgr:__init()
  self.req = nil
  self.gameObject = nil
  self.transform = nil
  self.cityZoneFog = nil
  self.isZoneMax = true
  self.zoneDict = {}
  self.seasonBuildingGroundPrefabReq = nil
  self.seasonBuildingGroundNormalNode = nil
  self.seasonBuildingGroundSnowNode = nil
  self.curUnlockLandDataDict = {}
  self:AddListener()
end

function CityZoneMgr:__delete()
  if self.delayTimer1 then
    self.delayTimer1:Stop()
    self.delayTimer1 = nil
  end
  self.curUnlockLandDataDict = nil
  self:RemoveListener()
  self:Destroy(true)
end

function CityZoneMgr:Destroy(isDelete)
  if self.req ~= nil then
    self.req:Destroy()
    self.req = nil
    self.transform = nil
    self.gameObject = nil
    PostEventLog.Track("city_zone_unload", {})
  end
  if self.seasonBuildingGroundPrefabReq ~= nil then
    self.seasonBuildingGroundPrefabReq:Destroy()
    self.seasonBuildingGroundPrefabReq = nil
  end
  for _, v in pairs(self.zoneDict) do
    v:Destroy()
  end
  self.isZoneMax = true
  self.zoneDict = {}
  if self.cityZoneFog then
    if isDelete then
      self.cityZoneFog:Destroy()
      self.cityZoneFog = nil
    else
      self.cityZoneFog:HideFog()
    end
  end
  self:HideSeasonBuildGround()
  EventManager:GetInstance():Broadcast(EventId.DestroyCityZoneGround)
end

function CityZoneMgr:Startup()
end

function CityZoneMgr:AddListener()
  EventManager:GetInstance():AddListener(EventId.LuaEntryEffectRefreshStatus, self.RefreshCityState)
  if self.showCityZone == nil then
    function self.showCityZone()
      self:ShowCityZone()
    end
    
    EventManager:GetInstance():AddListener(EventId.ShowCityZone, self.showCityZone)
  end
  if self.hideCityZone == nil then
    function self.hideCityZone()
      self:HideCityZone()
    end
    
    EventManager:GetInstance():AddListener(EventId.HideCityZone, self.hideCityZone)
  end
  if self.refreshCityZone == nil then
    function self.refreshCityZone()
      self:RefreshCityZone()
    end
    
    EventManager:GetInstance():AddListener(EventId.RefreshCityZone, self.refreshCityZone)
  end
  EventManager:GetInstance():AddListenerWithSelf(EventId.BUILDING_FURNACE_DATA_UPDATE, self.PersonalFurnaceStateChange, self)
end

function CityZoneMgr:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.LuaEntryEffectRefreshStatus, self.RefreshCityState)
  if self.showCityZone ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.ShowCityZone, self.showCityZone)
    self.showCityZone = nil
  end
  if self.hideCityZone ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.HideCityZone, self.hideCityZone)
    self.hideCityZone = nil
  end
  if self.refreshCityZone ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.RefreshCityZone, self.refreshCityZone)
    self.refreshCityZone = nil
  end
  EventManager:GetInstance():RemoveListener(EventId.BUILDING_FURNACE_DATA_UPDATE, self.PersonalFurnaceStateChange)
end

function CityZoneMgr.RefreshCityState(effectId)
  local self = DataCenter.CityZoneMgr
  if effectId == CityState.RuinedCity then
    self:ShowBurnEffect()
  end
end

function CityZoneMgr:ShowBurnEffect(isInit)
  local isOn = LuaEntry.Effect:CheckCityFarmState()
  if IsNull(self.cityStateEffect) then
    return
  end
  local flameObj = self.cityStateEffect.transform:Find("fameEffecrRoot")
  if flameObj.gameObject.activeSelf and not isOn and not isInit then
    self.delayTimer1 = TimerManager:GetInstance():DelayInvoke(function()
      if not IsNull(self.cityStateEffect) then
        local repairEffectObj = self.cityStateEffect.transform:Find("repairEffect")
        if not IsNull(repairEffectObj) then
          for i = 1, repairEffectObj.childCount do
            local child = repairEffectObj:GetChild(i - 1)
            child.gameObject:SetActive(true)
          end
        end
      end
    end, 1)
  end
  if not IsNull(flameObj) then
    flameObj.gameObject:SetActive(isOn)
  end
end

local TOTAL_ZONE_COUNT = 48

function CityZoneMgr:ShowCityZone()
  if self.req == nil then
    local inSnowSeason = SeasonUtil.IsInSeasonSnowMode()
    local path = "Assets/Main/Prefabs/City/Zone/CityZoneMax.prefab"
    if inSnowSeason then
      path = "Assets/Main/Prefabs/City/Season2/CityZoneMax_swsj.prefab"
    end
    local isZoneMax, newPath = DataCenter.LWCivilizationSparkExtend:CityZoneMgr_getCityZoneMaxData(TOTAL_ZONE_COUNT)
    self.isZoneMax = isZoneMax
    if not isZoneMax then
      path = newPath
    end
    self.req = Resource:InstantiateAsync(path, ObjectPoolTag.City)
    PostEventLog.Track("city_zone_load", {path = path})
    self.req:completed("+", function()
      if self.req.isError then
        return
      end
      PostEventLog.Track("city_zone_load_done", {
        path = path,
        state = tostring(self.req.state)
      })
      self.gameObject = self.req.gameObject
      if IsNull(self.gameObject) then
        PostEventLog.Track("city_zone_load_failed", {
          path = path,
          state = tostring(self.req.state)
        })
      end
      self.transform = self.req.gameObject.transform
      for i = 1, TOTAL_ZONE_COUNT do
        local param = {}
        param.zoneId = i
        param.root = self.transform
        self.zoneDict[i] = DataCenter.LWCivilizationSparkExtend:CityZoneMgr_createCityZone(param)
      end
      self.cityStateEffect = self.transform:Find("cityStateEffect")
      self:ShowBurnEffect(true)
      self:ShowCityGround()
      EventManager:GetInstance():Broadcast(EventId.GF_city_zone_loaded)
    end)
  end
  self:ShowSeasonBuildGround()
  if self.cityZoneFog then
    self.cityZoneFog:ShowFog()
  else
    self.cityZoneFog = CityZoneFog.New()
  end
end

function CityZoneMgr:ShowSeasonBuildGround()
  if not SeasonUtil.IsOpenSeasonBuildInCity() then
    return
  end
  local path = DataCenter.SeasonDataManager:GetGateDefenceData()
  if path and #path == 2 then
    utils.ReSetConfigBySeason(path[1], path[2])
  end
  local prefabPath
  local template = DataCenter.LandLockManager:GetTemplate(SEASON_BUILD_GROUND_ID)
  if template and not string.IsNullOrEmpty(template.unlockModel) then
    prefabPath = string.format(ObjectPrefabPath, template.unlockModel)
  end
  local userInfo = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  if userInfo then
    local loginServerId = LuaEntry.Player:GetSelfServerId()
    local mapIndex = DataCenter.SeasonDataManager:GetNinePalacesIndex(loginServerId)
    local skinCfg = userInfo:GetWorldSkinTemplate(mapIndex)
    if skinCfg and not string.IsNullOrEmpty(skinCfg.season_build_zone) then
      prefabPath = skinCfg.season_build_zone
    end
  end
  if string.IsNullOrEmpty(prefabPath) then
    return
  end
  local data = DataCenter.LandLockManager:GetLandLockDataById(SEASON_BUILD_GROUND_ID)
  if (data == nil or data.state == LandLockState.Finished) and self.seasonBuildingGroundPrefabReq == nil then
    local req = Resource:InstantiateAsync(prefabPath)
    self.seasonBuildingGroundPrefabReq = req
    req:completed("+", function()
      if req.isError then
        req:Destroy()
        return
      end
      local tilePos = data.pos + DataCenter.BuildManager.main_city_pos
      local go = req.gameObject
      if not go then
        return
      end
      local tf = go.transform
      go:SetActive(true)
      go.name = string.format("SeasonGround_%02d", SEASON_BUILD_GROUND_ID)
      tf:SetParent(CS.SceneManager.World.DynamicObjNode)
      tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      tf.position = SceneUtils.TileToWorld(tilePos)
      self.seasonBuildingGroundNormalNode = go.transform:Find("A_build_Jianzaoquyu")
      self.seasonBuildingGroundSnowNode = go.transform:Find("A_build_Jianzaoquyu_xue")
      if self.seasonBuildingEasterEggs then
        self.seasonBuildingEasterEggs:Clear()
        self.seasonBuildingEasterEggs = nil
      end
      self.seasonBuildingEasterEggs = SeasonBuildGroundEasterEggs.New()
      self.seasonBuildingEasterEggs:Init(go)
      self:RefreshSeasonBuildGround()
    end)
  end
end

function CityZoneMgr:RefreshSeasonBuildGround()
  if self.seasonBuildingGroundSnowNode and self.seasonBuildingGroundSnowNode.gameObject and self.seasonBuildingGroundNormalNode and self.seasonBuildingGroundNormalNode.gameObject then
    local seasonType = SeasonUtil.GetSeasonType()
    if seasonType == SeasonMapType.Snow then
      local furnaceState = DataCenter.BuildManager:GetFurnaceStateAndTemp()
      if furnaceState == HeatSourceState.Overload or furnaceState == HeatSourceState.Active then
        self.seasonBuildingGroundSnowNode.gameObject:SetActive(false)
        self.seasonBuildingGroundNormalNode.gameObject:SetActive(true)
      else
        self.seasonBuildingGroundSnowNode.gameObject:SetActive(true)
        self.seasonBuildingGroundNormalNode.gameObject:SetActive(false)
      end
    else
      self.seasonBuildingGroundSnowNode.gameObject:SetActive(false)
      self.seasonBuildingGroundNormalNode.gameObject:SetActive(true)
    end
  end
end

function CityZoneMgr:PersonalFurnaceStateChange()
  self:RefreshSeasonBuildGround()
end

function CityZoneMgr:HideSeasonBuildGround()
  if self.seasonBuildingGroundPrefabReq then
    self.seasonBuildingGroundPrefabReq:Destroy()
    self.seasonBuildingGroundPrefabReq = nil
  end
  if self.seasonBuildingEasterEggs then
    self.seasonBuildingEasterEggs:Clear()
    self.seasonBuildingEasterEggs = nil
  end
  self.seasonBuildingGroundSnowNode = nil
  self.seasonBuildingGroundNormalNode = nil
end

function CityZoneMgr:HideCityZone()
  self:Destroy()
end

function CityZoneMgr:RefreshCityZone()
  local isChange = false
  local unlockLandIdList = DataCenter.LWCivilizationSparkExtend:CityZoneMgr_getUnlockZoneIdList()
  local unlockLandCount = table.count(unlockLandIdList)
  if unlockLandCount > table.count(self.curUnlockLandDataDict) then
    isChange = true
  end
  if isChange then
    self:Destroy()
  end
end

function CityZoneMgr:UnlockZone(id)
  if self.isZoneMax then
    return
  end
  local data = DataCenter.LandLockManager:GetLandLockDataById(id)
  if data == nil or data.state ~= LandLockState.Finished then
    return
  end
  local needRefreshZoneDataList = {}
  for _, zone in ipairs(self.zoneDict) do
    local change = zone:CheckZoneState()
    if change or data.landToZone == zone.zoneId and DataCenter.LWCivilizationSparkExtend:LandLockManager_inV0Interval(id) then
      local param = {}
      param.zoneId = zone.zoneId
      param.pos = zone:GetCityZonePos()
      param.edgeDirectionState = zone.curEdgeDirectionState
      table.insert(needRefreshZoneDataList, param)
      self.curUnlockLandDataDict[param.zoneId] = param
    end
  end
  if table.count(needRefreshZoneDataList) > 0 then
    EventManager:GetInstance():Broadcast(EventId.UpdateShowCityZoneGround, needRefreshZoneDataList)
  end
end

function CityZoneMgr:GetCityZone(zoneId)
  if self.zoneDict then
    return self.zoneDict[zoneId]
  end
end

function CityZoneMgr:RefreshMonopolyLandBaseFog()
  if self.cityZoneFog then
    self.cityZoneFog:UnLockLandBase()
  end
end

function CityZoneMgr:ShowCityGround()
  self.curUnlockLandDataDict = {}
  local inSnowSeason = SeasonUtil.IsInSeasonSnowMode()
  local zoneIdList = DataCenter.LWCivilizationSparkExtend:CityZoneMgr_getUnlockZoneIdList()
  for i, v in ipairs(zoneIdList) do
    local zone = self.zoneDict[v]
    if zone then
      local param = {}
      param.zoneId = zone.zoneId
      param.pos = zone:GetCityZonePos()
      param.edgeDirectionState = zone.curEdgeDirectionState
      self.curUnlockLandDataDict[param.zoneId] = param
    end
  end
  local groundParam = {}
  groundParam.parent = self.transform
  groundParam.landLockDataDict = self.curUnlockLandDataDict
  EventManager:GetInstance():Broadcast(EventId.InitShowCityZoneGround, groundParam)
end

function CityZoneMgr:GetDebugManager()
  if self.debugMgr == nil and self.gameObject then
    self.debugMgr = self.gameObject:AddComponent(typeof(CS.CityZoneDebugManager))
  end
  return self.debugMgr
end

function CityZoneMgr:ShowTileGrid(ShowTile)
  local debugMgr = self:GetDebugManager()
  if debugMgr then
    debugMgr.ShowTile = ShowTile
  end
end

function CityZoneMgr:DebugRefreshCityZone(index)
  local cityZoneOrder = {
    2,
    5,
    1,
    4,
    7,
    8,
    9,
    6,
    3
  }
  local fenceDisplayCtrl = require("DataCenter.XiaoFanManager.FenceDisplayCtrl")
  fenceDisplayCtrl.HideTheBadOne()
  if self.zoneDict then
    for i, v in ipairs(self.zoneDict) do
      v:Destroy()
    end
    self.zoneDict = {}
  end
  if index == 1 then
    fenceDisplayCtrl.ShowTheBadOne()
  else
    DataCenter.CityZoneMgr.gameObject:SetActive(true)
    local debugUnlockZoneIdDict = {}
    for i = 1, index do
      if cityZoneOrder[i] then
        debugUnlockZoneIdDict[cityZoneOrder[i]] = true
      else
        debugUnlockZoneIdDict[i] = true
      end
    end
    for i = 1, TOTAL_ZONE_COUNT do
      local param = {}
      param.zoneId = i
      param.root = self.transform
      param.debugUnlockZoneIdDict = debugUnlockZoneIdDict
      self.zoneDict[i] = DataCenter.LWCivilizationSparkExtend:CityZoneMgr_createCityZone(param)
    end
  end
end

return CityZoneMgr
