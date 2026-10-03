local DecorationTemplateManager = BaseClass("DecorationTemplateManager")
local DecorationTemplate = require("DataCenter.DecorationDataManager.DecorationTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.templateDic = nil
  self.decorationItems = nil
  self.labelTextColorDict = {}
  self.initAll = false
  self.typeDic = {}
  self.seasonSkinIds = {}
end

local function __delete(self)
  self.templateDic = nil
  self.decorationItems = nil
  self.labelTextColorDict = nil
  self.initAll = nil
  self.typeDic = nil
  self.seasonSkinIds = nil
end

local function InitLineData(self, lineData)
  if not lineData then
    return
  end
  local id = lineData.id
  if self.templateDic and self.templateDic[id] then
    return
  end
  local item = DecorationTemplate.New()
  item:InitData(lineData)
  if not self.templateDic then
    self.templateDic = {}
  end
  self.templateDic[item.id] = item
  if not self.typeDic[item.type] then
    self.typeDic[item.type] = {}
  end
  self.typeDic[#self.typeDic[item.type] + 1] = item
  if item.season > 0 then
    self.seasonSkinIds[item.id] = item.season
  end
end

function DecorationTemplateManager:IsSeasonSkin(id)
  return self.seasonSkinIds[id]
end

local function InitAllTemplate(self)
  if not self.templateDic then
    self.templateDic = {}
  end
  LocalController:instance():visitTable(TableName.Decoration, function(id, lineData)
    InitLineData(self, lineData)
  end)
  self.initAll = true
end

local function GetAllTemplate(self)
  if not self.initAll then
    self:InitAllTemplate()
  end
  return self.templateDic
end

local function GetTemplate(self, id)
  if id == nil or id <= 0 then
    return nil
  end
  if self.templateDic and self.templateDic[id] then
    return self.templateDic[id]
  end
  local lineData = LocalController:instance():getLine(TableName.Decoration, id)
  if lineData == nil then
    return nil
  end
  if not self.templateDic then
    self.templateDic = {}
  end
  InitLineData(self, lineData)
  return self.templateDic[id]
end

local function GetAllTypes(self, showGroup)
  local result = {}
  local all = self:GetAllTemplate()
  local tmp = {}
  for _, v in pairs(all) do
    if showGroup == nil or v.showGroup == showGroup then
      tmp[v.type] = 1
    end
  end
  result = table.keys(tmp)
  table.sort(result, function(k, v)
    return k < v
  end)
  return result
end

local function GetTypeDecorations(self, type)
  local result = {}
  local all = self:GetAllTemplate()
  for k, v in pairs(all) do
    if v.type == type then
      table.insert(result, k)
    end
  end
  return result
end

local function GetDecorationItem(self)
  if self.decorationItems == nil then
    self.decorationItems = {}
  end
  local all = self:GetAllTemplate()
  for _, template in pairs(all) do
    local methods = template.gainMethod
    for _, v in pairs(methods) do
      self.decorationItems[v.id] = 1
    end
  end
  return self.decorationItems
end

local function GetItemInDecoraitonIndex(self, skinId, itemId)
  if not skinId or not itemId then
    return nil
  end
  local skinTemplate = self:GetTemplate(skinId)
  if not skinTemplate then
    return nil
  end
  if not table.IsNullOrEmpty(skinTemplate.gainMethod) then
    for _, v in pairs(skinTemplate.gainMethod) do
      if v.id == tonumber(itemId) then
        return v.index
      end
    end
  end
  return nil
end

local function GetAppearanceIdBySkinId(self, skinId)
  if not skinId then
    return nil
  end
  local skinTemplate = self:GetTemplate(skinId)
  if not skinTemplate then
    return nil
  end
  return skinTemplate.appearance
end

local function GetLabelSkinTextColor(self, skinId, colorType)
  if colorType == 6 then
    local test = 1
  end
  if not colorType then
    return CityLabelWhiteColor
  end
  if not skinId or skinId <= 0 then
    return CityLabelColors[colorType] or CityLabelWhiteColor
  end
  local numberColorType = colorType
  if self.labelTextColorDict[skinId] == nil then
    local skinTemplate = self:GetTemplate(skinId)
    if not skinTemplate then
      return CityLabelWhiteColor
    end
    if skinTemplate.type == DecorationType.DecorationType_TittleName then
      self.labelTextColorDict[skinId] = {}
      if not string.IsNullOrEmpty(skinTemplate.customVariable) then
        local temp1 = string.split(skinTemplate.customVariable, ";")
        for _, v in pairs(temp1) do
          local temp2 = string.split(v, ",")
          if not table.IsNullOrEmpty(temp2) then
            self.labelTextColorDict[skinId][tonumber(temp2[1])] = Color.New(tonumber(temp2[2]) or 1, tonumber(temp2[3]) or 1, tonumber(temp2[4]) or 1, 1)
          end
        end
      end
      local startIndex = CS.GameDefines.CityLabelColorType.Green:GetHashCode()
      local endIndex = CS.GameDefines.CityLabelColorType.Black:GetHashCode()
      for i = startIndex, endIndex do
        if not self.labelTextColorDict[skinId][i] then
          self.labelTextColorDict[skinId][i] = CityLabelColors[i]
        end
      end
    end
  end
  if self.labelTextColorDict[skinId] and self.labelTextColorDict[skinId][numberColorType] then
    return self.labelTextColorDict[skinId][numberColorType]
  end
  return CityLabelColors[numberColorType] or CityLabelWhiteColor
end

function DecorationTemplateManager:GetDefaultDecorationsByType(type)
  local result = {}
  local all = self:GetAllTemplate()
  for k, v in pairs(all) do
    if v.type == type and v.typeGain == DecorationGainType.DecorationGainType_Default then
      table.insert(result, k)
    end
  end
  return result
end

function DecorationTemplateManager:CheckTemplateCanShow(showCondition, serverList_)
  local serverFlag = false
  if serverList_ then
    local serverId = LuaEntry.Player:GetSourceServerId()
    for k, v in pairs(serverList_) do
      if serverId >= v[1] and serverId <= tonumber(v[2]) then
        serverFlag = true
        break
      end
    end
  else
    serverFlag = true
  end
  local conditionFlag = true
  for k, v in pairs(showCondition) do
    if v[1] == CityDecorationShowConditionType.ServerOpenDay then
      local day = UITimeManager:GetInstance().GetServerOpenDays()
      if day < tonumber(v[2]) then
        conditionFlag = false
        break
      end
    elseif v[1] == CityDecorationShowConditionType.GameSeason then
      local curSeason = DataCenter.SeasonDataManager:GetSeason() or 0
      if curSeason < tonumber(v[2]) then
        conditionFlag = false
        break
      end
    elseif v[1] == CityDecorationShowConditionType.AbsoluteTime then
      local curTime = UITimeManager:GetInstance():GetServerSeconds()
      if not v[2] then
        conditionFlag = false
        break
      end
      local absoluteTime = UIUtil.GetAbsoluteTimeByStr(v[2])
      if absoluteTime == nil or curTime < absoluteTime then
        conditionFlag = false
        break
      end
    elseif v[1] == CityDecorationShowConditionType.GameSeasonDays then
      local seasonDay = SeasonUtil.GetSeasonDay()
      if seasonDay < tonumber(v[2]) then
        conditionFlag = false
        break
      end
    elseif v[1] == CityDecorationShowConditionType.OnlyInSeason then
      if not SeasonUtil.IsInSeason() or SeasonUtil.GetSeason() ~= tonumber(v[2]) then
        conditionFlag = false
        break
      end
    elseif v[1] == CityDecorationShowConditionType.OnlyInSeasonSettle then
      if not SeasonUtil.IsInSeason() or SeasonUtil.GetSeason() ~= tonumber(v[2]) then
        conditionFlag = false
        break
      end
      local endTime = DataCenter.SeasonDataManager:GetSeasonSettleTime()
      if endTime == nil or endTime < UITimeManager:GetInstance():GetServerTime() then
        conditionFlag = false
        break
      end
    end
  end
  return serverFlag and conditionFlag
end

function DecorationTemplateManager:GetDecorationTypeName(decorationType)
  if decorationType == DecorationType.DecorationType_Main_City then
    return Localization:GetString(2000459)
  elseif decorationType == DecorationType.DecorationType_Head_Frame then
    return Localization:GetString(2000460)
  elseif decorationType == DecorationType.DecorationType_TittleName then
    return Localization:GetString(2000461)
  elseif decorationType == DecorationType.DecorationType_Main_Effect then
    return Localization:GetString(2000483)
  elseif decorationType == DecorationType.DecorationType_Chat_Bubble then
    return Localization:GetString(2900048)
  elseif decorationType == DecorationType.DecorationType_Emoji then
    return Localization:GetString("map_stickers")
  elseif decorationType == DecorationType.DecorationType_MultiKill then
    return Localization:GetString("killstreak_report_decoration_1")
  end
  return ""
end

DecorationTemplateManager.__init = __init
DecorationTemplateManager.__delete = __delete
DecorationTemplateManager.InitAllTemplate = InitAllTemplate
DecorationTemplateManager.GetAllTemplate = GetAllTemplate
DecorationTemplateManager.GetTemplate = GetTemplate
DecorationTemplateManager.GetAllTypes = GetAllTypes
DecorationTemplateManager.GetTypeDecorations = GetTypeDecorations
DecorationTemplateManager.GetDecorationItem = GetDecorationItem
DecorationTemplateManager.GetItemInDecoraitonIndex = GetItemInDecoraitonIndex
DecorationTemplateManager.GetAppearanceIdBySkinId = GetAppearanceIdBySkinId
DecorationTemplateManager.GetLabelSkinTextColor = GetLabelSkinTextColor
return DecorationTemplateManager
