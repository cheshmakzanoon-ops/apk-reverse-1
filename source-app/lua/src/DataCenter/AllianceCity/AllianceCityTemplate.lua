local base = require("Common.TemplateBase")
local AllianceCityTemplate = BaseClass("AllianceCityTemplate", base)

function AllianceCityTemplate:OnCreate()
end

function AllianceCityTemplate:OnDestroy()
end

function AllianceCityTemplate:InitData(row)
  if row == nil then
    return
  end
  local tbl_index, tbl_data, tbl_ext = row:getMetaData()
  base.SetRowData(self, tbl_index, tbl_data, tbl_ext)
  self.type = row:getIntValue("type")
end

function AllianceCityTemplate:GetName()
  return CS.GameEntry.Localization:GetString(self.name)
end

function AllianceCityTemplate:GetFullName()
  return CS.GameEntry.Localization:GetString(310161, self:GetName(), self.level)
end

function AllianceCityTemplate:GetBigIconPath()
  local city_big_icon = self.city_big_icon
  if city_big_icon == nil or city_big_icon == "" then
    city_big_icon = self:GetIconPath(false)
  end
  return city_big_icon
end

function AllianceCityTemplate:GetIconPath(for_npc_mode)
  local fileName
  local city_rally_icon_npc = self.city_rally_icon_npc
  if for_npc_mode and city_rally_icon_npc ~= nil and city_rally_icon_npc ~= "" then
    fileName = city_rally_icon_npc
  else
    fileName = self.city_rally_icon
  end
  return UIUtil.GetFullPath("Assets/Main/Sprites/UI/LWAllianceZone/Textures/", fileName)
end

function AllianceCityTemplate:GetPointId()
  if self.pointId == nil then
    local pos = self.pos
    self.pointId = SceneUtils.TileXYToIndex(pos.x, pos.y, ForceChangeScene.World)
  end
  return self.pointId
end

function AllianceCityTemplate:GetCurServerId(serverId)
  local curServerId = serverId or LuaEntry.Player:GetCurServerId()
  if SeasonUtil.InSeasonBigMapMode(curServerId) then
    local bigMapIndex = self.bigMapIndex
    curServerId = DataCenter.SeasonDataManager:GetNinePalacesServer(bigMapIndex, ServerEnum.View)
  end
  return curServerId
end

function AllianceCityTemplate:GetSourceServerId()
  local sourceServerId = LuaEntry.Player:GetSourceServerId()
  if SeasonUtil.InSeasonBigMapMode(sourceServerId) then
    local bigMapIndex = self.bigMapIndex
    sourceServerId = DataCenter.SeasonDataManager:GetNinePalacesServer(bigMapIndex, ServerEnum.Source)
  end
  return sourceServerId
end

function AllianceCityTemplate:GetServerIdByEnum(serverEnum)
  serverEnum = serverEnum or ServerEnum.View
  local serverId = LuaEntry.Player:GetServerId(serverEnum)
  if SeasonUtil.InSeasonBigMapMode(serverId) then
    local bigMapIndex = self.bigMapIndex
    serverId = DataCenter.SeasonDataManager:GetNinePalacesServer(bigMapIndex, serverEnum)
  end
  return serverId
end

function AllianceCityTemplate:GetPointInfo()
  local now = UITimeManager:GetInstance():GetServerTime()
  local _pointDataCache_ = self._pointDataCache_
  if _pointDataCache_ ~= nil and _pointDataCache_.pti ~= nil and now == _pointDataCache_.time then
    return _pointDataCache_.pti
  end
  local data
  local world = CS.SceneManager.World
  if world ~= nil then
    local season = self:getIntValue("season", 0)
    local pointId = self:GetPointId()
    if self.bigMapIndex ~= 0 and (season == 5 or season == 6 or season == 7) then
      local bigMapIndex = self.bigMapIndex
      local serverId = DataCenter.SeasonDataManager:GetNinePalacesServer(bigMapIndex, ServerEnum.View)
      data = world:GetPointInfoWithServer(pointId, serverId)
    else
      data = world:GetPointInfo(pointId)
    end
    if data then
      if self._pointDataCache_ then
        self._pointDataCache_.time = now
        self._pointDataCache_.pti = data
      else
        self._pointDataCache_ = {time = now, pti = data}
      end
    else
      self._pointDataCache_ = nil
    end
  end
  return data
end

function AllianceCityTemplate:GetWorldPos()
  local pos = SceneUtils.TileIndexToWorld(self:GetPointId(), ForceChangeScene.World)
  local bigMapIndex = self.bigMapIndex
  if bigMapIndex ~= nil and 1 < bigMapIndex then
    local x, y, z = SceneUtils.GetNinePalacesOffsetByIndex(bigMapIndex)
    if x ~= nil and z ~= nil then
      return Vector3.New(pos.x + x, pos.y + y, pos.z + z)
    end
  end
  return Vector3.New(pos.x, pos.y, pos.z)
end

function AllianceCityTemplate:JumpTo(initZoom, need_guide)
  local cityId = self.id
  local pointId = self:GetPointId()
  local serverId = self:GetCurServerId()
  local worldPointPos = SceneUtils.TileIndexToWorld(toInt(pointId), ForceChangeScene.World)
  local world = CS.SceneManager.World
  GoToUtil.CloseAllWindows()
  if initZoom then
    GoToUtil.GotoWorldPos(worldPointPos, initZoom, 0.2, function()
      TimerManager:GetInstance():DelayInvoke(function()
        local _world = CS.SceneManager.World
        if _world ~= nil then
          if need_guide then
            _world:AutoZoom(initZoom, 0.2, function()
              EventManager:GetInstance():DelayBroadcast(1, EventId.ShowCityGuideNode, cityId)
            end)
          else
            _world:AutoZoom(initZoom, 0.2)
          end
        end
      end, 0.1)
    end, serverId, 0)
  elseif world ~= nil then
    GoToUtil.GotoWorldPos(worldPointPos, world.InitZoom, 0.2, function()
      if need_guide then
        EventManager:GetInstance():DelayBroadcast(1, EventId.ShowCityGuideNode, cityId)
      end
    end, serverId, 0)
  else
    GoToUtil.GotoWorldPos(worldPointPos, nil, 0.2, function()
      if need_guide then
        EventManager:GetInstance():DelayBroadcast(1, EventId.ShowCityGuideNode, cityId)
      end
    end, serverId, 0)
  end
end

function AllianceCityTemplate:GetShopId(shopType_)
  shopType_ = shopType_ or DataCenter.SeasonTradeShopDataManager:GetShopType()
  if shopType_ == TradeShopType.NIGHT then
    return self.__nightShopId or 0
  end
  return self.__shopId or 0
end

function AllianceCityTemplate:GetResourceProductCount(resType)
  if self._resProductDict == nil then
    self:ParseResOutput()
  end
  if resType and self._resProductDict then
    return self._resProductDict[tostring(resType)] or 0
  end
  return 0
end

function AllianceCityTemplate:IsCanon()
  return self.type == WorldAllianceCityType.CrossZoneOutpostCanon or self.type == WorldAllianceCityType.Canon or self.type == WorldAllianceCityType.LLCanon or self.type == WorldAllianceCityType.MissileFactory
end

function AllianceCityTemplate:IsCrossZoneOutpostCity()
  return self.type == WorldAllianceCityType.CrossZoneOutpost
end

function AllianceCityTemplate:IsCrossZoneOutpostCanon()
  return self.type == WorldAllianceCityType.CrossZoneOutpostCanon
end

function AllianceCityTemplate:IsThroneCity()
  return self.type == WorldAllianceCityType.King
end

function AllianceCityTemplate:IsLLThroneCity()
  return self.type == WorldAllianceCityType.LLThroneCity
end

function AllianceCityTemplate:IsLLBigCity()
  return self.sub_type == LLConst.CitySubType.Fortress
end

function AllianceCityTemplate:IsThroneCityBattery()
  return self.type == WorldAllianceCityType.Canon
end

function AllianceCityTemplate:IsLLCityCanon()
  return self.type == WorldAllianceCityType.LLCanon
end

function AllianceCityTemplate:IsLLBuffCity()
  return self.type == WorldAllianceCityType.LLBuffCity
end

function AllianceCityTemplate:IsMissileFactory()
  return self.type == WorldAllianceCityType.MissileFactory
end

function AllianceCityTemplate:IsCity()
  return self.type == WorldAllianceCityType.City
end

function AllianceCityTemplate:IsLLCity()
  return self.type == WorldAllianceCityType.LLNormalCity
end

function AllianceCityTemplate:IsCityStronghold()
  return self.type == WorldAllianceCityType.Stronghold
end

function AllianceCityTemplate:IsTradingStation()
  return self.type == WorldAllianceCityType.TradingStation
end

function AllianceCityTemplate:IsBank()
  return self.type == WorldAllianceCityType.Stronghold and self.asset and self.asset > 0
end

function AllianceCityTemplate:IsAltar()
  return self.type == WorldAllianceCityType.Altar
end

function AllianceCityTemplate:GetPlotIdByIndex(index)
  local the_plot_id = self.plot_id
  if the_plot_id then
    return the_plot_id[index] or ""
  end
  return ""
end

function AllianceCityTemplate:ParseResOutput()
  self._season_snow_stone = self:getValue("stone")
  if self._season_snow_stone and type(self._season_snow_stone) == "string" then
    local theId, theValue = string.match(self._season_snow_stone, "([^;]+);([^;]+)")
    self._season_snow_stone_id = toInt(theId)
    self._season_snow_stone_value = toInt(theValue)
  else
    self._season_snow_stone_id = ResourceType.AllianceStone
    self._season_snow_stone_value = 0
  end
  local season_snow_coal = self:getValue("coal")
  self._resProductDict = {}
  if season_snow_coal ~= nil and season_snow_coal ~= "" and season_snow_coal ~= 0 then
    local typeProduct = type(season_snow_coal)
    if typeProduct == "number" then
      self._season_snow_coal_id = ResourceType.FLINT
      self._season_snow_coal_value = season_snow_coal
    elseif typeProduct == "string" then
      for item in string.gmatch(season_snow_coal, "([^|]+)|?") do
        local resId, resCount = string.match(item, "([^;]+);([^;]+)")
        if resId and resCount then
          if toInt(resId) == ResourceType.FLINT then
            self._season_snow_coal_id = ResourceType.FLINT
            self._season_snow_coal_value = toInt(resCount)
          end
          self._resProductDict[resId] = toInt(resCount)
        end
      end
    end
  end
end

function AllianceCityTemplate:ParseCampResOutput()
  local camp_coal = self:getValue("camp_coal")
  self._resCampProductDict = {}
  if camp_coal ~= nil and camp_coal ~= "" and camp_coal ~= 0 then
    local typeProduct = type(camp_coal)
    if typeProduct == "string" then
      for item in string.gmatch(camp_coal, "([^|]+)|?") do
        local resId, resCount = string.match(item, "([^;]+);([^;]+)")
        if resId and resCount then
          table.insert(self._resCampProductDict, {id = resId, count = resCount})
        end
      end
    end
  end
  return self._resCampProductDict
end

function AllianceCityTemplate:GetCampDestroyResOutput()
  local rewardId = self:getValue("camp_destroy_reward")
  local showCfg = LocalController:instance():getLine(TableName.RewardConfig, rewardId)
  if showCfg then
    local itemStr = showCfg.item
    local numStr = showCfg.num
    local items = string.split(itemStr, "|")
    local nums = string.split(numStr, "|")
    return {
      id = checknumber(items[1]),
      count = checknumber(nums[1])
    }
  end
end

function AllianceCityTemplate.getters:season_snow_stone_value()
  if self._resProductDict == nil then
    self:ParseResOutput()
  end
  return self._season_snow_stone_value
end

function AllianceCityTemplate.getters:season_snow_stone_id()
  if self._resProductDict == nil then
    self:ParseResOutput()
  end
  return self._season_snow_stone_id
end

function AllianceCityTemplate.getters:resProductDict()
  if self._resProductDict == nil then
    self:ParseResOutput()
  end
  return self._resProductDict
end

function AllianceCityTemplate.getters:season_snow_coal_id()
  if self._resProductDict == nil then
    self:ParseResOutput()
  end
  return self._season_snow_coal_id
end

function AllianceCityTemplate.getters:season_snow_coal_value()
  if self._resProductDict == nil then
    self:ParseResOutput()
  end
  return self._season_snow_coal_value
end

function AllianceCityTemplate:ParseItemOutput()
  local item_output = self:getValue("item_output")
  if item_output ~= nil and item_output ~= "" then
    local typeProduct = type(item_output)
    if typeProduct == "string" then
      local itemId, itemCount = string.split_ss(item_output, ";")
      if itemId ~= nil and itemCount ~= nil then
        self._itemProductId = toInt(itemId)
        self._itemProductCount = toInt(itemCount)
      end
    end
  end
end

function AllianceCityTemplate.getters:itemProductId()
  if self._itemProductId == nil then
    self:ParseItemOutput()
  end
  return self._itemProductId
end

function AllianceCityTemplate.getters:itemProductCount()
  if self._itemProductCount == nil then
    self:ParseItemOutput()
  end
  return self._itemProductCount
end

function AllianceCityTemplate.getters:temperature_table_id()
  return self:getIntValue("temperature_status", 0)
end

function AllianceCityTemplate.getters:temperatureCfg()
  if self._temperatureCfg == nil then
    local temperature_table_id = self.temperature_table_id
    if temperature_table_id ~= nil and temperature_table_id ~= 0 then
      local dataTemperature = DataCenter.HeatSourceTemplateManager:GetTemplate(temperature_table_id)
      if dataTemperature then
        self._temperatureCfg = dataTemperature
      end
    end
  end
  return self._temperatureCfg
end

function AllianceCityTemplate.getters:lod_icon()
  return self:getValue("lod_icon")
end

function AllianceCityTemplate.getters:level()
  return self:getIntValue("level")
end

function AllianceCityTemplate.getters:size()
  return self:getIntValue("size", 5)
end

function AllianceCityTemplate.getters:city_field()
  return self:getIntValue("city_field")
end

function AllianceCityTemplate.getters:city_field_LRTB()
  local data = self:getValue("city_field_new")
  if data ~= nil and data ~= "" then
    local arr = string.split_ii_array(data, "|")
    if arr and #arr == 4 then
      self.city_field_LRTB = arr
      return self.city_field_LRTB
    end
  end
  return nil
end

function AllianceCityTemplate.getters:declare_war_cd()
  return self:getIntValue("declare_war_cd", 0)
end

function AllianceCityTemplate.getters:season_tile_size()
  return self:getIntValue("season_tile_size", self.size)
end

function AllianceCityTemplate.getters:stronghold_points()
  return self:getIntValue("stronghold_points", 600)
end

function AllianceCityTemplate.getters:monster_id()
  return self:getValue("monster_id")
end

function AllianceCityTemplate.getters:monster_id_count()
  return #string.split(self.monster_id, "|")
end

function AllianceCityTemplate.getters:monster_num()
  return (self:getIntValue("monster_num"))
end

function AllianceCityTemplate.getters:buff()
  return self:getValue("buff")
end

function AllianceCityTemplate.getters:first_reward()
  return self:getValue("first_reward")
end

function AllianceCityTemplate.getters:show_reward()
  return self:getValue("show_reward")
end

function AllianceCityTemplate.getters:show_alliance_reward()
  return self:getValue("show_alliance_reward")
end

function AllianceCityTemplate.getters:kill_reward()
  return self:getValue("kill_reward")
end

function AllianceCityTemplate.getters:kill_show_reward()
  return self:getValue("kill_show_reward")
end

function AllianceCityTemplate.getters:destroy_reward()
  return self:getValue("destroy_reward")
end

function AllianceCityTemplate.getters:destroy_show_reward()
  return self:getValue("destroy_show_reward")
end

function AllianceCityTemplate.getters:wall()
  return (self:getIntValue("wall"))
end

function AllianceCityTemplate.getters:wall_recover()
  return self:getIntValue("wall_recover") or 0
end

function AllianceCityTemplate.getters:force()
  return self:getIntValue("force") or 0
end

function AllianceCityTemplate.getters:destroy_force()
  return self:getIntValue("destroy_force") or 0
end

function AllianceCityTemplate.getters:name()
  return self:getValue("name")
end

function AllianceCityTemplate.getters:desc()
  return self:getValue("desc")
end

function AllianceCityTemplate.getters:guard_num()
  return self:getIntValue("guard_num")
end

function AllianceCityTemplate.getters:wounded_rate()
  return self:getIntValue("wounded_rate")
end

function AllianceCityTemplate.getters:injury_rate()
  return self:getIntValue("injury_rate")
end

function AllianceCityTemplate.getters:army_recover_time()
  return self:getIntValue("army_recover_time")
end

function AllianceCityTemplate.getters:protect_time()
  return self:getIntValue("protect_time")
end

function AllianceCityTemplate.getters:open_time()
  return self:getValue("open_time")
end

function AllianceCityTemplate.getters:nearBy()
  self.nearBy = string.split(self:getValue("nearBy"), "|")
  return self.nearBy
end

function AllianceCityTemplate.getters:city_rally_icon()
  return self:getValue("city_rally_icon")
end

function AllianceCityTemplate.getters:city_rally_icon_npc()
  return self:getValue("city_rally_icon_npc") or self.city_rally_icon
end

function AllianceCityTemplate.getters:city_big_icon()
  return self:getValue("city_big_icon")
end

function AllianceCityTemplate.getters:recommend_soldier()
  return self:getIntValue("recommend_soldier", 0) or 0
end

function AllianceCityTemplate.getters:defence_buff()
  return self:getValue("defence_buff")
end

function AllianceCityTemplate.getters:stronghold_max()
  return self:getIntValue("stronghold_max", 0) or 0
end

function AllianceCityTemplate.getters:lord_cap()
  return self:getValue("lord_cap")
end

function AllianceCityTemplate.getters:battery()
  return self:getIntValue("battery", 0)
end

function AllianceCityTemplate.getters:parent_output()
  return self:getIntValue("parent_output", 1)
end

function AllianceCityTemplate.getters:bigMapIndexBelong()
  return self:getIntValue("belonging_server", 1)
end

function AllianceCityTemplate.getters:zoneImage()
  return self:getValue("zoneImage")
end

function AllianceCityTemplate.getters:bigMapIndex()
  local zoneId = self:getValue("zoneId")
  if zoneId == nil or zoneId == "" then
    self.bigMapIndex = 0
  else
    self.bigMapIndex = tonumber(zoneId) or 0
  end
  return self.bigMapIndex
end

function AllianceCityTemplate.getters:season_snow_scene_name()
  return self:getValue("scene_name")
end

function AllianceCityTemplate.getters:season_snow_supplies_num()
  return self:getValue("supplies_num")
end

function AllianceCityTemplate.getters:plot_id()
  if self._plot_id == nil then
    local plotId = self:getValue("plot_id")
    if not string.IsNullOrEmpty(plotId) then
      self._plot_id = string.split(plotId, ";")
    else
      self._plot_id = {
        "",
        "",
        "",
        ""
      }
    end
  end
  return self._plot_id
end

function AllianceCityTemplate.getters:stronghold_army_type()
  return self:getIntValue("stronghold_army_type", 0) or 0
end

function AllianceCityTemplate.getters:city_resistance_b()
  return self:getValue("city_resistance_b") or 0
end

function AllianceCityTemplate.getters:city_dmg_param()
  return self:getValue("city_dmg_param")
end

function AllianceCityTemplate.getters:loot_rewards()
  return self:getIntValue("loot_rewards", 0)
end

function AllianceCityTemplate.getters:sever_loot_reward()
  return self:getIntValue("sever_loot_reward", 0)
end

function AllianceCityTemplate.getters:season_snow_prosperity()
  return self:getIntValue("prosperity", 0)
end

function AllianceCityTemplate.getters:show_pic()
  return self:getValue("show_pic")
end

function AllianceCityTemplate.getters:avatar()
  return self:getValue("avatar")
end

function AllianceCityTemplate.getters:avatar_big()
  return self:getValue("avatar_big")
end

function AllianceCityTemplate.getters:head_icon()
  return self:getValue("head_icon")
end

function AllianceCityTemplate.getters:model()
  return self:getValue("model")
end

function AllianceCityTemplate.getters:monster_treat_prefab()
  return self:getValue("monster_treat_prefab")
end

function AllianceCityTemplate.getters:not_occupied_model()
  local not_occupied_model = self:getValue("not_occupied_model")
  if string.IsNullOrEmpty(not_occupied_model) then
    not_occupied_model = self:getValue("model")
  end
  return not_occupied_model
end

function AllianceCityTemplate.getters:location()
  return self:getValue("location")
end

function AllianceCityTemplate.getters:pos()
  local location_value = self:getValue("location")
  local x, y = string.split_ii(location_value, "|")
  self.pos = {
    x = toInt(x),
    y = toInt(y)
  }
  return self.pos
end

function AllianceCityTemplate.getters:max_fisher()
  return self:getIntValue("max_fisher", 0)
end

function AllianceCityTemplate.getters:tax_rate()
  return self:getIntValue("tax_rate", 0)
end

function AllianceCityTemplate.getters:alliance_discount()
  return self:getIntValue("alliance_discount", 1)
end

function AllianceCityTemplate.getters:__shopId()
  return self:getIntValue("shop", 0)
end

function AllianceCityTemplate.getters:__nightShopId()
  return self:getIntValue("night_shop", 0)
end

function AllianceCityTemplate.getters:asset()
  return self:getIntValue("asset", 0)
end

function AllianceCityTemplate.getters:default_asset()
  return self:getIntValue("default_asset", 0)
end

function AllianceCityTemplate.getters:max_asset()
  return self:getIntValue("max_asset", 0)
end

function AllianceCityTemplate.getters:max_into_asset()
  return self:getIntValue("max_into_asset", 0)
end

function AllianceCityTemplate.getters:max_player()
  return self:getIntValue("max_player", 0)
end

function AllianceCityTemplate.getters:deposit_time()
  local deposit_time = self:getValue("deposit_time", "")
  local _deposit_time = {}
  if deposit_time and deposit_time ~= "" then
    for time in string.gmatch(deposit_time, "([^|]+)") do
      local t = tonumber(time)
      if t then
        table.insert(_deposit_time, t)
      end
    end
  end
  return _deposit_time
end

function AllianceCityTemplate.getters:deposit_open_time()
  local deposit_open_time = self:getValue("deposit_open_time", "")
  local _deposit_open_time = {}
  if deposit_open_time and deposit_open_time ~= "" then
    for time in string.gmatch(deposit_open_time, "([^|]+)") do
      local t = tonumber(time)
      if t then
        table.insert(_deposit_open_time, t)
      end
    end
  end
  return _deposit_open_time
end

function AllianceCityTemplate.getters:interest()
  local interest = self:getValue("interest")
  local _interest = {}
  if interest and interest ~= "" then
    for rate in string.gmatch(interest, "([^|]+)") do
      local r = tonumber(rate)
      if r then
        table.insert(_interest, r)
      end
    end
  end
  return _interest
end

function AllianceCityTemplate.getters:only_original_zone()
  return self:getIntValue("only_original_zone", 0)
end

function AllianceCityTemplate.getters:ruins_points()
  return self:getIntValue("ruins_points", 0)
end

function AllianceCityTemplate.getters:defend_reward()
  return self:getValue("defend_reward")
end

function AllianceCityTemplate.getters:battle_destroy_reward()
  return self:getValue("battle_destroy_reward")
end

function AllianceCityTemplate.getters:unlock_week()
  return self:getIntValue("unlock_week", 0)
end

function AllianceCityTemplate.getters:belong_city_id()
  return self:getIntValue("belong_city_id", 0)
end

function AllianceCityTemplate.getters:boom_time()
  return self:getIntValue("boom_time", 0)
end

function AllianceCityTemplate.getters:half_boom_model()
  return self:getValue("half_boom_model")
end

function AllianceCityTemplate.getters:half_boom_icon()
  return self:getValue("half_boom_icon")
end

function AllianceCityTemplate.getters:full_boom_model()
  return self:getValue("full_boom_model")
end

function AllianceCityTemplate.getters:full_boom_icon()
  return self:getValue("full_boom_icon")
end

function AllianceCityTemplate.getters:ruins_model()
  return self:getValue("ruins_model")
end

function AllianceCityTemplate.getters:ruins_icon()
  return self:getValue("ruins_icon")
end

function AllianceCityTemplate.getters:building_model()
  return self:getValue("building_model")
end

function AllianceCityTemplate.getters:boom_progress()
  return self:getValue("boom_progress")
end

function AllianceCityTemplate.getters:sub_type()
  return self:getIntValue("sub_type", 0)
end

function AllianceCityTemplate.getters:special_status()
  return self:getIntValue("special_status", 0)
end

function AllianceCityTemplate.getters:first_open()
  return self:getValue("first_open")
end

function AllianceCityTemplate.getters:loop_blank()
  return self:getValue("loop_blank")
end

function AllianceCityTemplate.getters:open_para()
  return self:getValue("open_para")
end

function AllianceCityTemplate.getters:loop_time()
  return self:getValue("loop_time")
end

function AllianceCityTemplate.getters:city_ruins()
  return self:getValue("city_ruins")
end

function AllianceCityTemplate.getters:lod_icon_ruins()
  return self:getValue("lod_icon_ruins")
end

function AllianceCityTemplate.getters:flag()
  return self:getValue("flag")
end

function AllianceCityTemplate.getters:mutex_flag()
  return self:getValue("mutex_flag")
end

function AllianceCityTemplate.getters:city_bubble_icon()
  return self:getValue("city_bubble_icon")
end

function AllianceCityTemplate.getters:city_bubble_banner()
  return self:getValue("city_bubble_banner")
end

function AllianceCityTemplate.getters:alliance_destroy_reward_show()
  return self:getValue("alliance_destroy_reward_show")
end

return AllianceCityTemplate
