local WorldBuildHeadUIManager = BaseClass("WorldBuildHeadUIManager", Singleton)
local ResourceManager = CS.GameEntry.Resource
local WorldBuildHeadUI = require("Scene.WorldBuildHeadUI.WorldBuildHeadUI")
local WorldWinterStormTimer = require("Scene.WorldBuildHeadUI.WorldWinterStormTimer")
local Timer_WS_Prefab = "Assets/Main/Prefabs/World/BF_Winter/DragonWarWinterStormTimer_3dscenes.prefab"
local CityLabel_BattleField_Prefab = "Assets/Main/Prefabs/World/BattleField/BattleFieldCityLabel.prefab"

local function __init(self)
  self.allTips = {}
  self.dragonTips = {}
  self.winterSoldierInit = {}
  self.winterTimers = {}
  self.DragonBuildRequest = {}
  self.WinterTimerRequest = {}
  self.OnCreateTips = {}
  self.uidList = {}
  self.soldierTip = nil
  self:AddListener()
end

local function __delete(self)
  self:RemoveListener()
  for _, v in pairs(self.allTips) do
    local request = v.request
    v:OnDestroy()
    request:Destroy()
  end
  self.allTips = nil
  self:OnQuitDragonWorld()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.ShowCollectBattleValue, self.ShowCollectAttackHeadUISignal)
  EventManager:GetInstance():AddListener(EventId.ShowBuildAttackHeadUI, self.ShowBuildAttackHeadUISignal)
  EventManager:GetInstance():AddListener(EventId.CollectPointOut, self.HideBuildAttackHeadUISignal)
  EventManager:GetInstance():AddListener(EventId.HideBuildAttackHeadUI, self.HideBuildAttackHeadUISignal)
  EventManager:GetInstance():AddListener(EventId.WORLD_BUILD_OUT_VIEW, self.HideBuildAttackHeadUISignal)
  EventManager:GetInstance():AddListener(EventId.PlayerMessageInfo, self.OnUserInfoRefreshSignal)
  EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
  EventManager:GetInstance():AddListener(EventId.DragonBuildInView, self.OnDragonBuildInView)
  EventManager:GetInstance():AddListener(EventId.DragonBuildOutView, self.OnDragonBuildOutView)
  EventManager:GetInstance():AddListener(EventId.QuitDragonWorld, self.OnQuitDragonWorld)
  EventManager:GetInstance():AddListener(EventId.DragonBuildingChange, self.OnDragonBuildingChange)
  EventManager:GetInstance():AddListener(EventId.DragonBuildingTopChange, self.OnDragonBuildingTopChange)
  EventManager:GetInstance():AddListener(EventId.DragonScoreExplode, self.OnDragonScoreExplode)
  EventManager:GetInstance():AddListener(EventId.DragonAssistanceMarchPowerChanged, self.OnDragonAssistanceMarchPowerChanged)
  EventManager:GetInstance():AddListener(EventId.WinterStormDamagePush, self.OnShowDamageNum)
  EventManager:GetInstance():AddListener(EventId.WinterStormEntityUpdate, self.OnBuildHpChange)
  EventManager:GetInstance():AddListener(EventId.EpidemicBattleDamagePush, self.OnShowDamageNum)
  EventManager:GetInstance():AddListener(EventId.EpidemicBattleBuildHpChange, self.OnBuildHpChange)
  EventManager:GetInstance():AddListener(EventId.BattlefieldBuildRoleChanged, self.OnBattlefieldBuildRoleChanged)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.ShowCollectBattleValue, self.ShowCollectAttackHeadUISignal)
  EventManager:GetInstance():RemoveListener(EventId.ShowBuildAttackHeadUI, self.ShowBuildAttackHeadUISignal)
  EventManager:GetInstance():RemoveListener(EventId.CollectPointOut, self.HideBuildAttackHeadUISignal)
  EventManager:GetInstance():RemoveListener(EventId.HideBuildAttackHeadUI, self.HideBuildAttackHeadUISignal)
  EventManager:GetInstance():RemoveListener(EventId.PlayerMessageInfo, self.OnUserInfoRefreshSignal)
  EventManager:GetInstance():RemoveListener(EventId.WORLD_BUILD_OUT_VIEW, self.HideBuildAttackHeadUISignal)
  EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
  EventManager:GetInstance():RemoveListener(EventId.DragonBuildInView, self.OnDragonBuildInView)
  EventManager:GetInstance():RemoveListener(EventId.DragonBuildOutView, self.OnDragonBuildOutView)
  EventManager:GetInstance():RemoveListener(EventId.QuitDragonWorld, self.OnQuitDragonWorld)
  EventManager:GetInstance():RemoveListener(EventId.DragonBuildingChange, self.OnDragonBuildingChange)
  EventManager:GetInstance():RemoveListener(EventId.DragonBuildingTopChange, self.OnDragonBuildingTopChange)
  EventManager:GetInstance():RemoveListener(EventId.DragonScoreExplode, self.OnDragonScoreExplode)
  EventManager:GetInstance():RemoveListener(EventId.DragonAssistanceMarchPowerChanged, self.OnDragonAssistanceMarchPowerChanged)
  EventManager:GetInstance():RemoveListener(EventId.WinterStormDamagePush, self.OnShowDamageNum)
  EventManager:GetInstance():RemoveListener(EventId.WinterStormEntityUpdate, self.OnBuildHpChange)
  EventManager:GetInstance():RemoveListener(EventId.EpidemicBattleDamagePush, self.OnShowDamageNum)
  EventManager:GetInstance():RemoveListener(EventId.EpidemicBattleBuildHpChange, self.OnBuildHpChange)
  EventManager:GetInstance():RemoveListener(EventId.BattlefieldBuildRoleChanged, self.OnBattlefieldBuildRoleChanged)
end

local function OnQuitDragonWorld()
  local self = WorldBuildHeadUIManager:GetInstance()
  self.winterSoldierInit = {}
  if self.dragonTips then
    for _, v in pairs(self.dragonTips) do
      v:OnDestroy()
      v:Delete()
    end
    self.dragonTips = {}
  end
  if self.winterTimers then
    for _, v in pairs(self.winterTimers) do
      v:OnDestroy()
      v:Delete()
    end
    self.winterTimers = {}
  end
  if self.DragonBuildRequest ~= nil then
    for _, v in pairs(self.DragonBuildRequest) do
      v:Destroy()
    end
    self.DragonBuildRequest = {}
  end
  if self.WinterTimerRequest ~= nil then
    for _, v in pairs(self.WinterTimerRequest) do
      v:Destroy()
    end
    self.WinterTimerRequest = {}
  end
end

local function ChangeCameraLodSignal(lod)
  WorldBuildHeadUIManager:GetInstance():UpdateLod(lod)
end

local function UpdateLod(self, lod)
  if self.lodCache == lod then
    return
  end
  self.lodCache = lod
  if self.dragonTips then
    for pointId, component in pairs(self.dragonTips) do
      if component ~= nil and type(component.UpdateLod) == "function" then
        component:UpdateLod(lod)
      end
    end
  end
  if self.winterTimers then
    for pointId, component in pairs(self.winterTimers) do
      if component ~= nil and type(component.UpdateLod) == "function" then
        component:UpdateLod(lod)
      end
    end
  end
end

local function RemoveOneEffect(self, uuid)
  local temp = self.allTips[uuid]
  if temp ~= nil then
    local request = temp.request
    temp:OnDestroy()
    request:Destroy()
    self.allTips[uuid] = nil
  end
  temp = self.OnCreateTips[uuid]
  if temp ~= nil then
    temp:Destroy()
    self.OnCreateTips[uuid] = nil
  end
  for _, v in pairs(self.uidList) do
    if v[uuid] ~= nil then
      v[uuid] = nil
    end
  end
end

local function HideBuildAttackHeadUISignal(uuid)
  WorldBuildHeadUIManager:GetInstance():RemoveOneEffect(tonumber(uuid))
end

local function ShowBuildAttackHeadUISignal(data)
  local str = data
  if str ~= nil then
    local strArr = string.split(str, ";")
    if 2 < #strArr then
      local uuid = tonumber(strArr[1])
      local hp = tonumber(strArr[2])
      local hpMax = tonumber(strArr[3])
      WorldBuildHeadUIManager:GetInstance():CheckShowEffect(uuid, hpMax, hp)
    end
  end
end

local function ShowCollectAttackHeadUISignal(data)
  local str = data
  if str ~= nil then
    local strArr = string.split(str, ";")
    if 4 < #strArr then
      local uuid = tonumber(strArr[1])
      local pointIndex = tonumber(strArr[2])
      local hp = tonumber(strArr[4])
      local hpMax = tonumber(strArr[5])
      WorldBuildHeadUIManager:GetInstance():CheckShowCollectEffect(uuid, pointIndex, hpMax, hp)
    end
  end
end

local function CheckShowCollectEffect(self, bUuid, pointIndex, initHealth, curHealth)
  if self.allTips[bUuid] == nil and self.OnCreateTips[bUuid] == nil then
    if self.lodCache ~= nil and self.lodCache > 3 then
      return
    end
    local request = ResourceManager:InstantiateAsync(UIAssets.WorldBuildHeadUI)
    self.OnCreateTips[bUuid] = request
    request:completed("+", function()
      self.OnCreateTips[bUuid] = nil
      if request.isError then
        return
      end
      local info = CS.SceneManager.World:GetPointInfo(pointIndex)
      if info == nil then
        request:Destroy()
        return
      end
      cast(info, typeof(CS.ResPointInfo))
      if info == nil then
        request:Destroy()
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:SetParent(CS.SceneManager.World.BuildBubbleNode)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local labelUI = WorldBuildHeadUI.New()
      labelUI:OnCreate(request)
      self.allTips[bUuid] = labelUI
      self.allTips[bUuid]:InitCollectInfo(info, initHealth, curHealth, bUuid)
    end)
  elseif self.allTips[bUuid] ~= nil then
    self.allTips[bUuid]:SetHP(curHealth, initHealth)
  end
end

local function OnUserInfoRefreshSignal(uid)
  WorldBuildHeadUIManager:GetInstance():OnUserInfoRefresh(tostring(uid))
end

local function CheckShowEffect(self, bUuid, initHealth, curHealth)
  if self.allTips[bUuid] == nil and self.OnCreateTips[bUuid] == nil then
    if self.lodCache ~= nil and self.lodCache > 3 then
      return
    end
    local request = ResourceManager:InstantiateAsync(UIAssets.WorldBuildHeadUI)
    self.OnCreateTips[bUuid] = request
    request:completed("+", function()
      self.OnCreateTips[bUuid] = nil
      if request.isError then
        return
      end
      local info = CS.SceneManager.World:GetPointInfoByUuid(bUuid)
      if info == nil then
        request:Destroy()
        return
      end
      cast(info, typeof(CS.BuildPointInfo))
      if info == nil then
        request:Destroy()
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:SetParent(CS.SceneManager.World.BuildBubbleNode)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local uid = info.ownerUid
      local ownerData = ChatInterface.getUserData(uid)
      local labelUI = WorldBuildHeadUI.New()
      labelUI:OnCreate(request)
      self.allTips[bUuid] = labelUI
      self.allTips[bUuid]:InitInfo(info, initHealth, curHealth, uid, ownerData)
      if self.uidList[uid] == nil then
        self.uidList[uid] = {}
      end
      self.uidList[uid][bUuid] = 1
    end)
  elseif self.allTips[bUuid] ~= nil then
    self.allTips[bUuid]:SetHP(curHealth, initHealth)
  end
end

local function OnUserInfoRefresh(self, uid)
  if self.uidList[uid] ~= nil then
    for k, v in pairs(self.uidList[uid]) do
      if v ~= nil and self.allTips[k] ~= nil then
        local ownerData = ChatInterface.getUserData(uid)
        self.allTips[k]:SetPlayerData(uid, ownerData)
      end
    end
  end
end

local function CreateTimerPrefab(self, info, gameObject, pointId)
  local config = info.detail ~= nil and DataCenter.WinterStormTemplateManager:GetTemplate(info.detail.BuildId) or nil
  if config == nil then
    return
  end
  if config:IsBuild() or config:IsScoreBox() then
    return
  end
  local request = ResourceManager:InstantiateAsync(Timer_WS_Prefab)
  if self.WinterTimerRequest == nil then
    self.WinterTimerRequest = {}
  end
  self.WinterTimerRequest[pointId] = request
  request:completed("+", function()
    if request.isError then
      return
    end
    local _go = request.gameObject
    local goTrans = gameObject.transform
    local reqTrans = _go.transform
    reqTrans:SetParent(goTrans)
    _go:SetActive(true)
    reqTrans:Set_localPosition(0, 0, 0)
    local scale = 1
    local cType = config.type
    if cType == 101 then
      scale = 3
    elseif cType == 102 then
      scale = 3
    else
      scale = 5
    end
    local labelUI = WorldWinterStormTimer.New()
    labelUI:OnCreate(request, scale)
    labelUI:ReInit(pointId, info)
    if self.lodCache ~= nil then
      labelUI:UpdateLod(self.lodCache)
    end
    if self.winterTimers == nil then
      self.winterTimers = {}
    end
    self.winterTimers[pointId] = labelUI
  end)
end

local function CreateLabelPrefab(self, info, gameObject, pointId)
  local pt = info.PointType
  local request = ResourceManager:InstantiateAsync(CityLabel_BattleField_Prefab)
  if self.DragonBuildRequest == nil then
    self.DragonBuildRequest = {}
  end
  self.DragonBuildRequest[pointId] = request
  request:completed("+", function()
    if request.isError then
      return
    end
    local _go = request.gameObject
    if IsNull(_go) then
      return
    end
    _go:SetActive(true)
    _go.transform:SetParent(gameObject.transform)
    _go.transform:Set_localPosition(0, 0, 0)
    local uiClass
    local _baseConfig = BattleFieldUtil.GetCurrentBaseConfig()
    if _baseConfig then
      uiClass = SafeRequire(_baseConfig.HeadUILuaPath)
    end
    if not uiClass then
      return
    end
    local labelUI = uiClass.New()
    labelUI:OnCreate(request)
    labelUI:ReInit(pointId, info)
    if self.lodCache ~= nil then
      labelUI:UpdateLod(self.lodCache)
    end
    if self.dragonTips == nil then
      self.dragonTips = {}
    end
    self.dragonTips[pointId] = labelUI
  end)
end

local function OnDragonBuildInView(pointId)
  local info = CS.SceneManager.World:GetPointInfo(pointId)
  if info == nil or info.detail == nil then
    return
  end
  local self = WorldBuildHeadUIManager:GetInstance()
  local obj = CS.SceneManager.World:GetObjectByPoint(pointId)
  local gameObject = obj ~= nil and obj:GetGameObject() or nil
  if gameObject == nil then
    return
  end
  local ptType = info.PointType
  if ptType == WorldPointType.WINTER_ENTITY then
    if self.WinterTimerRequest and self.WinterTimerRequest[pointId] ~= nil then
      local component = self.winterTimers ~= nil and self.winterTimers[pointId] or nil
      if component ~= nil then
        if ptType == WorldPointType.WINTER_ENTITY then
          component:UpdateData(pointId, info)
        end
        if self.lodCache ~= nil then
          component:UpdateLod(self.lodCache)
        end
      end
    else
      CreateTimerPrefab(self, info, gameObject, pointId)
    end
  end
  local labelFlag = ptType == WorldPointType.DRAGON_SCORE_POINT or ptType == WorldPointType.DRAGON_BUILDING or ptType == WorldPointType.WINTER_ENTITY
  if ptType == WorldPointType.BATTLEFIELD_BUILD then
    local buildTemp = BattleFieldUtil.GetBattlefieldBuildTemplate(info.detail.BuildId)
    if not buildTemp then
      labelFlag = false
    else
      labelFlag = buildTemp:ShowHeadUI()
    end
  end
  if self.DragonBuildRequest and self.DragonBuildRequest[pointId] ~= nil then
    local component = self.dragonTips ~= nil and self.dragonTips[pointId] or nil
    if component ~= nil then
      if labelFlag then
        component:UpdateData(pointId, info)
      end
      if self.lodCache ~= nil then
        component:UpdateLod(self.lodCache)
      end
    end
  elseif labelFlag then
    CreateLabelPrefab(self, info, gameObject, pointId)
  end
end

local function OnDragonBuildOutView(pointId)
  local self = WorldBuildHeadUIManager:GetInstance()
  if self.DragonBuildRequest ~= nil then
    local request = self.DragonBuildRequest[pointId]
    if request ~= nil then
      request:Destroy()
      self.DragonBuildRequest[pointId] = nil
    end
  end
  if self.WinterTimerRequest ~= nil then
    local request = self.WinterTimerRequest[pointId]
    if request ~= nil then
      request:Destroy()
      self.WinterTimerRequest[pointId] = nil
    end
  end
  if self.dragonTips then
    local component = self.dragonTips[pointId]
    if component ~= nil then
      component:OnDestroy()
      component:Delete()
      self.dragonTips[pointId] = nil
    end
  end
  if self.winterTimers then
    local component = self.winterTimers[pointId]
    if component ~= nil then
      component:OnDestroy()
      component:Delete()
      self.winterTimers[pointId] = nil
    end
  end
end

local function OnDragonBuildingChange(data)
  local self = WorldBuildHeadUIManager:GetInstance()
  if self.dragonTips and data and data.pointId then
    local component = self.dragonTips[data.pointId]
    if component ~= nil and component.OnDragonBuildingChange ~= nil then
      component:OnDragonBuildingChange(data.oldAllianceId, data.newAllianceId)
    end
  end
end

local function OnDragonBuildingTopChange(uuid)
  local self = WorldBuildHeadUIManager:GetInstance()
  local world = CS.SceneManager.World
  local pointInfo = world ~= nil and world:GetPointInfoByUuid(uuid) or nil
  local pointId = pointInfo ~= nil and pointInfo.pointIndex or 0
  local component = self.dragonTips and self.dragonTips[pointId] or nil
  if component ~= nil and component.OnDragonBuildingTopChange ~= nil then
    component:OnDragonBuildingTopChange()
  end
end

local function OnDragonScoreExplode(data)
  if data then
    local mainPoint = data.mainPoint
    local scorePoints = data.scorePoints
    if mainPoint and scorePoints then
      local self = WorldBuildHeadUIManager:GetInstance()
      if self.dragonTips then
        local component = self.dragonTips[mainPoint]
        if component ~= nil and component.OnDragonScoreExplode ~= nil then
          component:OnDragonScoreExplode(mainPoint, scorePoints)
        end
      end
    end
  end
end

local function OnDragonAssistanceMarchPowerChanged()
  local self = WorldBuildHeadUIManager:GetInstance()
  if self.dragonTips then
    for _, v in pairs(self.dragonTips) do
      if v ~= nil and v.OnDragonAssistanceMarchPowerChanged ~= nil then
        v:OnDragonAssistanceMarchPowerChanged()
      end
    end
  end
end

local function OnShowDamageNum(info)
  local pointIndex = info.pointIndex
  local self = WorldBuildHeadUIManager:GetInstance()
  local tipUI = self.dragonTips[pointIndex]
  if tipUI ~= nil and tipUI.ShowDamageNum ~= nil then
    tipUI:ShowDamageNum(info.damage)
  end
end

local function OnBuildHpChange(pointIndex)
  local self = WorldBuildHeadUIManager:GetInstance()
  local tipUI = self.dragonTips[pointIndex]
  if tipUI ~= nil and tipUI.RefreshHead ~= nil then
    tipUI:RefreshHead()
  end
end

local function OnBattlefieldBuildRoleChanged(pointIndex)
  local info = CS.SceneManager.World:GetPointInfo(pointIndex)
  if info == nil then
    return
  end
  local detail = info.detail
  if not detail then
    return
  end
  local self = WorldBuildHeadUIManager:GetInstance()
  if self.DragonBuildRequest and self.DragonBuildRequest[pointIndex] ~= nil then
    local component = self.dragonTips ~= nil and self.dragonTips[pointIndex] or nil
    if component ~= nil then
      component:OnRoleChanged(detail.Role)
    end
  end
end

WorldBuildHeadUIManager.__init = __init
WorldBuildHeadUIManager.__delete = __delete
WorldBuildHeadUIManager.AddListener = AddListener
WorldBuildHeadUIManager.RemoveListener = RemoveListener
WorldBuildHeadUIManager.RemoveOneEffect = RemoveOneEffect
WorldBuildHeadUIManager.CheckShowEffect = CheckShowEffect
WorldBuildHeadUIManager.OnUserInfoRefresh = OnUserInfoRefresh
WorldBuildHeadUIManager.HideBuildAttackHeadUISignal = HideBuildAttackHeadUISignal
WorldBuildHeadUIManager.ShowBuildAttackHeadUISignal = ShowBuildAttackHeadUISignal
WorldBuildHeadUIManager.OnUserInfoRefreshSignal = OnUserInfoRefreshSignal
WorldBuildHeadUIManager.UpdateLod = UpdateLod
WorldBuildHeadUIManager.ChangeCameraLodSignal = ChangeCameraLodSignal
WorldBuildHeadUIManager.ShowCollectAttackHeadUISignal = ShowCollectAttackHeadUISignal
WorldBuildHeadUIManager.CheckShowCollectEffect = CheckShowCollectEffect
WorldBuildHeadUIManager.OnDragonBuildInView = OnDragonBuildInView
WorldBuildHeadUIManager.OnDragonBuildOutView = OnDragonBuildOutView
WorldBuildHeadUIManager.OnQuitDragonWorld = OnQuitDragonWorld
WorldBuildHeadUIManager.OnDragonBuildingChange = OnDragonBuildingChange
WorldBuildHeadUIManager.OnDragonBuildingTopChange = OnDragonBuildingTopChange
WorldBuildHeadUIManager.OnDragonScoreExplode = OnDragonScoreExplode
WorldBuildHeadUIManager.OnDragonAssistanceMarchPowerChanged = OnDragonAssistanceMarchPowerChanged
WorldBuildHeadUIManager.OnShowDamageNum = OnShowDamageNum
WorldBuildHeadUIManager.OnBuildHpChange = OnBuildHpChange
WorldBuildHeadUIManager.OnBattlefieldBuildRoleChanged = OnBattlefieldBuildRoleChanged
return WorldBuildHeadUIManager
