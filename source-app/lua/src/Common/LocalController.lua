LocalController = BaseClass("LocalController")
local instance_
local SUB_EX = "_split"
local OLD_STYLE = {
  AB_building = true,
  APS_alScience = true,
  APS_alScienceTab = true,
  APS_arms = true,
  APS_global = true,
  APS_hero_color = true,
  APS_monster = true,
  APS_talent = true,
  DayAct = true,
  activity_continue_pay = true,
  activity_jigsaw = true,
  activity_luoha = true,
  activity_monster = true,
  activity_puzzle_monster = true,
  activity_showlist = true,
  affect_num = true,
  alScience = true,
  alScienceTab = true,
  alliance_effect = true,
  alliance_info = true,
  alliance_resource = true,
  alliance_task = true,
  aps_base_expansion = true,
  aps_build_queue = true,
  aps_buildzone = true,
  aps_city_buff = true,
  aps_decoration = true,
  aps_factory = true,
  aps_factory_B = true,
  aps_farming = true,
  aps_farming_B = true,
  aps_gather_resource = true,
  aps_hero_levelup = true,
  aps_heroes_quality = true,
  aps_heroes_rank = true,
  aps_heroes_rankLv = true,
  aps_landlock = true,
  aps_new_heroes = true,
  aps_new_heroes_B = true,
  aps_purchase_order = true,
  aps_purchase_order_B = true,
  aps_pve_ZombieWave = true,
  aps_pve_atom = true,
  aps_pve_battlebuff = true,
  aps_pve_buff = true,
  aps_pve_choosebuff = true,
  aps_pve_level = true,
  aps_pve_monster_group = true,
  aps_pve_monument = true,
  aps_pve_trigger = true,
  aps_pve_zombie = true,
  aps_sandRoad = true,
  aps_season = true,
  aps_singlemap_junk = true,
  aps_singlemap_pioneer = true,
  aps_uav_dialogue = true,
  aps_warning = true,
  aps_warning_B = true,
  aps_worldmap_position = true,
  army = true,
  arrow_tips = true,
  artifact = true,
  birth_coordinate_0 = true,
  boss_stage_reward = true,
  camp_effect = true,
  car_modify = true,
  car_transform = true,
  career_effect = true,
  decoration = true,
  desert_storm_match_result = true,
  effect = true,
  effect_num = true,
  effect_num_des = true,
  explore_level = true,
  explorer_case = true,
  explorer_entrance = true,
  goldbrick_and_price = true,
  goldbrick_default_price = true,
  goldbrick_ios_price = true,
  growth_fund = true,
  hero_bounty = true,
  hero_core = true,
  hero_entrust = true,
  hero_lack_tips = true,
  hero_official = true,
  hero_station = true,
  hero_tag = true,
  heroes_levelup = true,
  language = true,
  level_up = true,
  lw_arean_rank_reward = true,
  lw_buff_item = true,
  lw_building = true,
  lw_guide = true,
  lw_guide_flow_B = true,
  lw_guide_open = true,
  ["lw_hero-dev"] = true,
  lw_hero_rank_old = true,
  lw_hero_skill_reset = true,
  lw_monster_point = true,
  lw_plot_group = true,
  lw_radar = true,
  lw_random_hero_base_property = true,
  lw_resource_item = true,
  lw_resource_item_init = true,
  lw_resources = true,
  masteryExp = true,
  mine = true,
  monster_invasion_rank_reward = true,
  monster_refresh = true,
  noviceboot = true,
  noviceboot_B = true,
  player_career = true,
  player_level = true,
  questionAndAnswer = true,
  questionnaire = true,
  rec_science = true,
  res_lack_tips = true,
  rescoures_collect = true,
  resources_collect = true,
  reward1 = true,
  rocket_order = true,
  science = true,
  sciencegroup = true,
  season_city = true,
  season_mastery = true,
  season_pass = true,
  season_reward = true,
  season_reward_group = true,
  season_week = true,
  skill = true,
  speedup_config = true,
  status = true,
  subsidy = true,
  sys_red_packet = true,
  talent = true,
  talent_type = true,
  train_addition_reward_pool = true,
  trends = true,
  trends_function = true,
  troop_action = true,
  worldcity = true
}

function LocalController.instance()
  if not instance_ then
    instance_ = LocalController.New()
  end
  return instance_
end

function LocalController.__delete()
  if instance_ then
    UpdateManager:GetInstance():RemoveUpdate(instance_.cleanUpdater)
    instance_ = nil
  end
end

function LocalController:__init()
  Logger.Log("LocalController:__init")
  self.xmlValue = {}
  self.xmlPath = "LuaDatatable."
  self.DataConfig = {}
  self.mtDataLine = {
    __index = function(t, key)
      return t:getValue(key)
    end
  }
  self.xmlLastTouchTime = {}
  self.xmlLastTouchTimeArr = arrayV2.new()
  self.recordPool = {}
  self.cleanUpdater = BindCallback(self, self.TryCleanUnusedTableData)
  UpdateManager:GetInstance():AddSecondUpdate(self.cleanUpdater)
end

function LocalController:setTablePath(path)
end

function LocalController:getValue(xmlType, xmlId, xmlAttr, defValue)
  local lineData = self:getLineInternal(xmlType, xmlId)
  if lineData == nil then
    return defValue or ""
  end
  local xType = self:fixXmlType(xmlType)
  local t = self.xmlValue[xType]
  local strxmlAttr = tostring(xmlAttr)
  local idxAttr = t.index[strxmlAttr]
  local value
  if idxAttr ~= nil then
    local key = idxAttr[1]
    local link = idxAttr[3]
    value = lineData[key]
    if link and value and t.vExt then
      value = t.vExt[value]
    end
  end
  return value or defValue or ""
end

function LocalController:getIntValue(xmlType, xmlId, xmlAttr, defValue)
  local rValue = self:getValue(xmlType, xmlId, xmlAttr, defValue)
  return tonumber(rValue) or defValue or 0
end

function LocalController:getStrValue(xmlType, xmlId, xmlAttr, defValue)
  local rValue = self:getValue(xmlType, xmlId, xmlAttr, defValue)
  return tostring(rValue)
end

function LocalController:fixXmlId(xmlType, xmlId)
  if xmlType == TableName.DataConfig or xmlType == TableName.LW_Config_Split then
    return xmlId
  end
  local iXmlId = tonumber(xmlId)
  if iXmlId == nil then
    if CommonUtil.IsDebug() then
      Logger.LogError("LocalController:fixXmlId error!!!   table:" .. tostring(xmlType) .. "   id:" .. tostring(xmlId))
    else
      Logger.LogWarning("LocalController:fixXmlId error!!!   table:" .. tostring(xmlType) .. "   id:" .. tostring(xmlId))
    end
    return xmlId
  end
  return iXmlId
end

function LocalController:getLineInternal(xmlType, xmlId)
  local ixmlId = self:fixXmlId(xmlType, xmlId)
  local t = self:getTable(xmlType)
  if t == nil then
    return nil
  end
  if t.link and type(ixmlId) == "number" then
    local line
    for k, v in pairs(t.link) do
      if ixmlId >= v[1] and ixmlId <= v[2] then
        line = k
        break
      end
    end
    if line == nil then
      return nil
    end
    local xType = self:fixXmlType(xmlType, true)
    return self:getLineInternal(xType .. line, ixmlId)
  end
  return t.data[ixmlId]
end

function LocalController:getLine(xmlType, xmlId)
  if xmlId == nil then
    Logger.LogError("LocalController getLine xmlId is nil !!! ")
    return
  end
  local ixmlId = self:fixXmlId(xmlType, xmlId)
  local LineData = self:createLineData(xmlType, ixmlId)
  if LineData == nil then
    return nil
  end
  LineData._lineData = self:getLineInternal(xmlType, xmlId)
  if LineData._lineData == nil then
    if not CommonUtil.IsDebug() or tostring(xmlType) == "goods" or tostring(xmlType) == "lw_plot" or tostring(xmlType) == "battlefield_season_config" then
      Logger.Log("config not find!!!   table:" .. tostring(xmlType) .. "   id:" .. tostring(xmlId))
    else
      Logger.LogError("config not find!!!   table:" .. tostring(xmlType) .. "   id:" .. tostring(xmlId))
    end
    return nil
  end
  return LineData
end

function LocalController:hasLine(xmlType, xmlId)
  if xmlId == nil then
    Logger.LogError("LocalController getLine xmlId is nil !!! ")
    return false
  end
  if self:getLineInternal(xmlType, xmlId) == nil then
    return false
  end
  return true
end

function LocalController:tryGetLine(xmlType, xmlId)
  if self:hasLine(xmlType, xmlId) then
    return self:getLine(xmlType, xmlId)
  else
    return nil
  end
end

function LocalController:hasTable(xmlType)
  return self:getTable(xmlType, true) ~= nil
end

local CLEAN_TIME = 120

local function tryLoadTableNoSafe(self, xmlType, ignoreHave)
  if xmlType ~= nil and (ignoreHave or self.xmlValue[xmlType] == nil) then
    self.xmlValue[xmlType] = require(self.xmlPath .. tostring(xmlType))
    local _mt = {
      __index = function(t, key)
        local record = self:GetTableTouchRecord(xmlType)
        record.time = CLEAN_TIME
        return rawget(t, key)
      end
    }
    setmetatable(self.xmlValue[xmlType], _mt)
  end
end

function LocalController:fixXmlType(xmlType, bSplit)
  local xType = xmlType
  if not bSplit then
    return xType
  end
  if not OLD_STYLE[xType] and not string.find(xType, SUB_EX) then
    xType = xType .. SUB_EX
  end
  return xType
end

function LocalController:getTable(xmlType, ignoreError)
  local xType = self:fixXmlType(xmlType)
  local xmlTable = self.xmlValue[xType]
  if xmlTable == nil then
    if xmlType ~= xType and self.xmlValue[xmlType] ~= nil then
      Logger.LogWarning("Table Old: \"" .. xmlType .. "\" already loaded, now to load: \"" .. xType .. "\"")
    end
    local result, errorMsg = pcall(tryLoadTableNoSafe, self, xType)
    if result == false then
      if ignoreError then
        Logger.Log("LocalController Not Found Table: " .. xType, "    Error Msg\239\188\154" .. errorMsg)
      else
        Logger.LogError("LocalController Not Found Table: " .. xType, "    Error Msg\239\188\154" .. errorMsg)
      end
    else
      xmlTable = self.xmlValue[xType]
    end
  end
  return xmlTable
end

function LocalController:createLineData(xmlType, xmlId)
  local tbl = self:getTable(xmlType)
  if tbl == nil then
    return nil, nil
  end
  local xType = self:fixXmlType(xmlType)
  local LineData = {
    _xmlType = xType,
    _xmlId = xmlId,
    getValue = function(self, xmlAttr, defValue)
      local idxAttr = tbl.index[xmlAttr]
      if idxAttr ~= nil and self._lineData ~= nil then
        local key = idxAttr[1]
        local type = idxAttr[2]
        local link = idxAttr[3]
        local value = self._lineData[key]
        if link and value and tbl.vExt then
          value = tbl.vExt[value]
        end
        if type == "string" then
          return value or defValue or ""
        else
          return value or defValue
        end
      end
      if defValue ~= nil then
        return defValue
      end
      return nil
    end,
    getIntValue = function(self, xmlAttr, defValue)
      return tonumber(self.getValue(self, xmlAttr)) or defValue or 0
    end,
    getMetaData = function(self)
      return tbl.index, self._lineData, tbl.vExt
    end
  }
  setmetatable(LineData, self.mtDataLine)
  return LineData, tbl
end

local VisitNoRelease = {
  aps_factory = true,
  lw_monster = true,
  lw_monster_B = true,
  lw_monster_opt = true,
  lw_stage_feature = true,
  lw_stage_feature_B = true,
  lw_stage_feature_opt = true
}

function LocalController:visitTable(xmlType, callback)
  if callback == nil then
    return
  end
  ProfilerUtil.BeginSample("LC.visitTable")
  local LineData, tbl = self:createLineData(xmlType, -1)
  if LineData == nil then
    ProfilerUtil.EndSample()
    return
  end
  ProfilerUtil.BeginSample(xmlType)
  local t
  local link = tbl.link
  if link then
    t = {}
    local xType = self:fixXmlType(xmlType)
    for i = 1, #link do
      local tmpTbl = self:getTable(xType .. i)
      for k, v in pairs(tmpTbl.data) do
        t[k] = v
      end
    end
  else
    t = tbl.data
  end
  ProfilerUtil.BeginSample("callback")
  for k, v in pairs(t) do
    LineData._xmlId = k
    LineData._lineData = self:getLineInternal(xmlType, k)
    local stop = callback(k, LineData)
    if stop then
      break
    end
  end
  ProfilerUtil.EndSample()
  ProfilerUtil.EndSample()
  ProfilerUtil.EndSample()
end

function LocalController:GetTableLength(xmlType)
  local length = 0
  local tbl = self:getTable(xmlType)
  if tbl ~= nil then
    local t = tbl.data
    if t ~= nil then
      length = table.count(t)
    end
  end
  return length
end

function LocalController:setDataConfig(params)
  Logger.Log("<color=#94e138>LocalController:setDataConfig</color>")
  if params ~= nil then
    self.DataConfig = params
  end
end

function LocalController:getDataConfig(configType, key)
  local ret = ""
  if self.DataConfig[configType] ~= nil then
    ret = self.DataConfig[configType][key] or ""
  end
  Logger.Log("<color=#94e138>LocalController:getDataConfig(", configType, ",", key, ") = ", ret, "</color>")
  return ret
end

function GetTableData(_type, itemId, name, defaultValue)
  return LocalController:instance():getValue(_type, itemId, name, defaultValue)
end

function LocalController:ReleaseTableData(name)
  if not name then
    return
  end
  if not self.xmlValue[name] then
    return
  end
  self.xmlValue[name] = nil
  local record = self.xmlLastTouchTime[name]
  if record then
    self.xmlLastTouchTime[name] = nil
    self.xmlLastTouchTimeArr:RemoveAt(record.id)
    table.insert(self.recordPool, record)
  end
  unloadModule(string.format("LuaDatatable.%s", name))
end

function LocalController:GetTableTouchRecord(xmlType)
  if self.xmlLastTouchTime[xmlType] then
    return self.xmlLastTouchTime[xmlType]
  end
  local node
  if #self.recordPool > 0 then
    node = table.remove(self.recordPool)
    node.name = xmlType
  else
    node = {
      time = 0,
      id = 0,
      name = xmlType
    }
  end
  node.id = self.xmlLastTouchTimeArr:Add(node)
  self.xmlLastTouchTime[xmlType] = node
  return node
end

local MAXCOSTTIMEPERFRAME = 0.01

function LocalController:TryCleanUnusedTableData()
  local startTime = Time.realtimeSinceStartup
  local toClean = {}
  local i = 1
  for k, v in self.xmlLastTouchTimeArr:iterator() do
    local time = v.time
    if 0 < time then
      local time = time - 1
      v.time = time
      if time <= 0 then
        toClean[i] = v.name
        i = i + 1
      end
    else
      toClean[i] = v.name
      i = i + 1
    end
  end
  for i = 1, #toClean do
    local v = toClean[i]
    self:ReleaseTableData(v)
    if Time.realtimeSinceStartup - startTime > MAXCOSTTIMEPERFRAME then
      break
    end
  end
end

return LocalController
