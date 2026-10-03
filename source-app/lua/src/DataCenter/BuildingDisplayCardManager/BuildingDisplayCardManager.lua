local BuildingDisplayCardManager = BaseClass("BuildingDisplayCardManager", Singleton)
local World = CS.SceneManager.World
local path = "ModelGo/BuildUpLevelTip"

local function __init(self)
  self.AddListener(self)
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.ResourceUpdated, self.OnResourceUpdated)
  EventManager:GetInstance():AddListener(EventId.HeroLvUpSuccess, self.UpdateAllHeroBuildInfo)
  EventManager:GetInstance():AddListener(EventId.RefreshItems, self.UpdateAllHeroBuildInfo)
  EventManager:GetInstance():AddListener(EventId.FinishInitItemTemplate, self.UpdateAllHeroBuildInfo)
  EventManager:GetInstance():AddListener(EventId.BUILD_IN_VIEW, self.UpdateOneBuild)
  EventManager:GetInstance():AddListener(EventId.BUILD_OUT_VIEW, self.DeleteOneBuildInfo)
  EventManager:GetInstance():AddListener(EventId.BuildLevelUp, self.UpdateAllBuildInfo)
  EventManager:GetInstance():AddListener(EventId.ShowBuildTopUI, self.DeleteOneBuildInfo)
  EventManager:GetInstance():AddListener(EventId.HideBuildTopUI, self.UpdateOneBuild)
  EventManager:GetInstance():AddListener(EventId.AddDecorate, self.OnAddDecorate)
end

local function __delete(self)
  self.RemoveListener(self)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.ResourceUpdated, self.OnResourceUpdated)
  EventManager:GetInstance():RemoveListener(EventId.HeroLvUpSuccess, self.UpdateAllHeroBuildInfo)
  EventManager:GetInstance():RemoveListener(EventId.RefreshItems, self.UpdateAllHeroBuildInfo)
  EventManager:GetInstance():RemoveListener(EventId.FinishInitItemTemplate, self.UpdateAllHeroBuildInfo)
  EventManager:GetInstance():RemoveListener(EventId.BUILD_IN_VIEW, self.UpdateOneBuild)
  EventManager:GetInstance():RemoveListener(EventId.BuildLevelUp, self.UpdateAllBuildInfo)
  EventManager:GetInstance():RemoveListener(EventId.BUILD_OUT_VIEW, self.DeleteOneBuildInfo)
  EventManager:GetInstance():RemoveListener(EventId.ShowBuildTopUI, self.DeleteOneBuildInfo)
  EventManager:GetInstance():RemoveListener(EventId.HideBuildTopUI, self.UpdateOneBuild)
  EventManager:GetInstance():RemoveListener(EventId.AddDecorate, self.OnAddDecorate)
end

local function InitData()
end

local function ShowLevel(uuid, isShow)
  local data = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  if data and CS.SceneManager.World then
    if CS.SceneManager.World.SetLevelUpActive then
      CS.SceneManager.World:SetLevelUpActive(data.pointId, isShow)
    else
      local cityObj = CS.SceneManager.World:GetBuildingByPoint(data.pointId)
      if not cityObj then
        return
      end
      local tip = cityObj.gameObject.transform:Find(path)
      if tip then
        tip.gameObject:SetActive(isShow)
      end
    end
  end
end

local function DeleteOneBuildInfo(uuid)
  ShowLevel(uuid, false)
end

local function UpdateOneDecorate(data, template)
  if template.tab_type == UIBuildListTabType.Decorate then
    local decorate = DataCenter.BuildManager:GetFunbuildByItemID(data.itemId)
    if not decorate then
      return
    end
    local list = BuildingUtils.GetDecorateUpLevelBuilds(decorate)
    local canUpgrade = list and not list[#list].needScore
    ShowLevel(decorate.uuid, canUpgrade)
  end
end

local function UpdateOneBuildByBuildData(data)
  if data.itemId == BuildingTypes.Lw_BUILD_BATTLE_FEATURE_ENTRY or not SceneUtils.GetIsInCity() then
    return
  end
  if data.itemId == BuildingTypes.LW_BUILD_TREASURE_CHEST then
    ShowLevel(data.uuid, false)
    return
  end
  local needPre = false
  local buildCurLevelTemplate, itemsSatisfy
  itemsSatisfy = true
  needPre = false
  local data = data
  local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(data.itemId)
  if (data:IsUpgrading() or data:IsUpgradeFinish() or data.level == template.max_level) and data.itemId ~= BuildingTypes.LW_BUILD_HERO then
    DeleteOneBuildInfo(data.uuid)
    return
  end
  buildCurLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(data.itemId, data.level)
  local buildManager = DataCenter.BuildManager
  if not buildCurLevelTemplate:IsPreBuildConditionValid() then
    needPre = true
  end
  local needResource = buildCurLevelTemplate:GetNeedResource()
  if needResource ~= nil then
    for k, v in ipairs(needResource) do
      local resourceType1 = v.resourceType
      if v.count > LuaEntry.Resource:GetCntByResType(resourceType1) then
        itemsSatisfy = false
      end
    end
  end
  if data.itemId == BuildingTypes.LW_BUILD_HERO then
    itemsSatisfy = false
    local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(data.prodStatus)
    if heroData ~= nil then
      itemsSatisfy = DataCenter.HeroDataManager:GetHeroCanUpgradeInfos(heroData)
    end
  end
  if template.tab_type == UIBuildListTabType.Decorate then
    local buildData = buildManager:GetBuildingDataByUuid(data.uuid)
    if buildData.state == BuildingStateType.FoldUp then
      return
    else
      local list = BuildingUtils.GetDecorateUpLevelBuilds(buildData)
      local canUpgrade = list and not list[#list].nextScore
      if not canUpgrade then
        itemsSatisfy = false
      end
    end
  end
  local isSeasonTimeValidate = true
  if buildCurLevelTemplate ~= nil and not buildCurLevelTemplate:IsTimeConditionValid() then
    isSeasonTimeValidate = false
  end
  if SeasonUtil.IsMummyYardBuilding(data.itemId) and not SeasonUtil.IsInSeason() then
    isSeasonTimeValidate = false
  end
  if not needPre and itemsSatisfy and isSeasonTimeValidate then
    ShowLevel(data.uuid, true)
  else
    ShowLevel(data.uuid, false)
  end
end

local function OnAddDecorate(data)
  local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(data.itemId)
  UpdateOneDecorate(data, template, true)
end

local function UpdateOneBuild(buildUuid)
  local data = DataCenter.BuildManager:GetBuildingDataByUuid(buildUuid)
  if data then
    UpdateOneBuildByBuildData(data)
  end
end

local function UpdateAllBuildInfo(self)
  if SceneUtils.GetIsInCity() then
    local buildList = DataCenter.BuildManager:GetAllBuildData()
    local template
    for i, v in pairs(buildList) do
      UpdateOneBuildByBuildData(v)
    end
  end
end

local function OnResourceUpdated(self)
  if SceneUtils.GetIsInCity() then
    local buildList = DataCenter.BuildManager:GetAllBuildData()
    local template
    for i, v in pairs(buildList) do
      template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(v.itemId)
      if template and template.tab_type ~= UIBuildListTabType.Decorate then
        UpdateOneBuildByBuildData(v)
      end
    end
  end
end

local function UpdateAllHeroBuildInfo(self)
  if SceneUtils.GetIsInCity() then
    local buildList = DataCenter.BuildManager:GetAllBuildData()
    local template
    for i, v in pairs(buildList) do
      template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(v.itemId)
      if v.itemId == BuildingTypes.LW_BUILD_HERO then
        UpdateOneBuildByBuildData(v)
      end
    end
  end
end

local function OnBuildInfo(data)
  if not data then
    return
  end
  local buidData = DataCenter.BuildManager:GetBuildingDataByUuid(data.uuid)
  if buidData:IsUpgrading() or buidData:IsUpgradeFinish() then
    DeleteOneBuildInfo(data.uuid)
  else
    UpdateOneBuild(data.uuid)
  end
end

BuildingDisplayCardManager.__init = __init
BuildingDisplayCardManager.__delete = __delete
BuildingDisplayCardManager.AddListener = AddListener
BuildingDisplayCardManager.RemoveListener = RemoveListener
BuildingDisplayCardManager.OnBuildInfo = OnBuildInfo
BuildingDisplayCardManager.InitData = InitData
BuildingDisplayCardManager.UpdateAllBuildInfo = UpdateAllBuildInfo
BuildingDisplayCardManager.UpdateOneBuild = UpdateOneBuild
BuildingDisplayCardManager.DeleteOneBuildInfo = DeleteOneBuildInfo
BuildingDisplayCardManager.UpdateAllHeroBuildInfo = UpdateAllHeroBuildInfo
BuildingDisplayCardManager.OnAddDecorate = OnAddDecorate
BuildingDisplayCardManager.UpdateOneDecorate = UpdateOneDecorate
BuildingDisplayCardManager.OnResourceUpdated = OnResourceUpdated
return BuildingDisplayCardManager
