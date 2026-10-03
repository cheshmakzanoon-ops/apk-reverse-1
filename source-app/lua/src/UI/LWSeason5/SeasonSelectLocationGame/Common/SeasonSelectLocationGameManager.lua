local rapidjson = require("rapidjson")
local SeasonTetrisManager = require("DataCenter/SeasonTetris/SeasonTetrisManager")
local SeasonSelectLocationGameManager = BaseClass("SeasonSelectLocationGameManager")

function SeasonSelectLocationGameManager:__init()
  self:InitVars()
end

function SeasonSelectLocationGameManager:__delete()
end

function SeasonSelectLocationGameManager:InitVars()
  self.RankType = {
    Total = 0,
    Server = 1,
    SingleServer = 2
  }
  self.WaitingGetRank = {}
  self.CacheRankData = {}
end

function SeasonSelectLocationGameManager:GetCurActDay()
  local actData = DataCenter.SeasonTetrisManager:GetActData()
  if actData ~= nil then
    local now = UITimeManager:GetInstance():GetServerTime()
    return math.floor((now - actData.startTime) / 86400 / 1000)
  end
  return 0
end

function SeasonSelectLocationGameManager:GetLeftTimes()
  local cur = DataCenter.SeasonTetrisManager:GetCurLevelIndex()
  local total = DataCenter.SeasonTetrisManager:GetTotalLevelCountToday()
  return math.max(0, total - cur + 1)
end

function SeasonSelectLocationGameManager:ShowClaimDailyReward()
  local actCell = DataCenter.SeasonTetrisManager:GetActCell()
  if actCell ~= nil then
    local shouldShowLevel = 1
    local curLevel = DataCenter.SeasonTetrisManager:GetCurLevelIndex()
    if shouldShowLevel + 1 == curLevel then
      return true
    end
  end
  return false
end

function SeasonSelectLocationGameManager:GetTodayRewardId()
  local gameCell = DataCenter.SeasonTetrisManager:GetCurLevelCell()
  if gameCell ~= nil then
    return gameCell.reward
  end
  return 0
end

function SeasonSelectLocationGameManager:IsInGame()
  local gameData = DataCenter.SeasonTetrisManager.GameData
  if gameData ~= nil then
    local isStart = checknumber(gameData.StartTime) > 0
    local isFail = checknumber(gameData.IsFail) == 1
    local isGiveUp = self:IsManualQuit()
    return isStart and not isFail and not isGiveUp
  end
  return false
end

function SeasonSelectLocationGameManager:IsManualQuit()
  local gameData = DataCenter.SeasonTetrisManager.GameData
  if gameData ~= nil then
    return CommonUtil.PlayerPrefsGetLong("TETRIS_GAME_MANUAL_QUIT", 0) == checknumber(gameData.StartTime)
  end
  return false
end

function SeasonSelectLocationGameManager:GetRankData(rankType, serverId)
  local key = self:GetRankCacheKey(rankType, serverId)
  return self:GetRankDataByKey(key)
end

function SeasonSelectLocationGameManager:GetRankDataByKey(key)
  if key ~= nil then
    return self.CacheRankData[key]
  end
  return nil
end

function SeasonSelectLocationGameManager:ClearCacheRankData(excludeKey)
  self.WaitingGetRank = {}
  if excludeKey ~= nil then
    for key, _ in pairs(self.CacheRankData) do
      if key ~= excludeKey then
        self.CacheRankData[key] = nil
      end
    end
  else
    self.CacheRankData = {}
  end
end

function SeasonSelectLocationGameManager:GetRankCacheKey(rankType, serverId)
  return string.format("%s_%s", checknumber(rankType), checknumber(serverId))
end

function SeasonSelectLocationGameManager:SendGetRank(rankType, serverId)
  local key = self:GetRankCacheKey(rankType, serverId)
  if key ~= nil and not self.WaitingGetRank[key] then
    self.WaitingGetRank[key] = true
    local param = {}
    param.rankType = rankType
    param.serverId = checknumber(serverId)
    SFSNetwork.SendMessage(MsgDefines.ActivityTetrisSidposRanklist, param)
  end
end

function SeasonSelectLocationGameManager:OnGetRankCallback(res)
  if res == nil then
    return
  end
  local key = self:HandleRankPayload(res)
  self.WaitingGetRank[key] = false
  EventManager:GetInstance():Broadcast(EventId.SeasonSelectLocationGameRankUpdate, key)
end

function SeasonSelectLocationGameManager:HandleRankPayload(res)
  local rankType = res.rankType
  local serverId = res.serverId
  local key = self:GetRankCacheKey(rankType, serverId)
  if rankType == self.RankType.Server then
    table.sort(res.servers, function(a, b)
      return a < b
    end)
    local servers = res.servers
    for _, sid in ipairs(servers) do
      local found = false
      for _, rankData in pairs(res.rankList) do
        if rankData.sid == sid then
          found = true
          break
        end
      end
      if not found then
        local slot = {}
        slot.score = 0
        slot.rank = 0
        slot.sid = sid
        table.insert(res.rankList, slot)
      end
    end
    table.sort(res.rankList, function(a, b)
      if a.rank == b.rank then
        return a.sid < b.sid
      end
      if a.rank == 0 or b.rank == 0 then
        return a.rank > b.rank
      end
      return a.rank < b.rank
    end)
    self.CacheRankData[key] = res
  elseif rankType == self.RankType.Total then
    self.CacheRankData[key] = res
  elseif rankType == self.RankType.SingleServer then
    self.CacheRankData[key] = res
  end
  return key
end

return SeasonSelectLocationGameManager
