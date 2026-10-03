local CityDomeProtectEffectManager = BaseClass("CityDomeProtectEffectManager", Singleton)
local ResourceManager = CS.GameEntry.Resource
local CityDomeProtectEffect = require("Scene.CityDomeProtectEffect.CityDomeProtectEffect")
local GovernmentEffect = require("Scene.CityDomeProtectEffect.GovernmentEffect")
local VirusEffect = require("Scene.CityDomeProtectEffect.VirusEffect")
local MusicEffect = require("Scene.CityDomeProtectEffect.MusicEffect")
local MummyEffect = require("Scene.CityDomeProtectEffect.MummyEffect")
local FarmerEffect = require("Scene.CityDomeProtectEffect.FarmerEffect")
local BatteryPowerEffect = require("Scene.CityDomeProtectEffect.BatteryPowerEffect")
local BuildingShowEffect = require("Scene.CityDomeProtectEffect.BuildingShowEffect")
local BuildingRewardBubbleEffect = require("Scene.CityDomeProtectEffect.BuildingRewardBubbleEffect")
local BuildingGetRewardBubbleEffect = require("Scene.CityDomeProtectEffect.BuildingGetRewardBubbleEffect")
local EpidemicEffect = require("Scene.CityDomeProtectEffect.EpidemicEffect")
local MusicFestival2025_BubbleEffect = require("Scene.CityDomeProtectEffect.MusicFestival2025_BubbleEffect")

local function __init(self)
  self.allEffect = {}
  self.OnCreateEffect = {}
  self.protectEffectCreateSeq = {}
  self.allProtectEffect = {}
  self.buildingStatusEffect = {}
  self.StatusTypeBuildingEffobj = {}
  self.lod = 1
  self:AddListener()
end

local function __delete(self)
  for k, v in pairs(self.allEffect) do
    local request = v.request
    pcall(v.OnDestroy, v)
    if request ~= nil then
      pcall(request.Destroy, request)
    end
  end
  for k, v in pairs(self.OnCreateEffect) do
    pcall(v.Destroy, v)
  end
  self:RemoveAllBuildingStatusEffect()
  self.OnCreateEffect = nil
  self.protectEffectCreateSeq = nil
  self.allEffect = nil
  self.allProtectEffect = nil
  self.buildingStatusEffect = nil
  self.StatusTypeBuildingEffobj = nil
  self:RemoveListener()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.PveLevelEnter, self.RemoveAllTips)
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.RemoveAllTips)
  EventManager:GetInstance():AddListener(EventId.EnterDragonWorld, self.RemoveAllTips)
  EventManager:GetInstance():AddListener(EventId.CheckDomeOpen, self.BuildInViewSignal)
  EventManager:GetInstance():AddListener(EventId.WORLD_BUILD_IN_VIEW, self.BuildInViewSignal)
  EventManager:GetInstance():AddListener(EventId.WORLD_BUILD_OUT_VIEW, self.BuildOutViewSignal)
  EventManager:GetInstance():AddListener(EventId.CityDomeShow, self.CityDomeShowSignal)
  EventManager:GetInstance():AddListener(EventId.CityDomeHide, self.CityDomeHideSignal)
  EventManager:GetInstance():AddListener(EventId.ShowDomeGlass, self.BuildInViewSignal)
  EventManager:GetInstance():AddListener(EventId.ChomperCreateOrDelete, self.BuildInViewSignal)
  EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
  EventManager:GetInstance():AddListener(EventId.HelpToTreatVirus, self.OnHelpToTreatVirusFinish)
  EventManager:GetInstance():AddListener(EventId.OnScoutTroopArrived, self.OnScoutTroopArrived)
  EventManager:GetInstance():AddListener(EventId.PlayerHPChanged, self.OnPlayerHPChanged)
  EventManager:GetInstance():AddListener(EventId.WorldRewardBubbleGetMsg, self.OnWorldRewardBubbleGetMsg)
  EventManager:GetInstance():AddListener(EventId.WorldGetRewardBubbleGetMsg, self.OnWorldGetRewardBubbleGetMsg)
  EventManager:GetInstance():AddListener(EventId.GetBuildMainPartyRewardRefresh, self.RefreshGetBuildMainPartyRewardShow)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, self.RemoveAllTips)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.RemoveAllTips)
  EventManager:GetInstance():RemoveListener(EventId.EnterDragonWorld, self.RemoveAllTips)
  EventManager:GetInstance():RemoveListener(EventId.CheckDomeOpen, self.BuildInViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.WORLD_BUILD_IN_VIEW, self.BuildInViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.WORLD_BUILD_OUT_VIEW, self.BuildOutViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.CityDomeShow, self.CityDomeShowSignal)
  EventManager:GetInstance():RemoveListener(EventId.CityDomeHide, self.CityDomeHideSignal)
  EventManager:GetInstance():RemoveListener(EventId.ShowDomeGlass, self.BuildInViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.ChomperCreateOrDelete, self.BuildInViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
  EventManager:GetInstance():RemoveListener(EventId.HelpToTreatVirus, self.OnHelpToTreatVirusFinish)
  EventManager:GetInstance():RemoveListener(EventId.OnScoutTroopArrived, self.OnScoutTroopArrived)
  EventManager:GetInstance():RemoveListener(EventId.PlayerHPChanged, self.OnPlayerHPChanged)
  EventManager:GetInstance():RemoveListener(EventId.WorldRewardBubbleGetMsg, self.OnWorldRewardBubbleGetMsg)
  EventManager:GetInstance():RemoveListener(EventId.WorldGetRewardBubbleGetMsg, self.OnWorldGetRewardBubbleGetMsg)
  EventManager:GetInstance():RemoveListener(EventId.GetBuildMainPartyRewardRefresh, self.RefreshGetBuildMainPartyRewardShow)
end

local function RemoveAllTips(data)
  CityDomeProtectEffectManager:GetInstance():RemoveAllEffect()
end

function CityDomeProtectEffectManager.OnScoutTroopArrived(marchUuid)
  if marchUuid ~= nil then
    local marchInfo = CS.SceneManager.World:GetMarch(marchUuid)
    if marchInfo == nil then
      return
    end
    local targetUuid = marchInfo.targetUuid
    if marchInfo.type == CS.NewMarchType.POWER_WORKER then
    elseif marchInfo.type == CS.NewMarchType.SCOUT then
      local info = CS.SceneManager.World:GetPointInfoByUuid(targetUuid)
      if info ~= nil and info.PointType == WorldPointType.PlayerBuilding then
        cast(info, typeof(CS.BuildPointInfo))
        if info.itemId == BuildingTypes.FUN_BUILD_MAIN then
          local curServerId = LuaEntry.Player:GetCurServerId()
          local worldPos = SceneUtils.TileIndexToWorld(marchInfo.targetPos, ForceChangeScene.World, curServerId)
          local playerInfo = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(info.ownerUid, true)
          local marchTargetType = marchInfo:GetMarchTargetType()
          if marchTargetType == MarchTargetType.SEASON_MUMMY_CONVERT then
            do
              local showParticle, showBubble = WorldSimpleModeUtils.ShowMummyTranslate()
              if showBubble then
                EventManager:GetInstance():Broadcast(EventId.WorldBuildTopBubblePlot, {
                  bUuid = targetUuid,
                  plotId = 8145,
                  playerInfo = playerInfo
                })
                BuildTopBubbleManager:GetInstance():RemoveOneEffect(tonumber(targetUuid))
              end
              if showParticle then
                local effectPath = "Assets/_Art_LastWar/Effect/Prefab/S3/Eff_S3_zhuanhua.prefab"
                CS.SceneManager.World:CreateBattleVFX(effectPath, 1.5, function(go)
                  local theWorld = CS.SceneManager.World
                  if theWorld ~= nil and go ~= nil then
                    go.transform.position = worldPos
                  end
                end)
              end
            end
          end
        end
      end
    elseif marchInfo.type == CS.NewMarchType.TREAT_VIRUS then
      CityDomeProtectEffectManager.OnHelpToTreatVirusFinish(marchInfo.targetUuid)
    end
  end
end

function CityDomeProtectEffectManager.OnHelpToTreatVirusFinish(targetUuid)
  if targetUuid ~= nil then
    local info = CS.SceneManager.World:GetPointInfoByUuid(targetUuid)
    if info ~= nil and info.PointType == WorldPointType.PlayerBuilding then
      cast(info, typeof(CS.BuildPointInfo))
      if info.itemId == BuildingTypes.FUN_BUILD_MAIN then
        local myAlId = LuaEntry.Player.allianceId
        local playerInfo = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(info.ownerUid, true)
        EventManager:GetInstance():Broadcast(EventId.WorldBuildTopBubblePlot, {
          bUuid = targetUuid,
          plotId = 6042,
          playerInfo = playerInfo
        })
        EventManager:GetInstance():Broadcast(EventId.HelpToTreatVirusBubbleShow, {bUuid = targetUuid})
        BuildTopBubbleManager:GetInstance():RemoveOneEffect(tonumber(targetUuid))
        if not string.IsNullOrEmpty(myAlId) and info.allianceId == myAlId then
          DataCenter.LWSoundManager:PlaySound(1000011, false)
        end
      end
    end
  end
end

local function RemoveAllEffect(self)
  for k, v in pairs(self.allEffect) do
    local request = v.request
    pcall(v.OnDestroy, v)
    if request ~= nil then
      pcall(request.Destroy, request)
    end
  end
  for k, v in pairs(self.OnCreateEffect) do
    pcall(v.Destroy, v)
  end
  self:RemoveAllBuildingStatusEffect()
  self.OnCreateEffect = {}
  self.protectEffectCreateSeq = {}
  self.allEffect = {}
  self.allProtectEffect = {}
  self.buildingStatusEffect = {}
  self.StatusTypeBuildingEffobj = {}
end

local function TryShowProtectEffect(self, bUuid, prefabName, param)
  if self == nil or self.allEffect == nil or self.allProtectEffect == nil then
    return
  end
  local reqSeq = (self.protectEffectCreateSeq[bUuid] or 0) + 1
  self.protectEffectCreateSeq[bUuid] = reqSeq
  local request = ResourceManager:InstantiateAsync(prefabName)
  self.OnCreateEffect[bUuid] = request
  request:completed("+", function()
    if self == nil or self.allEffect == nil or self.allProtectEffect == nil then
      if request ~= nil then
        request:Destroy()
      end
      return
    end
    if self.protectEffectCreateSeq[bUuid] ~= reqSeq or self.OnCreateEffect[bUuid] ~= request then
      request:Destroy()
      return
    end
    self.OnCreateEffect[bUuid] = nil
    if request.isError then
      return
    end
    request.gameObject:SetActive(self.lod <= (param.maxLod or 2))
    local parent = param.parent
    if IsNotNull(parent) then
      request.gameObject.transform:SetParent(parent)
      request.gameObject.transform.localPosition = Vector3.zero
    else
      request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    end
    if param.scale == nil then
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    else
      request.gameObject.transform:Set_localScale(param.scale, param.scale, param.scale)
    end
    local effect = CityDomeProtectEffect.New()
    effect:OnCreate(request, parent)
    effect:ReInit(param)
    self.allEffect[bUuid] = effect
    self.allProtectEffect[bUuid] = {
      effect = effect,
      maxLod = param.maxLod or 2
    }
  end)
end

local function ShowBuildProtectEffect(self, bUuid, posIndex, endTime, domeLv, effectPrefabPath, scale, parentNode, maxLod)
  local prefabName = UIAssets.LWCityDomeProtectEffect
  local param = {}
  param.bUuid = bUuid
  param.posIndex = posIndex
  param.endTime = endTime
  param.domeLv = domeLv
  param.scale = scale
  param.parent = IsNotNull(parentNode) and parentNode or nil
  param.maxLod = maxLod
  if effectPrefabPath ~= nil then
    prefabName = effectPrefabPath
  end
  if self.allEffect[bUuid] == nil and self.OnCreateEffect[bUuid] == nil then
    TryShowProtectEffect(self, bUuid, prefabName, param)
  elseif self.allEffect[bUuid] ~= nil then
    local temp = self.allEffect[bUuid]
    if temp ~= nil then
      if temp:GetDomeLevel() ~= domeLv then
        self:RemoveBuildProtectEffect(bUuid)
        TryShowProtectEffect(self, bUuid, prefabName, param)
      elseif IsNotNull(param.parent) then
        temp:ReInit(param)
        local effTran = self.allEffect[bUuid].transform
        if IsNotNull(effTran) and effTran.parent ~= param.parent then
          effTran:SetParent(param.parent)
          effTran:Set_localScale(1, 1, 1)
          effTran.localPosition = Vector3.zero
        end
      else
        temp:ReInit(param)
      end
    end
  end
end

local function RemoveBuildProtectEffect(self, bUuid)
  self.protectEffectCreateSeq[bUuid] = (self.protectEffectCreateSeq[bUuid] or 0) + 1
  local temp = self.allEffect[bUuid]
  if temp ~= nil then
    local request = temp.request
    if request ~= nil then
      request:Destroy()
    end
    temp:OnDestroy()
    self.allEffect[bUuid] = nil
    self.allProtectEffect[bUuid] = nil
  end
  if self.OnCreateEffect[bUuid] ~= nil then
    self.OnCreateEffect[bUuid]:Destroy()
    self.OnCreateEffect[bUuid] = nil
  end
end

function CityDomeProtectEffectManager:OnPlayerHPChanged(uuid)
  if uuid then
    local self = CityDomeProtectEffectManager:GetInstance()
    local effect = self.allEffect[uuid .. "_virus"]
    if effect ~= nil then
      effect:OnPlayerHPChanged()
    end
  end
end

function CityDomeProtectEffectManager:ShowVirusEffect(info)
  if BattleFieldUtil.InBattleField() then
    self:RemoveVirusEffect(info.uuid)
    return
  end
  if info and info.itemId == BuildingTypes.FUN_BUILD_MAIN then
    local key = info.uuid .. "_virus"
    local statusList = info.status
    local virusLayer = toInt(info.virusLayer or 0)
    local virusEndTime = toInt(info.virusEndTime or 0)
    local refuseTreadVirus = info.refuseTreadVirus
    virusLayer, virusEndTime = SeasonUtil.CalcVirusLevel(virusLayer, virusEndTime)
    if virusLayer == 0 or virusEndTime == 0 then
      self:RemoveVirusEffect(info.uuid)
      return
    end
    local effect = self.allEffect[key]
    local mainIndex = info.mainIndex
    local obj = CS.SceneManager.World:GetObjectByPoint(mainIndex)
    if obj ~= nil then
      do
        local gameObject = obj:GetGameObject()
        if gameObject ~= nil then
          local theModelGo = gameObject.transform:Find("ModelGo")
          if theModelGo == nil then
            theModelGo = gameObject.transform:Find("Model")
          end
          if theModelGo == nil then
            self:RemoveVirusEffect(info.uuid)
            return
          end
          local theCityLabel = theModelGo.transform:Find("CityLabel")
          if theCityLabel == nil then
            self:RemoveVirusEffect(info.uuid)
            return
          end
          local worldPos = theCityLabel.position
          if effect ~= nil then
            effect:SetBasePos(worldPos)
            effect:ReInit(virusLayer, virusEndTime, info.uuid, info.mainIndex, info.curHp, statusList, refuseTreadVirus)
            effect:OnCameraChangeLod(self.lod)
            return
          end
          if theCityLabel and self.allEffect[key] == nil and self.OnCreateEffect[key] == nil then
            do
              local request = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/UI/LWSeasonShared/Virus.prefab")
              self.OnCreateEffect[key] = request
              request:completed("+", function()
                self.OnCreateEffect[key] = nil
                if request.isError then
                  return
                end
                local theWorld = CS.SceneManager.World
                if theWorld == nil then
                  request:Destroy()
                  return
                end
                local _obj = theWorld:GetObjectByPoint(mainIndex)
                if _obj == nil then
                  request:Destroy()
                  return
                end
                if IsNull(theModelGo) or IsNull(theCityLabel) then
                  request:Destroy()
                  return
                end
                virusLayer, virusEndTime = SeasonUtil.CalcVirusLevel(virusLayer, virusEndTime)
                if virusLayer == 0 or virusEndTime == 0 then
                  request:Destroy()
                  return
                end
                local go = request.gameObject
                go.name = "Virus"
                go:SetActive(true)
                go.transform:SetParent(theWorld.DynamicObjNode)
                go.transform:Set_localScale(0.5, 0.5, 0.5)
                go.transform.position = worldPos
                local effectVirus = VirusEffect.New()
                effectVirus:OnCreate(go)
                effectVirus:SetBasePos(worldPos)
                effectVirus:ReInit(virusLayer, virusEndTime, info.uuid, info.mainIndex, info.curHp, statusList, refuseTreadVirus)
                effectVirus:OnCameraChangeLod(self.lod)
                effectVirus.request = request
                self.allEffect[key] = effectVirus
              end)
            end
          end
        end
      end
    end
  end
end

function CityDomeProtectEffectManager:RemoveVirusEffect(uuid)
  local key = uuid .. "_virus"
  local effect = self.allEffect[key]
  if effect ~= nil then
    local request = effect.request
    if request ~= nil then
      pcall(request.Destroy, request)
    end
    pcall(effect.OnDestroy, effect)
    self.allEffect[key] = nil
  end
end

function CityDomeProtectEffectManager:ShowFarmerEffect(info)
  if not (info and info.seasonRole) or info.seasonRole == 0 or info.itemId ~= BuildingTypes.FUN_BUILD_MAIN or BattleFieldUtil.InBattleField() then
    return
  end
  local key = string.format("%s_%s", info.uuid, "farmer")
  local effect = self.allEffect[key]
  if effect then
    effect:ReInit(info.seasonRole, info.uuid, info.mainIndex)
    return
  end
  local obj = CS.SceneManager.World:GetObjectByPoint(info.mainIndex)
  if not obj then
    return
  end
  local gameObject = obj:GetGameObject()
  if not gameObject then
    return
  end
  local theTransform = gameObject.transform:Find("ModelGo/CityLabel/Farmer")
  if theTransform then
    effect = FarmerEffect.New()
    effect:OnCreate(theTransform)
    effect:ReInit(info.seasonRole, info.uuid, info.mainIndex)
    self.allEffect[key] = effect
    return
  end
  local theModelGo = gameObject.transform:Find("ModelGo")
  if theModelGo == nil then
    theModelGo = gameObject.transform:Find("Model")
  end
  if theModelGo == nil then
    return
  end
  local theCityLabel = theModelGo.transform:Find("CityLabel")
  if not theCityLabel or self.OnCreateEffect[key] then
    return
  end
  local request = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/MainCity/Farmer.prefab")
  self.OnCreateEffect[key] = request
  request:completed("+", function()
    self.OnCreateEffect[key] = nil
    if request.isError then
      return
    end
    if IsNull(theModelGo) or IsNull(theCityLabel) then
      request:Destroy()
      return
    end
    local theWorld = CS.SceneManager.World
    if theWorld == nil then
      request:Destroy()
      return
    end
    local go = request.gameObject
    pcall(function()
      go.name = "Farmer"
      go:SetActive(true)
      go.transform:SetParent(theCityLabel)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      effect = FarmerEffect.New()
      effect:OnCreate(go)
      effect:ReInit(info.seasonRole, info.uuid, info.mainIndex)
    end)
    effect.request = request
    self.allEffect[key] = effect
  end)
end

function CityDomeProtectEffectManager:RemoveFarmerEffect(uuid)
  local key = string.format("%s_%s", uuid, "farmer")
  local effect = self.allEffect[key]
  if effect ~= nil then
    local request = effect.request
    if request ~= nil then
      pcall(request.Destroy, request)
    end
    pcall(effect.OnDestroy, effect)
    self.allEffect[key] = nil
  end
end

function CityDomeProtectEffectManager:ShowMummyEffect(info)
  if BattleFieldUtil.InBattleField() then
    return
  end
  if info and info.itemId == BuildingTypes.FUN_BUILD_MAIN then
    local key = info.uuid .. "_mummy"
    local mummyConvertCount = toInt(info.mummyConvertCount or 0)
    local mummyConvertId = toInt(info.mummyConvertId or 0)
    local effect = self.allEffect[key]
    if effect ~= nil then
      if mummyConvertCount == 0 or mummyConvertId == 0 then
        self.allEffect[key] = nil
        effect:Delete()
      else
        effect:ReInit(mummyConvertId, mummyConvertCount)
      end
      return
    end
    if mummyConvertCount == 0 or mummyConvertId == 0 then
      return
    end
    local obj = CS.SceneManager.World:GetObjectByPoint(info.mainIndex)
    if obj ~= nil then
      local gameObject = obj:GetGameObject()
      if gameObject == nil then
        return
      end
      local theModelGo = gameObject.transform:Find("ModelGo")
      if theModelGo == nil then
        theModelGo = gameObject.transform:Find("Model")
      end
      if theModelGo == nil then
        return
      end
      local theCityLabel = theModelGo.transform:Find("CityLabel")
      if theCityLabel then
        local theNewEffect = MummyEffect.New("MummyEffect", theCityLabel, "Assets/Main/SeasonRes/Shared/Prefabs/World/MummyConvert.prefab")
        theNewEffect:ReInit(mummyConvertId, mummyConvertCount)
        self.allEffect[key] = theNewEffect
      end
    end
  end
end

function CityDomeProtectEffectManager:RemoveMummyEffect(uuid)
  local key = uuid .. "_mummy"
  local effect = self.allEffect[key]
  if effect ~= nil then
    self.allEffect[key] = nil
    effect:Delete()
  end
end

function CityDomeProtectEffectManager:UpdateBatteryPowerEffect(pointId, data, myself)
  local sunrise = DataCenter.BloodyNightDataManager:IsSunrise()
  if sunrise or pointId == nil or pointId == -1 or pointId == 0 or data == nil or BattleFieldUtil.InBattleField() then
    return
  end
  if not SceneUtils.GetIsInWorld() then
    return
  end
  local World = CS.SceneManager.World
  if World == nil then
    return
  end
  local pointInfo = World:GetPointInfo(pointId)
  if pointInfo == nil or pointInfo.PointType ~= WorldPointType.PlayerBuilding then
    return
  end
  cast(pointInfo, typeof(CS.BuildPointInfo))
  if pointInfo == nil or pointInfo.ownerUid == nil or pointInfo.ownerUid == 0 then
    return
  end
  if myself then
    if pointInfo.ownerUid ~= LuaEntry.Player.uid then
      return
    end
  elseif pointInfo.ownerUid ~= data.uid then
    return
  end
  local key = pointInfo.uuid .. "_power"
  local effect = self.allEffect[key]
  if effect == nil then
    return
  end
  local obj = World:GetObjectByPoint(pointId)
  if obj == nil then
    return
  end
  local gameObject = obj:GetGameObject()
  if gameObject == nil then
    return
  end
  if myself then
    local lightHouseStatus = DataCenter.SeasonPowerWorkerManager.lightHouseStatus
    if lightHouseStatus == nil or lightHouseStatus.active ~= true then
      return
    end
    effect:UpdateDataByPush(data, true)
  elseif data.uid ~= nil then
    effect:UpdateDataByPush(data, false)
  end
end

function CityDomeProtectEffectManager:ShowBatteryPowerEffect(info)
  local sunrise = DataCenter.BloodyNightDataManager:IsSunrise()
  if sunrise or BattleFieldUtil.InBattleField() then
    return
  end
  local World = CS.SceneManager.World
  if World == nil then
    return
  end
  if info and info.itemId == BuildingTypes.FUN_BUILD_MAIN then
    local lightHouseInfo = info.lightHouseInfo
    local key = info.uuid .. "_power"
    local effect = self.allEffect[key]
    if lightHouseInfo == nil or toInt(lightHouseInfo.LightHouseLevel) == 0 then
      if effect ~= nil then
        self.allEffect[key] = nil
        effect:Delete()
      end
      return
    end
    if effect ~= nil then
      effect:ReInit(info.uuid, lightHouseInfo, nil, self.lod)
      return
    end
    local obj = World:GetObjectByPoint(info.mainIndex)
    if obj ~= nil then
      local gameObject = obj:GetGameObject()
      if gameObject == nil then
        return
      end
      local theModelGo = gameObject.transform:Find("ModelGo")
      if theModelGo == nil then
        theModelGo = gameObject.transform:Find("Model")
      end
      if theModelGo == nil then
        return
      end
      local theCityLabel = theModelGo.transform:Find("CityLabel")
      if theCityLabel then
        local theNewEffect = BatteryPowerEffect.New("BatteryEffect", theCityLabel, "Assets/Main/SeasonRes/S4/Prefabs/World/BatteryPowerEffect.prefab")
        theNewEffect:ReInit(info.uuid, lightHouseInfo, theModelGo.position, self.lod, info.ownerUid, info.mainIndex)
        self.allEffect[key] = theNewEffect
      end
    end
  end
end

function CityDomeProtectEffectManager:RemoveBatteryPowerEffect(uuid)
  local key = uuid .. "_power"
  local effect = self.allEffect[key]
  if effect ~= nil then
    self.allEffect[key] = nil
    effect:Delete()
  end
end

function CityDomeProtectEffectManager:ShowGovernmentEffect(governmentId, info)
  if info ~= nil and governmentId ~= nil then
    local key = info.uuid .. "_office"
    if info.showPosition == false then
      if self.allEffect[key] ~= nil or self.OnCreateEffect[key] ~= nil then
        self:RemoveGovernmentEffect(info.uuid)
      end
      return
    end
    local prefabName = "Assets/Main/Prefabs/World/GovernmentInfo.prefab"
    local serverId = info.serverId
    local position = SceneUtils.TileIndexToWorld(info.mainIndex, ForceChangeScene.World, serverId)
    if info.appearanceId == 2 then
      position.y = 1.4
    elseif info.level ~= nil and type(info.level) == "number" then
      if info.level <= 10 then
        position.y = 0.6
      elseif info.level >= 20 then
        position.y = 1.85
      else
        position.y = 1.7
      end
    end
    if self.allEffect[key] == nil and self.OnCreateEffect[key] == nil then
      do
        local request = ResourceManager:InstantiateAsync(prefabName)
        self.OnCreateEffect[key] = request
        request:completed("+", function()
          self.OnCreateEffect[key] = nil
          if request.isError then
            return
          end
          local theWorld = CS.SceneManager.World
          if theWorld == nil then
            request:Destroy()
            return
          end
          request.gameObject:SetActive(true)
          request.gameObject.transform:SetParent(theWorld.DynamicObjNode)
          request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          request.gameObject.transform.position = position
          local effect = GovernmentEffect.New()
          effect:OnCreate(request)
          effect:ReInit(governmentId, self.lod, info.uuid)
          self.allEffect[key] = effect
        end)
      end
    end
  elseif info ~= nil then
    self:RemoveGovernmentEffect(info.uuid)
  end
end

function CityDomeProtectEffectManager:RemoveGovernmentEffect(uuid)
  local key = uuid .. "_office"
  local temp = self.allEffect[key]
  if temp ~= nil then
    local request = temp.request
    if request ~= nil then
      request:Destroy()
    end
    temp:OnDestroy()
    self.allEffect[key] = nil
  end
  if self.OnCreateEffect[key] ~= nil then
    self.OnCreateEffect[key]:Destroy()
    self.OnCreateEffect[key] = nil
  end
end

local function BuildInViewSignal(uuid)
  local theUuid = tonumber(uuid)
  CityDomeProtectEffectManager:GetInstance():CheckShowEffect(theUuid)
end

local function BuildOutViewSignal(uuid)
  local theUuid = tonumber(uuid)
  CityDomeProtectEffectManager:GetInstance():RemoveBuildProtectEffect(theUuid)
  CityDomeProtectEffectManager:GetInstance():RemoveGovernmentEffect(theUuid)
  CityDomeProtectEffectManager:GetInstance():RemoveVirusEffect(theUuid)
  CityDomeProtectEffectManager:GetInstance():RemoveMummyEffect(theUuid)
  CityDomeProtectEffectManager:GetInstance():RemoveBatteryPowerEffect(theUuid)
  CityDomeProtectEffectManager:GetInstance():RemoveBuildingStatusEffectByUuid(theUuid)
  CityDomeProtectEffectManager:GetInstance():RemoveFarmerEffect(theUuid)
  CityDomeProtectEffectManager:GetInstance():RemoveEpidemic(theUuid)
end

local function CityDomeShowSignal(uuid)
  CityDomeProtectEffectManager:GetInstance():ShowDome(tonumber(uuid))
end

local function CityDomeHideSignal(uuid)
  CityDomeProtectEffectManager:GetInstance():HideDome(tonumber(uuid))
end

local function ChangeCameraLodSignal(lod)
  CityDomeProtectEffectManager:GetInstance():OnCameraChangeLod(lod)
end

local function OnCameraChangeLod(self, lod)
  for k, v in pairs(self.allProtectEffect) do
    local go = v.effect.gameObject
    if go ~= nil and not IsNull(go) then
      go:SetActive(lod <= v.maxLod)
    end
  end
  self.lod = lod
  for k, v in pairs(self.allEffect) do
    if k and v and type(k) == "string" and (string.endswith(k, "_office") or string.endswith(k, "_power") or string.endswith(k, "_virus")) then
      v:OnCameraChangeLod(lod)
    end
  end
  self:SetAllBuildingStatusEffectIsShow(lod)
end

local function CheckShowEffect(self, bUuid)
  local info = CS.SceneManager.World:GetPointInfoByUuid(bUuid)
  if info ~= nil then
    self:OnWorldBaseRefresh(info)
  end
end

function CityDomeProtectEffectManager:OnWorldBaseRefresh(info)
  local bUuid = info.uuid
  if info.itemId == BuildingTypes.FUN_BUILD_MAIN then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    local infoProtectEndTime = info.protectEndTime
    if infoProtectEndTime ~= nil and 0 < infoProtectEndTime then
      if curTime < infoProtectEndTime then
        local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.FUN_BUILD_MAIN, info.level)
        if levelTemplate then
          if info.sandWorm and info.sandWorm:IsChomper() then
            self:RemoveBuildProtectEffect(bUuid)
          else
            self:ShowBuildProtectEffect(bUuid, info.mainIndex, infoProtectEndTime, levelTemplate.offer_range)
          end
        end
      else
        self:RemoveBuildProtectEffect(bUuid)
      end
    else
      self:RemoveBuildProtectEffect(bUuid)
    end
    local positionId = info.positionId
    if positionId ~= nil and positionId ~= 0 and positionId ~= "" then
      if info.ownerUid == LuaEntry.Player.uid then
        DataCenter.GovernmentManager:SetSelfPositionFromPositions(positionId)
      end
      if info.IsWerewolf then
        self:RemoveGovernmentEffect(bUuid)
      else
        self:ShowGovernmentEffect(positionId, info)
      end
    else
      self:RemoveGovernmentEffect(bUuid)
    end
    if not BattleFieldUtil.InBattleField() then
      local isInSeason = false
      local cfg = SeasonUtil.GetCurServerConfig()
      local theType = SeasonMapType.Nothing
      if cfg ~= nil then
        isInSeason = cfg:InNormalMode()
        theType = cfg:GetServerType(false)
      end
      if isInSeason then
        self:ShowFarmerEffect(info)
        if theType == SeasonMapType.Mummy then
          self:ShowMummyEffect(info)
        elseif theType == SeasonMapType.CityStronghold then
          self:ShowVirusEffect(info)
        elseif theType == SeasonMapType.Darkness and info.lightHouseInfo ~= nil and info.lightHouseInfo.LightHouseActive then
          local sunrise = DataCenter.BloodyNightDataManager:IsSunrise()
          if not sunrise then
            self:ShowBatteryPowerEffect(info)
          end
        end
      end
    end
    self:RefreshBuildingStatusByInfo(info)
  elseif info.itemId == BuildingTypes.WORM_HOLE_CROSS and BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
    local flag = false
    local quarantineLeave = info.quarantineLeave or 0
    if 0 < quarantineLeave then
      flag = true
    else
      local arbiterUid = DataCenter.ActEpidemicZoneManager:GetBattleInfo().arbiterUid
      if info.ownerUid == arbiterUid then
        flag = true
      end
    end
    self:ShowEpidemic(info, flag)
  end
end

local function TimeCallBack(bUuid)
  CityDomeProtectEffectManager:GetInstance():RemoveOneEffect(bUuid)
end

function CityDomeProtectEffectManager:GetPointModelParent(pointId, pointInfo)
  local effectParentNode
  if pointInfo.PointType == WorldPointType.WORLD_ALLIANCE_CITY or pointInfo.PointType == WorldPointType.ZWL_BUILDING or pointInfo.PointType == WorldPointType.ZWL_BUILDING_TOWER or pointInfo.PointType == WorldPointType.ZWL_BUILDING_BUFF or pointInfo.PointType == WorldPointType.ZWL_BUILDING_THRONE then
    local obj = CS.SceneManager.World:GetObjectByPoint(pointId)
    if obj then
      local rootObj = obj:GetGameObject()
      if rootObj then
        effectParentNode = rootObj.transform:Find("Model")
      end
    end
  end
  return effectParentNode
end

local function ShowDome(self, pointId)
  local temp = self.allEffect[pointId]
  if temp == nil then
    local cityData = DataCenter.AllianceCityTemplateManager:GetCityDataByPointIndex(pointId, LuaEntry.Player:GetCurServerId())
    if cityData ~= nil and (cityData:IsThroneCity() or cityData:IsThroneCityBattery() or cityData:IsMissileFactory()) then
      local pointInfo = CS.SceneManager.World:GetPointInfo(pointId)
      if pointInfo ~= nil and pointInfo.extraInfo ~= nil then
        local curTime = UITimeManager:GetInstance():GetServerSeconds()
        local extraInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
        if extraInfo ~= nil then
          local timeOpen = extraInfo.openTime or 0
          local timeEnd = extraInfo.protectTime or 0
          local isCrossServerThrone = extraInfo.state == AllianceCityState.SERVER_NEUTRAL or extraInfo.state == AllianceCityState.SERVER_OCCUPIED or extraInfo.state == AllianceCityState.SERVER_BUILD_THRONE
          if isCrossServerThrone then
            if CS.CommonUtils.IsDebug() then
              Logger.Log(string.format("[Debug] [%s]\229\164\132\228\186\142\232\183\168\229\155\189\231\142\139\229\186\167\230\136\152\230\156\159\233\151\180, state = %s", cityData.id, extraInfo.state))
            end
            if cityData:IsThroneCity() then
              local totalPoint = SeasonUtil.GetWorldBattleTotalPoint(pointInfo.serverId)
              if totalPoint <= extraInfo.buildPoint then
                extraInfo.state = AllianceCityState.SERVER_OCCUPIED
              end
            elseif cityData:IsThroneCityBattery() or cityData:IsMissileFactory() then
              DataCenter.AllianceCityTipManager:RefreshAllianceCityName()
            end
            if curTime > timeEnd and CS.CommonUtils.IsDebug() then
              Logger.Log(string.format("[Debug] \230\149\176\230\141\174\233\148\153\232\175\175 [%s]\229\164\132\228\186\142\232\183\168\229\155\189\231\142\139\229\186\167\230\136\152\230\156\159\233\151\180, state = %s", cityData.id, extraInfo.state))
              Logger.Log("THRONE.openTime = " .. timeOpen)
              Logger.Log("THRONE.protectTime = " .. timeEnd)
            end
            if curTime < timeOpen then
              if cityData:IsThroneCityBattery() or cityData:IsMissileFactory() then
                self:ShowBuildProtectEffect(pointId, pointId, timeOpen, 7, WorldAllianceBuildUtil.GetCityShellEffPath(), 0.5, self:GetPointModelParent(pointId, pointInfo), 5)
              else
                self:ShowBuildProtectEffect(pointId, pointId, timeOpen, 7, WorldAllianceBuildUtil.GetKingDomeShellEffPath(), nil, self:GetPointModelParent(pointId, pointInfo), 5)
              end
            elseif extraInfo.state == AllianceCityState.SERVER_OCCUPIED or curTime > timeEnd then
              if cityData:IsThroneCityBattery() or cityData:IsMissileFactory() then
                self:ShowBuildProtectEffect(pointId, pointId, curTime + 36000, 7, WorldAllianceBuildUtil.GetCityShellEffPath(), 0.5, self:GetPointModelParent(pointId, pointInfo), 5)
              else
                self:ShowBuildProtectEffect(pointId, pointId, curTime + 36000, 7, WorldAllianceBuildUtil.GetKingDomeShellEffPath(), nil, self:GetPointModelParent(pointId, pointInfo), 5)
              end
            else
              self:RemoveBuildProtectEffect(pointId)
            end
            return
          end
          local protectEndTime = 0
          if CS.CommonUtils.IsDebug() then
            Logger.Log(string.format("[Debug] [%s]\228\191\157\230\138\164\231\189\169, state = %s [%s] [%s] [%s]", cityData.id, extraInfo.state, UITimeManager:GetInstance():ConvertServerTimeToLocalTime(timeOpen * 1000), UITimeManager:GetInstance():ConvertServerTimeToLocalTime(curTime * 1000), UITimeManager:GetInstance():ConvertServerTimeToLocalTime(timeEnd * 1000)))
          end
          if curTime > timeOpen and curTime > timeEnd then
            if CS.CommonUtils.IsDebug() then
              Logger.Log(string.format("[Debug] [%s] \230\149\176\230\141\174\230\156\137\233\148\153,\228\184\141\229\186\148\232\175\165\233\131\189\229\176\143\228\186\142\229\189\147\229\137\141\230\151\182\233\151\180, state = %s", cityData.id, extraInfo.state))
            end
            protectEndTime = curTime + 36000
          elseif curTime > timeOpen and curTime < timeEnd then
            if cityData:IsThroneCityBattery() or cityData:IsMissileFactory() then
              protectEndTime = timeEnd
            else
              local activityServerData = DataCenter.GovernmentManager.activityServerData
              if activityServerData ~= nil and activityServerData.actFightStep == 2 then
                if CS.CommonUtils.IsDebug() then
                  Logger.Log(string.format("[Debug] [%s]\230\136\152\230\150\151\231\187\147\230\157\159\230\152\190\231\164\186\228\191\157\230\138\164\231\189\169, state = %s", cityData.id, extraInfo.state))
                end
                protectEndTime = timeEnd
              else
                protectEndTime = 0
              end
            end
          elseif curTime < timeOpen then
            protectEndTime = timeOpen
          else
            protectEndTime = curTime + 36000
            goto lbl_348
            protectEndTime = curTime + OneDayTime * 1000
          end
          ::lbl_348::
          if protectEndTime ~= 0 then
            if cityData:IsThroneCityBattery() or cityData:IsMissileFactory() then
              self:ShowBuildProtectEffect(pointId, pointId, protectEndTime, 7, WorldAllianceBuildUtil.GetCityShellEffPath(), 0.5, self:GetPointModelParent(pointId, pointInfo), 5)
            else
              self:ShowBuildProtectEffect(pointId, pointId, protectEndTime, 7, WorldAllianceBuildUtil.GetKingDomeShellEffPath(), nil, self:GetPointModelParent(pointId, pointInfo), 5)
            end
          end
        end
      end
    elseif cityData ~= nil and (cityData:IsLLThroneCity() or cityData:IsLLCity() or cityData:IsLLCityCanon() or cityData:IsLLBuffCity()) then
      local pointInfo = CS.SceneManager.World:GetPointInfo(pointId)
      if pointInfo then
        local bUuid = pointInfo.uuid
        local protectEndTime = 0
        local clientState = pointInfo.curClientState
        if clientState == LLConst.LLBuildingState.Rebuilding then
          protectEndTime = pointInfo.fixEndTime / 1000
        elseif clientState == LLConst.LLBuildingState.NotOpen then
          protectEndTime = DataCenter.LandlordMgr:GetLLCityNextOpenTimeByCityId(pointInfo.cityId) / 1000
        elseif clientState == LLConst.LLBuildingState.OpenButShield then
          protectEndTime = pointInfo.unlockTime / 1000
        end
        local scale = 0.7
        if cityData:IsLLThroneCity() then
          scale = 1
        elseif cityData:IsLLCityCanon() then
          scale = 0.5
        elseif cityData:IsLLBigCity() then
          scale = 1
        end
        if 0 < protectEndTime then
          self:ShowBuildProtectEffect(bUuid, pointId, protectEndTime, 7, WorldAllianceBuildUtil.GetCityShellEffPath(), scale, self:GetPointModelParent(pointId, pointInfo), 5)
        else
          self:RemoveBuildProtectEffect(bUuid)
        end
      end
    end
  else
    temp:Show()
  end
end

local function HideDome(self, bUuid)
  local temp = self.allEffect[bUuid]
  if temp ~= nil then
    local info = CS.SceneManager.World:GetPointInfoByUuid(bUuid)
    if info ~= nil then
      cast(info, typeof(CS.BuildPointInfo))
      if info.itemId == BuildingTypes.FUN_BUILD_MAIN and info.ownerUid == LuaEntry.Player.uid then
        temp:Hide()
      end
    end
  end
end

local function RemoveBuildingStatusEffectByUuid(self, uuid)
  if self.buildingStatusEffect[uuid] ~= nil then
    for k, v in pairs(self.buildingStatusEffect[uuid]) do
      v:OnDestroy()
    end
    self.buildingStatusEffect[uuid] = nil
  end
  for k, v in pairs(self.StatusTypeBuildingEffobj) do
    if v[uuid] ~= nil then
      v[uuid]:OnDestroy()
      v[uuid]:Delete()
      v[uuid] = nil
    end
  end
end

local function RefreshBuildingStatusByInfo(self, info)
  local statueCalData = {}
  local statueTypeCalData = {}
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local status = info.status
  if status ~= nil then
    for i = 1, status.Count do
      local v = status[i - 1]
      local id = v.Id
      local expireTime = v.ExpireTime
      if curTime < expireTime then
        local statueType2 = DataCenter.StatusManager:GetStatusType2(id)
        if statueType2 == StatusType2.MusicFestivalSkill then
          if statueCalData[id] == nil then
            statueCalData[id] = 0
          end
          if expireTime > statueCalData[id] then
            statueCalData[id] = expireTime
          end
        elseif statueType2 == StatusType2.BuildingRewardEffect or statueType2 == StatusType2.BuildingEffect then
          if statueTypeCalData[statueType2] == nil then
            statueTypeCalData[statueType2] = {}
          end
          if statueTypeCalData[statueType2][id] == nil then
            statueTypeCalData[statueType2][id] = 0
          end
          if expireTime > statueTypeCalData[statueType2][id] then
            statueTypeCalData[statueType2][id] = expireTime
          end
        elseif statueType2 == StatusType2.BuildingRewardBubble1 or statueType2 == StatusType2.BuildingRewardBubble2 then
          local isInCrossServer = false
          local player = LuaEntry.Player
          if not player:IsInSourceServer() or player:GetCurServerId() ~= player:GetSelfServerId() then
            isInCrossServer = true
          end
          local ownerUid = info.ownerUid
          if ownerUid ~= LuaEntry.Player.uid and not isInCrossServer and info.serverId == info.srcServerId then
            local isGet = DataCenter.ActGiftGivingDataManager:GetActivityStatusReceiveDict(id, ownerUid)
            if not isGet then
              local targetType = StatusType2.BuildingRewardBubble1
              if statueTypeCalData[targetType] == nil then
                statueTypeCalData[targetType] = {}
              end
              if statueTypeCalData[targetType][id] == nil then
                statueTypeCalData[targetType][id] = 0
              end
              if expireTime > statueTypeCalData[targetType][id] then
                statueTypeCalData[targetType][id] = expireTime
              end
            end
          end
        elseif statueType2 == StatusType2.BuildingRewardBubble3 then
          local isInCrossServer = false
          local player = LuaEntry.Player
          local ownerUid = info.ownerUid
          if not isInCrossServer then
            local isGet = DataCenter.ActivityReceiveDataManager:GetActivityStatusReceiveDict(id, ownerUid)
            if not isGet then
              local targetType = StatusType2.BuildingRewardBubble3
              if statueTypeCalData[targetType] == nil then
                statueTypeCalData[targetType] = {}
              end
              if statueTypeCalData[targetType][id] == nil then
                statueTypeCalData[targetType][id] = 0
              end
              if expireTime > statueTypeCalData[targetType][id] then
                statueTypeCalData[targetType][id] = expireTime
              end
            end
          end
        elseif statueType2 == StatusType2.MusicFestival2025_RewardBubble then
          local isInCrossServer = false
          local player = LuaEntry.Player
          if not player:IsInSourceServer() or player:GetCurServerId() ~= player:GetSelfServerId() or BattleFieldUtil.InBattleField() then
            isInCrossServer = true
          end
          local ownerUid = info.ownerUid
          if not isInCrossServer and info.serverId == info.srcServerId then
            local isGet = DataCenter.ActivityReceiveDataManager:GetActivityStatusReceiveDict(id, ownerUid)
            if not isGet then
              local targetType = StatusType2.MusicFestival2025_RewardBubble
              statueTypeCalData[targetType] = statueTypeCalData[targetType] or {}
              statueTypeCalData[targetType][id] = statueTypeCalData[targetType][id] or 0
              if expireTime > statueTypeCalData[targetType][id] then
                statueTypeCalData[targetType][id] = expireTime
              end
            end
          end
        end
      end
    end
  end
  if self.buildingStatusEffect[info.uuid] == nil then
    self.buildingStatusEffect[info.uuid] = {}
  end
  for musicId, effect in pairs(self.buildingStatusEffect[info.uuid]) do
    if statueCalData[musicId] == nil then
      self.buildingStatusEffect[info.uuid][musicId]:OnDestroy()
      self.buildingStatusEffect[info.uuid][musicId] = nil
    else
      self.buildingStatusEffect[info.uuid][musicId]:ReInit(self.lod, info.pointIndex, statueCalData[musicId], musicId)
    end
  end
  for musicId, expireTime in pairs(statueCalData) do
    if self.buildingStatusEffect[info.uuid][musicId] == nil then
      local effect = MusicEffect.New()
      effect:OnCreate()
      effect:ReInit(self.lod, info.pointIndex, expireTime, musicId)
      self.buildingStatusEffect[info.uuid][musicId] = effect
    end
  end
  local needRefreshStatusType = {
    StatusType2.BuildingRewardEffect,
    StatusType2.BuildingRewardBubble1,
    StatusType2.BuildingEffect,
    StatusType2.BuildingRewardBubble3,
    StatusType2.MusicFestival2025_RewardBubble
  }
  for _, statusType in ipairs(needRefreshStatusType) do
    if self.StatusTypeBuildingEffobj[statusType] == nil then
      self.StatusTypeBuildingEffobj[statusType] = {}
    end
    if self.StatusTypeBuildingEffobj[statusType][info.uuid] then
      if statueTypeCalData[statusType] == nil then
        self.StatusTypeBuildingEffobj[statusType][info.uuid]:OnDestroy()
        self.StatusTypeBuildingEffobj[statusType][info.uuid]:Delete()
        self.StatusTypeBuildingEffobj[statusType][info.uuid] = nil
      else
        local param = statueTypeCalData[statusType]
        local extraParam = self:GetExtraParamByStatusType(statusType, info)
        self.StatusTypeBuildingEffobj[statusType][info.uuid]:ReInit(self.lod, info.pointIndex, info.uuid, param, extraParam, info.serverId)
      end
    elseif statueTypeCalData[statusType] then
      local param = statueTypeCalData[statusType]
      local extraParam = self:GetExtraParamByStatusType(statusType, info)
      local effect = self:GetEffectScriptByStatusType(statusType)
      if effect then
        effect:OnCreate()
        effect:ReInit(self.lod, info.pointIndex, info.uuid, param, extraParam, info.serverId)
        self.StatusTypeBuildingEffobj[statusType][info.uuid] = effect
      end
    end
  end
end

function CityDomeProtectEffectManager:GetExtraParamByStatusType(statusType, info)
  if statusType == StatusType2.BuildingRewardBubble1 or statusType == StatusType2.BuildingRewardBubble3 then
    return {
      ownerUid = info.ownerUid
    }
  elseif statusType == StatusType2.MusicFestival2025_RewardBubble then
    local status = info.status
    if status == nil then
      return nil
    end
    for i = 1, status.Count do
      local v = status[i - 1]
      local id = v.Id
      local statueType2 = DataCenter.StatusManager:GetStatusType2(id)
      if statueType2 == statusType then
        return {
          status = v,
          playerUid = info.ownerUid,
          playerName = info.playerName
        }
      end
    end
  elseif statusType == StatusType2.BuildingEffect then
    return {
      serverId = info.serverId
    }
  end
  return nil
end

function CityDomeProtectEffectManager:GetEffectScriptByStatusType(statusType)
  if statusType == StatusType2.BuildingRewardEffect or statusType == StatusType2.BuildingEffect then
    return BuildingShowEffect.New()
  elseif statusType == StatusType2.BuildingRewardBubble1 then
    return BuildingRewardBubbleEffect.New()
  elseif statusType == StatusType2.BuildingRewardBubble3 then
    return BuildingGetRewardBubbleEffect.New()
  elseif statusType == StatusType2.MusicFestival2025_RewardBubble then
    return MusicFestival2025_BubbleEffect.New()
  end
  return nil
end

function CityDomeProtectEffectManager.RefreshGetBuildMainPartyRewardShow(playerUid)
  local self = CityDomeProtectEffectManager:GetInstance()
  local statusType = StatusType2.MusicFestival2025_RewardBubble
  if self.StatusTypeBuildingEffobj == nil or self.StatusTypeBuildingEffobj[statusType] == nil then
    return
  end
  for k, v in pairs(self.StatusTypeBuildingEffobj[statusType]) do
    local script = v
    if v.playerUid == playerUid then
      script:TryRefreshShow()
    end
  end
end

local function OnWorldRewardBubbleGetMsg()
  local self = CityDomeProtectEffectManager:GetInstance()
  local targetType = StatusType2.BuildingRewardBubble1
  if self.StatusTypeBuildingEffobj[targetType] == nil then
    return
  end
  for k, v in pairs(self.StatusTypeBuildingEffobj[targetType]) do
    v:TryRefreshShow()
  end
end

local function OnWorldGetRewardBubbleGetMsg()
  local self = CityDomeProtectEffectManager:GetInstance()
  local targetType = StatusType2.BuildingRewardBubble3
  if self.StatusTypeBuildingEffobj[targetType] == nil then
    return
  end
  for k, v in pairs(self.StatusTypeBuildingEffobj[targetType]) do
    v:TryRefreshShow()
  end
end

local function RemoveAllBuildingStatusEffect(self)
  for k, v in pairs(self.buildingStatusEffect) do
    for kk, vv in pairs(v) do
      vv:OnDestroy()
    end
  end
  self.buildingStatusEffect = {}
  for k, v in pairs(self.StatusTypeBuildingEffobj) do
    for kk, vv in pairs(v) do
      vv:OnDestroy()
    end
  end
  self.StatusTypeBuildingEffobj = {}
end

local function SetAllBuildingStatusEffectIsShow(self, lod)
  for k, v in pairs(self.buildingStatusEffect) do
    for kk, vv in pairs(v) do
      vv:SetLod(lod)
    end
  end
  for k, v in pairs(self.StatusTypeBuildingEffobj) do
    for kk, vv in pairs(v) do
      vv:SetLod(lod)
    end
  end
end

local _PREFAB_EPIDEMIC = "Assets/Main/Prefabs/World/BF_Epidemic/EpidemicFix.prefab"

function CityDomeProtectEffectManager:ShowEpidemic(info, flag)
  if not BattleFieldUtil.InBattleField() then
    return
  end
  if info == nil or info.itemId ~= BuildingTypes.WORM_HOLE_CROSS then
    return
  end
  local key = info.uuid .. "_epidemic"
  local effect = self.allEffect[key]
  if effect ~= nil then
    effect:ReInit(info.uuid)
    return
  end
  local obj = CS.SceneManager.World:GetObjectByPoint(info.mainIndex)
  local gameObject = obj ~= nil and obj:GetGameObject() or nil
  if gameObject == nil then
    return
  end
  local theCityLabel = gameObject.transform:Find("ModelGo/CityLabel")
  if theCityLabel == nil then
    theCityLabel = gameObject.transform:Find("Model/CityLabel")
  end
  if theCityLabel == nil then
    return
  end
  local goName = "Epidemic"
  local theTransform = theCityLabel.transform:Find(goName)
  if theTransform ~= nil then
    local effectEpidemic = self.allEffect[key]
    if effectEpidemic ~= nil then
      effectEpidemic:ReInit(info.uuid)
    end
    return
  elseif not flag then
    return
  end
  if self.OnCreateEffect[key] ~= nil then
    return
  end
  local request = ResourceManager:InstantiateAsync(_PREFAB_EPIDEMIC)
  self.OnCreateEffect[key] = request
  request:completed("+", function()
    if request.isError or IsNull(theCityLabel) then
      request:Destroy()
      self.OnCreateEffect[key] = nil
      return
    end
    local go = request.gameObject
    go.name = goName
    go:SetActive(true)
    go.transform:SetParent(theCityLabel)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.transform:Set_localPosition(0, 0, 0)
    local effectEpidemic = EpidemicEffect.New()
    effectEpidemic:OnCreate(go)
    effectEpidemic:ReInit(info.uuid)
    self.allEffect[key] = effectEpidemic
  end)
end

function CityDomeProtectEffectManager:RemoveEpidemic(uuid)
  local key = uuid .. "_epidemic"
  local effect = self.allEffect[key]
  if effect ~= nil then
    effect:OnDestroy()
    self.allEffect[key] = nil
  end
  local req = self.OnCreateEffect[key]
  if req then
    req:Destroy()
    self.OnCreateEffect[key] = nil
  end
end

CityDomeProtectEffectManager.__init = __init
CityDomeProtectEffectManager.__delete = __delete
CityDomeProtectEffectManager.AddListener = AddListener
CityDomeProtectEffectManager.RemoveListener = RemoveListener
CityDomeProtectEffectManager.BuildInViewSignal = BuildInViewSignal
CityDomeProtectEffectManager.BuildOutViewSignal = BuildOutViewSignal
CityDomeProtectEffectManager.RemoveBuildProtectEffect = RemoveBuildProtectEffect
CityDomeProtectEffectManager.CheckShowEffect = CheckShowEffect
CityDomeProtectEffectManager.ShowBuildProtectEffect = ShowBuildProtectEffect
CityDomeProtectEffectManager.TimeCallBack = TimeCallBack
CityDomeProtectEffectManager.ShowDome = ShowDome
CityDomeProtectEffectManager.HideDome = HideDome
CityDomeProtectEffectManager.CityDomeHideSignal = CityDomeHideSignal
CityDomeProtectEffectManager.CityDomeShowSignal = CityDomeShowSignal
CityDomeProtectEffectManager.RemoveAllEffect = RemoveAllEffect
CityDomeProtectEffectManager.RemoveAllTips = RemoveAllTips
CityDomeProtectEffectManager.ChangeCameraLodSignal = ChangeCameraLodSignal
CityDomeProtectEffectManager.OnCameraChangeLod = OnCameraChangeLod
CityDomeProtectEffectManager.RemoveBuildingStatusEffectByUuid = RemoveBuildingStatusEffectByUuid
CityDomeProtectEffectManager.RefreshBuildingStatusByInfo = RefreshBuildingStatusByInfo
CityDomeProtectEffectManager.RemoveAllBuildingStatusEffect = RemoveAllBuildingStatusEffect
CityDomeProtectEffectManager.SetAllBuildingStatusEffectIsShow = SetAllBuildingStatusEffectIsShow
CityDomeProtectEffectManager.OnWorldRewardBubbleGetMsg = OnWorldRewardBubbleGetMsg
CityDomeProtectEffectManager.OnWorldGetRewardBubbleGetMsg = OnWorldGetRewardBubbleGetMsg
return CityDomeProtectEffectManager
