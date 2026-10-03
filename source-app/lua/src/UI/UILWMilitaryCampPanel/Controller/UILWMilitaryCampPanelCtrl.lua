local UILWMilitaryCampPanelCtrl = BaseClass("UILWMilitaryCampPanelCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWMilitaryCampPanel)
end

local function GetIsUnloackByBuildLevel(soldierData, buildLevel)
  local levelNumber = soldierData.train_need_barrack
  levelNumber = levelNumber and tonumber(levelNumber)
  if not levelNumber or buildLevel >= levelNumber then
    return true
  end
end

local function GetIsUnLoackByScience(soldierData)
  local isUnLoackScience, id, scienceData
  if string.IsNullOrEmpty(soldierData.train_need_science) then
    isUnLoackScience = true
  else
    scienceData = DataCenter.ScienceTemplateManager:GetScienceTemplate(soldierData.train_need_science)
    if scienceData then
      id = scienceData.science_id
      local science = DataCenter.ScienceDataManager:GetScienceById(id)
      if science then
        isUnLoackScience = science.level > 0
      end
    end
  end
  return isUnLoackScience
end

local function GetIsUnLockByBuff(soldierData)
  local isUnLockBuff = true
  if soldierData.train_need_buff and soldierData.train_need_buff > 0 then
    local effectValue = LuaEntry.Effect:GetGameEffect(soldierData.train_need_buff)
    isUnLockBuff = effectValue and 0 < effectValue
  end
  return isUnLockBuff
end

local function GetIsUnLoack(soldierData, buildLevel)
  local isLevelUnLoack, isUnLoackScience, isUnLockBuff
  isLevelUnLoack = GetIsUnloackByBuildLevel(soldierData, buildLevel)
  isUnLoackScience = GetIsUnLoackByScience(soldierData)
  isUnLockBuff = GetIsUnLockByBuff(soldierData)
  if isUnLoackScience and isLevelUnLoack and isUnLockBuff then
    return true
  end
end

local function GetUnloackSoldier(buildLevel)
  local allSoldierList = DataCenter.SoldierDataManager.soldiers
  local soldierList = {}
  for i, data in pairs(allSoldierList) do
    if GetIsUnLoack(data, buildLevel) then
      table.insert(soldierList, data.id)
    end
  end
  return soldierList
end

local function GetAllShowSoldierList(self, allSoldier)
  if not allSoldier then
    return {}
  end
  local showSoldierList = {}
  local showT11 = T11Util.IfShowT11InCamp()
  for _, v in pairs(allSoldier) do
    local isT11 = T11Util.IsSuperSoldier(v.level)
    if not isT11 or isT11 and showT11 then
      showSoldierList[v.id] = v
    end
  end
  return showSoldierList
end

local function GetSoldierDataList(self, canTrainSoldierList)
  local allSoldierList = DataCenter.SoldierDataManager:GetAllSoldiers()
  local allShowSoldierList = self:GetAllShowSoldierList(allSoldierList)
  local soldiers = DataCenter.SoldierDataManager:GetInsideSoldiers()
  local outSoldiers = DataCenter.SoldierDataManager:GetOutsideSoldiers()
  for _, v in pairs(allShowSoldierList) do
    v.unlocked = false
  end
  local maxLevel = 0
  local manxLevelId = 0
  local minLevel = 99999
  local minLevelId = 0
  if canTrainSoldierList ~= nil then
    for _, v in ipairs(canTrainSoldierList) do
      local id = tonumber(v)
      if allShowSoldierList[id] ~= nil then
        allShowSoldierList[id].unlocked = true
        if maxLevel < allShowSoldierList[id].level then
          maxLevel = allShowSoldierList[id].level
          manxLevelId = id
        end
      end
    end
  end
  local outSoldierDic = {}
  for i, v in pairs(outSoldiers) do
    outSoldierDic[v.id] = v
  end
  local dataList = {}
  for _, v in pairs(allShowSoldierList) do
    v.count = nil
    for j, citySoldier in pairs(soldiers) do
      if v.id == citySoldier.id then
        v.count = citySoldier.count
      end
    end
    if v.count ~= nil and 0 < v.count and maxLevel > v.level then
      if minLevel > v.level then
        minLevel = v.level
        minLevelId = v.id
      end
      v.isUp = true
    end
    if outSoldierDic[v.id] then
      v.outCount = outSoldierDic[v.id].count
    end
    table.insert(dataList, v)
  end
  table.sort(dataList, function(a, b)
    return a.id < b.id
  end)
  return dataList, manxLevelId, minLevelId
end

UILWMilitaryCampPanelCtrl.CloseSelf = CloseSelf
UILWMilitaryCampPanelCtrl.GetSoldierDataList = GetSoldierDataList
UILWMilitaryCampPanelCtrl.GetUnloackSoldier = GetUnloackSoldier
UILWMilitaryCampPanelCtrl.GetIsUnLoack = GetIsUnLoack
UILWMilitaryCampPanelCtrl.GetIsUnLoackByScience = GetIsUnLoackByScience
UILWMilitaryCampPanelCtrl.GetIsUnloackByBuildLevel = GetIsUnloackByBuildLevel
UILWMilitaryCampPanelCtrl.GetAllShowSoldierList = GetAllShowSoldierList
UILWMilitaryCampPanelCtrl.GetIsUnLockByBuff = GetIsUnLockByBuff
return UILWMilitaryCampPanelCtrl
