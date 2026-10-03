local AllianceCityTipManager = BaseClass("AllianceCityTipManager")
local AllianceCityTip = require("DataCenter.AllianceCityTip.AllianceCityTip")
local ResourceManager = CS.GameEntry.Resource
local Fire_Prefab = {
  "Assets/Main/Prefabs/World/Eff_dafuw_fire_da.prefab",
  "Assets/Main/Prefabs/World/Eff_dafuw_fire_fanwei.prefab",
  "Assets/Main/Prefabs/World/Eff_dafuw_fire_zhong.prefab",
  "Assets/Main/Prefabs/World/Eff_daditu_zhucheng_fire.prefab"
}

local function __init(self)
  self.lodCache = 1
  self.bloodyNightFireEffect = nil
  self.protectTimeDict = {}
  self.lordDict = {}
  self.tipDict = {}
  self.notShowTipFlag = {}
  self.fireReqs = {}
  self.gunnerAtkObj = {}
  self.gunnerAtkReq = {}
  self.zoneInView = {}
  self:AddListeners()
end

local function __delete(self)
  if self.bloodyNightFireEffect then
    self.bloodyNightFireEffect:Delete()
    self.bloodyNightFireEffect = nil
  end
  if self.fireReqs then
    for _, v in pairs(self.fireReqs) do
      for _, req in pairs(v) do
        req:Destroy()
      end
    end
  end
  self.zoneInView = {}
  self.fireReqs = {}
  if self.tipDict ~= nil then
    for _, t in pairs(self.tipDict) do
      if t.tip ~= nil then
        t.tip:OnDestroy()
      end
      if t.req ~= nil then
        t.req:Destroy()
      end
    end
    self.tipDict = nil
  end
  if self.lordDict ~= nil then
    for _, node in pairs(self.lordDict) do
      if node and type(node.Delete) == "function" then
        pcall(node.Delete, node)
      end
    end
    self.lordDict = nil
  end
  self.notShowTipFlag = nil
  for i, v in ipairs(self.gunnerAtkReq) do
    v:Destroy()
  end
  self.gunnerAtkReq = nil
  self.gunnerAtkObj = nil
  self:RemoveListeners()
end

local function Startup(self)
end

local function RemoveAllAllianceCityTip(self)
  if self.tipDict ~= nil then
    for _, t in pairs(self.tipDict) do
      if t.tip ~= nil then
        t.tip:OnDestroy()
      end
      if t.req ~= nil then
        t.req:Destroy()
      end
    end
    self.tipDict = {}
  end
  if self.lordDict ~= nil then
    for _, node in pairs(self.lordDict) do
      if node and type(node.Delete) == "function" then
        pcall(node.Delete, node)
      end
    end
    self.lordDict = {}
  end
  if self.bloodyNightFireEffect then
    self.bloodyNightFireEffect:Delete()
    self.bloodyNightFireEffect = nil
  end
  self.zoneInView = {}
  self.protectTimeDict = {}
end

local function AddListeners(self)
  EventManager:GetInstance():AddListener(EventId.ActNuclearScoreUpdate, self.OnNuclearScoreUpdate)
  EventManager:GetInstance():AddListener(EventId.CityDomeShow, self.OnPointDateUpdate)
  EventManager:GetInstance():AddListener(EventId.UPDATE_CITY_POINTS_DATA, self.OnPointDateUpdate)
  EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
  EventManager:GetInstance():AddListener(EventId.AllianceCityInView, self.AllianceCityInViewSignal)
  EventManager:GetInstance():AddListener(EventId.AllianceCityOutView, self.AllianceCityOutViewSignal)
  EventManager:GetInstance():AddListener(EventId.WorldCityOwnerInfoChanged, self.AllianceCityNameChange)
  EventManager:GetInstance():AddListener(EventId.OnActBossDataRefresh, self.ShowActBossIconShow)
  EventManager:GetInstance():AddListener(EventId.DeclareWar, self.AllianceCityRefreshDeclare)
  EventManager:GetInstance():AddListener(EventId.KingOccupyProgressRefresh, self.OnKingOccupyProgressRefresh)
  EventManager:GetInstance():AddListener(EventId.GovernmentPresidentRefresh, self.OnGovernmentPresidentRefresh)
  EventManager:GetInstance():AddListener(EventId.WorldAllianceCityDetail, self.OnWorldAllianceCityDetail)
  EventManager:GetInstance():AddListener(EventId.StrongholdBattleStateUpdate, self.OnStrongholdBattleStateUpdate)
  EventManager:GetInstance():AddListener(EventId.UpdateAllServerTradeInfo, self.OnTradePointDateUpdate)
  EventManager:GetInstance():AddListener(EventId.CityGhostCreateFinish, self.OnCityGhostUpdate)
  EventManager:GetInstance():AddListener(EventId.CityGhostHideFinish, self.OnCityGhostUpdate)
  EventManager:GetInstance():AddListener(EventId.BloodyNightActivityRefresh, self.OnBloodyNightUpdate)
  EventManager:GetInstance():AddListener(EventId.CityBattleS1RestUpdateFirstInfo, self.OnCityBattleS1RestUpdateFirstInfo)
  EventManager:GetInstance():AddListener(EventId.ShowCityGuideNode, self.ShowCityGuideNode)
  EventManager:GetInstance():AddListener(EventId.PushAllianceFriendsHelp, self.OnAllianceFriendsHelp)
  EventManager:GetInstance():AddListener(EventId.LandlordCenterStateChange, self.OnLandlordCenterStateChange)
end

local function RemoveListeners(self)
  EventManager:GetInstance():RemoveListener(EventId.ActNuclearScoreUpdate, self.OnNuclearScoreUpdate)
  EventManager:GetInstance():RemoveListener(EventId.CityDomeShow, self.OnPointDateUpdate)
  EventManager:GetInstance():RemoveListener(EventId.UPDATE_CITY_POINTS_DATA, self.OnPointDateUpdate)
  EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
  EventManager:GetInstance():RemoveListener(EventId.AllianceCityInView, self.AllianceCityInViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.AllianceCityOutView, self.AllianceCityOutViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.WorldCityOwnerInfoChanged, self.AllianceCityNameChange)
  EventManager:GetInstance():RemoveListener(EventId.OnActBossDataRefresh, self.ShowActBossIconShow)
  EventManager:GetInstance():RemoveListener(EventId.DeclareWar, self.AllianceCityRefreshDeclare)
  EventManager:GetInstance():RemoveListener(EventId.KingOccupyProgressRefresh, self.OnKingOccupyProgressRefresh)
  EventManager:GetInstance():RemoveListener(EventId.GovernmentPresidentRefresh, self.OnGovernmentPresidentRefresh)
  EventManager:GetInstance():RemoveListener(EventId.WorldAllianceCityDetail, self.OnWorldAllianceCityDetail)
  EventManager:GetInstance():RemoveListener(EventId.StrongholdBattleStateUpdate, self.OnStrongholdBattleStateUpdate)
  EventManager:GetInstance():RemoveListener(EventId.UpdateAllServerTradeInfo, self.OnTradePointDateUpdate)
  EventManager:GetInstance():RemoveListener(EventId.CityGhostCreateFinish, self.OnCityGhostUpdate)
  EventManager:GetInstance():RemoveListener(EventId.CityGhostHideFinish, self.OnCityGhostUpdate)
  EventManager:GetInstance():RemoveListener(EventId.BloodyNightActivityRefresh, self.OnBloodyNightUpdate)
  EventManager:GetInstance():RemoveListener(EventId.CityBattleS1RestUpdateFirstInfo, self.OnCityBattleS1RestUpdateFirstInfo)
  EventManager:GetInstance():RemoveListener(EventId.ShowCityGuideNode, self.ShowCityGuideNode)
  EventManager:GetInstance():RemoveListener(EventId.PushAllianceFriendsHelp, self.OnAllianceFriendsHelp)
  EventManager:GetInstance():RemoveListener(EventId.LandlordCenterStateChange, self.OnLandlordCenterStateChange)
end

function AllianceCityTipManager.OnAllianceFriendsHelp(data)
  if data then
    local cityId = toInt(data.cityId)
    local tipDict = DataCenter.AllianceCityTipManager.tipDict
    if tipDict ~= nil then
      local theCityTip = tipDict[cityId]
      if theCityTip ~= nil and theCityTip.tip ~= nil then
        theCityTip.tip:ShowAllianceFriendsHelpTips(data)
      end
    end
  end
end

function AllianceCityTipManager.OnCityGhostUpdate(cityId)
  local tipDict = DataCenter.AllianceCityTipManager.tipDict
  if tipDict ~= nil then
    local theCityTip = tipDict[toInt(cityId)]
    if theCityTip ~= nil and theCityTip.tip ~= nil then
      theCityTip.tip:TryUpdatePosition()
    end
  end
end

function AllianceCityTipManager.OnNuclearScoreUpdate()
  if SeasonUtil.GetSeasonType() == SeasonMapType.Snow and SceneUtils.GetIsInWorld() then
    local theWorld = CS.SceneManager.World
    if theWorld == nil then
      return
    end
    local pointInfo = theWorld:GetPointInfo(THRONE_POINT_ID)
    if pointInfo == nil then
      return
    end
    local obj = theWorld:GetObjectByPoint(THRONE_POINT_ID)
    if obj == nil then
      return
    end
    local gameObject = obj:GetGameObject()
    if gameObject == nil then
      return
    end
    local eff_path = "Model/S2saiji_hefanyin/hefanyin/Eff_build_s_hefanyin"
    local effectRoot = gameObject.transform:Find(eff_path)
    if effectRoot ~= nil then
      local serverId = LuaEntry.Player:GetCurServerId()
      local data = SeasonUtil.GetSeasonInfo(serverId)
      if data and data:InHaltMode() then
        effectRoot.gameObject:SetActive(true)
      elseif data and data:ServerInReady() and data:InNormalMode() and DataCenter.SeasonNuclearPowerPlantDataManager:BuildNuclearPowerBtnOpen() then
        local max = DataCenter.SeasonNuclearPowerPlantDataManager:GetScoreMax()
        local actNuclearScore = DataCenter.WorldAllianceCityDataManager:GetThroneNuclearScore(serverId)
        effectRoot.gameObject:SetActive(max <= actNuclearScore and LuaEntry.Player:AtHomeNow())
      else
        effectRoot.gameObject:SetActive(false)
      end
    end
  end
end

function AllianceCityTipManager:OnStrongholdBattleStateUpdate()
  local tipDict = DataCenter.AllianceCityTipManager.tipDict
  if tipDict then
    for k, v in pairs(tipDict) do
      if v.tip ~= nil then
        v.tip:OnStrongholdBattleStateUpdate()
      end
    end
  end
end

function AllianceCityTipManager.ShowCityGuideNode(cityId)
  local tipDict = DataCenter.AllianceCityTipManager.tipDict
  if tipDict ~= nil then
    for k, v in pairs(tipDict) do
      if v ~= nil and v.meta ~= nil and v.meta.id == cityId then
        if v.tip ~= nil then
          v.tip:ShowCityGuideNode()
        else
        end
        return
      end
    end
  end
end

function AllianceCityTipManager.OnPointDateUpdate(pointIndex)
  ProfilerUtil.BeginSample("AllianceCityTipManager.OnPointDateUpdate")
  local tipDict = DataCenter.AllianceCityTipManager.tipDict
  if tipDict then
    for k, v in pairs(tipDict) do
      if v.tip ~= nil then
        if pointIndex == nil then
          v.tip:OnPointDateUpdate()
        elseif v.tip.pointId == pointIndex then
          v.tip:OnPointDateUpdate()
        end
      end
    end
  end
  if pointIndex == THRONE_POINT_ID and SeasonUtil.GetSeasonType() == SeasonMapType.Snow then
    DataCenter.AllianceCityTipManager:OnNuclearScoreUpdate()
  end
  ProfilerUtil.EndSample()
end

function AllianceCityTipManager.OnTradePointDateUpdate()
  local pThis = DataCenter.AllianceCityTipManager
  if pThis then
    local tipDict = pThis.tipDict
    if tipDict then
      for k, v in pairs(tipDict) do
        if v.tip ~= nil and v.tip.data ~= nil and v.tip.data:IsTradingStation() then
          v.tip:OnPointDateUpdate()
        end
      end
    end
    if pThis.lodCache then
      pThis:UpdateTipLod(pThis.lodCache, true)
    end
  end
end

function AllianceCityTipManager:OnWorldAllianceCityDetail()
  local tipDict = DataCenter.AllianceCityTipManager.tipDict
  if tipDict ~= nil then
    for k, v in pairs(tipDict) do
      if v.tip ~= nil then
        v.tip:OnWorldAllianceCityDetail()
      end
    end
  end
end

function AllianceCityTipManager:OnGovernmentPresidentRefresh()
  DataCenter.AllianceCityTipManager:OnKingOccupyProgressRefresh()
  DataCenter.AllianceCityTipManager:AllianceCityNameChange()
end

function AllianceCityTipManager:OnKingOccupyProgressRefresh()
  local tipDict = DataCenter.AllianceCityTipManager.tipDict
  if tipDict ~= nil then
    for k, v in pairs(tipDict) do
      if v ~= nil and v.meta ~= nil and v.tip ~= nil and v.type == WorldAllianceCityType.King then
        v.tip:OnKingOccupyProgressRefresh()
      end
    end
  end
end

local function ChangeCameraLodSignal(lod)
  DataCenter.AllianceCityTipManager:UpdateLod(lod)
end

local function ShowActBossIconShow(data)
  DataCenter.AllianceCityTipManager:CheckAllianceCityTipsShowBoss()
end

local function CheckAllianceCityTipsShowBoss(self)
  for k, v in pairs(self.tipDict) do
    if v.tip ~= nil then
      v.tip:CheckBossData()
    end
  end
end

function AllianceCityTipManager:TryAddTradeStationLord(cityId)
  if BattleFieldUtil.InBattleField() then
    return
  end
  if self.lodCache ~= 8 or self.lordDict == nil or self.lordDict[cityId] ~= nil then
    return
  end
  local curServerId = LuaEntry.Player:GetCurServerId()
  local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, curServerId)
  if meta == nil then
    return
  end
  local serverId = meta:GetCurServerId(curServerId)
  local tradeInfo = DataCenter.SeasonTradeDataManager:GetServerTradeStationData(cityId, serverId)
  if tradeInfo == nil then
    return
  end
  local theWorld = CS.SceneManager.World
  local pointLord = tradeInfo.occupyInfoUserInfo
  if tradeInfo == nil or pointLord == nil then
    return
  end
  local TradeStationLordHead = require("DataCenter.AllianceCityTip.Season.TradeStation.ActivityTradeStationLordHead")
  local prefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/AllianceCityTip/TradeStationLordPopup.prefab"
  local lordInfoRoot = TradeStationLordHead.New(nil, theWorld.DynamicObjNode, prefabPath)
  if lordInfoRoot ~= nil then
    self.lordDict[cityId] = lordInfoRoot
    lordInfoRoot:ReInit(pointLord, cityId, serverId)
    lordInfoRoot:SetWorldPos(meta:GetWorldPos())
    lordInfoRoot:SetLod(self.lodCache)
  end
end

local function UpdateTipLod(self, _lod, updateData)
  if BattleFieldUtil.InBattleField() then
    return
  end
  local lod = toInt(_lod)
  for k, v in pairs(self.tipDict) do
    if v.tip ~= nil then
      v.tip:CheckLod(lod)
    end
  end
  if lod < 7 and self.zoneInView ~= nil then
    for cityId, shown in pairs(self.zoneInView) do
      if shown and self.tipDict[cityId] == nil and self.notShowTipFlag[cityId] == nil then
        self:CreateTip(cityId)
      end
    end
  end
  if lod == 8 then
    if self.lordDict == nil then
      self.lordDict = {}
    end
    if self.zoneInView ~= nil then
      for cityId, shown in pairs(self.zoneInView) do
        if shown and self.lordDict[cityId] == nil then
          self:TryAddTradeStationLord(cityId)
        end
      end
    end
  end
  if self.lordDict ~= nil then
    for _, node in pairs(self.lordDict) do
      if node and type(node.CheckLod) == "function" then
        pcall(node.CheckLod, node, lod)
      end
      if lod == 8 and updateData and node and type(node.DataRefresh) == "function" then
        pcall(node.DataRefresh, node)
      end
    end
  end
end

local function UpdateLod(self, lod)
  if self.lodCache ~= lod then
    if self.lodCache == 8 then
      self.lodCache = lod
      for cityId, shown in pairs(self.zoneInView) do
        self:ShowTip(cityId, shown)
      end
    end
    self.lodCache = lod
    if 7 <= lod then
      self:SendRequest()
    end
    self:UpdateTipLod(lod, false)
  end
  if self.bloodyNightFireEffect then
    self.bloodyNightFireEffect:UpdateLod(lod)
  end
end

local function SendRequest(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.WorldBoss.Type)
  if 0 < #dataList then
    local data = dataList[1]
    if curTime >= data.startTime and curTime <= data.endTime then
      SFSNetwork.SendMessage(MsgDefines.UserGetActBossMarch)
    end
  end
end

local function AllianceCityNameChange(data)
  DataCenter.AllianceCityTipManager:RefreshAllianceCityName()
end

local function RefreshAllianceCityName(self)
  for k, v in pairs(self.tipDict) do
    if v.tip ~= nil then
      v.tip:SetName(k)
      v.tip:SetAllianceColor(k)
    end
  end
end

local function SetCanShowFlag(self, id, canShow)
  if canShow then
    if self.notShowTipFlag[id] ~= nil then
      self.notShowTipFlag[id] = nil
      DataCenter.AllianceCityTipManager:ShowTip(id, true)
    end
  elseif self.notShowTipFlag[id] == nil then
    self.notShowTipFlag[id] = true
    DataCenter.AllianceCityTipManager:ShowTip(id, false)
  end
end

local function AllianceCityInViewSignal(id)
  local curServerId = LuaEntry.Player:GetCurServerId()
  local pThis = DataCenter.AllianceCityTipManager
  if SeasonUtil.IsKingCity(id, curServerId) then
    local seasonInfo = SeasonUtil.GetSeasonInfo(curServerId)
    local template = DataCenter.AllianceCityTemplateManager:GetTemplate(id, curServerId)
    local serverId = template:GetCurServerId()
    local seasonType = SeasonMapType.Nothing
    local seasonMode = 0
    if seasonInfo ~= nil then
      seasonMode = seasonInfo.mode
      seasonType = seasonInfo:GetServerType(false)
    end
    local batteryList = DataCenter.AllianceCityTemplateManager:GetThroneCityBatteryList(serverId)
    if seasonType == SeasonMapType.Darkness then
      if seasonMode == 1 then
        for _, v in ipairs(batteryList) do
          if v ~= nil and v.type == WorldAllianceCityType.Canon and v.size == 9 then
            pThis:ShowTip(v.id, true, v)
          end
        end
      else
        for _, v in ipairs(batteryList) do
          if v ~= nil and v.type == WorldAllianceCityType.Canon and v.size == 3 then
            pThis:ShowTip(v.id, true, v)
          end
        end
      end
    else
      for _, v in ipairs(batteryList) do
        if v ~= nil and v.type == WorldAllianceCityType.Canon then
          pThis:ShowTip(v.id, true, v)
        end
      end
    end
    local missileList = DataCenter.AllianceCityTemplateManager:GetMissileFactoryList(serverId)
    for _, v in ipairs(missileList) do
      if v ~= nil and v.type == WorldAllianceCityType.MissileFactory then
        pThis:ShowTip(v.id, true, v)
      end
    end
    if seasonMode == 1 and seasonType == SeasonMapType.Snow and DataCenter.SeasonNuclearPowerPlantDataManager:BuildNuclearPowerBtnOpen() then
      SFSNetwork.SendMessage(MsgDefines.NuclearServerScoreView, serverId)
    end
  end
  pThis.zoneInView[id] = true
  pThis:ShowTip(id, true)
  AllianceCityTipManager.OnBloodyNightUpdate()
end

function AllianceCityTipManager.OnBloodyNightUpdate()
  local pThis = DataCenter.AllianceCityTipManager
  if pThis.isInSeason == nil or pThis.seasonType == nil then
    pThis.isInSeason = SeasonUtil.IsInSeason(true)
    pThis.seasonType = SeasonUtil.GetSeasonType()
  end
  if pThis.bloodyNightFireEffect == nil and pThis.isInSeason and pThis.seasonType == SeasonMapType.Darkness and SceneUtils.GetIsInWorld() then
    local isBloodyNight = DataCenter.BloodyNightDataManager:IsBloodyNight()
    if isBloodyNight then
      local theWorld = CS.SceneManager.World
      if theWorld and theWorld.DynamicObjNode then
        local theAsyncNode = require("UI.LWSeason4.Component.BloodyNightFireEffect")
        local effectPath = "Assets/Main/SeasonRes/S4/Prefabs/Effect/BloodyNight/Eff_ljw_s4_xueye_scene_loop.prefab"
        pThis.bloodyNightFireEffect = theAsyncNode.New("bloodyNightFire", theWorld.DynamicObjNode.transform, effectPath)
      end
    end
  end
end

local function AllianceCityOutViewSignal(id)
  local pThis = DataCenter.AllianceCityTipManager
  local curServerId = LuaEntry.Player:GetCurServerId()
  if SeasonUtil.IsKingCity(id, curServerId) then
    local template = DataCenter.AllianceCityTemplateManager:GetTemplate(id, curServerId)
    local serverId = template:GetCurServerId()
    local batteryList = DataCenter.AllianceCityTemplateManager:GetThroneCityBatteryList(serverId)
    for _, v in ipairs(batteryList) do
      if v ~= nil and v.type == WorldAllianceCityType.Canon then
        DataCenter.AllianceCityTipManager:ShowTip(v.id, false, v)
      end
    end
    local missileList = DataCenter.AllianceCityTemplateManager:GetMissileFactoryList(serverId)
    for _, v in ipairs(missileList) do
      if v ~= nil and v.type == WorldAllianceCityType.MissileFactory then
        DataCenter.AllianceCityTipManager:ShowTip(v.id, false, v)
      end
    end
  end
  pThis.zoneInView[id] = false
  DataCenter.AllianceCityTipManager:ShowTip(id, false)
end

local function AllianceCityRefreshDeclare()
  DataCenter.AllianceCityTipManager:RefreshDeclare()
end

local function RefreshDeclare(self)
  for k, v in pairs(self.tipDict) do
    if v.tip ~= nil then
      v.tip:CheckCityDeclare()
    end
  end
end

local function ShowTip(self, id, show, data)
  if show and self.tipDict[id] == nil and self.notShowTipFlag[id] == nil then
    self:CreateTip(id, data)
  elseif not show and self.tipDict[id] ~= nil then
    self:DestroyTip(id)
  end
  if self.lordDict then
    if show then
      if self.lodCache == 8 and not BattleFieldUtil.InBattleField() then
        local serverId = LuaEntry.Player:GetCurServerId()
        local check_data = DataCenter.AllianceCityTemplateManager:GetTemplate(id, serverId)
        if check_data ~= nil and check_data.type == WorldAllianceCityType.TradingStation then
          self:TryAddTradeStationLord(id)
        end
      end
    else
      local node = self.lordDict[id]
      if node ~= nil then
        if node and type(node.Delete) == "function" then
          pcall(node.Delete, node)
        end
        self.lordDict[id] = nil
      end
    end
  end
end

local function CreateTip(self, id, data)
  if BattleFieldUtil.InBattleField() then
    return
  end
  local serverId = LuaEntry.Player:GetCurServerId()
  if DataCenter.LandlordMgr:IsInNewCenterMapPeriod() and DataCenter.LandlordMgr:GetCityTemplate(id) then
    serverId = DataCenter.LandlordMgr:GetCenterServerId()
  end
  local check_data = DataCenter.AllianceCityTemplateManager:GetTemplate(id, serverId)
  if check_data == nil or check_data.type == nil then
    return
  end
  serverId = check_data:GetCurServerId(serverId)
  if SeasonUtil.GetWorldCityTableNameByServerId(serverId) == DataCenter.LandlordMgr:GetCityTemplateTableName() and not LocalController:instance():hasLine(DataCenter.LandlordMgr:GetCityTemplateTableName(), tostring(id)) then
    return
  end
  local curServerId = LuaEntry.Player:GetCurServerId()
  local curSeasonInfo = SeasonUtil.GetSeasonInfo(curServerId)
  if curSeasonInfo and curSeasonInfo.isSingleServerMode and serverId ~= curServerId and curSeasonInfo:GetServerType(false) == SeasonMapType.NineNation then
    return
  end
  local city_type = check_data.type
  if city_type == WorldAllianceCityType.CrossZoneOutpost and SeasonUtil.IsInSameGroup(serverId, ServerEnum.Source) then
    local seasonType = SeasonUtil.GetSeasonType(false, true, ServerEnum.View)
    if seasonType == SeasonMapType.NineNationRainforest then
      local putByServerId = DataCenter.SeasonOutpostManager:GetPutInfoByCityId(id)
      if putByServerId == nil or putByServerId == 0 then
        return
      end
    end
  end
  local isBattle = SeasonUtil.CityIsInBattle(serverId, id)
  if not isBattle and self.lodCache ~= nil then
    if self.lodCache > 6 and city_type == WorldAllianceCityType.Stronghold then
      return
    end
    if self.lodCache > 7 and city_type ~= WorldAllianceCityType.King and city_type ~= WorldAllianceCityType.CrossZoneOutpost and city_type ~= WorldAllianceCityType.LLNormalCity and city_type ~= WorldAllianceCityType.LLThroneCity then
      return
    end
  end
  local request = ResourceManager:InstantiateAsync(UIAssets.AllianceCityTip)
  request:completed("+", function()
    local pThis = DataCenter.AllianceCityTipManager
    if request.isError then
      if pThis.tipDict then
        pThis.tipDict[id] = nil
      end
      return
    end
    if pThis.lodCache and pThis.lodCache > 6 and city_type == WorldAllianceCityType.Stronghold then
      request:Destroy()
      if pThis.tipDict then
        pThis.tipDict[id] = nil
      end
      return
    end
    if BattleFieldUtil.InBattleField() or CS.SceneManager.World == nil or not SceneUtils.GetIsInWorld() then
      request:Destroy()
      if pThis.tipDict then
        pThis.tipDict[id] = nil
      end
      return
    end
    local template = check_data
    if template then
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      if template.type == WorldAllianceCityType.Stronghold then
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      else
        go.transform:Set_localScale(ResetScale.x * 0.75, ResetScale.y * 0.75, ResetScale.z * 0.75)
      end
      if CS.CommonUtils.IsDebug() and CS.UnityEngine.Application.isEditor then
        go.name = "AllianceCityTip_" .. id
      end
      local autoFace = go:GetComponent(typeof(CS.AutoFaceToCamera))
      local adjustScales = go:GetComponent(typeof(CS.AutoAdjustScale))
      local adjustLod = go:GetComponent(typeof(CS.AutoAdjustLod))
      if not IsNull(autoFace) then
        autoFace.enabled = true
      end
      if not IsNull(adjustScales) then
        adjustScales.enabled = true
      end
      if not IsNull(adjustLod) then
        adjustLod.enabled = true
      end
      local tip = AllianceCityTip.New()
      tip:OnCreate(request)
      tip:SetLod(self.lodCache)
      tip:SetData(template, self.lodCache)
      self.tipDict[id] = {
        tip = tip,
        req = request,
        meta = template,
        type = city_type
      }
    end
  end)
  self.tipDict[id] = {
    tip = nil,
    req = request,
    meta = check_data,
    type = city_type
  }
end

local function DestroyTip(self, id)
  local t = self.tipDict[id]
  if t ~= nil then
    if t.tip ~= nil then
      t.tip:OnDestroy()
    end
    if t.req ~= nil then
      t.req:Destroy()
    end
  end
  self.tipDict[id] = nil
end

function AllianceCityTipManager:AllianceCityRefreshFire(cityId, transform)
  local template = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, LuaEntry.Player:GetCurServerId())
  if not template then
    return
  end
  local info = template:GetPointInfo()
  if not info then
    return
  end
  local allianceCityPointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.AllianceCityPointInfo")
  if allianceCityPointInfo == nil then
    return
  end
  if template:IsThroneCity() then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    local timeOpen = allianceCityPointInfo.openTime
    local timeEnd = allianceCityPointInfo.protectTime
    if curTime < timeOpen or curTime >= timeEnd then
      return
    end
  end
  local maxDurability = template.wall
  local durability = allianceCityPointInfo.durability
  local lastDurabilityTime = allianceCityPointInfo.lastDurabilityTime or 0
  local cityRecoverSpeed = template.wall_recover or 0
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local addNum = (curTime - lastDurabilityTime) * tonumber(cityRecoverSpeed)
  local realDurabilityNum = durability + math.max(addNum, 0)
  local curDurability = math.min(realDurabilityNum, maxDurability)
  local fireNum, maxRadius = DataCenter.WorldAllianceCityDataManager:GetFireNumByBlood(curDurability, maxDurability)
  if not self.fireReqs[cityId] then
    self.fireReqs[cityId] = {}
  end
  if #self.fireReqs[cityId] == fireNum then
    return
  end
  local parent = transform:Find("Model")
  if IsNull(parent) then
    return
  end
  if fireNum > #self.fireReqs[cityId] then
    for i = #self.fireReqs[cityId] + 1, fireNum do
      local path = Fire_Prefab[math.random(4)]
      self.fireReqs[cityId][i] = ResourceManager:InstantiateAsync(path)
      self.fireReqs[cityId][i]:completed("+", function(req)
        local go = req.gameObject
        if IsNull(go) then
          return
        end
        go:SetActive(true)
        local trans = go.transform
        trans:SetParent(parent)
        trans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local x = maxRadius * math.random() - maxRadius * 0.5
        local y = maxRadius * math.random() - maxRadius * 0.5
        local newX = 0.7 * x - 0.7 * y
        local newY = 0.7 * x + 0.7 * y
        trans:Set_localPosition(newX, newY, newY)
      end)
    end
  elseif fireNum < #self.fireReqs[cityId] then
    for i = #self.fireReqs[cityId], fireNum + 1, -1 do
      self.fireReqs[cityId][i]:Destroy()
      table.remove(self.fireReqs[cityId], i)
    end
  end
end

function AllianceCityTipManager:AllianceCityRemoveFire(cityId)
  if self.fireReqs[cityId] then
    for _, v in pairs(self.fireReqs[cityId]) do
      v:Destroy()
    end
    self.fireReqs[cityId] = {}
  end
end

function AllianceCityTipManager:ShowBloodQueenGunnerAttackEffect(cityId, transform)
  if self.gunnerAtkObj[cityId] == nil then
    if self.gunnerAtkReq[cityId] == nil then
      local path = "Assets/_Art_LastWar/Effect/Prefab/Common/D_lanpao_hit_big.prefab"
      local parent = transform:Find("Model")
      if IsNull(parent) then
        return
      end
      local request = ResourceManager:InstantiateAsync(path)
      request:completed("+", function(req)
        local go = req.gameObject
        if IsNull(go) then
          return
        end
        local trans = go.transform
        trans:SetParent(parent)
        local scale = 3.3
        trans:Set_localScale(scale, scale, scale)
        trans:Set_localPosition(0, 0, 0)
        self.gunnerAtkObj[cityId] = go
      end)
      self.gunnerAtkReq[cityId] = request
    end
  else
    self.gunnerAtkObj[cityId]:SetActive(false)
    self.gunnerAtkObj[cityId]:SetActive(true)
  end
end

function AllianceCityTipManager:RemoveBloodQueenGunnerAttackEffect(cityId)
  if self.gunnerAtkReq[cityId] then
    self.gunnerAtkReq[cityId]:Destroy()
    self.gunnerAtkReq[cityId] = nil
  end
  if self.gunnerAtkObj[cityId] then
    self.gunnerAtkObj[cityId] = nil
  end
end

function AllianceCityTipManager:ShowBloodQueenButcherExplodeTip(totalDamage, pointId)
  local pointInfo = CS.SceneManager.World:GetPointInfo(pointId)
  if pointInfo == nil then
    return
  end
  local cityId = pointInfo.cityId or pointInfo.CityId
  if cityId == nil then
    return
  end
  if self.tipDict and self.tipDict[cityId] then
    local tip = self.tipDict[cityId].tip
    if tip then
      tip:ShowBloodQueenButcherExplodeTip(totalDamage)
    end
  end
end

function AllianceCityTipManager:ShowBloodQueenHpChangeTip(totalDamage, cityId)
  if self.tipDict and self.tipDict[cityId] then
    local tip = self.tipDict[cityId].tip
    if tip then
      tip:ShowBloodQueenHpChangeTip(totalDamage)
    end
  end
end

function AllianceCityTipManager:UpdateProtectedTime(serverId, protectDict)
  local data = self.protectTimeDict[serverId]
  if data == nil then
    data = protectDict
    self.protectTimeDict[serverId] = data
  else
    for k, v in pairs(protectDict) do
      data[k] = v
    end
  end
  for k, v in pairs(self.tipDict) do
    if v.tip ~= nil and v.tip.cityId ~= nil then
      local openTime = data[v.tip.cityId]
      if openTime then
        v.tip:UpdateProtectedTime(openTime)
      end
    end
  end
end

function AllianceCityTipManager:SetProtectedTime(serverId, cityId, protectTime)
  local protectDict = self.protectTimeDict[serverId]
  if protectDict then
    protectDict[cityId] = protectTime
  else
    local data = {}
    data[cityId] = protectTime
    self.protectTimeDict[serverId] = data
  end
end

function AllianceCityTipManager:GetProtectedTime(serverId, cityId)
  local protectDict = self.protectTimeDict[serverId]
  if protectDict then
    return protectDict[cityId] or 0
  end
  return 0
end

function AllianceCityTipManager:OnCityBattleS1RestUpdateFirstInfo()
  local tipDict = DataCenter.AllianceCityTipManager.tipDict
  if tipDict then
    for k, v in pairs(tipDict) do
      if v.tip ~= nil and v.tip.data and v.tip.data:IsCity() then
        v.tip:OnPointDateUpdate()
      end
    end
  end
end

function AllianceCityTipManager:OnCitySkinColorSettingChanged()
  local tipDict = DataCenter.AllianceCityTipManager.tipDict
  if tipDict then
    for k, v in pairs(tipDict) do
      if v.tip ~= nil then
        v.tip:OnCitySkinColorSettingChanged()
      end
    end
  end
end

function AllianceCityTipManager:OnLandlordCenterStateChange()
  DataCenter.AllianceCityTipManager:RemoveAllAllianceCityTip()
end

function AllianceCityTipManager:FindCityTipByLodCollider(lodColliderObj)
  for cityId, v in pairs(self.tipDict) do
    local view = v
    if view and view.tip and view.tip.lodIconCollider and view.tip.lodIconCollider.gameObject == lodColliderObj then
      return cityId
    end
  end
end

AllianceCityTipManager.__init = __init
AllianceCityTipManager.__delete = __delete
AllianceCityTipManager.Startup = Startup
AllianceCityTipManager.RemoveAllAllianceCityTip = RemoveAllAllianceCityTip
AllianceCityTipManager.AddListeners = AddListeners
AllianceCityTipManager.RemoveListeners = RemoveListeners
AllianceCityTipManager.ChangeCameraLodSignal = ChangeCameraLodSignal
AllianceCityTipManager.AllianceCityInViewSignal = AllianceCityInViewSignal
AllianceCityTipManager.AllianceCityOutViewSignal = AllianceCityOutViewSignal
AllianceCityTipManager.ShowTip = ShowTip
AllianceCityTipManager.CreateTip = CreateTip
AllianceCityTipManager.DestroyTip = DestroyTip
AllianceCityTipManager.SetCanShowFlag = SetCanShowFlag
AllianceCityTipManager.RefreshAllianceCityName = RefreshAllianceCityName
AllianceCityTipManager.AllianceCityNameChange = AllianceCityNameChange
AllianceCityTipManager.ShowActBossIconShow = ShowActBossIconShow
AllianceCityTipManager.CheckAllianceCityTipsShowBoss = CheckAllianceCityTipsShowBoss
AllianceCityTipManager.UpdateTipLod = UpdateTipLod
AllianceCityTipManager.SendRequest = SendRequest
AllianceCityTipManager.UpdateLod = UpdateLod
AllianceCityTipManager.AllianceCityRefreshDeclare = AllianceCityRefreshDeclare
AllianceCityTipManager.RefreshDeclare = RefreshDeclare
return AllianceCityTipManager
