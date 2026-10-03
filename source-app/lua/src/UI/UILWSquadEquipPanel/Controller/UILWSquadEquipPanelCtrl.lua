local UILWSquadEquipPanelCtrl = BaseClass("UILWSquadEquipPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSquadEquipPanel)
end

local function GetTabsData(self)
  local tabs = {}
  local tabData = {}
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_PARKINGLOT)
  tabData.index = 1
  tabData.buildType = BuildingTypes.LW_BUILD_PARKINGLOT
  if buildData then
    tabData.buildId = buildData.itemId
    tabData.buildUuid = buildData.uuid
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
    if buildTemplate then
      tabData.name = buildTemplate.name
    end
  end
  table.insert(tabs, tabData)
  local tabData = {}
  buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_PARKINGLOT_TWO)
  tabData.index = 2
  tabData.buildType = BuildingTypes.LW_BUILD_PARKINGLOT_TWO
  if buildData then
    tabData.buildId = buildData.itemId
    tabData.buildUuid = buildData.uuid
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
    if buildTemplate then
      tabData.name = buildTemplate.name
    end
  end
  table.insert(tabs, tabData)
  local tabData = {}
  buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_PARKINGLOT_THREE)
  tabData.index = 3
  tabData.buildType = BuildingTypes.LW_BUILD_PARKINGLOT_THREE
  if buildData then
    tabData.buildId = buildData.itemId
    tabData.buildUuid = buildData.uuid
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
    if buildTemplate then
      tabData.name = buildTemplate.name
    end
  end
  table.insert(tabs, tabData)
  local tabData = {}
  buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_PARKINGLOT_FOUR)
  tabData.index = 4
  tabData.buildType = BuildingTypes.LW_BUILD_PARKINGLOT_FOUR
  if buildData then
    tabData.buildId = buildData.itemId
    tabData.buildUuid = buildData.uuid
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
    if buildTemplate then
      tabData.name = buildTemplate.name
    end
  end
  table.insert(tabs, tabData)
  table.sort(tabs, function(a, b)
    local aBuildData = DataCenter.BuildManager:GetBuildingDataByUuid(a.buildUuid)
    local bBuildData = DataCenter.BuildManager:GetBuildingDataByUuid(b.buildUuid)
    local isAUnlock = a.buildUuid ~= nil and aBuildData ~= nil and aBuildData.level >= 1
    local isBUnlock = b.buildUuid ~= nil and bBuildData ~= nil and bBuildData.level >= 1
    if isAUnlock ~= isBUnlock then
      return isAUnlock
    end
    if isAUnlock and isBUnlock then
      local isAMonthCard = a.buildType == BuildingTypes.LW_BUILD_PARKINGLOT_FOUR
      local isBMonthCard = b.buildType == BuildingTypes.LW_BUILD_PARKINGLOT_FOUR
      if isAMonthCard ~= isBMonthCard then
        return isAMonthCard
      end
    end
    return a.index < b.index
  end)
  return tabs
end

UILWSquadEquipPanelCtrl.CloseSelf = CloseSelf
UILWSquadEquipPanelCtrl.Close = Close
UILWSquadEquipPanelCtrl.GetTabsData = GetTabsData
return UILWSquadEquipPanelCtrl
