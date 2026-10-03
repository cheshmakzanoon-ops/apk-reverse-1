local BuildingLevelTemplate = BaseClass("BuildingLevelTemplate")

local function __init(self)
  self.id = 0
  self.max_level = 1
  self.power = 0
  self.needResource = {}
  self.needItem = {}
  self.needResourceItem = {}
  self.time = 0
  self.preBuilds = {}
  self.local_num = {}
  self.max_hp = 0
  self.offer_range = 0
  self.base_tax_rate = 1
  self.item_tax_rate = ""
  self.model = ""
  self.model_world = ""
  self.pic = ""
  self.level_up = 0
  self.para1 = ""
  self.para2 = ""
  self.para4 = ""
  self.para5 = ""
  self.para7 = ""
  self.para3 = ""
  self.icon_position_x = 0
  self.icon_position_y = 0
  self.scan = BuildScanAnim.No
  self.exp = 0
  self.building_effect = {}
  self.building_effect_last = {}
  self.name = ""
  self.des = ""
  self.people = 0
  self.no_queue = BuildNoQueue.No
  self.rewardNeedTalentId = 0
  self.produce_time = 0
  self.produce_cost_consume = {}
  self.produce_cost_resource = {}
  self.produce_gain_consume = {}
  self.produce_gain_resource = {}
  self.storage_resource = {}
  self.produce_goods = {}
  self.tab_type = nil
  self.mono_condition = nil
  self.hero_slots = 0
  self.hero_exp_show = 0
  self.build_hammer_need_opstage = 0
  self.build_hammer_need_otherbuildings = {}
  self.reward_show = ""
  self.red_dot = BuildRedDotType.No
  self.equal_glue_value = 0
  self.hero_sort = 0
  self.time_condition = nil
  self.temperature_status = nil
  self.coal_normal = nil
  self.coal_overload = nil
  self.needScience = {}
  self.effect_Local_dialog = {}
  self.effect_Local_type = {}
  self.decorationUpgradeType = DecorationUpgradeType.NormalUpgrade
  self.decoGroupUpgradeBaseId = -1
  self.convert_decorator_num = 0
  self.helpBuildAniPath = nil
  self.chapter_limit = nil
end

local function __delete(self)
  self.id = 0
  self.max_level = 1
  self.power = 0
  self.needResource = {}
  self.needItem = {}
  self.needResourceItem = {}
  self.time = 0
  self.preBuilds = {}
  self.local_num = {}
  self.max_hp = 0
  self.offer_range = 0
  self.base_tax_rate = 1
  self.item_tax_rate = ""
  self.model = ""
  self.model_world = ""
  self.pic = ""
  self.level_up = 0
  self.para1 = ""
  self.para2 = ""
  self.para4 = ""
  self.para5 = ""
  self.para7 = ""
  self.para3 = ""
  self.icon_position_x = 0
  self.icon_position_y = 0
  self.scan = BuildScanAnim.No
  self.exp = 0
  self.building_effect = {}
  self.building_effect_last = {}
  self.name = ""
  self.rewardNeedTalentId = 0
  self.people = 0
  self.no_queue = BuildNoQueue.No
  self.tab_type = 0
  self.produce_time = 0
  self.produce_cost_consume = {}
  self.produce_cost_resource = {}
  self.produce_gain_consume = {}
  self.produce_gain_resource = {}
  self.storage_resource = {}
  self.produce_goods = {}
  self.hero_slots = 0
  self.hero_exp_show = 0
  self.build_hammer_need_opstage = 0
  self.build_hammer_need_otherbuildings = {}
  self.reward_show = ""
  self.red_dot = BuildRedDotType.No
  self.equal_glue_value = 0
  self.mono_condition = 0
  self.hero_sort = 0
  self.time_condition = nil
  self.needScience = {}
  self.effect_Local_dialog = {}
  self.effect_Local_type = {}
  self.decorationUpgradeType = DecorationUpgradeType.NormalUpgrade
  self.decoGroupUpgradeBaseId = 0
  self.convert_decorator_num = 0
  self.helpBuildAniPath = nil
  self.chapter_limit = nil
end

local AdditionUpLevelResTechnological = 50136

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.power = row:getValue("power")
  self.name = row:getValue("name")
  self.des = row:getValue("description")
  self.level = self.id % BuildLevelCap
  self.max_level = row:getValue("max_level")
  self.tab_type = row:getValue("tab_type")
  self.mono_condition = tonumber(row:getValue("mono_condition"))
  local resource = row:getValue("cost_consume")
  if resource ~= nil and resource ~= "" then
    local vec = string.split_ss_array(resource, "|")
    for k, v in ipairs(vec) do
      local vec1 = string.split_ii_array(v, ";")
      if 2 <= #vec1 then
        local need = {}
        need.resourceType = vec1[1]
        need.count = vec1[2]
        if need.count > 0 then
          need.notDerateCount = need.count
          table.insert(self.needResource, need)
        end
      end
    end
  end
  resource = row:getValue("item")
  if resource ~= nil and resource ~= "" then
    local vec = string.split_ss_array(resource, "|")
    for k, v in ipairs(vec) do
      local vec1 = string.split_ii_array(v, ";")
      if 2 <= #vec1 then
        local need = {}
        need.itemId = vec1[1]
        need.num = vec1[2]
        if 0 < need.num then
          table.insert(self.needItem, need)
        end
      end
    end
  end
  resource = row:getValue("cost_resource")
  if resource ~= nil and resource ~= "" then
    local vec = string.split_ss_array(resource, "|")
    for k, v in ipairs(vec) do
      local vec1 = string.split_ii_array(v, ";")
      if 2 <= #vec1 then
        local need = {}
        need.itemId = vec1[1]
        need.count = vec1[2]
        if need.count > 0 then
          table.insert(self.needResourceItem, need)
        end
      end
    end
  end
  self.time = row:getValue("time")
  resource = row:getValue("building")
  if resource ~= nil and resource ~= "" then
    local vec = string.split(resource, "|")
    for k, v in ipairs(vec) do
      local vec1 = string.split(v, ";")
      if 2 <= #vec1 then
        local need = {}
        need.buildId = tonumber(vec1[1])
        need.level = tonumber(vec1[2])
        table.insert(self.preBuilds, need)
      end
    end
  end
  resource = row:getValue("local_num")
  if resource ~= nil and resource ~= "" then
    local vec = string.split(resource, ";")
    for k, v in ipairs(vec) do
      table.insert(self.local_num, v)
    end
  end
  self.max_hp = row:getValue("max_hp")
  self.offer_range = row:getValue("offer_range")
  self.base_tax_rate = row:getValue("base_tax_rate")
  self.item_tax_rate = row:getValue("item_tax_rate")
  self.model = row:getValue("model")
  if self.model == nil or self.model == "" then
    self.model = "building_401000"
  end
  self.model_world = row:getValue("model_world")
  self.pic = row:getValue("pic")
  self.pic_full_path = row:getValue("pic_path")
  self.model_full_path = row:getValue("model_path")
  self.model_world_full_path = row:getValue("model_world_path")
  local level_up = row:getValue("level_up")
  if level_up ~= nil and level_up ~= "" then
    self.level_up = tonumber(level_up)
  end
  self.bd_effect_result = row:getValue("bd_effect_result")
  self.para1 = row:getValue("para1")
  self.para2 = row:getValue("para2")
  self.para4 = row:getValue("para4")
  self.para5 = row:getValue("para5")
  self.para7 = row:getValue("para7")
  self.para3 = row:getValue("para3")
  self.long_description = row:getValue("long_description")
  local icon_position = row:getValue("icon_position")
  if icon_position ~= nil then
    local str = string.split(icon_position, ",")
    if 1 < table.count(str) then
      self.icon_position_x = str[1]
      self.icon_position_y = str[2]
    end
  end
  self.scan = row:getValue("scan")
  self.exp = row:getValue("exp")
  self.building_effect = {}
  local effectStr = row:getValue("building_effect")
  if not string.IsNullOrEmpty(effectStr) then
    for _, str in ipairs(string.split(effectStr, "|")) do
      local spls = string.split(str, ";")
      if #spls == 2 then
        local effect = tonumber(spls[1])
        local value = tonumber(spls[2])
        self.building_effect[effect] = value
      end
    end
  end
  self.building_effect_last = {}
  local effectLastStr = row:getValue("building_effect_last")
  if not string.IsNullOrEmpty(effectLastStr) then
    for _, str in ipairs(string.split(effectLastStr, "|")) do
      local spls = string.split(str, ";")
      if #spls == 2 then
        local effect = tonumber(spls[1])
        local value = tonumber(spls[2])
        self.building_effect_last[effect] = value
      end
    end
  end
  local reward = row:getValue("reward")
  if not string.IsNullOrEmpty(reward) then
    local spl = string._split_ss_array(reward, "|")
    if 2 <= #spl then
      local spl2 = string.split_ii_array(spl[2], ";")
      if 0 < #spl2 then
        self.rewardNeedTalentId = spl2[1]
      end
    end
  end
  resource = row:getValue("people")
  if resource ~= nil and resource ~= "" then
    self.people = tonumber(resource)
  end
  self.no_queue = row:getValue("no_queue")
  self.produce_time = tonumber(row:getValue("produce_time")) or 60
  self.produce_cost_consume = {}
  local pccStr = row:getValue("produce_cost_consume")
  if not string.IsNullOrEmpty(pccStr) then
    local strs = string.split(pccStr, "|")
    for _, str in ipairs(strs) do
      local spls = string.split(str, ";")
      if #spls == 2 then
        self.produce_cost_consume[tonumber(spls[1])] = tonumber(spls[2])
      end
    end
  end
  self.produce_cost_resource = {}
  local pcrStr = row:getValue("produce_cost_resource")
  if not string.IsNullOrEmpty(pcrStr) then
    local strs = string.split(pcrStr, "|")
    for _, str in ipairs(strs) do
      local spls = string.split(str, ";")
      if #spls == 2 then
        self.produce_cost_resource[tonumber(spls[1])] = tonumber(spls[2])
      end
    end
  end
  self.produce_gain_consume = {}
  self.pgcStr = row:getValue("produce_gain_consume")
  local pgcStr = row:getValue("produce_gain_consume")
  self.effect_last = row:getValue("building_effect_last")
  if not string.IsNullOrEmpty(pgcStr) then
    local strs = string.split(pgcStr, "|")
    for _, str in ipairs(strs) do
      local spls = string.split(str, ";")
      if #spls == 2 then
        self.produce_gain_consume[tonumber(spls[1])] = tonumber(spls[2])
      end
    end
  end
  self.produce_gain_resource = {}
  local pgrStr = row:getValue("produce_gain_resource")
  if not string.IsNullOrEmpty(pgrStr) then
    local strs = string.split(pgrStr, "|")
    for _, str in ipairs(strs) do
      local spls = string.split(str, ";")
      if #spls == 2 then
        self.produce_gain_resource[tonumber(spls[1])] = tonumber(spls[2])
      end
    end
  end
  self.storage_resource = {}
  local srStr = row:getValue("storage_resource")
  if not string.IsNullOrEmpty(srStr) then
    local strs = string.split(srStr, "|")
    for _, str in ipairs(strs) do
      local spls = string.split(str, ";")
      if #spls == 2 then
        self.storage_resource[tonumber(spls[1])] = tonumber(spls[2])
      end
    end
  end
  self.produce_goods = {}
  local pgStr = row:getValue("produce_goods")
  if not string.IsNullOrEmpty(pgStr) then
    local strs = string.split(pgStr, "|")
    for _, str in ipairs(strs) do
      local spls = string.split(str, ";")
      if #spls == 2 then
        self.produce_goods[tonumber(spls[1])] = tonumber(spls[2])
      end
    end
  end
  self.hero_slots = tonumber(row:getValue("hero_slots")) or 0
  self.hero_exp_show = tonumber(row:getValue("exp_hero_show")) or 0
  self.season_mastery_exp_show = tonumber(row:getValue("season_mastery")) or 0
  local hummer_build = row:getValue("hummer_build")
  if #hummer_build == 0 then
    self.build_hammer_need_opstage = nil
    self.build_hammer_need_otherbuildings = nil
  else
    self.build_hammer_need_opstage = tonumber(hummer_build[2])
    local buildIdStrs = string.split(hummer_build[1], ";")
    for _, buildIdStr in ipairs(buildIdStrs) do
      table.insert(self.build_hammer_need_otherbuildings, tonumber(buildIdStr))
    end
  end
  self.reward_show = row:getValue("reward_show")
  local red_dot = row:getValue("red_dot")
  if red_dot ~= nil and red_dot ~= "" then
    self.red_dot = tonumber(red_dot)
  end
  self.equal_glue_value = tonumber(row:getValue("equal_glue_value")) or 0
  self.finish_quest = row:getValue("finish_quest")
  self.quest_condition = row:getValue("quest_condition")
  self.upgrade_type = row:getValue("upgrade_type")
  self.season_score = row:getValue("season_score")
  self.season_mastery = row:getValue("season_mastery")
  self.season_group = row:getValue("season_group")
  self.default_army = row:getValue("default_army")
  local effect_number_condition = row:getValue("effect_number_condition")
  if not string.IsNullOrEmpty(effect_number_condition) then
    local KeyStr, ValueStr = string.match(effect_number_condition, "(.*)[;,](.*)")
    if KeyStr ~= nil and ValueStr ~= nil then
      self.effectCondition = {
        effectId = tonumber(KeyStr),
        effectValue = tonumber(ValueStr)
      }
    end
  end
  self.hero_sort = tonumber(row:getValue("hero_sort")) or 0
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
  self.coal_normal = row:getValue("coal_normal")
  if self.coal_normal and #self.coal_normal == 2 then
    self.coal_normal[1] = tonumber(self.coal_normal[1])
    self.coal_normal[2] = tonumber(self.coal_normal[2])
  end
  self.coal_overload = row:getValue("coal_overload")
  if self.coal_overload and #self.coal_overload == 2 then
    self.coal_overload[1] = tonumber(self.coal_overload[1])
    self.coal_overload[2] = tonumber(self.coal_overload[2])
  end
  self.temperature_status = row:getValue("temperature_status")
  self.building_prerequisites = row:getValue("building_prerequisites")
  resource = row:getValue("need_science")
  if not string.IsNullOrEmpty(resource) then
    local vec = string.split(resource, ";")
    table.walk(vec, function(k, v)
      local need = {}
      local num = tonumber(v)
      need.scienceId = CommonUtil.GetScienceBaseType(num)
      need.level = CommonUtil.GetScienceLv(num)
      table.insert(self.needScience, need)
    end)
  end
  resource = row:getValue("effect_local")
  if resource ~= nil and resource ~= "" then
    local vec = string.split_ss_array(resource, ";")
    table.walk(vec, function(k, v)
      local vec1 = string.split_ss_array(v, ",")
      if 2 <= #vec1 then
        table.insert(self.effect_Local_dialog, vec1[1])
        table.insert(self.effect_Local_type, tonumber(vec1[2]))
      end
    end)
  end
  local decoGroupUpgradeBaseId = row:getValue("extra_lvup_para")
  if not string.IsNullOrEmpty(decoGroupUpgradeBaseId) then
    self.decorationUpgradeType = DecorationUpgradeType.AdvanceUpgrade
    self.decoGroupUpgradeBaseId = toInt(decoGroupUpgradeBaseId)
  end
  local convert_decorator_num = row:getValue("convert_decorator_num")
  self.convert_decorator_num = toInt(convert_decorator_num)
  self.helpBuildAniPath = row:getValue("help_build_ani_path")
  local chapter_limit = row:getValue("chapter_limit")
  if not string.IsNullOrEmpty(chapter_limit) then
    self.chapter_limit = toInt(chapter_limit)
  end
  self.decoration_recommend_order = row:getValue("decoration_recommend_order")
end

local function GetNeedResource(self)
  for _, need in pairs(self.needResource) do
    local effectValue = LuaEntry.Effect:GetGameEffect(AdditionUpLevelResTechnological)
    effectValue = LuaEntry.Effect:GetFixDoubleNumber(effectValue)
    need.count = math.ceil(need.notDerateCount * (1 - effectValue))
  end
  return self.needResource
end

local function GetPreBuild(self)
  return self.preBuilds
end

local function GetNeedItem(self)
  local baseId = CommonUtil.GetBuildBaseType(self.id)
  if baseId == BuildingTypes.FUN_BUILD_ARROW_TOWER then
    local num = LuaEntry.Effect:GetGameEffect(EffectDefine.DEC_UPGRADE_BUILD_ARROW_TOWER_ITEM)
    if 0 < num then
      local resource = self.para2
      if resource ~= nil and resource ~= "" then
        local item = {}
        local vec = string.split(resource, "|")
        for k, v in ipairs(vec) do
          local vec1 = string.split(v, ";")
          if 2 <= #vec1 then
            local need = {}
            need.itemId = tonumber(vec1[1])
            need.num = tonumber(vec1[2])
            table.insert(item, need)
          end
        end
        return item
      end
    end
  end
  return self.needItem
end

local function GetNeedResourceItem(self)
  return self.needResourceItem
end

local function GetCollectSpeed(self)
  if self.para1 ~= nil and self.para1 ~= "" then
    local original = tonumber(self.para1)
    local addRate = 0
    local add = 0
    local buildType = DataCenter.BuildManager:GetBuildId(self.id)
    if buildType == BuildingTypes.FUN_BUILD_WIND_TURBINE then
      addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.WIND_ELECTRICITY_SPEED_ADD)
      add = add + LuaEntry.Effect:GetGameEffect(EffectDefine.NUCLEAR_SPEED)
    elseif buildType == BuildingTypes.FUN_BUILD_CONDOMINIUM or buildType == BuildingTypes.FUN_BUILD_GROCERY_STORE then
      addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.HOTEL_MONEY_SPEED_ADD)
      addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.MONEY_SPEED_ADD)
    elseif buildType == BuildingTypes.FUN_BUILD_VILLA then
      addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.HOUSE_MONEY_SPEED_ADD)
      addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.MONEY_SPEED_ADD)
    elseif buildType == BuildingTypes.FUN_BUILD_OIL then
      addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.GAS_BUILD_COLLECT_SPEED_ADD)
      add = add + LuaEntry.Effect:GetGameEffect(EffectDefine.OIL_SPEED)
    elseif buildType == BuildingTypes.FUN_BUILD_STONE then
      addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.METAL_SPEED_ADD)
      add = add + LuaEntry.Effect:GetGameEffect(EffectDefine.METAL_SPEED)
    elseif buildType == BuildingTypes.FUN_BUILD_SOLAR_POWER_STATION then
      addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.SOLAR_ELECTRICITY_SPEED_ADD)
      add = add + LuaEntry.Effect:GetGameEffect(EffectDefine.ELECTRICITY_SPEED)
    elseif buildType == BuildingTypes.FUN_BUILD_ELECTRICITY then
      addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.FIRE_ELECTRICITY_SPEED_ADD)
      add = add + LuaEntry.Effect:GetGameEffect(EffectDefine.FOOD_SPEED)
    elseif buildType == BuildingTypes.FUN_BUILD_WATER then
      addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.WATER_BUILD_COLLECT_SPEED_ADD)
    elseif buildType == BuildingTypes.FUN_BUILD_GREEN_CRYSTAL then
      addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.GREEN_CTRSTAL_SPEED_ADD)
    end
    return original * (1 + addRate / 100) + add / 3600
  end
  return 0
end

local function GetCollectMax(self)
  if self.para2 ~= nil and self.para2 ~= "" then
    local original = tonumber(self.para2)
    local addRate = 0
    local buildType = DataCenter.BuildManager:GetBuildId(self.id)
    if buildType == BuildingTypes.FUN_BUILD_WATER then
      addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.WATER_CAPACITY_ADD)
    elseif buildType == BuildingTypes.FUN_BUILD_STONE then
      addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.METAL_CAPACITY_ADD)
    elseif buildType == BuildingTypes.FUN_BUILD_OIL then
      addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.GAS_CAPACITY_ADD)
    elseif buildType == BuildingTypes.FUN_BUILD_WIND_TURBINE then
      addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.WIND_ELECTRICITY_CAPACITY_ADD)
    elseif buildType == BuildingTypes.FUN_BUILD_SOLAR_POWER_STATION then
      addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.FIRE_ELECTRICITY_CAPACITY_ADD)
    elseif buildType == BuildingTypes.FUN_BUILD_CONDOMINIUM or buildType == BuildingTypes.FUN_BUILD_GROCERY_STORE then
      addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.HOTEL_MONEY_CAPACITY_ADD)
      addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.MONEY_CAPACITY_ADD)
    elseif buildType == BuildingTypes.FUN_BUILD_VILLA then
      addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.HOUSE_MONEY_CAPACITY_ADD)
      addRate = addRate + LuaEntry.Effect:GetGameEffect(EffectDefine.MONEY_CAPACITY_ADD)
    end
    local x, y = math.modf(original * (1 + addRate / 100))
    return x
  end
  return 0
end

local function GetCollectMaxOthers(self)
  if self.para2 ~= nil and self.para2 ~= "" then
    local original = tonumber(self.para2)
    return original
  end
  return 0
end

local function GetCostSpeed(self)
  if self.para5 ~= nil and self.para5 ~= "" then
    return tonumber(self.para5)
  end
  return 0
end

local function GetCostMax(self)
  if self.para4 ~= nil and self.para4 ~= "" then
    return tonumber(self.para4)
  end
  return 0
end

local function GetOutItemSpeed(self)
  if self.para4 ~= nil and self.para4 ~= "" then
    return tonumber(self.para4)
  end
  return 0
end

local function GetOutItemNeedValue(self)
  if self.para5 ~= nil and self.para5 ~= "" then
    return tonumber(self.para5)
  end
  return 1
end

local function GetDefenceWallMax(self)
  local maxHp = LuaEntry.Effect:GetGameEffect(EffectDefine.MAX_MY_CITY_DEFENCE)
  local stateId = EffectDefine.SEASON_MUMMY_Status_Id_CURSE2
  local layer = LuaEntry.Effect:GetStatusLayer(stateId)
  if 0 < layer then
    local stateMeta = LocalController:instance():getLine(TableName.StatusTab, stateId)
    if stateMeta then
      local effect_num = tonumber(stateMeta.effect_num)
      if effect_num then
        maxHp = maxHp - math.abs(layer * effect_num)
      end
    end
  end
  return maxHp
end

local function GetDefenceWallCoverSpeed(self)
  if self.para5 ~= nil and self.para5 ~= "" then
    local speed = tonumber(self.para5)
    if speed == nil then
      speed = 0
    end
    return speed
  end
  return 0
end

local function GetShowTalkAfterGetItem(self)
  if self.para7 ~= nil and self.para7 ~= "" then
    local vec = string.split(self.para7, ";")
    local index = math.random(1, #vec)
    return vec[index]
  end
  return ""
end

local AdditionUpLevelSpeedTechnological = 50129

local function GetBuildTime(self)
  local effectAdd = LuaEntry.Effect:GetGameEffect(EffectDefine.BUILD_SPEED_ADD)
  local oldTime = math.floor(self.time * 1000 / (1 + effectAdd / 100))
  return oldTime / (1 + LuaEntry.Effect:GetGameEffect(AdditionUpLevelSpeedTechnological))
end

local function GetShowBubblePercent(self)
  if self.para3 ~= nil and self.para3 ~= "" then
    local num = tonumber(self.para3)
    if 100 < num then
      num = 100
    end
    return num / 100
  end
  return 0.05
end

local function GetIconDeltaPosition(self)
  return Vector3.New(self.icon_position_x, self.icon_position_y, 0)
end

local function GetShowLevel(self)
  if self.showLv == nil then
    local lv = CommonUtil.GetBuildLv(self.id)
    local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(CommonUtil.GetBuildBaseType(self.id))
    if template ~= nil then
      self.showLv = template:GetShowLevel(lv)
    end
  end
  if self.showLv == nil then
    local lv = CommonUtil.GetBuildLv(self.id)
    self.showLv = lv
  end
  return self.showLv
end

local function GetLevelRange(self)
  local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(CommonUtil.GetBuildBaseType(self.id))
  if self.showMax == nil then
    local lv = CommonUtil.GetBuildLv(self.id)
    if template ~= nil then
      local showMin, showMax = template:GetLevelRange(lv)
      self.showMax = showMax
      self.showMin = showMin
    end
  end
  if self.showMax == nil then
    self.showMax = template.max_level
    self.showMin = 1
  end
  return self.showMin, self.showMax
end

local function GetOutResourceItemId(self)
  if self.para4 ~= nil and self.para4 ~= "" then
    return tonumber(self.para4)
  end
end

local function GetNeedPeopleNum(self)
  if self.people ~= nil then
    return self.people
  end
  return 0
end

function BuildingLevelTemplate:GetRewardNeedTalent()
  return self.rewardNeedTalentId
end

function BuildingLevelTemplate:GetBuildIconOutCity()
  if string.IsNullOrEmpty(self.pic_full_path) then
    if string.IsNullOrEmpty(self.pic) then
      return DefaultImage
    end
    return string.format(LoadPath.BuildIconOutCity, self.pic)
  end
  return self.pic_full_path
end

function BuildingLevelTemplate:GetCityModelName()
  local result = self.model
  if not string.IsNullOrEmpty(self.model_full_path) then
    result = self.model_full_path
  end
  if LuaEntry.DataConfig:CheckSwitch("building_model_new") and self.model_new ~= nil and self.model_new ~= "" then
    result = self.model_new
  end
  local buildType = self.id - self.level
  if buildType == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION1 or buildType == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION2 or buildType == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION3 or buildType == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION4 then
  elseif buildType == BuildingTypes.LW_BUILD_SEASON4_LIGHTHOUSE then
  else
    local replaceData = DataCenter.SeasonCallbackManager:GetReplaceRecord(buildType)
    if replaceData then
      result = replaceData.model
    end
  end
  return result
end

function BuildingLevelTemplate:GetWorldModelName()
  if not string.IsNullOrEmpty(self.model_world_full_path) then
    return self.model_world_full_path
  end
  return self.model_world
end

function BuildingLevelTemplate:GetEqualGlueValue()
  return self.equal_glue_value
end

function BuildingLevelTemplate:IsTimeConditionValid()
  if not self.time_condition then
    return true
  end
  local seasonNum = SeasonUtil.GetSeason()
  if seasonNum > self.time_condition[1] then
    return true
  elseif seasonNum < self.time_condition[1] then
    return false
  end
  return self.time_condition[2] <= SeasonUtil.GetSeasonDayByOpenServerZero()
end

function BuildingLevelTemplate:IsPreBuildConditionValid()
  if string.IsNullOrEmpty(self.building_prerequisites) then
    local thePreBuilds = self:GetPreBuild()
    if thePreBuilds then
      for k, v in ipairs(thePreBuilds) do
        if not DataCenter.BuildManager:IsExistBuildByTypeLv(v.buildId, v.level) then
          return false
        end
      end
    end
    return true
  end
  local data_list = string.split(self.building_prerequisites, "|")
  for k, v in ipairs(data_list) do
    local tmp = string.split_ii_array(v, ";")
    if 2 <= #tmp and DataCenter.BuildManager:IsExistBuildByTypeLv(tmp[1], tmp[2]) then
      return true
    end
  end
  return false
end

function BuildingLevelTemplate:GetNeedScience()
  return self.needScience
end

BuildingLevelTemplate.__init = __init
BuildingLevelTemplate.__delete = __delete
BuildingLevelTemplate.InitData = InitData
BuildingLevelTemplate.GetNeedResource = GetNeedResource
BuildingLevelTemplate.GetPreBuild = GetPreBuild
BuildingLevelTemplate.GetNeedItem = GetNeedItem
BuildingLevelTemplate.GetCollectSpeed = GetCollectSpeed
BuildingLevelTemplate.GetCollectMax = GetCollectMax
BuildingLevelTemplate.GetCostSpeed = GetCostSpeed
BuildingLevelTemplate.GetCostMax = GetCostMax
BuildingLevelTemplate.GetOutItemSpeed = GetOutItemSpeed
BuildingLevelTemplate.GetOutItemNeedValue = GetOutItemNeedValue
BuildingLevelTemplate.GetShowTalkAfterGetItem = GetShowTalkAfterGetItem
BuildingLevelTemplate.GetBuildTime = GetBuildTime
BuildingLevelTemplate.GetShowBubblePercent = GetShowBubblePercent
BuildingLevelTemplate.GetIconDeltaPosition = GetIconDeltaPosition
BuildingLevelTemplate.GetCollectMaxOthers = GetCollectMaxOthers
BuildingLevelTemplate.GetShowLevel = GetShowLevel
BuildingLevelTemplate.GetLevelRange = GetLevelRange
BuildingLevelTemplate.GetDefenceWallMax = GetDefenceWallMax
BuildingLevelTemplate.GetDefenceWallCoverSpeed = GetDefenceWallCoverSpeed
BuildingLevelTemplate.GetNeedResourceItem = GetNeedResourceItem
BuildingLevelTemplate.GetOutResourceItemId = GetOutResourceItemId
BuildingLevelTemplate.GetNeedPeopleNum = GetNeedPeopleNum
return BuildingLevelTemplate
