local CityCarbarnManager = BaseClass("CityCarbarnManager")
local Resource = CS.GameEntry.Resource
local Const = require("Scene.CityCarbarn.Const")
local buildBattleArrayDic = {}
local slowDownObject = {}
local buildingUuid2HeroDataDict = {}
local heroUniqueWeaponWaitLoadDic = {}

local function __init(self)
  EventManager:GetInstance():AddListener(EventId.BUILD_IN_VIEW, self.UpdateArmyFormationList)
  EventManager:GetInstance():AddListener(EventId.BUILD_OUT_VIEW, self.OnBuildOutView)
  EventManager:GetInstance():AddListener(EventId.RefreshCarbarnFormation, self.UpdateArmyFormationList)
  EventManager:GetInstance():AddListener(EventId.HeroModelChange, self.OnHeroModelChange)
end

local slowSpeed = 0.03

local function SetAnimationSpeedSlow(modelObject)
  local animation = modelObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
  if animation then
    animation:Stop()
    animation:SetStateSpeed("idle", slowSpeed)
    animation:Play("idle")
    slowDownObject[modelObject] = true
  end
end

local function ResetAnimationSpeedAndStop(modelObject)
  if slowDownObject[modelObject] then
    local animation = modelObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    if animation then
      animation:SetStateSpeed("idle", 1)
      animation:Stop()
    end
    slowDownObject[modelObject] = nil
  end
end

local function CreateHeroUniqueWeapon(buildingUid, modelPath, heroParent, heroInfoIndex, index, heroType)
  if heroParent then
    local localPos = 0 < index and Const.heroPosList[index] or Vector3.New(0, 0, 0)
    index = index < 0 and 1 or index
    local info = heroUniqueWeaponWaitLoadDic[buildingUid][heroInfoIndex]
    if not info.reqDic then
      info.reqDic = {}
    end
    local path = info.path
    info.reqDic[index] = Resource:InstantiateAsync(path, ObjectPoolTag.Normal, LoadPriority.Low)
    info.reqDic[index]:completed("+", function(req)
      req.gameObject.transform:SetParent(heroParent)
      req.gameObject.transform.localPosition = localPos
      req.gameObject.transform.rotation = Const.moelRotation
      req.gameObject.transform.localScale = Const.moelScale
      if heroType == HeroType.Aircraft then
        SetAnimationSpeedSlow(req.gameObject)
      end
      local origin = buildBattleArrayDic[buildingUid][heroInfoIndex]
      if origin then
        if origin.reqDic[index] then
          origin.reqDic[index]:Destroy()
        else
          Logger.LogError("\229\142\159\230\168\161\229\158\139\228\184\162 buildingUid\239\188\154 " .. buildingUid .. "  slot: " .. heroInfoIndex)
        end
        origin.reqDic[index] = req
        EventManager:GetInstance():Broadcast(EventId.HeroModelInFormationLoaded, {
          buildingUid,
          index,
          info.heroUuid,
          req.gameObject
        })
      else
        Logger.LogError("\232\191\153\233\135\140\228\184\141\229\186\148\232\175\165\232\181\176\229\136\176\228\186\134\239\188\140\231\156\139\231\156\139\230\152\175\228\184\186\229\149\165  buildingUid\239\188\154" .. buildingUid .. "  slot: " .. heroInfoIndex)
      end
      if heroUniqueWeaponWaitLoadDic[buildingUid] and heroUniqueWeaponWaitLoadDic[buildingUid][heroInfoIndex] then
        heroUniqueWeaponWaitLoadDic[buildingUid][heroInfoIndex].reqDic[index] = nil
        heroUniqueWeaponWaitLoadDic[buildingUid][heroInfoIndex] = nil
      end
    end)
  end
end

local function CreateSoldierFormation(buildingUid, modelPath, heroParent, heroInfoIndex, index, heroType, hasUniqueWeapon)
  if heroParent then
    local localPos = 0 < index and Const.heroPosList[index] or Vector3.New(0, 0, 0)
    index = index < 0 and 1 or index
    local info = buildBattleArrayDic[buildingUid][heroInfoIndex]
    if not info.reqDic then
      info.reqDic = {}
    end
    info.reqDic[index] = Resource:InstantiateAsync(modelPath, ObjectPoolTag.Normal, LoadPriority.Low)
    info.reqDic[index]:completed("+", function(req)
      req.gameObject.transform:SetParent(heroParent)
      req.gameObject.transform.localPosition = localPos
      req.gameObject.transform.rotation = Const.moelRotation
      req.gameObject.transform.localScale = Const.moelScale
      if heroType == HeroType.Aircraft then
        SetAnimationSpeedSlow(req.gameObject)
      end
      EventManager:GetInstance():Broadcast(EventId.HeroModelInFormationLoaded, {
        buildingUid,
        index,
        info.heroUuid,
        req.gameObject
      })
      if hasUniqueWeapon then
        CreateHeroUniqueWeapon(buildingUid, modelPath, heroParent, heroInfoIndex, index, heroType)
      end
    end)
  end
end

local function CreateOneHero(buildingUid, build, heroInfo)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroInfo.heroUuid)
  if not heroData then
    return
  end
  local modelPath, appearanceId, modelSourceType = heroData:GetHeroModelData(HeroModelType.City)
  local isModelFromUniqueWeapon = modelSourceType == HeroModelSourceType.UniqueWeapon or modelSourceType == HeroModelSourceType.HeroAwaken
  if isModelFromUniqueWeapon then
    local packConfigId = LocalController:instance():getValue("lw_hero", heroData.heroId, "download_packs_id")
    if packConfigId and 0 < packConfigId then
      local isLoaded = UIUtil.CheckAssetDownloaded(modelPath)
      if not isLoaded then
        local originalModelPath, originalAppearanceId = HeroUtils.GetHeroModelDataForceHeroSourceType(heroData.heroId, HeroModelType.City)
        heroUniqueWeaponWaitLoadDic[buildingUid][heroInfo.index].path = modelPath
        modelPath = originalModelPath
        appearanceId = originalAppearanceId
      end
    end
  end
  local reqDic = buildBattleArrayDic[buildingUid][heroInfo.index].reqDic
  if reqDic and 0 < table.count(reqDic) then
    for i, object in pairs(reqDic) do
      ResetAnimationSpeedAndStop(object.gameObject)
      object:RealDestroy()
    end
  end
  local reqDicUW = heroUniqueWeaponWaitLoadDic[buildingUid][heroInfo.index].reqDic
  if reqDicUW and 0 < table.count(reqDicUW) then
    for i, object in pairs(reqDicUW) do
      ResetAnimationSpeedAndStop(object.gameObject)
      object:RealDestroy()
    end
  end
  buildBattleArrayDic[buildingUid][heroInfo.index].reqDic = {}
  local heroParent = build.gameObject.transform:Find(string.format(Const.heroParentPath, heroInfo.index))
  if heroData.modelId == "10001" then
    for i = 1, 4 do
      CreateSoldierFormation(buildingUid, modelPath, heroParent, heroInfo.index, i, heroData.heroType)
    end
  else
    local hasWeapon = heroUniqueWeaponWaitLoadDic[buildingUid][heroInfo.index].path ~= nil
    CreateSoldierFormation(buildingUid, modelPath, heroParent, heroInfo.index, -1, heroData.heroType, hasWeapon)
  end
end

local function IsCanCreateModel(buildingUid, heroInfo)
  if buildBattleArrayDic[buildingUid][heroInfo.index] then
    local info = buildBattleArrayDic[buildingUid][heroInfo.index]
    if info.heroUuid ~= heroInfo.heroUuid or info.heroModelId ~= heroInfo.heroModelId then
      if info.reqDic then
        for w, model in pairs(info.reqDic) do
          ResetAnimationSpeedAndStop(model.gameObject)
          model:RealDestroy()
        end
      end
      info.heroUuid = heroInfo.heroUuid
      info.heroModelId = heroInfo.heroModelId
      if not heroUniqueWeaponWaitLoadDic[buildingUid] then
        heroUniqueWeaponWaitLoadDic[buildingUid] = {}
      end
      heroUniqueWeaponWaitLoadDic[buildingUid][heroInfo.index] = {}
      heroUniqueWeaponWaitLoadDic[buildingUid][heroInfo.index].heroUuid = heroInfo.heroUuid
      heroUniqueWeaponWaitLoadDic[buildingUid][heroInfo.index].heroModelId = heroInfo.heroModelId
      return true
    end
  else
    buildBattleArrayDic[buildingUid][heroInfo.index] = {}
    buildBattleArrayDic[buildingUid][heroInfo.index].heroUuid = heroInfo.heroUuid
    buildBattleArrayDic[buildingUid][heroInfo.index].heroModelId = heroInfo.heroModelId
    heroUniqueWeaponWaitLoadDic[buildingUid][heroInfo.index] = {}
    heroUniqueWeaponWaitLoadDic[buildingUid][heroInfo.index].heroUuid = heroInfo.heroUuid
    heroUniqueWeaponWaitLoadDic[buildingUid][heroInfo.index].heroModelId = heroInfo.heroModelId
    return true
  end
end

local function CreateHeroList(buildingUid, build, heroList)
  if not buildBattleArrayDic[buildingUid] then
    buildBattleArrayDic[buildingUid] = {}
  end
  if not heroUniqueWeaponWaitLoadDic[buildingUid] then
    heroUniqueWeaponWaitLoadDic[buildingUid] = {}
  end
  buildingUuid2HeroDataDict[buildingUid] = heroList
  local info
  for i, v in pairs(heroList) do
    info = {}
    info.index = v
    info.heroUuid = i
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(i)
    if heroData then
      info.heroModelId = heroData.modelId
    else
      info.heroModelId = 0
    end
    local isCanCreate = IsCanCreateModel(buildingUid, info)
    if isCanCreate then
      CreateOneHero(buildingUid, build, info)
    end
  end
end

local function DeleteBuildHeroListByBuidUid(bUuid)
  local builddata = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if builddata and DataCenter.CityCarbarnManager.IsCarbarn(builddata.itemId) then
    if buildBattleArrayDic[bUuid] then
      for i, info in pairs(buildBattleArrayDic[bUuid]) do
        if info.reqDic then
          for w, model in pairs(info.reqDic) do
            ResetAnimationSpeedAndStop(model.gameObject)
            model:RealDestroy()
          end
        end
      end
    end
    if heroUniqueWeaponWaitLoadDic[bUuid] then
      for index, info in pairs(heroUniqueWeaponWaitLoadDic[bUuid]) do
        if info.reqDic then
          for w, model in pairs(info.reqDic) do
            ResetAnimationSpeedAndStop(model.gameObject)
            model:RealDestroy()
          end
        end
      end
    end
    heroUniqueWeaponWaitLoadDic[bUuid] = {}
    buildBattleArrayDic[bUuid] = {}
    buildingUuid2HeroDataDict[bUuid] = {}
  end
end

local function DeleteBuildHeroByBuildingUuidAndHeroIndex(bUuid, heroIndex)
  local builddata = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if builddata and DataCenter.CityCarbarnManager.IsCarbarn(builddata.itemId) then
    if buildBattleArrayDic[bUuid] then
      for index, info in pairs(buildBattleArrayDic[bUuid]) do
        if index == heroIndex then
          if info.reqDic then
            for w, model in pairs(info.reqDic) do
              ResetAnimationSpeedAndStop(model.gameObject)
              model:RealDestroy()
            end
          end
          break
        end
      end
      buildBattleArrayDic[bUuid][heroIndex] = nil
    end
    if heroUniqueWeaponWaitLoadDic[bUuid] then
      for index, info in pairs(heroUniqueWeaponWaitLoadDic[bUuid]) do
        if index == heroIndex then
          if info.reqDic then
            for w, model in pairs(info.reqDic) do
              ResetAnimationSpeedAndStop(model.gameObject)
              model:RealDestroy()
            end
          end
          break
        end
      end
      heroUniqueWeaponWaitLoadDic[bUuid][heroIndex] = nil
    end
  end
end

local function GetNeedDeleteHeroList(buildingUuid, newHeroDict)
  local needDeleteHeroIndex = {}
  if buildingUuid2HeroDataDict[buildingUuid] then
    local curHeroDict = buildingUuid2HeroDataDict[buildingUuid]
    for heroUuid, index in pairs(curHeroDict) do
      if not newHeroDict[heroUuid] then
        table.insert(needDeleteHeroIndex, index)
      else
        local newIndex = newHeroDict[heroUuid]
        if newIndex ~= index then
          table.insert(needDeleteHeroIndex, index)
        end
      end
    end
  end
  return needDeleteHeroIndex
end

local function UpdateArmyFormationList(bUuid)
  local allList = DataCenter.ArmyFormationDataManager:GetArmyFormationList()
  local builddata = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if builddata and DataCenter.CityCarbarnManager.IsCarbarn(builddata.itemId) then
    if not IsNull(CS.SceneManager.World) then
      local build = CS.SceneManager.World:GetBuildingByPoint(builddata.pointId)
      if build then
        for i, v in pairs(allList) do
          if v.buildingUuid == bUuid then
            local needDeleteHeroIndex = GetNeedDeleteHeroList(bUuid, v.heroes)
            local needDeleteCount = table.count(needDeleteHeroIndex)
            if 0 < needDeleteCount then
              for j = 1, needDeleteCount do
                DeleteBuildHeroByBuildingUuidAndHeroIndex(bUuid, needDeleteHeroIndex[j])
              end
            end
            CreateHeroList(bUuid, build, v.heroes)
          end
        end
      else
        DeleteBuildHeroListByBuidUid(bUuid)
      end
    else
      DeleteBuildHeroListByBuidUid(bUuid)
    end
  end
end

local function OnBuildOutView(bUuid)
  DeleteBuildHeroListByBuidUid(bUuid)
end

local function InitData()
end

local buildList = {
  10105000,
  10125000,
  10135000,
  10145000
}

local function GetVacancyByBuildData(buildData)
  if not buildData then
    return
  end
  local build = CS.SceneManager.World:GetBuildingByPoint(buildData.pointId)
  if buildBattleArrayDic[buildData.uuid] and build then
    for i = 1, 5 do
      if not buildBattleArrayDic[buildData.uuid][i] then
        local info = {}
        local pos = build.gameObject.transform:Find(string.format(Const.heroParentPath, i))
        local squadData = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByBuildingUuid(buildData.uuid)
        info.pos = pos and pos.position or nil
        info.index = i
        info.buildData = buildData
        if squadData and squadData.index then
          info.teamIndex = squadData and squadData.index or nil
          buildBattleArrayDic[buildData.uuid][i] = {}
          return info
        end
      end
    end
  end
end

local function GetVacancyPos()
  for i = 1, #buildList do
    local listBuilds = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildList[i])
    if listBuilds ~= nil and 0 < #listBuilds then
      for j = 1, #listBuilds do
        if listBuilds[j] and 0 < listBuilds[j].level then
          local result = GetVacancyByBuildData(listBuilds[j])
          if result then
            return result
          end
        end
      end
    end
  end
end

local function GetHeroModel(self, buildUid, index)
  if buildBattleArrayDic[buildUid] then
    return buildBattleArrayDic[buildUid][index] and buildBattleArrayDic[buildUid][index].reqDic or nil
  end
end

local function IsCarbarn(itemId)
  for i = 1, #buildList do
    if buildList[i] == itemId then
      return true
    end
  end
end

local function OnHeroModelChange(heroId)
  if buildBattleArrayDic then
    for buildUuid, data in pairs(buildBattleArrayDic) do
      for index, info in pairs(data) do
        local heroUuid = info.heroUuid
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
        if heroData and heroData.heroId == heroId then
          UpdateArmyFormationList(buildUuid)
          return
        end
      end
    end
  end
end

CityCarbarnManager.InitData = InitData
CityCarbarnManager.CreateHeroList = CreateHeroList
CityCarbarnManager.__init = __init
CityCarbarnManager.UpdateArmyFormationList = UpdateArmyFormationList
CityCarbarnManager.OnBuildOutView = OnBuildOutView
CityCarbarnManager.GetVacancyPos = GetVacancyPos
CityCarbarnManager.GetHeroModel = GetHeroModel
CityCarbarnManager.IsCarbarn = IsCarbarn
CityCarbarnManager.OnHeroModelChange = OnHeroModelChange
return CityCarbarnManager
