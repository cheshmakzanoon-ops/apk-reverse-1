local ScienceTemplate = BaseClass("ScienceTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.science_id = 0
  self.level = 0
  self.name = ""
  self.icon = ""
  self.description = ""
  self.tab = 0
  self.needScience = {}
  self.needBuild = {}
  self.needItem = {}
  self.needResource = {}
  self.needResourceItem = {}
  self.time = 0
  self.need_effect = 0
  self.power = 0
  self.max_level = 1
  self.show = {}
  self.showTag = 0
  self.positionX = 0
  self.positionY = 0
  self.effect = {}
  self.exp = 0
  self.inactivity = 0
  self.is_special = 0
  self.time_condition = nil
  self.effect_description_lv_other = ""
  self.effect_description_lv_0 = ""
  self.line_type = 0
  self.desc_condition = nil
  self.description_new = nil
  self.tab_condition = ""
end

local function __delete(self)
  self.id = nil
  self.science_id = nil
  self.level = nil
  self.name = nil
  self.icon = nil
  self.description = nil
  self.tab = nil
  self.needScience = nil
  self.needBuild = nil
  self.needItem = nil
  self.needResource = nil
  self.needResourceItem = nil
  self.time = nil
  self.need_effect = nil
  self.power = nil
  self.max_level = nil
  self.show = nil
  self.showTag = nil
  self.positionX = nil
  self.positionY = nil
  self.effect = nil
  self.exp = nil
  self.inactivity = nil
  self.is_special = nil
  self.time_condition = nil
  self.effect_description_lv_other = nil
  self.effect_description_lv_0 = nil
  self.tab_condition = nil
  self.line_type = nil
  self.tabCondition = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.science_id = row:getValue("science_id")
  self.level = row:getValue("level")
  self.max_level = row:getValue("max_level")
  self.name = row:getValue("name")
  self.icon = row:getValue("icon")
  self.description = row:getValue("description")
  self.tab = row:getValue("tab")
  local tempShow = row:getValue("show")
  self.show = {}
  if tempShow ~= nil then
    for k, v in ipairs(tempShow) do
      local spl = string.split_ss_array(v, ",")
      if table.count(spl) > 2 then
        local tempTab = {}
        tempTab.dialog = spl[1]
        tempTab.valueType = tonumber(spl[2])
        tempTab.value = spl[3]
        table.insert(self.show, tempTab)
      end
    end
  end
  self.need_effect = row:getValue("need_effect")
  self.time = row:getValue("time")
  self.power = row:getValue("power")
  tempShow = row:getValue("research_need")
  self.needResource = {}
  if tempShow ~= nil then
    for k, v in pairs(tempShow) do
      local tempTab = {}
      tempTab.resourceType = tonumber(k)
      tempTab.count = tonumber(v)
      if tempTab.count > 0 then
        table.insert(self.needResource, tempTab)
      end
    end
  end
  tempShow = row:getValue("building_condition")
  self.needBuild = {}
  if tempShow ~= nil then
    for k, v in ipairs(tempShow) do
      local tempTab = {}
      tempTab.buildId = CommonUtil.GetBuildBaseType(tonumber(v))
      tempTab.level = CommonUtil.GetBuildLv(tonumber(v))
      table.insert(self.needBuild, tempTab)
    end
  end
  tempShow = row:getValue("science_condition")
  self.needScience = {}
  if tempShow ~= nil then
    for k, v in ipairs(tempShow) do
      local tempTab = {}
      tempTab.scienceId = CommonUtil.GetScienceBaseType(tonumber(v))
      tempTab.level = CommonUtil.GetScienceLv(tonumber(v))
      table.insert(self.needScience, tempTab)
    end
  end
  self.links = {}
  tempShow = row:getValue("link")
  if tempShow then
    local scienceConfs = string.split_ss_array(tempShow, "|")
    for i, scienceConfig in ipairs(scienceConfs) do
      local scienceLink = string.split_ss_array(scienceConfig, ",")
      self.links[scienceLink[1]] = scienceLink[2]
    end
  end
  tempShow = row:getValue("resource_item_need")
  self.needResourceItem = {}
  if tempShow ~= nil then
    local spl = string.split_ss_array(tempShow, "|")
    for k, v in ipairs(spl) do
      local spl1 = string.split_ii_array(v, ";")
      if table.count(spl1) > 1 then
        local tempTab = {}
        tempTab.resourceItemId = spl1[1]
        tempTab.count = spl1[2]
        if tempTab.count > 0 then
          table.insert(self.needResourceItem, tempTab)
        end
      end
    end
  end
  self.needItem = {}
  local needItemsTb = row:getValue("goods_need")
  if needItemsTb then
    local confArr = string.split_ss_array(needItemsTb, "|")
    for i, v in ipairs(confArr) do
      local perItem = string.split_ss_array(v, ",")
      if 1 < #perItem then
        local param = {}
        param.itemId = perItem[1]
        param.count = tonumber(perItem[2])
        if param.count > 0 then
          table.insert(self.needItem, param)
        end
      end
    end
  end
  self.showTag = row:getIntValue("showTag")
  local position = row:getValue("position")
  if position ~= nil and position ~= "" then
    local spl = string.split_ii_array(position, ";")
    if table.count(spl) > 1 then
      self.positionX = spl[1]
      self.positionY = spl[2]
    end
  end
  local effectStr = row:getValue("effect") or ""
  local tempVec = string.split_ss_array(effectStr, "|")
  for _, v in ipairs(tempVec) do
    local tempVec1 = string.split_ss_array(v, ";")
    if table.count(tempVec1) == 2 then
      local tempTab = {}
      tempTab.effectId = tempVec1[1]
      tempTab.effectValue = tempVec1[2]
      table.insert(self.effect, tempTab)
    end
  end
  self.exp = tonumber(row:getValue("exp"))
  self.inactivity = tonumber(row:getValue("inactivity"))
  local is_special = row:getValue("is_special")
  if not string.IsNullOrEmpty(is_special) then
    self.is_special = tonumber(is_special)
  end
  local time_condition = row:getValue("time_condition")
  if not string.IsNullOrEmpty(time_condition) then
    local spl = string.split(time_condition, ";")
    if table.count(spl) == 2 then
      self.time_condition = {
        tonumber(spl[1]),
        tonumber(spl[2])
      }
    end
  end
  self.effect_description_lv_other = row:getValue("effect_description_lv_other") or ""
  self.effect_description_lv_0 = row:getValue("effect_description_lv_0") or ""
  self.line_type = tonumber(row:getValue("line_type"))
  self.description_new = row:getValue("description_new")
  self.desc_condition = row:getValue("desc_condition")
  self.tab_condition = row:getValue("tab_condition")
  if not string.IsNullOrEmpty(self.tab_condition) then
    local splitStr = string.split(self.tab_condition, ";")
    if 2 <= #splitStr then
      self.tabCondition = {}
      local idListStr = splitStr[1]
      self.tabCondition.needPercent = tonumber(splitStr[2])
      self.tabCondition.tabIdList = {}
      if not string.IsNullOrEmpty(idListStr) then
        local idList = string.split(idListStr, ",")
        for i, v in ipairs(idList) do
          if v then
            table.insert(self.tabCondition.tabIdList, tonumber(v))
          end
        end
      end
      if splitStr[3] then
        self.tabCondition.descKey = splitStr[3]
      end
    end
  end
end

local function GetNeedResourceItem(self)
  return self.needResourceItem
end

local function GetNeedResource(self)
  return self.needResource
end

local function GetNeedItem(self)
  return self.needItem
end

local function GetNeedBuild(self)
  return self.needBuild
end

local function GetScienceTime(self, bUuid)
  local effectSpeedUp = 0
  effectSpeedUp = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_SCIENCE_RESEARCH_SPEED)
  if bUuid ~= nil then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
    if buildData ~= nil then
      effectSpeedUp = BuildingUtils.GetPropertyValueByType(buildData, 2, EffectDefine.LW_SCIENCE_RESEARCH_SPEED)
    end
  end
  local x = self.time
  x = x / (1 + effectSpeedUp)
  return x
end

local function IsTimeConditionValid(self)
  if not self.time_condition then
    return true
  end
  local seasonNum = SeasonUtil.GetSeason()
  if seasonNum > self.time_condition[1] then
    return true
  elseif seasonNum < self.time_condition[1] then
    return false
  end
  return self.time_condition[2] <= SeasonUtil.GetSeasonDay()
end

local function GetEffectDesText(self)
  local result = ""
  if string.IsNullOrEmpty(self.effect_description_lv_other) then
    if self.effect and #self.effect > 0 then
      local description, value = WorkerUtil.GetEffectText(tonumber(self.effect[1].effectId), tonumber(self.effect[1].effectValue), true)
      result = tostring(value)
    end
  else
    local strSplit = string.split(self.effect_description_lv_other, ";")
    if #strSplit == 2 then
      result = Localization:GetString(strSplit[1], strSplit[2])
    elseif #strSplit == 1 then
      result = Localization:GetString(strSplit[1])
    end
  end
  return result
end

local function GetEffectDesTextLv0(self)
  local result = "0"
  if not string.IsNullOrEmpty(self.effect_description_lv_0) then
    local strSplit = string.split(self.effect_description_lv_0, ";")
    if #strSplit == 2 then
      result = Localization:GetString(strSplit[1], strSplit[2])
    elseif #strSplit == 1 then
      result = Localization:GetString(strSplit[1])
    end
  end
  return result
end

local function GetDesc(self)
  local desc_key
  if not table.IsNullOrEmpty(self.desc_condition) then
    local nowSeason = SeasonUtil.GetSeason()
    local nowSeasonDay = SeasonUtil.GetSeasonDay()
    local key_id
    for i = #self.desc_condition, 1, -1 do
      local condition = self.desc_condition[i]
      local season, seasonDay = string.match(condition, "(%d+);(%d+)")
      if season and seasonDay and (nowSeason > tonumber(season) or nowSeason == tonumber(season) and nowSeasonDay >= tonumber(seasonDay)) then
        key_id = i
        break
      end
    end
    if key_id then
      if self.description_new[key_id] then
        desc_key = self.description_new[key_id]
      else
        desc_key = self.description_new[#self.description_new]
      end
    end
  end
  desc_key = desc_key or self.description
  return Localization:GetString(desc_key)
end

function ScienceTemplate:GetTabCondition()
  return self.tabCondition
end

function ScienceTemplate:IsShowTabConditionInDetail()
  return self.tabCondition ~= nil and not string.IsNullOrEmpty(self.tabCondition.descKey)
end

function ScienceTemplate:IsTacticalWeaponSkillStarUp()
  if self.effect ~= nil then
    for i, v in ipairs(self.effect) do
      if checknumber(v.effectId) == ScienceEffectID.TacticalSkillStarUp then
        return true
      end
    end
  end
  return false
end

ScienceTemplate.__init = __init
ScienceTemplate.__delete = __delete
ScienceTemplate.InitData = InitData
ScienceTemplate.GetNeedResourceItem = GetNeedResourceItem
ScienceTemplate.GetNeedResource = GetNeedResource
ScienceTemplate.GetNeedItem = GetNeedItem
ScienceTemplate.GetNeedBuild = GetNeedBuild
ScienceTemplate.GetScienceTime = GetScienceTime
ScienceTemplate.IsTimeConditionValid = IsTimeConditionValid
ScienceTemplate.GetEffectDesText = GetEffectDesText
ScienceTemplate.GetEffectDesTextLv0 = GetEffectDesTextLv0
ScienceTemplate.GetDesc = GetDesc
return ScienceTemplate
