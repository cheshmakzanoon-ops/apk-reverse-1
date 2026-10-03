local FarmingDataManager = BaseClass("FarmingDataManager")

local function __init(self)
  self.farmTemplateList = {}
  self.farmTemplateDic = {}
  self.useTableName = nil
end

local function __delete(self)
  self.farmTemplateList = nil
  self.farmTemplateDic = nil
  self.useTableName = nil
end

local function GetFarmTemplateByBuildId(self, buildId)
  if self.farmTemplateList[buildId] == nil then
    self.farmTemplateList[buildId] = {}
    LocalController:instance():visitTable(self:GetTableName(), function(id, lineData)
      local item = FarmTemplate.New()
      item:InitData(lineData)
      if item.build_id == buildId then
        table.insert(self.farmTemplateList[buildId], item)
        if self.farmTemplateDic[item.id] == nil then
          self.farmTemplateDic[item.id] = item
        end
      end
    end)
  end
  return self.farmTemplateList[buildId]
end

local function GetFarmTemplateByBuildIdInGroup(self, buildId, currentItemIndex)
  currentItemIndex = currentItemIndex or -1
  local isOpen = LuaEntry.DataConfig:CheckSwitch("farm_more")
  if not isOpen then
    currentItemIndex = -1
  end
  if self.farmTemplateList[buildId] == nil then
    self.farmTemplateList[buildId] = {}
    LocalController:instance():visitTable(self:GetTableName(), function(id, lineData)
      local item = FarmTemplate.New()
      item:InitData(lineData)
      if item.build_id == buildId then
        table.insert(self.farmTemplateList[buildId], item)
        if self.farmTemplateDic[item.id] == nil then
          self.farmTemplateDic[item.id] = item
        end
      end
    end)
  end
  local result = {}
  local tmp = {}
  table.walk(self.farmTemplateList[buildId], function(_, v)
    if v.show_level > DataCenter.BuildManager.MainLv then
      return
    end
    if tmp[v.group] == nil then
      tmp[v.group] = {}
    end
    table.insert(tmp[v.group], v)
  end)
  local tmpLockStatus = {}
  
  local function GetLockStatus(template)
    if tmpLockStatus[template.id] == nil then
      tmpLockStatus[template.id] = self:IsUnlock(template)
    end
    return tmpLockStatus[template.id]
  end
  
  table.walk(tmp, function(_, v)
    table.sort(v, function(a, b)
      local lockStatusA = GetLockStatus(a)
      local lockStatusB = GetLockStatus(b)
      if lockStatusA == true and lockStatusB == false then
        return true
      elseif lockStatusA == lockStatusB then
        if lockStatusA then
          return a.order < b.order
        end
        return a.unlock_order < b.unlock_order
      end
      return false
    end)
  end)
  table.walk(tmp, function(_, v)
    local find
    for index, k in ipairs(v) do
      if find == nil then
        find = k
      end
      if not self:IsUnlock(k) or 0 < currentItemIndex and index > currentItemIndex then
        break
      end
      find = k
    end
    if find ~= nil then
      table.insert(result, find)
    end
  end)
  return result
end

local function GetAllFarmTemplate(self)
  local farmList = {}
  LocalController:instance():visitTable(self:GetTableName(), function(id, lineData)
    local item = FarmTemplate.New()
    item:InitData(lineData)
    if farmList[item.id] == nil then
      farmList[item.id] = item
    end
  end)
  return farmList
end

local function GetFramingTemplate(self, id)
  if self.farmTemplateDic[tonumber(id)] == nil then
    local oneTemplate = LocalController:instance():getLine(self:GetTableName(), id)
    if oneTemplate ~= nil then
      local item = FarmTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.farmTemplateDic[item.id] = item
      end
    end
  end
  return self.farmTemplateDic[tonumber(id)]
end

local function IsHaveEnough(self, id, enoughType)
  local template = self:GetFramingTemplate(id)
  if template ~= nil then
    if enoughType == FarmingEnoughType.Plant then
      local result = true
      table.walk(template:GetNeedResource(1), function(c, d)
        if d > LuaEntry.Resource:GetCntByResType(c) then
          result = false
        end
      end)
      table.walk(template.need_goods, function(e, f)
        local itemData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(e, LuaEntry.Player.uid)
        if itemData == nil or f > itemData.number then
          result = false
        end
      end)
      return result
    elseif enoughType == FarmingEnoughType.Feed then
      local result = true
      local itemId
      table.walk(template.second_get_goods, function(m, n)
        itemId = m
      end)
      local resourceItemData = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(itemId)
      if resourceItemData ~= nil then
        local needGoodsId, needGoodsNum
        table.walk(template.second_need_goods, function(e, f)
          needGoodsId = e
          needGoodsNum = f
        end)
        local itemData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(needGoodsId, LuaEntry.Player.uid)
        if itemData == nil or needGoodsNum > itemData.number then
          result = false
        end
      end
      return result
    end
  end
  return true
end

local function GetTableName(self)
  if self.useTableName == nil then
    self.useTableName = LuaEntry.Player:GetABTestTableName(TableName.Farming)
  end
  return self.useTableName
end

local function IsUnlock(self, functionTemplate)
  local unlock_type = functionTemplate.unlock_type
  local unlock_player_level = functionTemplate.unlock_player_level
  local checkState = true
  if unlock_type ~= nil then
    local needConditionId, needConditionLv
    table.walk(functionTemplate.unlock_condition, function(a, b)
      needConditionId = a
      needConditionLv = b
    end)
    if needConditionId ~= nil and needConditionLv ~= nil then
      if unlock_type == TemplateUnlockType.Build then
        checkState = CommonUtil.CheckIsBuildEnough(needConditionId, needConditionLv)
      elseif unlock_type == TemplateUnlockType.Science then
        checkState = needConditionLv <= CommonUtil.CheckIsScienceEnough(needConditionId)
      elseif unlock_type == TemplateUnlockType.MonthCard then
        checkState = self:CheckMonthCard(functionTemplate.unlock_condition)
      elseif unlock_type == TemplateUnlockType.Talent then
        checkState = DataCenter.TalentDataManager:IsTalentOpen(needConditionId)
      end
    end
  end
  if not DataCenter.PlayerLevelManager:ReachLevel(unlock_player_level) then
    checkState = false
  end
  return checkState
end

local function CheckMonthCard(self, monthCard)
  if monthCard == nil or table.count(monthCard) == 0 then
    return false
  end
  local result = true
  table.walk(monthCard, function(k, _)
    if result == true and not DataCenter.MonthCardNewManager:CheckIfMonthCardActive() then
      result = false
    end
  end)
  return result
end

local function GetProductLevels(self)
  local isOpen = LuaEntry.DataConfig:CheckSwitch("farm_more")
  if not isOpen then
    return {1}
  end
  self:GetFarmTemplateByBuildId(BuildingTypes.APS_BUILD_FARM_FIELD)
  local tmp = {}
  table.walk(self.farmTemplateList[BuildingTypes.APS_BUILD_FARM_FIELD], function(_, v)
    if tmp[v.group] == nil then
      tmp[v.group] = {}
    end
    table.insert(tmp[v.group], v)
  end)
  table.walk(tmp, function(_, v)
    table.sort(v, function(a, b)
      return a.order < b.order
    end)
  end)
  local max = 0
  for k, v in pairs(tmp) do
    local find = false
    for k1, v1 in ipairs(v) do
      if not self:IsUnlock(v1) then
        if k1 > max and not find then
          max = k1
        end
        break
      else
        find = true
        if k1 > max then
          max = k1
        end
      end
    end
  end
  local result = {}
  local index = 1
  while max >= index do
    table.insert(result, index)
    index = index + 1
  end
  return result
end

FarmingDataManager.__init = __init
FarmingDataManager.__delete = __delete
FarmingDataManager.GetFarmTemplateByBuildId = GetFarmTemplateByBuildId
FarmingDataManager.GetFramingTemplate = GetFramingTemplate
FarmingDataManager.GetAllFarmTemplate = GetAllFarmTemplate
FarmingDataManager.IsHaveEnough = IsHaveEnough
FarmingDataManager.GetTableName = GetTableName
FarmingDataManager.GetFarmTemplateByBuildIdInGroup = GetFarmTemplateByBuildIdInGroup
FarmingDataManager.IsUnlock = IsUnlock
FarmingDataManager.CheckMonthCard = CheckMonthCard
FarmingDataManager.GetProductLevels = GetProductLevels
return FarmingDataManager
