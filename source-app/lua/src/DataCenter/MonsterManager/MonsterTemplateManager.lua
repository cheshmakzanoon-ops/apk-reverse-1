local MonsterTemplateManager = BaseClass("MonsterTemplateManager")
local LWWorldMonsterTableIDBase = {
  [LWWorldMonsterType.ResMetal] = 1002000,
  [LWWorldMonsterType.ResFood] = 1003000,
  [LWWorldMonsterType.Boss] = 8,
  [LWWorldMonsterType.City] = 100499,
  [LWWorldMonsterType.ResGold] = 1004000,
  [LWWorldMonsterType.S4Tank] = 4032000,
  [LWWorldMonsterType.S4Airplane] = 4033000,
  [LWWorldMonsterType.S4Missile] = 4034000,
  [LWWorldMonsterType.S4Boss] = 403100,
  [LWWorldMonsterType.S4TankBN] = 4032100,
  [LWWorldMonsterType.S4AirplaneBN] = 4033100,
  [LWWorldMonsterType.S4MissileBN] = 4034100,
  [LWWorldMonsterType.S4BossBN] = 4031100
}

local function __init(self)
  self.monsterTemplateDic = {}
  self.maxLevel = 0
  self.maxLevelByType = {}
  self.errorId = {}
end

local function __delete(self)
  self.errorId = {}
  self.monsterTemplateDic = nil
end

local function GetMonsterTemplate(self, id, ignoreErrorLog)
  local monsterId = toInt(id)
  if monsterId == 0 or self.errorId[monsterId] == true then
    if not ignoreErrorLog then
      Logger.Log("monsterId not find  => " .. monsterId)
    end
    return nil
  end
  if self.monsterTemplateDic[monsterId] == nil then
    local tblName = LuaEntry.Player:GetABTestTableName(TableName.Monster)
    local oneTemplate = LocalController:instance():getLine(tblName, monsterId)
    if oneTemplate ~= nil then
      local item = MonsterTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.monsterTemplateDic[item.id] = item
      end
    else
      self.errorId[monsterId] = true
      if not ignoreErrorLog then
        Logger.Log("monsterId not find  => " .. monsterId)
      end
    end
  end
  return self.monsterTemplateDic[monsterId]
end

local function TryGetMonsterTemplate(self, id)
  local monsterId = toInt(id)
  if monsterId == 0 or self.errorId[monsterId] == true then
    return nil
  end
  if self.monsterTemplateDic[monsterId] == nil then
    local tblName = LuaEntry.Player:GetABTestTableName(TableName.Monster)
    local oneTemplate = LocalController:instance():tryGetLine(tblName, monsterId)
    if oneTemplate ~= nil then
      local item = MonsterTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.monsterTemplateDic[item.id] = item
      end
    else
      self.errorId[monsterId] = true
    end
  end
  return self.monsterTemplateDic[monsterId]
end

local function InitAllTemplate(self)
end

local function GetMonsterTableBaseId(self, theType)
  if SeasonUtil.CurServerIsInSeason() then
    local infoList = DataCenter.SeasonDataManager.SpecialServerSeasonInfoList
    if infoList then
      local serverId = LuaEntry.Player:GetCurServerId()
      local data = infoList[toInt(serverId)]
      if data and data.seasonConfigId then
        local seasonConfig = LocalController:instance():getLine(TableName.LW_Season, data.seasonConfigId)
        if seasonConfig.world_monster_boss then
          local baseId = toInt(seasonConfig.world_monster_boss)
          if theType == LWWorldMonsterType.Boss or theType == LWWorldMonsterType.S4Boss then
            if baseId and 1 < baseId then
              return baseId - 1
            end
          elseif theType == LWWorldMonsterType.S4BossBN then
            local monster = self:GetMonsterTemplate(baseId)
            if monster and monster.blood_monster and 1 < monster.blood_monster then
              return monster.blood_monster - 1
            end
          end
        end
        if seasonConfig.world_monster and type(seasonConfig.world_monster) == "string" then
          local baseIds = string.split(seasonConfig.world_monster, "|")
          if #baseIds == 3 then
            local baseId = 0
            if theType == LWWorldMonsterType.ResMetal or theType == LWWorldMonsterType.S4Tank or theType == LWWorldMonsterType.S4TankBN then
              baseId = toInt(baseIds[1])
            elseif theType == LWWorldMonsterType.ResFood or theType == LWWorldMonsterType.S4Airplane or theType == LWWorldMonsterType.S4AirplaneBN then
              baseId = toInt(baseIds[2])
            elseif theType == LWWorldMonsterType.ResGold or theType == LWWorldMonsterType.S4Missile or theType == LWWorldMonsterType.S4MissileBN then
              baseId = toInt(baseIds[3])
            end
            if theType == LWWorldMonsterType.S4TankBN or theType == LWWorldMonsterType.S4AirplaneBN or theType == LWWorldMonsterType.S4MissileBN then
              local monster = self:GetMonsterTemplate(baseId)
              if monster and monster.blood_monster and 1 < monster.blood_monster then
                return monster.blood_monster - 1
              end
            elseif baseId and 1 < baseId then
              return baseId - 1
            end
          elseif #baseIds == 9 then
            local baseId = 0
            local curCamp = SceneUtils.GetCampIdByPointIndex(LuaEntry.Player:GetMainWorldPos(), LuaEntry.Player:GetSelfServerId())
            if theType == LWWorldMonsterType.ResMetal then
              baseId = toInt(baseIds[curCamp * 3 - 2])
            elseif theType == LWWorldMonsterType.ResFood then
              baseId = toInt(baseIds[curCamp * 3 - 1])
            elseif theType == LWWorldMonsterType.ResGold then
              baseId = toInt(baseIds[curCamp * 3])
            end
            if baseId and 1 < baseId then
              return baseId - 1
            end
          end
        end
      end
    end
  end
  return LWWorldMonsterTableIDBase[theType]
end

local function GetMonsterMaxLevel(self)
  if self.maxLevel > 0 then
    return self.maxLevel
  end
  local result = 0
  local season = 0
  if SeasonUtil.IsInSeason() then
    season = DataCenter.SeasonDataManager:GetSeason() or 0
  end
  LocalController:instance():visitTable(LuaEntry.Player:GetABTestTableName(TableName.Monster), function(id, row)
    local m_special = row:getIntValue("special")
    local m_season = row:getIntValue("season")
    local m_level = row:getValue("level")
    if m_special == 0 and m_season == season and m_level > result then
      result = m_level
    end
  end)
  self.maxLevel = result
  return result
end

local function GetMonsterMaxLevelbyType(self, type)
  if self.maxLevelByType[type] ~= nil and self.maxLevelByType[type] > 0 then
    return self.maxLevelByType[type]
  end
  local season = 0
  if SeasonUtil.IsInSeason() then
    season = DataCenter.SeasonDataManager:GetSeason() or 0
  end
  local result = 0
  LocalController:instance():visitTable(LuaEntry.Player:GetABTestTableName(TableName.Monster), function(id, row)
    local m_special = row:getIntValue("special")
    local m_season = row:getIntValue("season")
    local m_level = row:getValue("level")
    local m_type = tonumber(row:getValue("type")) or 0
    if m_type == type and m_special == 0 and m_season == season and self:CheckSeasonAndPassDayConditionWithLineData(row) and m_level > result then
      result = m_level
    end
  end)
  self.maxLevelByType[type] = result
  return result
end

local function GetMonsterMaxLevelATypeByTypeList(self, typeList)
  for i, type in ipairs(typeList) do
    if self.maxLevelByType[type] ~= nil and self.maxLevelByType[type] > 0 then
      return self.maxLevelByType[type], type
    end
  end
  local season = 0
  if SeasonUtil.IsInSeason() then
    season = DataCenter.SeasonDataManager:GetSeason() or 0
  end
  local result = 0
  local checkType
  local types = {}
  for i, v in ipairs(typeList) do
    types[v] = true
  end
  LocalController:instance():visitTable(LuaEntry.Player:GetABTestTableName(TableName.Monster), function(id, row)
    local m_special = row:getIntValue("special")
    local m_season = row:getIntValue("season")
    local m_level = row:getValue("level")
    local m_type = tonumber(row:getValue("type")) or 0
    if (checkType and m_type == checkType or types[m_type]) and m_special == 0 and m_season == season and self:CheckSeasonAndPassDayConditionWithLineData(row) and m_level > result then
      result = m_level
      if checkType == nil then
        checkType = m_type
      end
    end
  end)
  if checkType == nil then
    checkType = typeList[1]
  end
  self.maxLevelByType[checkType] = result
  return result, checkType
end

local function GetMonsterTemplatebyLevelType(self, level, type)
  if LWWorldMonsterTableIDBase[type] == nil then
    return
  end
  local baseId = self:GetMonsterTableBaseId(type)
  local maxLevel = self:GetMonsterMaxLevelbyType(type)
  level = Mathf.Clamp(level or maxLevel, 1, maxLevel)
  return self:GetMonsterTemplate(baseId + level)
end

function MonsterTemplateManager:GetMonsterTemplateBySpecialLevel(level, type, special, forActivity)
  local ret
  local theLevel = math.max(level, 1)
  local season = 0
  if not forActivity and SeasonUtil.IsInSeason() then
    season = DataCenter.SeasonDataManager:GetSeason() or 0
  end
  if not forActivity and self.maxLevelByType[type] ~= nil and 0 < self.maxLevelByType[type] then
    theLevel = math.min(theLevel, self.maxLevelByType[type])
  end
  local cacheLevel = 0
  LocalController:instance():visitTable(LuaEntry.Player:GetABTestTableName(TableName.Monster), function(id, row)
    local m_special = row:getIntValue("special")
    local m_season = row:getIntValue("season")
    local m_level = row:getValue("level")
    local m_type = tonumber(row:getValue("type")) or 0
    if m_type == type and m_special == special and m_season == season then
      if m_level == theLevel then
        ret = row:getValue("id")
        cacheLevel = m_level
      elseif cacheLevel == 0 or m_level > cacheLevel and m_level < theLevel then
        ret = row:getValue("id")
        cacheLevel = m_level
      end
    end
  end)
  if ret ~= nil then
    return self:GetMonsterTemplate(ret)
  end
  return nil
end

function MonsterTemplateManager:GetMaxLevel(theType, theSpecialType, forActivity)
  theType = theType or 0
  theSpecialType = theSpecialType or 0
  local season = 0
  local seasonType = 0
  if not forActivity and SeasonUtil.IsInSeason() then
    season = DataCenter.SeasonDataManager:GetSeason() or 0
    seasonType = SeasonUtil.GetSeasonType()
  end
  local key = theType .. "#" .. theSpecialType .. "#" .. season .. "#" .. seasonType
  if self.cachedMaxLevel == nil then
    self.cachedMaxLevel = {}
  end
  if self.cachedMaxLevel[key] ~= nil and 0 < self.cachedMaxLevel[key] then
    return self.cachedMaxLevel[key]
  end
  if not forActivity and SeasonUtil.IsOpenAttackMonsterByLevel(theType, theSpecialType) then
    return DataCenter.SeasonDataManager:GetMonsterMaxLevel(theType)
  end
  local maxLevel = 0
  LocalController:instance():visitTable(LuaEntry.Player:GetABTestTableName(TableName.Monster), function(id, row)
    local m_special = row:getIntValue("special")
    local m_season = row:getIntValue("season")
    local m_level = row:getValue("level")
    local m_type = tonumber(row:getValue("type")) or 0
    if m_type == theType and m_special == theSpecialType and m_season == season and self:CheckSeasonAndPassDayConditionWithLineData(row) then
      maxLevel = math.max(maxLevel, m_level)
    end
  end)
  self.cachedMaxLevel[key] = maxLevel
  return maxLevel
end

local function CheckSeasonAndPassDayCondition(self, monsterTemplate)
  if not monsterTemplate then
    return true
  end
  local needSeason = monsterTemplate.time_limit_4_season
  local needSeasonPassDay = monsterTemplate.time_limit_4_passDay
  local curSeasonNum = SeasonUtil.GetSeason()
  if needSeason < curSeasonNum then
    return true
  elseif needSeason > curSeasonNum then
    return false
  end
  return needSeasonPassDay <= SeasonUtil.GetSeasonDay()
end

local function CheckSeasonAndPassDayConditionWithLineData(self, row)
  local time_limit_4_season = 0
  local time_limit_4_passDay = 0
  local time_limit_info = row:getValue("time_limit")
  if not string.IsNullOrEmpty(time_limit_info) then
    local time_limit_arr = string.split(time_limit_info, ";")
    if time_limit_arr and 2 <= #time_limit_arr then
      time_limit_4_season = toInt(time_limit_arr[1])
      time_limit_4_passDay = toInt(time_limit_arr[2])
    end
  end
  local needSeason = time_limit_4_season
  local needSeasonPassDay = time_limit_4_passDay
  local curSeasonNum = SeasonUtil.GetSeason()
  if needSeason < curSeasonNum then
    return true
  elseif needSeason > curSeasonNum then
    return false
  end
  return needSeasonPassDay <= SeasonUtil.GetSeasonDay()
end

MonsterTemplateManager.__init = __init
MonsterTemplateManager.__delete = __delete
MonsterTemplateManager.GetMonsterTemplate = GetMonsterTemplate
MonsterTemplateManager.TryGetMonsterTemplate = TryGetMonsterTemplate
MonsterTemplateManager.InitAllTemplate = InitAllTemplate
MonsterTemplateManager.GetMonsterMaxLevel = GetMonsterMaxLevel
MonsterTemplateManager.GetMonsterMaxLevelbyType = GetMonsterMaxLevelbyType
MonsterTemplateManager.GetMonsterTemplatebyLevelType = GetMonsterTemplatebyLevelType
MonsterTemplateManager.GetMonsterTableBaseId = GetMonsterTableBaseId
MonsterTemplateManager.CheckSeasonAndPassDayCondition = CheckSeasonAndPassDayCondition
MonsterTemplateManager.CheckSeasonAndPassDayConditionWithLineData = CheckSeasonAndPassDayConditionWithLineData
MonsterTemplateManager.GetMonsterMaxLevelATypeByTypeList = GetMonsterMaxLevelATypeByTypeList
return MonsterTemplateManager
