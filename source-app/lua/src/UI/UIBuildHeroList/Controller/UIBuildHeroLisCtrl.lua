local UIBuildHeroListCtrl = BaseClass("UIBuildHeroListCtrl", UIBaseCtrl)
local curBuildIndex, buildData
local buildDispatchingHeroDic = {}
local dwellingsDispathchingHeroDic = {}

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIBuildHeroList)
end

local function UpdateDispatchingHeroDic()
  dwellingsDispathchingHeroDic = {}
  buildDispatchingHeroDic = {}
  local allBuildings = DataCenter.BuildManager:GetAllBuildUuid()
  table.walk(allBuildings, function(k, v)
    local tempBuildData = DataCenter.BuildManager:GetBuildingDataByUuid(v)
    if table.count(tempBuildData.assignedHeroList) >= 1 then
      for i = 1, #tempBuildData.assignedHeroList do
        if tempBuildData.assignedHeroList[i] ~= nil and tempBuildData.assignedHeroList[i] ~= "" then
          if tempBuildData.itemId == BuildingTypes.LW_BUILD_LIBRARY then
            dwellingsDispathchingHeroDic[tonumber(tempBuildData.assignedHeroList[i])] = v
          else
            buildDispatchingHeroDic[tonumber(tempBuildData.assignedHeroList[i])] = v
          end
        end
      end
    end
  end)
end

local function GetDispatchingByHeroUuid(self, heroUuid)
  if table.count(buildDispatchingHeroDic) == 0 and table.count(dwellingsDispathchingHeroDic) == 0 then
    UpdateDispatchingHeroDic()
  end
  local otherBuildUuid, dwellingUuid
  if table.count(buildDispatchingHeroDic) ~= 0 then
    otherBuildUuid = buildDispatchingHeroDic[heroUuid]
  end
  if table.count(dwellingsDispathchingHeroDic) ~= 0 then
    dwellingUuid = dwellingsDispathchingHeroDic[heroUuid]
  end
  return otherBuildUuid, dwellingUuid
end

local function GetBuildShowHeroDataList(self, buildIndex)
  local curData
  if buildIndex ~= curBuildIndex then
    curData = DataCenter.BuildManager:GetBuildingDataByPointId(buildIndex)
  else
    curData = buildData and buildData or DataCenter.BuildManager:GetBuildingDataByPointId(buildIndex)
  end
  if curData then
    local heroList = DataCenter.WorkerDataManager:GetCanWorkWorkerListByBuildItmeId(curData.itemId)
    local sortList = {
      {},
      {},
      {},
      {}
    }
    local showHeroDataList = {}
    sortList[1] = DataCenter.WorkerDataManager:GetToUnlockWorkerListByBuildItmeId(curData.itemId)
    table.sort(sortList[1], function(a, b)
      local aWorkerId = a
      local bWorkerId = b
      local aWorkerQualitiy = DataCenter.WorkerTemplateManager:GetWorkerQualityById(aWorkerId)
      local bWorkerQualitiy = DataCenter.WorkerTemplateManager:GetWorkerQualityById(bWorkerId)
      if aWorkerQualitiy ~= bWorkerQualitiy then
        return aWorkerQualitiy > bWorkerQualitiy
      end
      return aWorkerId < bWorkerId
    end)
    for i, woker in pairs(heroList) do
      woker.curBuildData = curData
      if woker.dispatchingBuildUid == nil or woker.dispatchingBuildUid == "" then
        woker.grey = false
        table.insert(sortList[2], woker)
      elseif woker.dispatchingBuildUid ~= curData.uuid then
        woker.grey = false
        table.insert(sortList[3], woker)
      else
        woker.grey = true
        table.insert(sortList[4], woker)
      end
    end
    for i = 2, #sortList do
      table.sort(sortList[i], function(a, b)
        return a.quality > b.quality
      end)
      for j = 1, #sortList[i] do
        table.insert(showHeroDataList, sortList[i][j])
      end
    end
    return showHeroDataList
  end
end

local function SetCurBuildIndex(self, buildIndex)
  curBuildIndex = buildIndex
  buildData = DataCenter.BuildManager:GetBuildingDataByPointId(curBuildIndex)
end

local function GetCurBuildData(self)
  return buildData
end

UIBuildHeroListCtrl.GetBuildShowHeroDataList = GetBuildShowHeroDataList
UIBuildHeroListCtrl.GetDispatchingByHeroUuid = GetDispatchingByHeroUuid
UIBuildHeroListCtrl.UpdateDispatchingHeroDic = UpdateDispatchingHeroDic
UIBuildHeroListCtrl.SetCurBuildIndex = SetCurBuildIndex
UIBuildHeroListCtrl.CloseSelf = CloseSelf
UIBuildHeroListCtrl.GetCurBuildData = GetCurBuildData
return UIBuildHeroListCtrl
