local AllianceCityTemplateManager = BaseClass("AllianceCityTemplateManager")
local AllianceCityTemplate = require("DataCenter.AllianceCity.AllianceCityTemplate")
local Localization = CS.GameEntry.Localization

function AllianceCityTemplateManager:__init()
  self.cacheData = {}
  self.templatesByTableName = {}
  self.specialByTableName = {}
  self:AddListener()
end

function AllianceCityTemplateManager:__delete()
  self:RemoveListener()
end

function AllianceCityTemplateManager:Startup()
end

function AllianceCityTemplateManager:AddListener()
  EventManager:GetInstance():AddListener(EventId.LandlordCenterStateChange, self.OnLandlordCenterStateChange)
end

function AllianceCityTemplateManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.LandlordCenterStateChange, self.OnLandlordCenterStateChange)
end

function AllianceCityTemplateManager:InitTableList(tblName)
  local tblMgr = LocalController:instance()
  local theTemplateAll = self.templatesByTableName[tblName]
  if theTemplateAll == nil then
    theTemplateAll = {}
    local ThroneCityBatteryList = {}
    local MissileFactoryList = {}
    local KingCityList = {}
    local StrongholdList = {}
    tblMgr:visitTable(tblName, function(id, lineData)
      local template = AllianceCityTemplate.New()
      template:InitData(lineData)
      theTemplateAll[tostring(id)] = template
      if template.type == WorldAllianceCityType.King then
        table.insert(KingCityList, template)
      elseif template.type == WorldAllianceCityType.Canon then
        table.insert(ThroneCityBatteryList, template)
      elseif template.type == WorldAllianceCityType.MissileFactory then
        table.insert(MissileFactoryList, template)
      elseif template.type == WorldAllianceCityType.Stronghold then
        table.insert(StrongholdList, template)
      end
    end)
    self.templatesByTableName[tblName] = theTemplateAll
    self.specialByTableName[tblName] = {
      KingCityList,
      ThroneCityBatteryList,
      MissileFactoryList,
      StrongholdList
    }
  end
  return theTemplateAll
end

function AllianceCityTemplateManager:InitTemplateDict(serverId)
  local theServerId = serverId or LuaEntry.Player:GetSelfServerId()
  local tblName = SeasonUtil.GetWorldCityTableNameByServerId(theServerId)
  local dataALL = self.cacheData[theServerId] or {}
  local templateDict = dataALL.templateDict
  local oldTblName = dataALL.tblName
  dataALL.tblName = tblName
  if templateDict == nil or tblName ~= oldTblName then
    local theTemplateAll = self:InitTableList(tblName)
    dataALL.tableName = tblName
    dataALL.templateDict = theTemplateAll
    self.cacheData[theServerId] = dataALL
    local info = SeasonUtil.GetSeasonInfo(theServerId)
    if info and table.count(info.serverListInt) > 1 then
      for _serverId, _ in pairs(info.serverListInt) do
        if _serverId ~= 0 and _serverId ~= -1 then
          local _dataALL = self.cacheData[_serverId] or {}
          if _dataALL.templateDict == nil then
            local serverTableName = SeasonUtil.GetWorldCityTableNameByServerId(_serverId)
            local serverTheTemplateAll = self:InitTableList(serverTableName)
            _dataALL.tableName = serverTableName
            _dataALL.templateDict = serverTheTemplateAll
            self.cacheData[_serverId] = _dataALL
          end
        end
      end
    end
  end
  return dataALL
end

function AllianceCityTemplateManager:GetTemplateBySeasonConfigId(configId, seasonConfigId)
  local tableName = SeasonUtil.GetWorldCityTableNameBySeasonConfigId(seasonConfigId)
  return self:GetTemplateByTableName(configId, tableName)
end

function AllianceCityTemplateManager:GetTemplateByTableName(configId, tableName)
  local theTemplateAll = self.templatesByTableName[tableName]
  if theTemplateAll ~= nil then
    local data = theTemplateAll[tostring(configId)]
    if data == nil then
      if CommonUtil.IsGrayServer() then
        Logger.LogWarning("AllianceCityGetTemplateError," .. configId .. "," .. tableName)
      else
        Logger.LogInfo("AllianceCityGetTemplateError," .. configId .. "," .. tableName)
      end
    end
    return data
  end
  local lineData = LocalController:instance():getLine(tableName, toInt(configId))
  if lineData then
    local template = AllianceCityTemplate.New()
    template:InitData(lineData)
    return template
  end
  if CommonUtil.IsGrayServer() then
    Logger.LogWarning("AllianceCityGetTemplateError," .. configId .. "," .. tableName)
  else
    Logger.LogInfo("AllianceCityGetTemplateError," .. configId .. "," .. tableName)
  end
  return nil
end

function AllianceCityTemplateManager:GetTemplate(id, serverId)
  local curServerId = LuaEntry.Player:GetCurServerId()
  local theServerId = serverId or LuaEntry.Player:GetSelfServerId()
  if self.cacheData then
    local dataALL = self.cacheData[theServerId]
    if dataALL ~= nil and dataALL.templateDict ~= nil then
      local data = dataALL.templateDict[tostring(id)]
      if data then
        return data
      end
    end
  end
  local tblName = SeasonUtil.GetWorldCityTableNameByServerId(theServerId)
  local lineData = LocalController:instance():tryGetLine(tblName, toInt(id))
  if lineData then
    local template = AllianceCityTemplate.New()
    template:InitData(lineData)
    return template
  elseif theServerId ~= curServerId then
    tblName = SeasonUtil.GetWorldCityTableNameByServerId(curServerId)
    lineData = LocalController:instance():tryGetLine(tblName, toInt(id))
    if lineData then
      local template = AllianceCityTemplate.New()
      template:InitData(lineData)
      return template
    end
  end
  lineData = LocalController:instance():tryGetLine("season_city_s5", toInt(id))
  if lineData then
    local template = AllianceCityTemplate.New()
    template:InitData(lineData)
    return template
  end
  if CommonUtil.IsGrayServer() then
    Logger.LogWarning("GetAllianceCityTemplateFail," .. id .. "," .. curServerId .. "," .. theServerId)
  else
    Logger.LogInfo("GetAllianceCityTemplateFail," .. id .. "," .. curServerId .. "," .. theServerId)
  end
  return nil
end

function AllianceCityTemplateManager:GetAllTemplate(serverId)
  local theServerId = serverId or LuaEntry.Player:GetSelfServerId()
  local dataALL = self.cacheData[theServerId]
  if dataALL == nil or dataALL.templateDict == nil then
    dataALL = self:InitTemplateDict(theServerId)
  end
  return dataALL.templateDict
end

function AllianceCityTemplateManager:GetTemplateMaxLv(serverId)
  local lv = 1
  local template = self:GetAllTemplate(serverId)
  for i, v in pairs(template) do
    if lv < v.level and v.type ~= WorldAllianceCityType.Canon and v.type ~= WorldAllianceCityType.Stronghold and v.type ~= WorldAllianceCityType.TradingStation and v.type ~= WorldAllianceCityType.MissileFactory and v.type ~= WorldAllianceCityType.GoldTree and v.type ~= WorldAllianceCityType.Mountain then
      lv = v.level
    end
  end
  return lv
end

function AllianceCityTemplateManager:GetAllyCitySize(serverId)
  local ret = {}
  local template = self:GetAllTemplate(serverId)
  local landlordCenterServerTemplate = {}
  if DataCenter.LandlordMgr:IsInNewCenterMapPeriod() then
    local centerServerId = DataCenter.LandlordMgr:GetCenterServerId()
    landlordCenterServerTemplate = self:GetAllTemplate(centerServerId)
  end
  local inSeason = SeasonUtil.IsInSeason()
  for i, v in pairs(template) do
    local tempData = v
    if landlordCenterServerTemplate[i] then
      tempData = landlordCenterServerTemplate[i]
    end
    local data = {}
    data.itemId = tempData.id
    if inSeason and tempData.season_tile_size ~= nil and tempData.season_tile_size ~= 0 then
      data.size = tempData.season_tile_size
      data.cityType = tempData.type
    else
      data.size = tempData.size
      data.cityType = tempData.type
    end
    table.insert(ret, data)
  end
  return ret
end

function AllianceCityTemplateManager:GetFirstRewardByLevel(level, serverId)
  local template = self:GetAllTemplate(serverId)
  for i, v in pairs(template) do
    if v.level == level and v.type ~= WorldAllianceCityType.Canon and v.type ~= WorldAllianceCityType.Stronghold and v.type ~= WorldAllianceCityType.TradingStation and v.type ~= WorldAllianceCityType.MissileFactory and v.type ~= WorldAllianceCityType.GoldTree and v.type ~= WorldAllianceCityType.Mountain then
      return v.show_reward
    end
  end
  return "15;5;1000|230006;7;10|400106;7;10|400206;7;10"
end

local function city_sort(a, b)
  if a.level == b.level then
    return a.id < b.id
  end
  return a.level > b.level
end

function AllianceCityTemplateManager:GetOccupiedCityList(al, inSeason)
  local theServerId = LuaEntry.Player:GetSelfServerId()
  local dataALL = self.cacheData[theServerId]
  if dataALL == nil or dataALL.templateDict == nil then
    dataALL = self:InitTemplateDict(theServerId)
  end
  local occupied = {}
  local unmanned = {}
  if dataALL == nil or dataALL.templateDict == nil then
    return occupied, unmanned
  end
  local cityWarInfo = DataCenter.WorldAllianceCityDataManager.theCityWarInfo
  if cityWarInfo == nil or cityWarInfo.cityInfoList == nil then
    local template = self:GetAllTemplate(theServerId)
    for _, cityInfo in pairs(template) do
      if cityInfo and cityInfo:IsCity() then
        table.insert(unmanned, cityInfo)
      end
    end
  else
    local maxLevel = 8
    if not inSeason and cityWarInfo.nextOpen ~= nil then
      maxLevel = cityWarInfo.nextOpen.level or 7
    end
    local cityIdList = {}
    for _, v in pairs(cityWarInfo.cityInfoList) do
      local cityInfo = dataALL.templateDict[tostring(v.cityId)]
      if cityInfo ~= nil and maxLevel > cityInfo.level then
        if al ~= nil and v.alId == al or v.alId ~= nil and al == nil then
          if cityInfo and cityInfo:IsCity() then
            table.insert(occupied, cityInfo)
          end
        elseif cityInfo and cityInfo:IsCity() then
          table.insert(unmanned, cityInfo)
        end
        cityIdList[v.cityId] = v
      end
    end
    if inSeason then
      for _, v in pairs(cityWarInfo.noOpenList) do
        if cityIdList[v.cityId] == nil then
          local cityInfo = dataALL.templateDict[tostring(v.cityId)]
          if cityInfo and cityInfo:IsCity() then
            table.insert(unmanned, cityInfo)
          end
          cityIdList[v.cityId] = v
        end
      end
    end
  end
  table.sort(occupied, city_sort)
  table.sort(unmanned, city_sort)
  return occupied, unmanned
end

function AllianceCityTemplateManager:GetCityDataByPointIndex(pointId, serverId)
  local kingCityId, kingCityPosIndex = SeasonUtil.GetKingCityId(serverId)
  if pointId == kingCityPosIndex then
    return self:GetKingCityData(serverId)
  end
  if 0 < pointId and pointId < WorldTileCount * WorldTileCount * 10 then
    local template = self:GetAllTemplate(serverId)
    for _, v in pairs(template) do
      if v ~= nil and v:GetPointId() == pointId then
        return v
      end
    end
  end
  return nil
end

function AllianceCityTemplateManager:GetCityByType(type, serverId)
  local template = self:GetAllTemplate(serverId)
  for _, v in pairs(template) do
    if v and v.type == type then
      return v
    end
  end
  return nil
end

function AllianceCityTemplateManager:GetKingCityData(serverId)
  local theServerId = serverId or LuaEntry.Player:GetSelfServerId()
  local kingCityId, kingCityPosIndex = SeasonUtil.GetKingCityId(theServerId)
  local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(kingCityId, theServerId)
  return cityMeta
end

function AllianceCityTemplateManager:GetThroneCityBatteryList(serverId)
  local theServerId = serverId or LuaEntry.Player:GetSelfServerId()
  local dataALL = self.cacheData[theServerId]
  if dataALL == nil or dataALL.templateDict == nil then
    dataALL = self:InitTemplateDict(theServerId)
  end
  if dataALL.ThroneCityBatteryList then
    return dataALL.ThroneCityBatteryList
  end
  local data = self.specialByTableName[dataALL.tableName]
  if data then
    local KingCityList = data[1]
    if KingCityList == nil or #KingCityList == 1 then
      return data[2] or {}
    elseif data[2] ~= nil then
      local info = SeasonUtil.GetSeasonInfo(theServerId)
      if info then
        local ThroneCityBatteryList = {}
        for k, v in ipairs(data[2]) do
          local _serverId = info:GetNinePalacesServer(v.bigMapIndex)
          if _serverId == theServerId then
            table.insert(ThroneCityBatteryList, v)
          end
        end
        dataALL.ThroneCityBatteryList = ThroneCityBatteryList
        return ThroneCityBatteryList
      end
    end
  end
  return {}
end

function AllianceCityTemplateManager:GetMissileFactoryList(serverId)
  local theServerId = serverId or LuaEntry.Player:GetSelfServerId()
  local dataALL = self.cacheData[theServerId]
  if dataALL == nil or dataALL.templateDict == nil then
    dataALL = self:InitTemplateDict(theServerId)
  end
  if dataALL.MissileFactoryList then
    return dataALL.MissileFactoryList
  end
  local data = self.specialByTableName[dataALL.tableName]
  if data then
    local KingCityList = data[1]
    if KingCityList == nil or #KingCityList == 1 then
      return data[3] or {}
    elseif data[3] ~= nil then
      local info = SeasonUtil.GetSeasonInfo(theServerId)
      if info then
        local MissileFactoryList = {}
        for k, v in ipairs(data[3]) do
          local _serverId = info:GetNinePalacesServer(v.bigMapIndex)
          if _serverId == theServerId then
            table.insert(MissileFactoryList, v)
          end
        end
        dataALL.MissileFactoryList = MissileFactoryList
        return MissileFactoryList
      end
    end
  end
  return {}
end

function AllianceCityTemplateManager:GetStrongholdList(serverId)
  local theServerId = serverId or LuaEntry.Player:GetSelfServerId()
  local dataALL = self.cacheData[theServerId]
  if dataALL == nil or dataALL.templateDict == nil then
    dataALL = self:InitTemplateDict(theServerId)
  end
  local specialData = self.specialByTableName[dataALL.tableName]
  return specialData and specialData[4] or {}
end

function AllianceCityTemplateManager:GetCityIconByLevel(level, serverId)
  local template = self:GetAllTemplate(serverId)
  for _, v in pairs(template) do
    if v ~= nil and v.level == level and v.type ~= WorldAllianceCityType.Canon and v.type ~= WorldAllianceCityType.Stronghold and v.type ~= WorldAllianceCityType.TradingStation and v.type ~= WorldAllianceCityType.MissileFactory and v.type ~= WorldAllianceCityType.GoldTree and v.type ~= WorldAllianceCityType.Mountain then
      return v:GetIconPath(false)
    end
  end
  return "Assets/Main/Sprites/UI/LWAllianceZone/Textures/chengshi_7.png"
end

function AllianceCityTemplateManager:GetCityByLevel(level, serverId, buildType, bigMapIndex)
  local template = self:GetAllTemplate(serverId)
  for _, v in pairs(template) do
    if v ~= nil and v.level == level and (bigMapIndex == nil or v.bigMapIndex == bigMapIndex) then
      if buildType == nil then
        if v.type == WorldAllianceCityType.City or v.type == WorldAllianceCityType.King then
          return v
        end
      elseif v.type == buildType then
        return v
      end
    end
  end
  return nil
end

function AllianceCityTemplateManager:GetFormatName(cityId, serverId)
  serverId = serverId or LuaEntry.Player:GetCurServerId()
  local template = self:GetTemplate(cityId, serverId)
  if template then
    local name = Localization:GetString(template.name)
    return Localization:GetString("140205", template.level, name) .. " " .. Localization:GetString("300015", template.pos.x, template.pos.y)
  end
  return ""
end

function AllianceCityTemplateManager:GetCurServerConfig(cityId)
  return self:GetTemplate(cityId, LuaEntry.Player:GetCurServerId())
end

function AllianceCityTemplateManager:GetAllianceCityBuffByCityId(cityId, serverId)
  local template = self:GetTemplate(cityId, serverId)
  if not template then
    return nil
  end
  local buff = template.buff
  if not buff then
    return nil
  end
  local oneData = {}
  oneData.buffDes = ""
  oneData.buffAddNum = ""
  local buffArr = string.split(buff, "|")
  if 0 < #buffArr then
    local buffStr = string.split(buffArr[1], ";")
    if 1 < #buffStr then
      local effectId = tonumber(buffStr[1])
      if effectId ~= 30145 then
        local value = tonumber(buffStr[2])
        local buffAddNum, effectName = UIUtil.GetEffectStr(nil, value, effectId)
        oneData.buffDes = effectName
        oneData.buffAddNum = buffAddNum
      end
    end
    if 1 < #buffArr then
      local buffStr2 = string.split(buffArr[2], ";")
      if 1 < #buffStr2 then
        local effectId = tonumber(buffStr2[1])
        if effectId ~= 30145 then
          local value = tonumber(buffStr2[2])
          local nameStr = GetTableData(TableName.LW_Effect_Number, effectId, "name")
          oneData.buffDes2 = nameStr
          local type = toInt(GetTableData(TableName.LW_Effect_Number, effectId, "type"))
          if type == EffectLocalTypeInEffectDesc.Num then
            oneData.buffAddNum2 = string.GetFormattedSeperatorNum(value)
          elseif type == EffectLocalTypeInEffectDesc.Percent then
            oneData.buffAddNum2 = string.GetFormattedPercentStr(value)
          elseif type == EffectLocalTypeInEffectDesc.Thousandth then
            oneData.buffAddNum2 = string.GetFormattedThousandthStr(value)
          end
        end
      end
    end
  end
  return oneData
end

function AllianceCityTemplateManager:GetAllianceCityBuffDescByCityId(cityId, serverId)
  local descData = self:GetAllianceCityBuffByCityId(cityId, serverId)
  if descData then
    local desc = Localization:GetString(descData.buffDes)
    return string.format("%s<color=#34FF80>%s</color>", desc, descData.buffAddNum)
  end
  return ""
end

function AllianceCityTemplateManager:GetNearestCity(targetIndex, targetType)
  if targetIndex == nil or targetIndex <= 0 then
    targetIndex = 1002
  end
  local theServerId = serverId or LuaEntry.Player:GetSelfServerId()
  local dataALL = self.cacheData[theServerId]
  if dataALL == nil or dataALL.templateDict == nil then
    dataALL = self:InitTemplateDict(theServerId)
  end
  local templateDict = dataALL.templateDict
  local zoneId = SceneUtils.GetZoneIdByPosId(targetIndex)
  if zoneId then
    local cityInfo = templateDict[tostring(zoneId)]
    if cityInfo and (targetType == nil or targetType == cityInfo.type) then
      return cityInfo
    end
    if cityInfo and cityInfo.nearBy then
      for k, v in pairs(cityInfo.nearBy) do
        local theCity = self:GetTemplate(v)
        if theCity and (targetType == nil or targetType == theCity.type) then
          return theCity
        end
      end
    end
  end
  local pos = SceneUtils.IndexToTilePos(targetIndex, ForceChangeScene.World)
  local minDis = 99999
  local ret
  for k, v in pairs(templateDict) do
    if targetType == nil or targetType == v.type then
      local dis = math.abs(v.pos.x - pos.x) + math.abs(v.pos.y - pos.y)
      if minDis > dis then
        ret = v
        minDis = dis
      end
    end
  end
  return ret
end

function AllianceCityTemplateManager:GetAllNearByCities(cityId)
  local template = self:GetTemplate(cityId)
  if template == nil or string.IsNullOrEmpty(template.nearBy) then
    return {}
  end
  local ret = {}
  for i = 1, #template.nearBy do
    local temp = self:GetTemplate(template.nearBy[i])
    if temp then
      table.insert(ret, temp)
    end
  end
  return ret
end

function AllianceCityTemplateManager:GetStrongholdByCampAndLevelList(camp, levelList)
  local ret = {}
  local serverList = DataCenter.SeasonFactionWarDataManager:GetServerIdListByCampId(camp)
  for _, serverId in pairs(serverList) do
    local strongHold = self:GetStrongholdList(serverId)
    for _, city in pairs(strongHold) do
      for _, level in pairs(levelList) do
        if city.level == level then
          table.insert(ret, city)
          break
        end
      end
    end
  end
  return ret
end

function AllianceCityTemplateManager:OnLandlordCenterStateChange()
  local self = DataCenter.AllianceCityTemplateManager
  if self.cacheData then
    local centerServerId = DataCenter.LandlordMgr:GetCenterServerId()
    SeasonUtil.ClearTableNameByServerId(centerServerId)
    if self.cacheData[centerServerId] then
      self.cacheData[centerServerId] = nil
    end
  end
end

return AllianceCityTemplateManager
