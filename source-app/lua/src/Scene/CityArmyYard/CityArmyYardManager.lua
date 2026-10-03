local CityArmyYardManager = BaseClass("CityArmyYardManager", CEventable)
local Resource = CS.GameEntry.Resource
local buildBattleArrayDic = {}
local buildingUuid2SoldierDataList = {}

local function __init(self)
  self:RegisterEvent(EventId.BUILD_IN_VIEW, self.OnBuildInView)
  self:RegisterEvent(EventId.BUILD_OUT_VIEW, self.OnBuildOutView)
  self:RegisterEvent(EventId.SoldierDataChanged, self.UpdateAllBuildingInView)
  self:RegisterEvent(EventId.EffectNumChange, self.OnEffectNumChange)
  self.prevSoldierLimit = nil
  self.prevMummySoldierLimit = nil
  self.buildingsInView = {}
end

local function __delete(self)
  self.prevSoldierLimit = nil
  self.buildingsInView = nil
  if not table.IsNullOrEmpty(buildBattleArrayDic) then
    for uuid, array in pairs(buildBattleArrayDic) do
      if not table.IsNullOrEmpty(array) then
        for i, info in pairs(array) do
          if info.req then
            info.req:Destroy()
            info.req = nil
          end
        end
      end
      array = {}
    end
  end
  buildBattleArrayDic = {}
  buildingUuid2SoldierDataList = {}
end

local function CreateOneSoldier(buildingUid, build, soldierInfo)
  local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(soldierInfo.soldierId)
  if soldierTemplate == nil then
    return
  end
  local modelPath = soldierTemplate.model_jc
  if T11Util.CheckSuperSoldierByTmp(soldierTemplate) then
    modelPath = T11Util.GetPlayerSelfT11SoldierJCModelPath(soldierTemplate) or soldierTemplate.model_jc
  end
  local req = buildBattleArrayDic[buildingUid][soldierInfo.index].req
  if req then
    req:Destroy()
    buildBattleArrayDic[buildingUid][soldierInfo.index].req = nil
  end
  local firstIndex = math.floor(soldierInfo.index / 4)
  local heroParent = build.gameObject.transform:Find(string.format("ModelGo/Normal/g%d/%d", firstIndex + 1, soldierInfo.index + 1))
  if heroParent then
    local localPos = Vector3.New(0, 0, 0)
    local info = buildBattleArrayDic[buildingUid][soldierInfo.index]
    info.req = Resource:InstantiateAsync(modelPath, ObjectPoolTag.Normal, LoadPriority.Low)
    info.req:completed("+", function()
      if info.req.isError or IsNull(info.req.gameObject) then
        return
      end
      local gameObject = info.req.gameObject
      gameObject.transform:SetParent(heroParent)
      gameObject.transform.localPosition = localPos
      gameObject.transform.rotation = Vector3.New(0, 180, 0)
      gameObject.transform.localScale = Vector3.New(1, 1, 1)
      local animation = gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
      if animation then
        animation:Stop()
        animation:Play("idle")
      end
    end)
  end
end

local function IsCanCreateModel(buildingUid, soldierModelInfo)
  if buildBattleArrayDic[buildingUid][soldierModelInfo.index] then
    local info = buildBattleArrayDic[buildingUid][soldierModelInfo.index]
    if info.soldierId ~= soldierModelInfo.soldierId then
      if info.req then
        info.req:Destroy()
        info.req = nil
      end
      info.soldierId = soldierModelInfo.soldierId
      return true
    end
  else
    buildBattleArrayDic[buildingUid][soldierModelInfo.index] = {}
    buildBattleArrayDic[buildingUid][soldierModelInfo.index].heroUuid = soldierModelInfo.soldierId
    return true
  end
end

local function CreateSoldierList(buildingUid, build, soldierModelList)
  if not buildBattleArrayDic[buildingUid] then
    buildBattleArrayDic[buildingUid] = {}
  end
  buildingUuid2SoldierDataList[buildingUid] = soldierModelList
  local modelIndexOffset = 0
  for i, v in pairs(soldierModelList) do
    local soldierId = tonumber(v.id)
    for i = 1, v.count do
      local info = {}
      info.index = modelIndexOffset
      info.soldierId = soldierId
      local isCanCreate = IsCanCreateModel(buildingUid, info)
      if isCanCreate then
        CreateOneSoldier(buildingUid, build, info)
      end
      modelIndexOffset = modelIndexOffset + 1
    end
  end
end

local function DeleteSoldierFromBuilding(buildData)
  local bUuid = buildData.uuid
  if buildBattleArrayDic[bUuid] then
    for i, info in pairs(buildBattleArrayDic[bUuid]) do
      if info.req then
        info.req:Destroy()
        info.req = nil
      end
    end
  end
  buildBattleArrayDic[bUuid] = {}
  buildingUuid2SoldierDataList[bUuid] = nil
end

local maxSoldierModelCount = 32
local maxMummySoldierModelCount = 80

local function CreateSoldierDataList(soldierType)
  local soldiers = DataCenter.SoldierDataManager:GetPlayerSoldiers(soldierType)
  local soldierLimit = 0
  local maxModelCount = maxSoldierModelCount
  if soldierType == SoldierType.Player then
    maxModelCount = maxSoldierModelCount
    soldierLimit = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_SOLDIER_MAX_STOCK)
  elseif soldierType == SoldierType.Mummy then
    maxModelCount = maxMummySoldierModelCount
    soldierLimit = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_MUMMY_MAX_STOCK)
  else
    maxModelCount = maxMummySoldierModelCount
    soldierLimit = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_SOLDIER_MAX_STOCK)
  end
  local soldierModelCount = {}
  local totalModelCount = 0
  if not table.IsNullOrEmpty(soldiers) then
    table.sort(soldiers, function(a, b)
      return a.lv > b.lv
    end)
  end
  for i, v in pairs(soldiers) do
    if maxModelCount > totalModelCount then
      local param = {}
      param.id = v.id
      param.t11Type = v.t11Type
      param.count = math.ceil(v.count / soldierLimit * maxModelCount)
      param.count = math.min(param.count, maxModelCount)
      if maxModelCount < totalModelCount + param.count then
        param.count = maxModelCount - totalModelCount
      end
      table.insert(soldierModelCount, param)
      totalModelCount = totalModelCount + param.count
    end
  end
  return soldierModelCount
end

local function CompareSoldierDataIsChange(buildingUuid, newSoldierDataList)
  local oldSoldierDataList = {}
  if buildingUuid2SoldierDataList[buildingUuid] then
    oldSoldierDataList = buildingUuid2SoldierDataList[buildingUuid]
  end
  local newSoldierDataListCount = table.count(newSoldierDataList)
  local oldSoldierDataListCount = table.count(oldSoldierDataList)
  if newSoldierDataListCount ~= oldSoldierDataListCount then
    return true
  end
  for index, soldierInfo in pairs(newSoldierDataList) do
    local oldSoldierInfo = oldSoldierDataList[index]
    if oldSoldierInfo.id ~= soldierInfo.id or oldSoldierInfo.count ~= soldierInfo.count then
      return true
    end
    if oldSoldierInfo.t11Type ~= soldierInfo.t11Type then
      return true
    end
  end
  return false
end

local function UpdateArmyList(buildData, soldierType)
  local buildData = buildData
  if buildData and buildData.level >= 1 then
    if not IsNull(CS.SceneManager.World) then
      local build = CS.SceneManager.World:GetBuildingByPoint(buildData.pointId)
      if build then
        local soldierModelList = CreateSoldierDataList(soldierType)
        local isDataChange = CompareSoldierDataIsChange(buildData.uuid, soldierModelList)
        if isDataChange then
          DeleteSoldierFromBuilding(buildData)
          CreateSoldierList(buildData.uuid, build, soldierModelList)
        end
      else
        DeleteSoldierFromBuilding(buildData)
      end
    else
      DeleteSoldierFromBuilding(buildData)
    end
  end
end

local function UpdateAllBuildingInView(self)
  for i, v in pairs(self.buildingsInView) do
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(i)
    if buildData and buildData.itemId == BuildingTypes.LW_BUILD_ARMY_YARD then
      UpdateArmyList(buildData, SoldierType.Player)
    elseif buildData and SeasonUtil.IsMummyYardBuilding(buildData.itemId) then
      UpdateArmyList(buildData, SoldierType.Mummy)
    end
  end
end

local function OnEffectNumChange(self)
  local soldierLimit = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_SOLDIER_MAX_STOCK)
  if self.prevSoldierLimit ~= soldierLimit then
    self.prevSoldierLimit = soldierLimit
    UpdateAllBuildingInView(self)
    return
  end
  local mummySoldierLimit = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_MUMMY_MAX_STOCK)
  if self.prevMummySoldierLimit ~= mummySoldierLimit then
    self.prevMummySoldierLimit = mummySoldierLimit
    UpdateAllBuildingInView(self)
    return
  end
end

local function OnBuildInView(self, bUuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData and buildData.itemId == BuildingTypes.LW_BUILD_ARMY_YARD then
    UpdateArmyList(buildData, SoldierType.Player)
    self.buildingsInView[bUuid] = true
  elseif buildData and SeasonUtil.IsMummyYardBuilding(buildData.itemId) then
    UpdateArmyList(buildData, SoldierType.Mummy)
    self.buildingsInView[bUuid] = true
  end
end

local function OnBuildOutView(self, bUuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData and (buildData.itemId == BuildingTypes.LW_BUILD_ARMY_YARD or SeasonUtil.IsMummyYardBuilding(buildData.itemId)) then
    DeleteSoldierFromBuilding(buildData)
    self.buildingsInView[bUuid] = nil
  end
end

local function InitData()
end

CityArmyYardManager.InitData = InitData
CityArmyYardManager.CreateSoldierList = CreateSoldierList
CityArmyYardManager.__init = __init
CityArmyYardManager.__delete = __delete
CityArmyYardManager.UpdateArmyList = UpdateArmyList
CityArmyYardManager.OnBuildInView = OnBuildInView
CityArmyYardManager.OnBuildOutView = OnBuildOutView
CityArmyYardManager.OnEffectNumChange = OnEffectNumChange
CityArmyYardManager.UpdateAllBuildingInView = UpdateAllBuildingInView
return CityArmyYardManager
