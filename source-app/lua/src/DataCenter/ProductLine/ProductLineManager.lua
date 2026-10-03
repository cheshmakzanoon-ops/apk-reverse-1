local ProductLineManager = BaseClass("ProductLineManager")
local Resource = CS.GameEntry.Resource
local Setting = CS.GameEntry.Setting
local CollectEffectDuration = 3
local ProductLineCollectAudio = {
  [BuildingTypes.LW_BUILD_FARMLAND] = SoundAssetId.Music_Effect_get_food,
  [BuildingTypes.LW_BUILD_QUARRY] = SoundAssetId.Music_Effect_get_iron,
  [BuildingTypes.LW_BUILD_GOLD_MILL] = SoundAssetId.Music_Effect_get_coin,
  [BuildingTypes.LW_BUILD_SMELTERY] = SoundAssetId.Music_Effect_click_material_box,
  [BuildingTypes.LW_BUILD_TRAINING_CENTER] = SoundAssetId.Music_Effect_get_exp,
  [BuildingTypes.LW_BUILD_MATERIALS_WORKERSHOP] = SoundAssetId.Music_Effect_click_treaures,
  [BuildingTypes.LW_BUILD_SQUAD_EQUIP_FACTORY] = SoundAssetId.Music_Effect_click_treaures,
  [BuildingTypes.LW_BUILD_PETROLEUM] = SoundAssetId.Music_Effect_get_food,
  [BuildingTypes.LW_BUILD_DOMINATOR_TRAIN] = SoundAssetId.Music_Effect_get_exp
}

local function __init(self)
  self:OnAddListener()
  self.timer = {}
  self.collectTimeCache = 0
  self.oneKeyResSettingOn = Setting:GetBool(SettingKeys.ONE_KEY_COLLECT_RES, false) and Setting:GetBool(SettingKeys.SHAKE_COLLECT_RES, true)
end

local function __delete(self)
  self:OnRemoveListener()
  for _, timer in ipairs(self.timer) do
    timer:Stop()
  end
  self.collectTimeCache = nil
  self.oneKeyResSettingOn = nil
end

local function OnAddListener(self)
  EventManager:GetInstance():AddListener(EventId.UPDATE_BUILD_DATA, self.OnBuildDataUpdate)
  EventManager:GetInstance():AddListener(EventId.ResourceUpdated, self.OnResourceOrItemUpdate)
  EventManager:GetInstance():AddListener(EventId.RefreshResourceItem, self.OnResourceOrItemUpdate)
  EventManager:GetInstance():AddListener(EventId.BuildingHeroDispatching, self.OnBuildingHeroDispatching)
  EventManager:GetInstance():AddListener(EventId.RefreshOneKeyCollectResSetting, self.RefreshOneKeyResSetting)
end

local function OnRemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.UPDATE_BUILD_DATA, self.OnBuildDataUpdate)
  EventManager:GetInstance():RemoveListener(EventId.ResourceUpdated, self.OnResourceOrItemUpdate)
  EventManager:GetInstance():RemoveListener(EventId.RefreshResourceItem, self.OnResourceOrItemUpdate)
  EventManager:GetInstance():RemoveListener(EventId.BuildingHeroDispatching, self.OnBuildingHeroDispatching)
  EventManager:GetInstance():RemoveListener(EventId.RefreshOneKeyCollectResSetting, self.RefreshOneKeyResSetting)
end

local function IsProductLineBuild(self, buildId)
  local dict = self:GetAllBuildIds()
  return dict ~= nil and dict[buildId] == true
end

local theProductLineBuildsDict

local function GetAllBuildIds(self)
  if theProductLineBuildsDict ~= nil then
    return theProductLineBuildsDict
  end
  theProductLineBuildsDict = {}
  for _, v in ipairs(ProductLineBuilds) do
    theProductLineBuildsDict[v] = true
  end
  local config = SeasonUtil.GetSeasonWeekCardConfig()
  if config ~= nil then
    local farm_building_weekcard = toInt(config.farm_building_weekcard)
    if 0 < farm_building_weekcard then
      theProductLineBuildsDict[farm_building_weekcard] = true
    end
    local farm_building = config.farm_building
    if farm_building ~= nil and type(farm_building) == "string" then
      local arr = string.split_ii_array(farm_building, "|")
      for _, buildId in ipairs(arr) do
        theProductLineBuildsDict[buildId] = true
      end
    end
  end
  return theProductLineBuildsDict
end

local function GetCollectAudioName(self, itemId)
  if self:IsProductLineBuild(itemId) then
    return ProductLineCollectAudio[itemId]
  end
  return 0
end

local function GetAllBuildUuids(self)
  local bUuids = {}
  local i = 1
  local dictBuild = self:GetAllBuildIds()
  for buildId, _ in pairs(dictBuild) do
    local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
    for _, buildData in ipairs(list) do
      bUuids[i] = buildData.uuid
      i = i + 1
    end
  end
  return bUuids
end

function ProductLineManager:DoActionForAllBuildUuids(action)
  local dictBuild = self:GetAllBuildIds()
  for buildId, _ in pairs(dictBuild) do
    local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
    for _, buildData in ipairs(list) do
      action(buildData.uuid)
    end
  end
end

local function GetBuildUuidsByProductRes(self, resType)
  local bUuids = {}
  local dictBuild = self:GetAllBuildIds()
  for buildId, _ in pairs(dictBuild) do
    local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
    for _, buildData in ipairs(list) do
      local resDict = self:GetProductRes(buildData.uuid)
      if resDict[resType] ~= nil then
        table.insert(bUuids, buildData.uuid)
      end
    end
  end
  return bUuids
end

local function GetBuildUuidsByProductResItem(self, itemId)
  local bUuids = {}
  local dictBuild = self:GetAllBuildIds()
  for buildId, _ in pairs(dictBuild) do
    local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
    for _, buildData in ipairs(list) do
      local resItemDict = self:GetProductResItem(buildData.uuid)
      if resItemDict[itemId] ~= nil then
        table.insert(bUuids, buildData.uuid)
      end
    end
  end
  return bUuids
end

local function GetBuildUuidsByProductGoods(self, itemId)
  local bUuids = {}
  local dictBuild = self:GetAllBuildIds()
  for buildId, _ in pairs(dictBuild) do
    local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
    for _, buildData in ipairs(list) do
      local resItemDict = self:GetProductGoods(buildData.uuid)
      if resItemDict[itemId] ~= nil then
        table.insert(bUuids, buildData.uuid)
      end
    end
  end
  return bUuids
end

local function GetState(self, bUuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData == nil or buildData.level <= 0 then
    return ProductLineState.None
  end
  if 0 > self:GetNextCollectTime(bUuid) then
    return ProductLineState.Full
  end
  return ProductLineState.Normal
end

local function GetBubbleIcon(self, bUuid)
  local icon = ""
  local state = self:GetState(bUuid)
  if state == ProductLineState.NoHero then
    icon = string.format(LoadPath.ItemPath, "cfm_zhujiemian_qipao_gongren")
  elseif state == ProductLineState.Normal or state == ProductLineState.Full then
    local type = self.GetResType(bUuid)
    local itemId
    if type == CommonCostNeedType.Resource then
      itemId = table.keys(self:GetProductRes(bUuid))[1]
      icon = DataCenter.ResourceManager:GetResourceIconByType(itemId)
    elseif type == CommonCostNeedType.ResourceItem then
      itemId = table.keys(self:GetProductResItem(bUuid))[1]
      icon = DataCenter.ResourceItemDataManager:GetIconPath(itemId)
    elseif type == CommonCostNeedType.Goods then
      itemId = table.keys(self:GetProductGoods(bUuid))[1]
      icon = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, itemId)
    end
  end
  return icon
end

local function GetResType(bUuid)
  local buildLevelTemplate = DataCenter.BuildManager:GetBuildLevelTemplateByUuid(bUuid)
  if table.count(buildLevelTemplate.produce_gain_consume) > 0 then
    return CommonCostNeedType.Resource
  elseif 0 < table.count(buildLevelTemplate.produce_gain_resource) then
    return CommonCostNeedType.ResourceItem
  elseif 0 < table.count(buildLevelTemplate.produce_goods) then
    return CommonCostNeedType.Goods
  else
    return 0
  end
end

local function GetBubbleScale(self, bUuid)
  local type = GetResType(bUuid)
  if type == CommonCostNeedType.ResourceItem then
    return Vector3.New(1.2, 1.2, 1.2)
  elseif type == CommonCostNeedType.Goods then
    return Vector3.New(1.2, 1.2, 1.2)
  else
    return Vector3.New(2.3, 2.3, 2.3)
  end
end

local function GetStorageResItem(self, bUuid)
  local buildLevelTemplate = DataCenter.BuildManager:GetBuildLevelTemplateByUuid(bUuid)
  if buildLevelTemplate == nil then
    return {}
  end
  return buildLevelTemplate.storage_resource
end

local function GetCostRes(self, bUuid)
  local buildLevelTemplate = DataCenter.BuildManager:GetBuildLevelTemplateByUuid(bUuid)
  if buildLevelTemplate == nil then
    return {}
  end
  return buildLevelTemplate.produce_cost_consume
end

local function GetCostResItem(self, bUuid)
  local buildLevelTemplate = DataCenter.BuildManager:GetBuildLevelTemplateByUuid(bUuid)
  if buildLevelTemplate == nil then
    return {}
  end
  return buildLevelTemplate.produce_cost_resource
end

local function GetProductRes(self, bUuid)
  local buildLevelTemplate = DataCenter.BuildManager:GetBuildLevelTemplateByUuid(bUuid)
  if buildLevelTemplate == nil then
    return {}
  end
  return buildLevelTemplate.produce_gain_consume
end

local function GetProductResItem(self, bUuid)
  local buildLevelTemplate = DataCenter.BuildManager:GetBuildLevelTemplateByUuid(bUuid)
  if buildLevelTemplate == nil then
    return {}
  end
  return buildLevelTemplate.produce_gain_resource
end

local function GetProductGoods(self, bUuid)
  local buildLevelTemplate = DataCenter.BuildManager:GetBuildLevelTemplateByUuid(bUuid)
  if buildLevelTemplate == nil then
    return {}
  end
  return buildLevelTemplate.produce_goods
end

local function GetBuildingCurrStorage(self, bUuid)
  local cur = 0
  self:TryCollectRes(bUuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData then
    cur = buildData.prodExtend
  end
  return cur
end

local function GetBuildingWorkerEffect(self, bUuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  local buff = 0
  for key, value in pairs(buildData.assignedHeroList) do
    local wUuid = tonumber(value)
    if wUuid then
      local workerData = DataCenter.WorkerDataManager:GetWorkerDataByUid(wUuid)
      if workerData then
        local effectId = workerData.peculiarity
        local effectVal = workerData:GetWorkerProperty(effectId)
        if 0 < effectVal then
          buff = buff + effectVal
        end
      else
        Logger.LogError("worker data is nil uuid : " .. wUuid)
      end
    end
  end
  return buff
end

local function GetBuildProduceNum(self, bUuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
  if buildLevelTemplate == nil then
    return 0
  end
  local data = buildLevelTemplate.produce_gain_consume or {}
  local num = data[table.keys(data)[1]]
  if num == nil then
    data = buildLevelTemplate.produce_gain_resource or {}
    num = data[table.keys(data)[1]]
  end
  if num == nil then
    data = buildLevelTemplate.produce_goods or {}
    num = data[table.keys(data)[1]]
  end
  num = num and num * (1 + self:GetBuildingWorkerEffect(bUuid) + self:GetAdditionTechnological(buildData))
  return num or 0
end

local function GetNextCollectTime(self, bUuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData == nil then
    return -1
  end
  local buildLevelTemplate = DataCenter.BuildManager:GetBuildLevelTemplateByUuid(bUuid)
  if buildLevelTemplate == nil then
    return -1
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if not buildData.productStartTime then
    return -1
  end
  local endTime = buildData.productEndTime or 0
  local num = self:GetBuildProduceNum(bUuid)
  local totalProduct = (endTime - buildData.productTime) * num // buildLevelTemplate.produce_time
  local realEndTime = totalProduct / num * buildLevelTemplate.produce_time + buildData.productTime
  if curTime < endTime then
    buildData.productTime = (buildData.productTime - buildData.productStartTime) // buildLevelTemplate.produce_time * buildLevelTemplate.produce_time + buildData.productStartTime
  end
  if curTime > endTime then
    return -1
  end
  if realEndTime < buildData.productTime + buildLevelTemplate.produce_time then
    return endTime
  end
  return buildData.productTime + buildLevelTemplate.produce_time
end

local function SetCollectTime(self, bUuid, time)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData == nil then
    return
  end
  buildData.productTime = time
end

local additionTechnological = {
  [10207000] = 50101,
  [10201000] = 50023,
  [10202000] = 50024,
  [10203000] = 50102,
  [10206000] = 50103,
  [10208000] = 50104,
  [10103000] = 50105,
  [10221000] = 50219
}

local function TryCollectRes(self, bUuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData == nil then
    return
  end
  local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
  if buildLevelTemplate == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local nextTime = self:GetNextCollectTime(bUuid)
  buildData.prodExtend = buildData.prodExtend or 0
  if curTime > buildData.productTime and buildData.productTime < buildData.productEndTime then
    local cnt = (math.min(buildData.productEndTime, curTime) - buildData.productTime) // buildLevelTemplate.produce_time
    local num = self:GetBuildProduceNum(bUuid)
    if 0 < cnt then
      if false then
        Logger.Log(">>>>>>>> prod = " .. buildData.prodExtend .. ", num = " .. num .. ", cnt = " .. cnt .. ", effect = " .. self:GetBuildingWorkerEffect(bUuid) .. ", total = " .. buildData.prodExtend + num * cnt * self:GetBuildingWorkerEffect(bUuid) .. ", bUuid = " .. bUuid)
        Logger.Log(">>>>>>>> curTime = " .. curTime .. ", productTime = " .. buildData.productTime .. ", nextTime = " .. buildData.productTime + cnt * buildLevelTemplate.produce_time .. ", bUuid = " .. bUuid)
      end
      buildData.prodExtend = buildData.prodExtend + num * cnt
      nextTime = buildData.productTime + cnt * buildLevelTemplate.produce_time
      self:SetCollectTime(bUuid, nextTime)
    elseif curTime >= buildData.productEndTime then
      buildData.prodExtend = buildData.prodExtend + num * (buildData.productEndTime - buildData.productTime) // buildLevelTemplate.produce_time
      self:SetCollectTime(bUuid, buildData.productEndTime)
    end
  end
end

local function GetAdditionTechnological(self, buildData)
  local addition = 0
  if buildData then
    local effectId = additionTechnological[buildData.itemId]
    if effectId then
      addition = addition + LuaEntry.Effect:GetGameEffect(effectId)
      addition = addition + SeasonUtil.GetSeasonBuffValue(effectId)
    end
  end
  return addition
end

local function ProductionTimer(self, bUuid)
  if self.timer[bUuid] then
    self.timer[bUuid]:Stop()
  end
  local nextTime = -1
  local state = self:GetState(bUuid)
  if state == ProductLineState.Normal then
    nextTime = self:GetNextCollectTime(bUuid)
  end
  self:TryCollectRes(bUuid)
  if nextTime ~= -1 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local delay = (nextTime - curTime) / 1000
    delay = math.max(delay, 1)
    self.timer[bUuid] = TimerManager:GetInstance():DelayInvoke(function()
      self.timer[bUuid] = nil
      self:ProductionTimer(bUuid)
    end, delay)
  else
    DataCenter.BuildBubbleManager:RefreshBubbleShow(BuildBubbleType.ProductLineNormal)
    DataCenter.BuildBubbleManager:RefreshBubbleShow(BuildBubbleType.ProductLineFull)
  end
end

local function RestartTimer(self)
  if not self.bindProductionTimer then
    function self.bindProductionTimer(bUuid)
      self:ProductionTimer(bUuid)
    end
  end
  self:DoActionForAllBuildUuids(self.bindProductionTimer)
end

local function ShowCollectEffectByMessage(self, message)
  local uid = message.buildInfo.uuid
  local resType, icon
  local buildResType = self.GetResType(uid)
  if buildResType == CommonCostNeedType.Resource or buildResType == CommonCostNeedType.ResourceItem then
    if self.GetResType(uid) == CommonCostNeedType.Resource then
      resType = table.keys(self:GetProductRes(message.buildInfo.uuid))[1]
      icon = DataCenter.ResourceManager:GetResourceIconByType(resType)
    elseif self.GetResType(uid) == CommonCostNeedType.ResourceItem then
      resType = table.keys(self:GetProductResItem(message.buildInfo.uuid))[1]
      icon = DataCenter.ResourceItemDataManager:GetIconPath(resType)
    end
    local count = message.resNum
    self:ShowCollectEffectForBuilding(message.buildInfo.uuid, icon, count)
    local pos = CS.CSUtils.WorldPositionToUISpacePosition(SceneUtils.TileIndexToWorld(DataCenter.BuildManager:GetBuildingDataByUuid(message.buildInfo.uuid).pointId))
    local type = ResTypeToReward[resType]
    local cfg = {
      {
        pos,
        {
          rewardType = type and type or tonumber(resType)
        }
      }
    }
    EventManager:GetInstance():Broadcast(EventId.UIMainFlyReward, cfg)
  end
  if self.GetResType(uid) == CommonCostNeedType.Goods then
    resType = table.keys(self:GetProductGoods(message.buildInfo.uuid))[1]
    icon = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, resType)
    local count = message.resNum
    self:ShowCollectEffectForBuilding(message.buildInfo.uuid, icon, count)
    local pos = CS.CSUtils.WorldPositionToUISpacePosition(SceneUtils.TileIndexToWorld(DataCenter.BuildManager:GetBuildingDataByUuid(message.buildInfo.uuid).pointId))
    local cfg = {
      {
        pos,
        {
          rewardType = RewardType.GOODS,
          itemId = resType
        }
      }
    }
    EventManager:GetInstance():Broadcast(EventId.UIMainFlyReward, cfg)
  end
end

local function ShowCollectEffectForBuilding(self, bUuid, icon, count)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData == nil and not self:IsProductLineBuild(buildData.itemId) then
    return
  end
  local pos = buildData:GetCenterVec()
  local effReq = Resource:InstantiateAsync(UIAssets.ProductLineFlyText)
  effReq:completed("+", function(req)
    if req.isError then
      return
    end
    local tf = req.gameObject.transform
    local text = tf:Find("num"):GetComponent(typeof(CS.SuperTextMesh))
    local sprite = tf:Find("num/icon"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    tf.position = pos
    local v3 = Vector3.New(0.5, 0.5, 0.5)
    if GetResType(bUuid) == CommonCostNeedType.Resource then
      v3 = Vector3.one
    end
    sprite.gameObject.transform.localScale = v3
    tf.localScale = Vector3.New(2, 2, 2)
    text.text = "+" .. count
    sprite:LoadSprite(icon)
    TimerManager:GetInstance():DelayInvoke(function()
      if req ~= nil then
        req:Destroy()
      end
    end, CollectEffectDuration)
  end)
end

local function PrintDebug(self, bUuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData == nil and not self:IsProductLineBuild(buildData.itemId) then
    return
  end
  local buildLevelTemplate = DataCenter.BuildManager:GetBuildLevelTemplateByUuid(bUuid)
  local state = self:GetState(bUuid)
  Logger.Log("PLM debug ------------------------------")
  Logger.Log("PLM bUuid " .. bUuid)
  Logger.Log("PLM name " .. CS.GameEntry.Localization:GetString(buildLevelTemplate.name))
  Logger.Log("PLM state " .. state)
  local productResItemDict = self:GetProductResItem(bUuid)
  if table.count(productResItemDict) > 0 then
    local isFull = true
    for itemId, _ in pairs(productResItemDict) do
      Logger.Log("PLM product itemId " .. itemId)
      local resItemTemplate = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(itemId)
      if resItemTemplate ~= nil then
      end
    end
    if isFull then
      Logger.Log("PLM isFull")
    end
  end
end

local function OnNoHeroBubbleClick(self, bUuid)
  self:PrintDebug(bUuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData then
    UIUtil.OpenLWUIBuildDetailsView(tostring(buildData.pointId))
    if buildData:IsMainBuilding() then
      local taylorWorkerId = 13303
      local unlockTaylor = DataCenter.WorkerDataManager:GetWorkerById(taylorWorkerId) ~= nil
      local taylorDispatchableState = WorkerUtil.IsExistDispatchableTaylorWorker()
      local hasTaylor = unlockTaylor or taylorDispatchableState
      PostEventLog.Track(PostEventLog.Defines.c_open_build_main_detail_way, {
        i_para1 = 3,
        i_para2 = hasTaylor and 1 or 2,
        i_para3 = DataCenter.BuildManager.MainLv,
        i_para4 = DataCenter.MonopolyManager.player.curId
      })
    end
  end
end

local function GetResItemCurStorage(self, type)
  local cur = 0
  for _, resItemTemplate in pairs(DataCenter.ResourceItemDataManager:GetAllTemplate()) do
    if resItemTemplate.type == type then
      cur = cur + DataCenter.ResourceItemDataManager:GetCountByItemId(itemId)
    end
  end
  return cur
end

local function GetResItemMaxStorage(self, type)
  local max = 0
  for _, bUuid in ipairs(self:GetAllBuildUuids()) do
    local storageDict = self:GetStorageResItem(bUuid)
    max = max + (storageDict[type] or 0)
  end
  return max
end

local function OnCollectClick(self, bUuid)
  self:PrintDebug(bUuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData then
    if self:GetBuildingCurrStorage(bUuid) > 0 then
      if self:CheckOneKeyCollectAll(buildData.itemId) then
        return
      end
      if BuildingUtils.IsSeasonWeekCardCityBuilding(buildData.itemId) then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local settleTime = DataCenter.SeasonDataManager:GetSeasonSettleTime()
        if curTime >= settleTime then
          UIUtil.ShowTipsId("season_weekcard_error_tips01")
          return
        end
      end
      local isOpen = LuaEntry.Effect:GetGameEffect(90020)
      if 0 < isOpen then
        local dataList = BuildingUtils.GetBuildListByBuildId(buildData.itemId)
        for i, data in pairs(dataList) do
          if 0 < GetBuildingCurrStorage(self, data.uuid) then
            self:SendCollect(data.uuid)
          end
        end
      else
        self:SendCollect(bUuid)
      end
    else
      UIUtil.ShowTipsId(602026)
    end
  end
end

local function OnBuildDataUpdate(bUuid)
  if bUuid == nil then
    return
  end
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData == nil then
    return
  end
  if DataCenter.ProductLineManager:IsProductLineBuild(buildData.itemId) then
    DataCenter.ProductLineManager:ProductionTimer(bUuid)
  end
end

local function OnResourceOrItemUpdate(self)
  DataCenter.ProductLineManager:RestartTimer()
end

local function OnBuildingHeroDispatching(self)
  DataCenter.ProductLineManager:RestartTimer()
end

local function SendCollect(self, bUuid)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.collectTimeCache = curTime
  SFSNetwork.SendMessage(MsgDefines.ProductLineCollect, {bUuid = bUuid})
end

local function HandleInit(self, message)
  EventManager:GetInstance():Broadcast(EventId.ProductLineUpdate)
end

local function HandleCollect(self, message)
  if (message.status or -1) == -1 then
    UIUtil.ShowTipsId(602026)
    return
  end
  self:ShowCollectEffectByMessage(message)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(message.buildInfo.uuid)
  buildData:UpdateInfo(message.buildInfo)
  self:ProductionTimer(message.buildInfo.uuid)
  EventManager:GetInstance():Broadcast(EventId.ProductLineUpdate)
end

local function OnBuildingUpgradeDone(buildingData)
  local autoCollectBuildings
  if buildingData.itemId == BuildingTypes.LW_BUILD_BAKERY then
    autoCollectBuildings = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_FARMLAND)
  elseif buildingData.itemId == BuildingTypes.LW_BUILD_STEEL_MILL then
    autoCollectBuildings = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_QUARRY)
  end
  if autoCollectBuildings then
    for _, building in ipairs(autoCollectBuildings) do
      DataCenter.ProductLineManager:OnCollectClick(building.uuid)
    end
  end
end

local function CheckOneKeyCollectAll(self, buildItemId)
  if not self:CanOneKeyCollectRes() then
    return false
  end
  local isOpenCollectAll = Setting:GetBool(SettingKeys.SHAKE_COLLECT_RES, true)
  local isHaveEffect = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_SHAKE_COLLECT_RES) > 0
  local isTargetBuild = DataCenter.BuildManager:CheckCanShakeCollect(buildItemId)
  if Config.IsPC() and isHaveEffect and not Setting:GetBool(SettingKeys.SHAKE_COLLECT_TIPS_SHOWN, false) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIShakeTip)
    Setting:SetBool(SettingKeys.SHAKE_COLLECT_TIPS_SHOWN, true)
  end
  if isOpenCollectAll and isHaveEffect and isTargetBuild then
    EventManager:GetInstance():Broadcast(EventId.TriggerOneKeyCollectAll, buildItemId)
    return true
  end
  return false
end

local function RefreshOneKeyResSetting()
  DataCenter.ProductLineManager.oneKeyResSettingOn = Setting:GetBool(SettingKeys.ONE_KEY_COLLECT_RES, false) and Setting:GetBool(SettingKeys.SHAKE_COLLECT_RES, true)
end

function ProductLineManager:CanOneKeyCollectRes()
  return Config.IsPC() or self.oneKeyResSettingOn
end

ProductLineManager.__init = __init
ProductLineManager.__delete = __delete
ProductLineManager.OnAddListener = OnAddListener
ProductLineManager.OnRemoveListener = OnRemoveListener
ProductLineManager.IsProductLineBuild = IsProductLineBuild
ProductLineManager.GetAllBuildIds = GetAllBuildIds
ProductLineManager.GetAllBuildUuids = GetAllBuildUuids
ProductLineManager.GetBuildUuidsByProductRes = GetBuildUuidsByProductRes
ProductLineManager.GetBuildUuidsByProductResItem = GetBuildUuidsByProductResItem
ProductLineManager.GetState = GetState
ProductLineManager.GetBubbleIcon = GetBubbleIcon
ProductLineManager.GetStorageResItem = GetStorageResItem
ProductLineManager.GetCostRes = GetCostRes
ProductLineManager.GetCostResItem = GetCostResItem
ProductLineManager.GetProductRes = GetProductRes
ProductLineManager.GetProductResItem = GetProductResItem
ProductLineManager.GetNextCollectTime = GetNextCollectTime
ProductLineManager.SetCollectTime = SetCollectTime
ProductLineManager.ProductionTimer = ProductionTimer
ProductLineManager.ShowCollectEffectByMessage = ShowCollectEffectByMessage
ProductLineManager.ShowCollectEffectForBuilding = ShowCollectEffectForBuilding
ProductLineManager.PrintDebug = PrintDebug
ProductLineManager.GetBuildingWorkerEffect = GetBuildingWorkerEffect
ProductLineManager.GetBuildingCurrStorage = GetBuildingCurrStorage
ProductLineManager.TryCollectRes = TryCollectRes
ProductLineManager.RestartTimer = RestartTimer
ProductLineManager.CheckCollectNeedBuilding = CheckCollectNeedBuilding
ProductLineManager.CheckOneKeyCollectAll = CheckOneKeyCollectAll
ProductLineManager.OnNoHeroBubbleClick = OnNoHeroBubbleClick
ProductLineManager.OnCollectClick = OnCollectClick
ProductLineManager.OnBuildDataUpdate = OnBuildDataUpdate
ProductLineManager.OnResourceOrItemUpdate = OnResourceOrItemUpdate
ProductLineManager.OnBuildingHeroDispatching = OnBuildingHeroDispatching
ProductLineManager.RefreshOneKeyResSetting = RefreshOneKeyResSetting
ProductLineManager.SendCollect = SendCollect
ProductLineManager.HandleInit = HandleInit
ProductLineManager.HandleCollect = HandleCollect
ProductLineManager.GetAdditionTechnological = GetAdditionTechnological
ProductLineManager.GetResItemCurStorage = GetResItemCurStorage
ProductLineManager.GetResItemMaxStorage = GetResItemMaxStorage
ProductLineManager.GetResType = GetResType
ProductLineManager.GetBubbleScale = GetBubbleScale
ProductLineManager.GetCollectAudioName = GetCollectAudioName
ProductLineManager.OnBuildingUpgradeDone = OnBuildingUpgradeDone
ProductLineManager.GetProductGoods = GetProductGoods
ProductLineManager.GetBuildUuidsByProductGoods = GetBuildUuidsByProductGoods
ProductLineManager.GetBuildProduceNum = GetBuildProduceNum
return ProductLineManager
