local AllianceBossS0TemplateManager = BaseClass("AllianceBossS0TemplateManager")
local AllianceBossS0Template = require("DataCenter.ActS0AllianceBoss.Template.AllianceBossS0Template")

function AllianceBossS0TemplateManager:__init()
  self.bossTemps = nil
  self.bossDifficultyDic = nil
  self.season = nil
  self.seasonDays = nil
  self.maxDifficulty = nil
  self:InitConfig()
end

function AllianceBossS0TemplateManager:__delete()
  self.bossTemps = nil
  self.bossDifficultyDic = nil
  self.season = nil
  self.seasonDays = nil
  self.maxDifficulty = nil
end

function AllianceBossS0TemplateManager:InitConfig()
  self.bossTemps = {}
  self.bossDifficultyDic = {}
  self:InitSeasonData()
  local season, seasonDays = self.season, self.seasonDays
  local maxDifficulty = 0
  LocalController:instance():visitTable(LuaEntry.Player:GetABTestTableName(TableName.ACTIVITY_ALLIANCE_BOSS_S0), function(id, lineData)
    local show_condition = lineData.show_condition
    if show_condition and (show_condition[1] < season or show_condition[1] == season and show_condition[2] <= seasonDays) then
      local item = AllianceBossS0Template.New()
      item:InitConfig(lineData)
      if item.id ~= nil then
        if maxDifficulty < item.difficulty then
          maxDifficulty = item.difficulty
        end
        self.bossTemps[item.id] = item
        self.bossDifficultyDic[item.difficulty] = item.id
      end
    end
  end)
  self.maxDifficulty = maxDifficulty
end

function AllianceBossS0TemplateManager:GetTemplate(id)
  if id == nil then
    Logger.LogError("id is nil")
    return
  end
  if self.bossTemps == nil then
    self:InitConfig()
  end
  if self.bossTemps[id] == nil and 0 < id then
    local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.ACTIVITY_ALLIANCE_BOSS_S0), id)
    if line ~= nil then
      local item = AllianceBossS0Template.New()
      item:InitConfig(line)
      if item.id ~= nil then
        self.bossTemps[item.id] = item
      end
    end
  end
  return self.bossTemps[id]
end

function AllianceBossS0TemplateManager:GetBossDifficultyIds()
  if self.bossDifficultyDic == nil then
    self:InitConfig()
  end
  return self.bossDifficultyDic
end

function AllianceBossS0TemplateManager:GetBossDifficulty(difficulty)
  if difficulty == nil then
    Logger.LogError("difficulty is nil")
    return
  end
  if self.bossDifficultyDic == nil then
    self:InitConfig()
  end
  return self.bossDifficultyDic[difficulty]
end

function AllianceBossS0TemplateManager:CheckShowOpenCondition(season_condition)
  if string.IsNullOrEmpty(season_condition) then
    return true
  end
  local arr = string.split(season_condition, ";")
  if arr and 2 <= #arr then
    local season = arr[1] and tonumber(arr[1]) or 0
    local seasonDays = arr[2] and tonumber(arr[2]) or 0
    return season < self.season or self.season == season and seasonDays <= self:GetSeasonDays()
  end
  return true
end

function AllianceBossS0TemplateManager:InitSeasonData()
  self.season = DataCenter.SeasonDataManager:GetSeason()
  local _, seasonDays = DataCenter.SeasonDataManager:GetNowSeasonAndSeasonDay()
  self.seasonDays = seasonDays
end

function AllianceBossS0TemplateManager:ClearData()
  self.bossDifficultyDic = nil
  self.bossTemps = nil
end

return AllianceBossS0TemplateManager
