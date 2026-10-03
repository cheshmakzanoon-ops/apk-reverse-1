local base = require("Common.TemplateBase")
local AllianceMineTemplate = BaseClass("AllianceMineTemplate", base)
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource

function AllianceMineTemplate:OnCreate()
end

function AllianceMineTemplate:OnDestroy()
end

function AllianceMineTemplate:InitData(row, season_index, season_type, season_group)
  if row == nil then
    return
  end
  local tbl_index, tbl_data, tbl_ext = row:getMetaData()
  base.SetRowData(self, tbl_index, tbl_data, tbl_ext)
  self._season_index_ = season_index
  self._season_type_ = season_type
  self._season_group_ = season_group
  self.type = row:getIntValue("type")
end

function AllianceMineTemplate:GetBuildIconOutCity()
  return self:GetIconPath()
end

function AllianceMineTemplate:GetIconPath()
  if string.sub(self.icon, 1, 7) == "Assets/" then
    return self.icon
  end
  local iconPath = "Assets/Main/Sprites/UI/UIAllianceNew/" .. self.icon .. ".png"
  if not ResourceManager:HasAsset(iconPath) then
    iconPath = "Assets/Main/Sprites/ItemIcons/" .. self.icon .. ".png"
  end
  if not ResourceManager:HasAsset(iconPath) then
    iconPath = "Assets/Main/Sprites/UI/UIAlliance/" .. self.icon .. ".png"
  end
  if not ResourceManager:HasAsset(iconPath) then
    iconPath = "Assets/Main/Sprites/UI/UISeasonHint/" .. self.icon .. ".png"
  end
  if self.season_group == 30 and not ResourceManager:HasAsset(iconPath) then
    iconPath = "Assets/Main/SeasonRes/S3/Sprites/AllianceBuilding/" .. self.icon .. ".png"
  end
  if self.season_group == 40 and not ResourceManager:HasAsset(iconPath) then
    iconPath = "Assets/Main/SeasonRes/S4/Sprites/AllianceBuilding/" .. self.icon .. ".png"
  end
  return iconPath
end

function AllianceMineTemplate:GetCircleIconPath()
  if string.sub(self.icon_small, 1, 7) == "Assets/" then
    return self.icon_small
  end
  local iconPath = "Assets/Main/Sprites/UI/UIAllianceNew/" .. self.icon_small .. ".png"
  if not ResourceManager:HasAsset(iconPath) then
    iconPath = "Assets/Main/Sprites/ItemIcons/" .. self.icon_small .. ".png"
  end
  if not ResourceManager:HasAsset(iconPath) then
    iconPath = "Assets/Main/Sprites/UI/UIAlliance/" .. self.icon_small .. ".png"
  end
  if not ResourceManager:HasAsset(iconPath) then
    iconPath = "Assets/Main/Sprites/UI/UISeasonHint/" .. self.icon_small .. ".png"
  end
  if self.season_group == 30 and not ResourceManager:HasAsset(iconPath) then
    iconPath = "Assets/Main/SeasonRes/S3/Sprites/AllianceBuilding/" .. self.icon_small .. ".png"
  end
  if self.season_group == 40 and not ResourceManager:HasAsset(iconPath) then
    iconPath = "Assets/Main/SeasonRes/S4/Sprites/AllianceBuilding/" .. self.icon_small .. ".png"
  end
  return iconPath
end

function AllianceMineTemplate:GetModelPath()
  if string.sub(self.model, 1, 7) == "Assets/" then
    return self.model
  end
  local modelName = string.IsNullOrEmpty(self.model) and "allianceBuilding_1000" or self.model
  local fullPath = "Assets/Main/Prefabs/AllianceBuilding/" .. modelName
  if self.season_group == 30 then
    local s3Path = "Assets/Main/SeasonRes/S3/Prefabs/AllianceBuilding/" .. modelName
    if ResourceManager:HasAsset(s3Path .. ".prefab") then
      fullPath = s3Path
    end
  end
  if self.season_group == 40 then
    local s4Path = "Assets/Main/SeasonRes/S4/Prefabs/AllianceBuilding/" .. modelName
    if ResourceManager:HasAsset(s4Path .. ".prefab") then
      fullPath = s4Path
    end
  end
  return fullPath
end

function AllianceMineTemplate:GetName()
  return Localization:GetString(self.name)
end

function AllianceMineTemplate:GetFullName()
  return Localization:GetString(310161, self:GetName(), self.level)
end

function AllianceMineTemplate:GetDescription()
  return Localization:GetString(self.desc)
end

function AllianceMineTemplate:GetBuildCost(resType)
  if resType and self.buildCostDict then
    return self.buildCostDict[tostring(resType)] or 0
  end
  return self.buildCost or 0
end

function AllianceMineTemplate:GetProduceInfo()
  local ret = {}
  if self.hour_product_stone then
    for ResType, ResValue in pairs(self.hour_product_stone) do
      table.insert(ret, {ResValue = ResValue, ResType = ResType})
    end
  end
  if self.hour_product_resource then
    for ResType, ResValue in pairs(self.hour_product_resource) do
      table.insert(ret, {ResValue = ResValue, ResType = ResType})
    end
  end
  if self.hour_product_goods then
    for itemId, itemCount in pairs(self.hour_product_goods) do
      table.insert(ret, {itemId = itemId, itemCount = itemCount})
    end
  end
  local electricity = toInt(self.electricity)
  if 0 < electricity then
    table.insert(ret, {
      ResValue = electricity * 600,
      ResType = ResourceType.BatteryPower
    })
  end
  return ret
end

function AllianceMineTemplate.getters:build_level()
  return self:getIntValue("level", 0)
end

function AllianceMineTemplate.getters:max_level()
  return self:getIntValue("max_level", 0)
end

function AllianceMineTemplate.getters:season_group()
  return self:getIntValue("season_group", 0)
end

function AllianceMineTemplate.getters:season_unlock()
  return self:getIntValue("season_unlock", 0)
end

function AllianceMineTemplate:ParseActiveBuilding()
  if self._active_building_id == nil then
    local active_building = self:getIntValue("active_building", 0)
    if active_building ~= 0 then
      self._active_building_id = active_building
      self._active_building_pos_x, self._active_building_pos_y = string.split_ii(self:getValue("relative_position") or "0;0", ";")
    end
  end
end

function AllianceMineTemplate.getters:active_building_id()
  self:ParseActiveBuilding()
  return self._active_building_id
end

function AllianceMineTemplate.getters:active_building_pos_x()
  self:ParseActiveBuilding()
  return self._active_building_pos_x
end

function AllianceMineTemplate.getters:active_building_pos_y()
  self:ParseActiveBuilding()
  return self._active_building_pos_y
end

function AllianceMineTemplate.getters:zone_buff_list()
  if self._zone_buff_list == nil then
    local zone_buff = self:getValue("zone_buff")
    if zone_buff ~= nil and zone_buff ~= "" then
      self._zone_buff_list = string.split_ii_array(zone_buff, "|")
    end
  end
  return self._zone_buff_list
end

function AllianceMineTemplate.getters:hour_product_stone()
  if self._hour_product_stone == nil then
    local product_stone = self:getValue("stone")
    if product_stone ~= nil and product_stone ~= "" then
      self._hour_product_stone = string.split_if_map(product_stone, "|", ";")
    end
  end
  return self._hour_product_stone
end

function AllianceMineTemplate.getters:hour_product_resource()
  if self._hour_product_resource == nil then
    local product_resource = self:getValue("resource")
    if product_resource ~= nil and product_resource ~= "" then
      self._hour_product_resource = string.split_if_map(product_resource, "|", ";")
    end
  end
  return self._hour_product_resource
end

function AllianceMineTemplate.getters:hour_product_goods()
  if self._hour_product_goods == nil then
    local product_goods = self:getValue("goods")
    if product_goods ~= nil and product_goods ~= "" then
      self._hour_product_goods = string.split_if_map(product_goods, "|", ";")
    end
  end
  return self._hour_product_goods
end

function AllianceMineTemplate.getters:group()
  return self:getIntValue("group")
end

function AllianceMineTemplate.getters:electricity()
  return self:getIntValue("electricity", 0)
end

function AllianceMineTemplate.getters:prosperity()
  return self:getIntValue("prosperity")
end

function AllianceMineTemplate.getters:coal_limit()
  return self:getIntValue("coal_limit")
end

function AllianceMineTemplate.getters:coal_normal()
  return self:getIntValue("coal_normal")
end

function AllianceMineTemplate.getters:coal_overload()
  return self:getIntValue("coal_overload")
end

function AllianceMineTemplate:ParseCoalDonate()
  if self._coal_donate_count == nil then
    local coal_donate_res, coal_donate_count = string.match(self:getValue("coal_donate_times", ""), "([^;]+);([^;]+)")
    self._coal_donate_count = toInt(coal_donate_count)
    self._coal_donate_res = toInt(coal_donate_res)
    self._coal_donate_limit = LuaEntry.DataConfig:TryGetNum("s2_alliance_center", "k4", 20)
  end
end

function AllianceMineTemplate.getters:coal_donate_count()
  self:ParseCoalDonate()
  return self._coal_donate_count
end

function AllianceMineTemplate.getters:coal_donate_res()
  self:ParseCoalDonate()
  return self._coal_donate_res
end

function AllianceMineTemplate.getters:coal_donate_limit()
  self:ParseCoalDonate()
  return self._coal_donate_limit
end

function AllianceMineTemplate.getters:coal_contribute_unit()
  return self:getIntValue("coal_contribute_unit")
end

function AllianceMineTemplate.getters:coal_value_show()
  return self:getValue("value_show")
end

function AllianceMineTemplate:ParseTotalStoneExp()
  if self._total_stone_exp_value == nil then
    local total_stone_exp = self:getValue("total_stone_exp")
    self._total_stone_exp = total_stone_exp
    if total_stone_exp and type(total_stone_exp) == "string" then
      local theId, theValue = string.match(total_stone_exp, "([^;]+);([^;]+)")
      self._total_stone_exp_id = toInt(theId)
      self._total_stone_exp_value = toInt(theValue)
    else
      self._total_stone_exp_id = ResourceType.AllianceStone
      self._total_stone_exp_value = 0
    end
  end
end

function AllianceMineTemplate.getters:total_stone_exp()
  self:ParseTotalStoneExp()
  return self._total_stone_exp
end

function AllianceMineTemplate.getters:total_stone_exp_id()
  self:ParseTotalStoneExp()
  return self._total_stone_exp_id
end

function AllianceMineTemplate.getters:total_stone_exp_value()
  self:ParseTotalStoneExp()
  return self._total_stone_exp_value
end

function AllianceMineTemplate:ParseTemperatureStatus()
  if self._temperatureCfg == nil then
    local temperature_table_id = self:getIntValue("temperature_status", 0)
    self._temperature_table_id = temperature_table_id
    if temperature_table_id ~= nil and temperature_table_id ~= 0 then
      local dataTemperature = DataCenter.HeatSourceTemplateManager:GetTemplate(temperature_table_id)
      if dataTemperature then
        self._temperatureCfg = dataTemperature
      end
    end
  end
end

function AllianceMineTemplate.getters:temperature_table_id()
  self:ParseTemperatureStatus()
  return self._temperature_table_id
end

function AllianceMineTemplate.getters:temperatureCfg()
  self:ParseTemperatureStatus()
  return self._temperatureCfg
end

function AllianceMineTemplate.getters:build_level()
  return self:getIntValue("level", self.id % BuildLevelCap)
end

function AllianceMineTemplate.getters:baseId()
  return self.id - self.build_level
end

function AllianceMineTemplate.getters:resSize()
  return tonumber(self:getValue("res_size")) or 0
end

function AllianceMineTemplate.getters:level()
  return tonumber(self:getValue("city_level"))
end

function AllianceMineTemplate.getters:resDurable()
  return tonumber(self:getValue("res_durable")) or 0
end

function AllianceMineTemplate.getters:res_base_durable()
  return tonumber(self:getValue("res_base_durable")) or 0
end

function AllianceMineTemplate.getters:resNum()
  return tonumber(self:getValue("res_num")) or 0
end

function AllianceMineTemplate.getters:collectType()
  return tonumber(self:getValue("collect_type")) or 0
end

function AllianceMineTemplate.getters:offter_range()
  return tonumber(self:getValue("offter_range")) or 0
end

function AllianceMineTemplate.getters:param()
  return tonumber(self:getValue("param")) or 0
end

function AllianceMineTemplate.getters:collectTypeK()
  return self.collectType .. ":" .. self.param
end

function AllianceMineTemplate.getters:collectSpeed()
  return tonumber(self:getValue("collect_speed")) or 0
end

function AllianceMineTemplate.getters:armyLimit()
  return tonumber(self:getValue("army_limit")) or 0
end

function AllianceMineTemplate.getters:expireTime()
  return tonumber(self:getValue("expire_time")) or 0
end

function AllianceMineTemplate.getters:army_recover_time()
  return tonumber(self:getValue("army_recover_time")) or 0
end

function AllianceMineTemplate.getters:order()
  return self:getIntValue("order", 0)
end

function AllianceMineTemplate.getters:name()
  return self:getValue("name")
end

function AllianceMineTemplate.getters:icon()
  return self:getValue("icon")
end

function AllianceMineTemplate.getters:icon_small()
  return self:getValue("icon_small")
end

function AllianceMineTemplate.getters:model()
  return self:getValue("model")
end

function AllianceMineTemplate.getters:desc()
  return self:getValue("desc")
end

function AllianceMineTemplate.getters:sever_intrusion_guide()
  return self:getValue("sever_intrusion_guide")
end

function AllianceMineTemplate.getters:world_desc()
  return self:getValue("world_desc")
end

function AllianceMineTemplate:ParseBuildCost()
  if self._buildCostDict == nil then
    self._buildCost = 0
    local buildCost = self:getValue("build_cost")
    if buildCost ~= nil and buildCost ~= "" and buildCost ~= 0 then
      local typeCost = type(buildCost)
      if typeCost == "number" then
        self._buildCost = buildCost
      elseif typeCost == "string" then
        self._buildCostDict = {}
        for item in string.gmatch(buildCost, "([^|]+)|?") do
          local itemId, itemCount = string.match(item, "([^;]+);([^;]+)")
          if itemId and itemCount then
            self._buildCost = toInt(itemCount)
            self._buildCostDict[itemId] = self._buildCost
          end
        end
      end
    end
  end
end

function AllianceMineTemplate.getters:buildCost()
  self:ParseBuildCost()
  return self._buildCost
end

function AllianceMineTemplate.getters:buildCostDict()
  self:ParseBuildCost()
  return self._buildCostDict
end

function AllianceMineTemplate.getters:init_durability()
  return self:getIntValue("init_durability")
end

function AllianceMineTemplate.getters:army_durable_rate()
  return self:getIntValue("army_durable_rate")
end

function AllianceMineTemplate.getters:pre_alliance_alliance()
  return self:getValue("pre_alliance_alliance")
end

function AllianceMineTemplate.getters:limit_alliance_tec()
  if self._limit_alliance_tec == nil then
    local limit_alliance_tec = self:getValue("limit_alliance_tec")
    if not string.IsNullOrEmpty(limit_alliance_tec) then
      local KeyStr, ValueStr = string.match(limit_alliance_tec, "(.*)[;,](.*)")
      if KeyStr ~= nil and ValueStr ~= nil then
        local tmp = DataCenter.AllianceScienceTemplateManager:GetAlScienceTemplateByBuffId(KeyStr)
        self._limit_alliance_tec = {
          k = tonumber(KeyStr),
          v = tonumber(ValueStr)
        }
        if tmp then
          self._limit_alliance_tec.science_id = toInt(tmp.science_id)
        end
        return self._limit_alliance_tec
      end
    end
    return nil
  end
  return self._limit_alliance_tec
end

function AllianceMineTemplate.getters:unlock_building()
  if self._unlock_building == nil then
    local unlock_building = self:getValue("unlock_building")
    if string.IsNullOrEmpty(unlock_building) then
      return nil
    end
    self._unlock_building = {}
    for building in string.gmatch(unlock_building, "([^;]+);?") do
      table.insert(self._unlock_building, building)
    end
  end
  return self._unlock_building
end

function AllianceMineTemplate.getters:limitMember()
  return self:getIntValue("limit_member", 0)
end

function AllianceMineTemplate.getters:limitRuin()
  return self:getIntValue("limit_ruin", 0)
end

function AllianceMineTemplate.getters:limitPower()
  return self:getIntValue("limit_power", 0)
end

function AllianceMineTemplate.getters:pre_build()
  return self:getIntValue("pre_build", 0)
end

function AllianceMineTemplate.getters:limit_city_level()
  return self:getIntValue("limit_city_level", 0)
end

function AllianceMineTemplate.getters:conditions()
  if self._conditions == nil then
    local conditions = {}
    conditions[AlMineConditionType.MemberCount] = self.limitMember
    conditions[AlMineConditionType.RuinLv] = self.limitRuin
    conditions[AlMineConditionType.Power] = self.limitPower
    conditions[AlMineConditionType.PreBuild] = self.pre_build
    conditions[AlMineConditionType.CityLevel] = self.limit_city_level
    conditions[AlMineConditionType.Science] = self.limit_alliance_tec
    self._conditions = conditions
  end
  return self._conditions
end

return AllianceMineTemplate
