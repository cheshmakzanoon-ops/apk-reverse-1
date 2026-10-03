local AttackCityS0ConfigManager = BaseClass("AttackCityS0ConfigManager")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.cityRewardConfigList = nil
  self.cityThumbsRewardConfigList = nil
  self.scoreItemId = nil
  self.scoreItemType = nil
  self.clueId = nil
  self.lvLimit = nil
end

local function __delete(self)
  self.cityRewardConfigList = nil
  self.cityThumbsRewardConfigList = nil
  self.scoreItemId = nil
  self.scoreItemType = nil
  self.clueId = nil
  self.lvLimit = nil
end

function AttackCityS0ConfigManager:GetCityRewardConfigList()
  if self.cityRewardConfigList then
    return self.cityRewardConfigList
  else
    self.cityRewardConfigList = {}
    local configStr = LuaEntry.DataConfig:TryGetStr("city_war_config", "k1", "")
    if not string.IsNullOrEmpty(configStr) then
      local result = {}
      for num in string.gmatch(configStr, "[^|]+") do
        table.insert(result, tonumber(num))
      end
      for k, v in pairs(result) do
        local config = DataCenter.AllianceCityTemplateManager:GetTemplate(v)
        local personalReward = config.show_reward
        local allianceReward = config.show_alliance_reward
        local icon = config.city_rally_icon
        local level = config.level
        self.cityRewardConfigList[k] = {
          level = level,
          personalReward = DataCenter.RewardManager:ParseRewardsStr(personalReward),
          allianceReward = DataCenter.RewardManager:ParseRewardsStr(allianceReward),
          icon = icon
        }
      end
      return self.cityRewardConfigList
    end
  end
  return nil
end

function AttackCityS0ConfigManager:GetCityClueConfigData(configId)
  local totalNum = GetTableData(TableName.City_Battle_Clue, configId, "total")
  local column = GetTableData(TableName.City_Battle_Clue, configId, "length")
  local reward = GetTableData(TableName.City_Battle_Clue, configId, "reward")
  local icon = GetTableData(TableName.City_Battle_Clue, configId, "resource")
  local param = {
    total = totalNum,
    column = column,
    reward = reward,
    icon = icon
  }
  return param
end

function AttackCityS0ConfigManager:GetAttackCityThumbsUpReward(cityLv)
  if self.cityThumbsRewardConfigList and self.cityThumbsRewardConfigList[cityLv] then
    return self.cityThumbsRewardConfigList[cityLv]
  end
  local config = LuaEntry.DataConfig:TryGetStr("city_war_config", "k2", "")
  if not string.IsNullOrEmpty(config) then
    local result = {}
    for num in string.gmatch(config, "[^|]+") do
      table.insert(result, num)
    end
    self.cityThumbsRewardConfigList = result
    return self.cityThumbsRewardConfigList[cityLv]
  end
  return nil
end

function AttackCityS0ConfigManager:GetCityPointIdByCityId(eventId)
  local cityId = DataCenter.AttackCityS0DataManager:GetDetectEventInfoByEventId(eventId)
  if not string.IsNullOrEmpty(cityId) then
    local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, LuaEntry.Player:GetCurServerId())
    if cityMeta then
      return cityMeta:GetPointId()
    end
  end
  return nil
end

function AttackCityS0ConfigManager:GetBattlePassScoreItemIdAndType()
  if self.scoreItemId and self.scoreItemType then
    return self.scoreItemId, self.scoreItemType
  else
    local goodsId = LuaEntry.DataConfig:TryGetStr("city_war_config", "k8", "")
    if not string.IsNullOrEmpty(goodsId) then
      local type = LocalController:instance():getIntValue(TableName.GoodsTab, goodsId, "type")
      self.scoreItemId = goodsId
      self.scoreItemType = type
      return self.scoreItemId, self.scoreItemType
    end
  end
  return nil, nil
end

function AttackCityS0ConfigManager:GetCityClueItemIdAndLevelLimit()
  if self.clueId and self.lvLimit then
    return self.clueId, self.lvLimit
  end
  local str = LuaEntry.DataConfig:TryGetStr("city_war_config", "k7")
  local limitLevel, goodsId = string.match(str, "([^|]+)|([^|]+)")
  limitLevel = tonumber(limitLevel)
  self.clueId = goodsId
  self.lvLimit = limitLevel
  return goodsId, limitLevel
end

AttackCityS0ConfigManager.__init = __init
AttackCityS0ConfigManager.__delete = __delete
return AttackCityS0ConfigManager
