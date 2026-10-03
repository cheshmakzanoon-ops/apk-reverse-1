local Localization = CS.GameEntry.Localization
local CityAttachmentTemplate = BaseClass("SeasonFarmerCityAttachmentTemplate")

function CityAttachmentTemplate:__init(row)
  self.cfgId = row:getIntValue("id")
  self.groupId = row:getIntValue("group")
  self.cityId = row:getIntValue("cityid")
  self.build_list = string.split(row:getValue("unlock"), "|")
  self.building_offset = string.split(row:getValue("building_offset"), "|")
  self.wall_list = string.split(row:getValue("wall_id"), "|")
  self.wall_offset = string.split(row:getValue("wall_offset"), "|")
  self.point2slot = {}
  self.slot2point = {}
  local chest_num = row:getValue("chest_num")
  if string.IsNullOrEmpty(chest_num) then
    self.chest_num_list = {}
  else
    self.chest_num_list = string.split(chest_num, "|")
  end
end

function CityAttachmentTemplate:__delete()
end

function CityAttachmentTemplate:GetSlotIdByBuildPos(pointId)
  local theSlotId = self.point2slot[pointId]
  if theSlotId ~= nil then
    return theSlotId
  end
  local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(self.cityId, LuaEntry.Player:GetCurServerId())
  if cityMeta == nil then
    return nil
  end
  local CityPointId = cityMeta:GetPointId()
  local v2 = SceneUtils.IndexToTilePos(CityPointId, ForceChangeScene.World)
  if self.wall_offset ~= nil then
    for slotId, v in ipairs(self.wall_offset) do
      if v then
        local xStr1, yStr1, xStr2, yStr2 = string.match(v, "([^,;]+),([^,;]+);([^,;]+),([^,;]+)")
        if xStr1 and yStr1 and xStr2 and yStr2 then
          self.point2slot[SceneUtils.TileXYToIndex(v2.x + toInt(xStr1), v2.y + toInt(yStr1), ForceChangeScene.World)] = slotId
          self.point2slot[SceneUtils.TileXYToIndex(v2.x + toInt(xStr2), v2.y + toInt(yStr2), ForceChangeScene.World)] = slotId
        else
          local xStr, yStr = string.match(v, "([^,;]+);([^,;]+)")
          if xStr and yStr then
            self.point2slot[SceneUtils.TileXYToIndex(v2.x + toInt(xStr), v2.y + toInt(yStr), ForceChangeScene.World)] = slotId
          else
            xStr, yStr = string.match(v, "([^,;]+),([^,;]+)")
            if xStr and yStr then
              self.point2slot[SceneUtils.TileXYToIndex(v2.x + toInt(xStr), v2.y + toInt(yStr), ForceChangeScene.World)] = slotId
            end
          end
        end
      end
    end
  end
  if self.building_offset ~= nil then
    for slotId, v in ipairs(self.building_offset) do
      if v then
        local xStr, yStr = string.match(v, "([^,;]+);([^,;]+)")
        if xStr and yStr then
          self.point2slot[SceneUtils.TileXYToIndex(v2.x + toInt(xStr), v2.y + toInt(yStr), ForceChangeScene.World)] = slotId
        else
          xStr, yStr = string.match(v, "([^,;]+),([^,;]+)")
          if xStr and yStr then
            self.point2slot[SceneUtils.TileXYToIndex(v2.x + toInt(xStr), v2.y + toInt(yStr), ForceChangeScene.World)] = slotId
          end
        end
      end
    end
  end
  return self.point2slot[pointId]
end

function CityAttachmentTemplate:GetChestNumBySlot(slotId)
  return toInt(self.chest_num_list[slotId])
end

function CityAttachmentTemplate:GetBuildPosBySlot(slotId)
  local thePointId = self.slot2point[slotId]
  if thePointId ~= nil then
    return thePointId
  end
  local building_offset = self.building_offset[slotId]
  if building_offset then
    local xStr, yStr = string.match(building_offset, "([^;]+);([^;]+)")
    if xStr and yStr then
      local xOffset = toInt(xStr)
      local yOffset = toInt(yStr)
      if xOffset ~= 0 or yOffset ~= 0 then
        local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(self.cityId, LuaEntry.Player:GetCurServerId())
        if cityMeta == nil then
          return nil
        end
        local CityPointId = cityMeta:GetPointId()
        local v2 = SceneUtils.IndexToTilePos(CityPointId, ForceChangeScene.World)
        thePointId = SceneUtils.TileXYToIndex(v2.x + xOffset, v2.y + yOffset, ForceChangeScene.World)
        self.slot2point[slotId] = thePointId
      end
    end
  end
  return thePointId
end

local ExpTemplate = BaseClass("SeasonFarmerExpTemplate")

function ExpTemplate:__init(row)
  self.cfgId = row:getIntValue("id")
  self.groupId = row:getIntValue("group")
  self.level = row:getIntValue("level")
  self.exp = row:getIntValue("Exp")
  self.unlockBuildId = row:getIntValue("builde_id")
  self.unlockCount = row:getIntValue("num")
end

function ExpTemplate:__delete()
end

local BuildTemplate = BaseClass("SeasonFarmerBuildTemplate")

function BuildTemplate:__init(row)
  self.cfgId = row:getIntValue("id")
  self.groupId = row:getIntValue("group")
  self.order = row:getIntValue("order")
  self.buildType = row:getIntValue("type")
  self.persons_num = row:getIntValue("persons_num")
  self.persons_power = row:getIntValue("persons_power")
  self.name = row:getValue("name")
  self.icon = row:getValue("icon")
  self.iconSmall = row:getValue("icon_1")
  self.iconSprite = row:getValue("icon_sprite")
  self.size_x = row:getIntValue("size_x")
  self.size_y = row:getIntValue("size_y")
  self.cost = row:getIntValue("cost")
  self.score = row:getIntValue("score")
  self.reward = row:getValue("reward")
  self.reward_time_max = row:getIntValue("reward_time_max")
  self.effect_1 = row:getValue("effect_1")
  self.effect_2 = row:getValue("effect_2")
  self.buff_effect = row:getValue("buff_effect")
  self.buff = row:getValue("buff")
  self.durability = row:getValue("durability")
  self.chest_num = row:getIntValue("chest_num")
  self.bubble_reward = row:getValue("bubble_reward")
  self.desc_1 = row:getValue("desc_1")
  self.desc_1_para = row:getValue("desc_1_para")
  self.desc_2 = row:getValue("desc_2")
  self.desc_2_para = row:getValue("desc_2_para")
  self.wall = row:getValue("wall")
  self.model = row:getValue("model")
  self.rewardResourceId = 0
  self.rewardResourceCount = 0
  if not string.IsNullOrEmpty(self.reward) then
    local tmp = string.split(self.reward, "|")
    if tmp and 0 < #tmp then
      local resId, resCount = string.match(tmp[1], "([^,;]+);([^,;]+)")
      if resId and resCount then
        self.rewardResourceId = toInt(resId)
        self.rewardResourceCount = toInt(resCount)
      end
    end
  end
end

function BuildTemplate:__delete()
end

function BuildTemplate:GetIconPath(needSprite)
  if needSprite then
    return self.iconSprite
  end
  return self.icon
end

function BuildTemplate:GetDesc()
  return Localization:GetString(self.desc_2, self.desc_2_para)
end

local SeasonFarmerTemplateManager = BaseClass("SeasonFarmerTemplateManager")

function SeasonFarmerTemplateManager:__init()
  self.templateCityAttachmentDict = nil
end

function SeasonFarmerTemplateManager:__delete()
  self.templateCityAttachmentDict = nil
end

function SeasonFarmerTemplateManager:GetMainCfg()
  local mainCfgId = SeasonUtil.GetFarmerConfigId()
  if mainCfgId == 0 then
    return nil
  end
  local cfg = LocalController:instance():getLine(TableName.LW_Season_builders_alliance_group, mainCfgId)
  if cfg == nil then
    Logger.LogError("season_builders_alliance_group is nil, id = " .. mainCfgId)
  end
  return cfg
end

function SeasonFarmerTemplateManager:GetCityAttachmentTemplate(cityId)
  if self.templateCityAttachmentDict == nil then
    local mainCfg = self:GetMainCfg()
    if mainCfg == nil then
      return nil
    end
    local cityGroup = toInt(mainCfg.city_group)
    self.templateCityAttachmentDict = {}
    LocalController:instance():visitTable(TableName.LW_Season_builders_city_list, function(id, lineData)
      if cityGroup == toInt(lineData.group) then
        local data = CityAttachmentTemplate.New(lineData)
        self.templateCityAttachmentDict[data.cityId] = data
      end
    end)
  end
  if self.templateCityAttachmentDict then
    return self.templateCityAttachmentDict[toInt(cityId)]
  end
  return nil
end

function SeasonFarmerTemplateManager:GetALLExpTemplate()
  if self.templateExpTemplateDict == nil then
    local mainCfg = self:GetMainCfg()
    if mainCfg == nil then
      return nil
    end
    local levelGroup = toInt(mainCfg.season_builders_alliance_level)
    self.templateExpTemplateDict = {}
    LocalController:instance():visitTable(TableName.LW_Season_builders_alliance_level, function(id, lineData)
      if levelGroup == toInt(lineData.group) then
        local data = ExpTemplate.New(lineData)
        self.templateExpTemplateDict[data.level] = data
      end
    end)
  end
  return self.templateExpTemplateDict or {}
end

function SeasonFarmerTemplateManager:GetExpTemplateByLevel(level)
  local all = self:GetALLExpTemplate()
  if all then
    return all[toInt(level)]
  end
  return nil
end

function SeasonFarmerTemplateManager:GetALLBuildTemplate()
  if self.templateBuildDict == nil then
    local buildGroup = -1
    local mainCfg = self:GetMainCfg()
    if mainCfg ~= nil then
      buildGroup = toInt(mainCfg.build_group)
    end
    local ConfigCache = CS.GameEntry.ConfigCache
    local name = TableName.LW_Season_builders_alliance_list
    self.templateBuildDict = {}
    self.templateBuildDictALL = {}
    LocalController:instance():visitTable(name, function(id, lineData)
      local theData = BuildTemplate.New(lineData)
      if buildGroup == toInt(lineData.group) then
        self.templateBuildDict[toInt(id)] = theData
      end
      self.templateBuildDictALL[toInt(id)] = theData
      local dictRow = {}
      if lineData.size_x then
        dictRow.size_x = tostring(lineData.size_x)
      end
      if lineData.size_y then
        dictRow.size_y = tostring(lineData.size_y)
      end
      if lineData.model then
        dictRow.model = tostring(lineData.model)
      end
      if lineData.bubble_reward then
        dictRow.bubble_reward = tostring(lineData.bubble_reward)
        local rewardId, rewardCount = string.match(dictRow.bubble_reward, "([^|]+)|([^|]+)")
        if rewardId and rewardCount then
          dictRow.bubble_reward_id = rewardId
          dictRow.bubble_reward_count = rewardCount
        end
      end
      ConfigCache:UpdateTemplateData(name, id, dictRow)
    end)
  end
  return self.templateBuildDict or {}
end

function SeasonFarmerTemplateManager:GetBuildTemplateById(buildId)
  self:GetALLBuildTemplate()
  if self.templateBuildDictALL then
    return self.templateBuildDictALL[toInt(buildId)]
  end
  return nil
end

return SeasonFarmerTemplateManager
