local WestwardExpansionDataManager = BaseClass("WestwardExpansionDataManager")

function WestwardExpansionDataManager:__init()
  self:Init()
end

function WestwardExpansionDataManager:__delete()
  self:Destroy()
end

function WestwardExpansionDataManager:Destroy()
  self.rankData = nil
  self.stageTemplateList = nil
  self.monsterSearchState = nil
end

function WestwardExpansionDataManager:Init()
  self.stageTemplateList = {}
  local activityData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.WestwardExpansion.Type)
  if not activityData then
    return
  end
  local stageCfgIds = string.split(activityData.para_1, ";")
  local seasonStartTime = activityData.startTime
  for _, id in pairs(stageCfgIds) do
    local cfg = LocalController:instance():getLine(TableName.Activity_Monster_Stage, id)
    if cfg then
      local startTime = seasonStartTime + (cfg:getValue("start_time", 1) - 1) * 24 * 60 * 60 * 1000
      local endTime = startTime + cfg:getValue("duration", 7) * 24 * 60 * 60 * 1000
      local stageTemp = {
        id = id,
        startTime = startTime,
        endTime = endTime,
        rank = cfg:getValue("rank"),
        stage_icon = cfg:getValue("stage_icon"),
        stage_name = cfg:getValue("stage_name"),
        stage_desc = cfg:getValue("stage_desc"),
        world_monster_level = cfg:getValue("world_monster_level")
      }
      table.insert(self.stageTemplateList, stageTemp)
    end
  end
  table.sort(self.stageTemplateList, function(a, b)
    return a.startTime < b.startTime
  end)
  for k, v in ipairs(self.stageTemplateList) do
    v.stage = k
    if self.stageTemplateList[k + 1] then
      v.nextTime = self.stageTemplateList[k + 1].startTime
    end
  end
end

function WestwardExpansionDataManager:GetStageTemplate()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for _, stageTemp in pairs(self.stageTemplateList) do
    if stageTemp.nextTime and curTime >= stageTemp.startTime and curTime < stageTemp.nextTime then
      return stageTemp, self.stageTemplateList
    end
  end
  return self.stageTemplateList[#self.stageTemplateList], self.stageTemplateList
end

function WestwardExpansionDataManager:GetStageRankId()
  local curStageConfig = self:GetStageTemplate()
  if not curStageConfig then
    return nil
  end
  return toInt(curStageConfig.rank)
end

function WestwardExpansionDataManager:GetStageRankCfgIdList()
  local curStageConfig = self:GetStageTemplate()
  if not curStageConfig then
    return {}
  end
  return {
    [1] = toInt(curStageConfig.rank)
  }
end

function WestwardExpansionDataManager:FetchRankData(isShort)
  local activityData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.WestwardExpansion.Type)
  if not activityData then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.LwSeasonNewWastelandInfo, toInt(activityData.id), isShort)
end

function WestwardExpansionDataManager:HandleRankMessage(msg)
  if msg then
    self.rankData = msg
    EventManager:GetInstance():Broadcast(EventId.WestwardExpansionRankRefresh)
  end
end

function WestwardExpansionDataManager:GetRankData()
  return self.rankData
end

function WestwardExpansionDataManager:GetMonsterSearchState()
  local states = {
    [1] = 3,
    [2] = 3,
    [3] = 3
  }
  local seasonInfo = DataCenter.SeasonDataManager:GetServerSeasonInfo()
  if not seasonInfo then
    Logger.LogError("\231\153\187\229\189\149\230\156\141\232\181\155\229\173\163\230\149\176\230\141\174 GetMonsterSearchState seasonInfo is nil")
    return states
  end
  local seasonConfig = seasonInfo:GetCurrentSeasonConfig()
  local search_monster_unlock = seasonConfig and seasonConfig.search_monster_unlock
  if string.IsNullOrEmpty(search_monster_unlock) then
    if seasonConfig and seasonConfig.id then
      Logger.LogError("S5\229\176\143\230\128\170\232\167\163\233\148\129\230\151\182\233\151\180\233\133\141\231\189\174\233\148\153\232\175\175,seasonId:" .. seasonConfig.id)
    end
    search_monster_unlock = "1;60|8;90|15;120"
  end
  search_monster_unlock = string.split(search_monster_unlock, "|")
  local startTime = seasonInfo:GetSeasonStartTime()
  local now = UITimeManager:GetInstance():GetServerTime()
  local serverId = LuaEntry.Player:GetSelfServerId()
  local pointId = LuaEntry.Player:GetMainWorldPos()
  local cityMeta = SceneUtils.GetCityMetaByPointIndex(pointId, serverId)
  local nextTime
  local recommendGroup = 1
  local levelGroup = {
    [1] = {min = 1, max = 30},
    [2] = {min = 31, max = 60},
    [3] = {min = 61, max = 90}
  }
  local unlockTime = {}
  for i = 1, 3 do
    local unlock = string.split(search_monster_unlock[i], ";")
    local level = tonumber(unlock[2])
    if i == 1 then
      levelGroup[i] = {min = 1, max = level}
    else
      levelGroup[i] = {
        min = levelGroup[i - 1].max + 1,
        max = level
      }
    end
    local configUnlockTime = startTime + (tonumber(unlock[1]) - 1) * 24 * 60 * 60 * 1000
    if now < configUnlockTime then
      states[i] = 1
      if nextTime == nil then
        nextTime = configUnlockTime
      end
      unlockTime[i] = configUnlockTime
    else
      states[i] = 2
      local city_level = LuaEntry.DataConfig:TryGetStr("monster_refresh_map", "k" .. i)
      city_level = string.split(city_level, "|")
      for k, v in pairs(city_level) do
        local pair = string.split(v, ";")
        if cityMeta.type == toInt(pair[1]) then
          local lv = string.split(pair[2], "-")
          if cityMeta.level >= toInt(lv[1]) and cityMeta.level <= toInt(lv[2]) then
            states[i] = 3
            recommendGroup = i
            break
          end
        end
      end
    end
  end
  return states, nextTime, recommendGroup, levelGroup, unlockTime
end

return WestwardExpansionDataManager
