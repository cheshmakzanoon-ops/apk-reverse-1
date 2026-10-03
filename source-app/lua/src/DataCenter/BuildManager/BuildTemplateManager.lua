local BuildTemplateManager = BaseClass("BuildTemplateManager")

local function __init(self)
  self.buildDesTemplateDic = {}
  self.buildLevelTemplateDic = {}
  self.buildListIds = {}
  self.initBuildIds = false
  self.levelUpDic = {}
  self.zone = {}
  self.useTableName = nil
  self.isAllTrans = false
  self.buyDecorateDataList = nil
end

local function __delete(self)
  self.buildDesTemplateDic = nil
  self.buildLevelTemplateDic = nil
  self.buildListIds = nil
  self.levelUpDic = nil
  self.zone = nil
  self.useTableName = nil
  self.isAllTrans = nil
  self.initBuildIds = nil
  self.buyDecorateDataList = nil
end

local function GetBuildingDesTemplate(self, id)
  if id == nil then
    Logger.LogError("shimin --------------------- GetBuildingDesTemplate stringId == 0")
  end
  local intId = toInt(id)
  if self.buildDesTemplateDic[intId] == nil and 0 < intId then
    local oneTemplate = LocalController:instance():getLine(self:GetTableName(), intId)
    if oneTemplate ~= nil then
      local item = BuildingDesTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.buildDesTemplateDic[item.id] = item
      end
    end
  end
  return self.buildDesTemplateDic[intId]
end

local function GetBuildingLevelTemplate(self, buildId, level)
  if buildId == nil or level == nil then
    Logger.LogError("GetBuildingDesTemplate stringId == 0")
    return nil
  end
  local intId = toInt(buildId)
  local id = intId + level
  if self.buildLevelTemplateDic[id] == nil then
    local oneTemplate = LocalController:instance():getLine(self:GetTableName(), id)
    if oneTemplate ~= nil then
      local item = BuildingLevelTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.buildLevelTemplateDic[item.id] = item
      end
    end
  end
  return self.buildLevelTemplateDic[id]
end

local function TransAllBuildingTemplate(self, filter)
  if self.isAllTrans then
    return
  end
  self.isAllTrans = true
  self.buildDesTemplateDic = {}
  self.buildLevelTemplateDic = {}
  local seasonBuildList = {}
  if SeasonUtil.IsInSeason() then
    local alMineTemplateDic = DataCenter.AllianceMineManager.alMineTemplateDic
    for i, v in pairs(alMineTemplateDic) do
      if v.unlock_building then
        for k, buildId in ipairs(v.unlock_building) do
          seasonBuildList[toInt(buildId)] = v
        end
      end
    end
  end
  LocalController:instance():visitTable(self:GetTableName(), function(_, lineData)
    local id = lineData:getValue("id")
    local level = id % BuildLevelCap
    local buildBaseId = id - level
    if level == 0 then
      local item = BuildingDesTemplate.New()
      item:InitData(lineData)
      if item.id ~= nil and (item.tab_type ~= UIBuildListTabType.SeasonBuild or seasonBuildList[buildBaseId] ~= nil) then
        if item.tab_type == UIBuildListTabType.SeasonBuild then
          item.allianceCenterBaseId = seasonBuildList[buildBaseId].baseId
          if item.para1 == nil or item.para1 == 0 or item.para1 == "" then
            item.para1 = item.allianceCenterBaseId
          end
        end
        self.buildDesTemplateDic[item.id] = item
      end
    elseif filter ~= nil and filter[buildBaseId] ~= nil and buildBaseId + filter[buildBaseId] == id then
      local item = BuildingLevelTemplate.New()
      item:InitData(lineData)
      if item.id ~= nil and (item.tab_type ~= UIBuildListTabType.SeasonBuild or seasonBuildList[buildBaseId] ~= nil) then
        if item.tab_type == UIBuildListTabType.SeasonBuild then
          item.allianceCenterBaseId = seasonBuildList[buildBaseId].baseId
          if item.para1 == nil or item.para1 == 0 or item.para1 == "" then
            item.para1 = item.allianceCenterBaseId
          end
        end
        self.buildLevelTemplateDic[item.id] = item
      end
    end
  end)
end

local function GetAllBuildTileByItemId(self)
  if not self.isAllTrans then
    self:TransAllBuildingTemplate()
  end
  local list = {}
  table.walk(self.buildDesTemplateDic, function(k, v)
    if v.id > 0 then
      local item = {}
      item.itemId = v.id
      item.tiles = v.tileX
      table.insert(list, item)
    end
  end)
  return list
end

local function GetAllBuildOffset(self)
  local list = {}
  local buildId = BuildingTypes.FUN_BUILD_MAIN
  local mainTemplate = self:GetBuildingDesTemplate(buildId)
  if mainTemplate ~= nil then
    local max = mainTemplate.max_level
    if 0 < max then
      for i = 1, max do
        local levelTemplate = self:GetBuildingLevelTemplate(buildId, i)
        if levelTemplate ~= nil then
          local item = {}
          item.id = levelTemplate.id
          item.offer_range = levelTemplate.offer_range
          table.insert(list, item)
        end
      end
    end
  end
  return list
end

local function InitBuildListIds(self)
  if self.initBuildIds then
    return
  end
  self.zone = {}
  self.buildListIds = {}
  self.buildListIds[UIBuildListTabType.Decorate] = {}
  local logErrorFlag = true
  local templateDic = self.buildDesTemplateDic
  if templateDic ~= nil then
    for k, v in pairs(templateDic) do
      local tId = v.id
      local level = tId % BuildLevelCap
      if level ~= 0 then
        if logErrorFlag then
          logErrorFlag = false
          Logger.LogError("InitBuildListIds level non 0 error, id: " .. tId)
        end
      else
        local tabType = v.tab_type
        local tempR = self.buildListIds[tabType]
        if tempR == nil then
          self.buildListIds[tabType] = {}
        end
        local param = {}
        if v.tab_type ~= UIBuildListTabType.Decorate then
          param.buildType = UIBuildListBuildType.Build
        else
          param.buildType = UIBuildListBuildType.Decorate
        end
        param.id = v.id
        param.order = v.order
        param.buildTemplate = v
        param.needLevel = 0
        if v.allianceCenterBaseId then
          param.allianceCenterId = v.allianceCenterBaseId
        end
        local preBuild = v:GetPreBuild()
        if preBuild ~= nil then
          for k1, v1 in ipairs(preBuild) do
            if v1.buildId == BuildingTypes.FUN_BUILD_MAIN then
              param.needLevel = v1.level
            end
          end
        end
        if v.build_type ~= BuildType.Third then
          table.insert(self.buildListIds[v.tab_type], param)
        end
        if self.zone[v.zoneType] == nil then
          self.zone[v.zoneType] = {}
        end
        if self.zone[v.zoneType][v.zoneMainType] == nil then
          self.zone[v.zoneType][v.zoneMainType] = {}
        end
        table.insert(self.zone[v.zoneType][v.zoneMainType], v)
      end
    end
  end
  self.initBuildIds = true
end

local function GetBuildListIds(self)
  return self.buildListIds
end

local function GetLevelUpTemplate(self, id)
  if self.levelUpDic[tonumber(id)] == nil then
    local oneTemplate = LocalController:instance():getLine(TableName.LevelUp, tostring(id))
    if oneTemplate ~= nil then
      local item = LevelUpTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.levelUpDic[item.id] = item
      end
    end
  end
  return self.levelUpDic[tonumber(id)]
end

local function GetZoneByZoneType(self, zoneType)
  if self.zone ~= nil and self.zone[zoneType] ~= nil then
    return self.zone[zoneType]
  end
end

local function GetZoneByBuildId(self, buildId)
  local templateDic = self:GetBuildingDesTemplate(buildId)
  if templateDic ~= nil and self.zone ~= nil and self.zone[templateDic.zoneType] ~= nil then
    return self.zone[templateDic.zoneType]
  end
end

local function GetTableName(self)
  if self.useTableName == nil then
    if LuaEntry.Player ~= nil then
      self.useTableName = LuaEntry.Player:GetABTestTableName(TableName.Building)
    else
      self.useTableName = TableName.Building
    end
  end
  return self.useTableName
end

local function GetAllBuildingDesTemplate(self)
  if not self.isAllTrans then
    self:TransAllBuildingTemplate()
  end
  return self.buildDesTemplateDic
end

local function GetBuyDecorateDataList(self)
  if self.buyDecorateDataList == nil then
    self.buyDecorateDataList = {}
    LocalController:instance():visitTable(self:GetTableName(), function(_, lineData)
      local id = lineData:getValue("id")
      local level = id % BuildLevelCap
      local buildBaseId = id - level
      if level ~= 0 then
        local tabType = lineData:getValue("tab_type")
        if tabType == UIBuildListTabType.Decorate then
          local buildTemplate = self:GetBuildingLevelTemplate(buildBaseId, level)
          if buildTemplate and buildTemplate.needResource and 0 < #buildTemplate.needResource then
            table.insert(self.buyDecorateDataList, buildTemplate)
          end
        end
      end
    end)
  end
  return self.buyDecorateDataList
end

local function GetNoBuyDecorateDataListByQuality(self, quality)
  local list = {}
  for baseId, buildTemp in pairs(self.buildDesTemplateDic) do
    baseId = CommonUtil.GetBuildBaseType(baseId)
    if buildTemp.tab_type == UIBuildListTabType.Decorate and (buildTemp.needResource == nil or table.IsEmpty(buildTemp.needResource)) and (quality == nil or buildTemp.para3 == tostring(quality)) and self:CheckDecoratorShowCondition(baseId) then
      list[baseId] = 1
    end
  end
  return list
end

local function GetDecorationListByEffectId(self, effectId)
  local map = {}
  LocalController:instance():visitTable(self:GetTableName(), function(_, lineData)
    local id = lineData:getValue("id")
    local level = id % BuildLevelCap
    local buildBaseId = id - level
    if level ~= 0 then
      local tabType = lineData:getValue("tab_type")
      if tabType == UIBuildListTabType.Decorate then
        local buildTemp = self:GetBuildingLevelTemplate(buildBaseId, level)
        if buildTemp and buildTemp.building_effect_last and buildTemp.building_effect_last[effectId] then
          local baseId = CommonUtil.GetBuildBaseType(buildTemp.id)
          if self:CheckDecoratorShowCondition(baseId) then
            map[baseId] = 1
          end
        end
      end
    end
  end)
  local list = {}
  table.walk(map, function(k, v)
    table.insert(list, k)
  end)
  return list
end

local function GetAllLevelEffectMapByBaseBuildingId(self, baseBuildingId)
  local retMap = {}
  local desTemplate = self:GetBuildingDesTemplate(baseBuildingId)
  for i = 1, desTemplate.max_level do
    local levelTemplate = self:GetBuildingLevelTemplate(baseBuildingId, i)
    local effectList = DeepCopy(levelTemplate.building_effect_last)
    retMap[i] = effectList
  end
  return retMap
end

local function CheckDecoratorShowCondition(self, baseId)
  local openDays = UITimeManager:GetInstance().GetServerOpenDays()
  local desTemplate = self:GetBuildingDesTemplate(baseId)
  local hasAnyDecorator = DataCenter.BuildManager:HasBuilding(baseId, true)
  if table.count(desTemplate.display_gallery_condition) >= 1 and not hasAnyDecorator then
    local flag = true
    local condition = desTemplate.display_gallery_condition
    for k, v in pairs(condition) do
      if tonumber(v[1]) == 1 and openDays < tonumber(v[2]) then
        flag = false
        break
      elseif tonumber(v[1]) == 2 then
        local serverStr = v[2]
        if serverStr then
          local result = false
          local serverRangeArray = string.split(serverStr, ",")
          for _, serverRangeStr in pairs(serverRangeArray) do
            local serverArray = string.split_ii_array(serverRangeStr, "-")
            local selfServerId = LuaEntry.Player:GetSourceServerId()
            if table.count(serverArray) == 2 then
              if selfServerId >= serverArray[1] and selfServerId <= serverArray[2] then
                result = true
                break
              end
            elseif table.count(serverArray) == 1 and selfServerId == serverArray[1] then
              result = true
              break
            end
          end
          if not result then
            flag = false
          end
        end
      elseif tonumber(v[1]) == 3 then
        local curTime = UITimeManager:GetInstance():GetServerSeconds()
        local absoluteTime = UIUtil.GetAbsoluteTimeByStr(v[2])
        if absoluteTime == nil or curTime < absoluteTime then
          flag = false
          break
        end
      end
    end
    if flag then
      return true
    end
  else
    return true
  end
  return false
end

BuildTemplateManager.__init = __init
BuildTemplateManager.__delete = __delete
BuildTemplateManager.GetBuildingDesTemplate = GetBuildingDesTemplate
BuildTemplateManager.GetBuildingLevelTemplate = GetBuildingLevelTemplate
BuildTemplateManager.TransAllBuildingTemplate = TransAllBuildingTemplate
BuildTemplateManager.InitBuildListIds = InitBuildListIds
BuildTemplateManager.GetBuildListIds = GetBuildListIds
BuildTemplateManager.GetLevelUpTemplate = GetLevelUpTemplate
BuildTemplateManager.GetAllBuildTileByItemId = GetAllBuildTileByItemId
BuildTemplateManager.GetAllBuildOffset = GetAllBuildOffset
BuildTemplateManager.GetZoneByZoneType = GetZoneByZoneType
BuildTemplateManager.GetZoneByBuildId = GetZoneByBuildId
BuildTemplateManager.GetTableName = GetTableName
BuildTemplateManager.GetAllBuildingDesTemplate = GetAllBuildingDesTemplate
BuildTemplateManager.GetBuyDecorateDataList = GetBuyDecorateDataList
BuildTemplateManager.GetNoBuyDecorateDataListByQuality = GetNoBuyDecorateDataListByQuality
BuildTemplateManager.GetDecorationListByEffectId = GetDecorationListByEffectId
BuildTemplateManager.GetAllLevelEffectMapByBaseBuildingId = GetAllLevelEffectMapByBaseBuildingId
BuildTemplateManager.CheckDecoratorShowCondition = CheckDecoratorShowCondition
return BuildTemplateManager
