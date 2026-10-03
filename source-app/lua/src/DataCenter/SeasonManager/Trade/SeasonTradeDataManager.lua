local SeasonTradeDataManager = BaseClass("SeasonTradeDataManager")
local TradeStationItemData = require("DataCenter.WorldAllianceCityData.TradeStationItemData")
local Localization = CS.GameEntry.Localization
local __ConfigKey = {
  [SeasonMapType.Darkness] = "season_new_s4_station",
  [SeasonMapType.Mummy] = "season_new_s3_station",
  [SeasonMapType.NineNation] = "season_new_s5_station",
  [SeasonMapType.NineNationRainforest] = "season_new_s6_station"
}

function SeasonTradeDataManager:__init()
  self.activityId = nil
  self.tradeStationDataCache = {}
  self.titleList = {
    10005,
    10004,
    10003,
    10002,
    10001
  }
  self.titleListSeason = {}
end

function SeasonTradeDataManager:__delete()
end

function SeasonTradeDataManager:InitData(data)
  self.activityId = data.id
end

function SeasonTradeDataManager:IsActive(includePrepare)
  return SeasonUtil.IsSeasonActivityOpen(self.activityId, SeasonMapType.Mummy, includePrepare)
end

function SeasonTradeDataManager:GetActivityData(includePrepare)
  if not self:IsActive(includePrepare) then
    return
  end
  return DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
end

function SeasonTradeDataManager:GetTitleTemplateByLevel(level)
  local titleList = self:GetTitleList()
  local id = titleList[level]
  return id and DataCenter.PlayerTitleTemplateManager:GetTitleInfo(id)
end

function SeasonTradeDataManager:GetSelfTitle(needRequest)
  local playerInfo = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(LuaEntry.Player.uid)
  local titleId = playerInfo and playerInfo.title
  if titleId == nil or titleId <= 0 then
    return
  end
  local titleList = self:GetTitleList()
  for i, id in ipairs(titleList) do
    if id == titleId then
      return DataCenter.PlayerTitleTemplateManager:GetTitleInfo(id)
    end
  end
end

function SeasonTradeDataManager:GetTitleList()
  if SeasonUtil.IsInSeason() then
    local seasonType = SeasonUtil.GetSeasonType(true, true)
    if self.titleListSeason[seasonType] then
      return self.titleListSeason[seasonType]
    end
    local configKey = __ConfigKey[seasonType]
    local str = configKey and LuaEntry.DataConfig:TryGetStr(configKey, "k8")
    local strList = not string.IsNullOrEmpty(str) and string.split(str, "|")
    if not table.IsNullOrEmpty(strList) then
      local list = {}
      self.titleListSeason[seasonType] = list
      for i, v in ipairs(strList) do
        list[i] = tonumber(v)
      end
      return list
    end
  end
  return self.titleList
end

function SeasonTradeDataManager:GetCurServerTradeStationDic(serverId)
  serverId = serverId or LuaEntry.Player:GetCurServerId()
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  if mySourceServerId ~= serverId then
    local seasonInfo = SeasonUtil.GetSeasonInfo(serverId)
    if seasonInfo and seasonInfo:GetServerSubdivisionType(false) == SeasonMapType.NineNationRainforest and serverId == SeasonUtil.GetCenterServerId(serverId, false) then
      serverId = mySourceServerId
    end
  end
  local cache = self.tradeStationDataCache[serverId]
  if cache == nil then
    cache = {}
    self.tradeStationDataCache[serverId] = cache
  end
  return cache
end

function SeasonTradeDataManager:SetServerTradeStationData(msg)
  if not msg or not msg.worldCityTradeArr then
    return
  end
  local curServerId = LuaEntry.Player:GetCurServerId()
  if SeasonUtil.IsInSeasonNineNationMode(true) or msg.serverId == curServerId then
    local serverCache = self:GetCurServerTradeStationDic(msg.serverId)
    local list = {}
    for j, jV in ipairs(msg.worldCityTradeArr) do
      local tradeId = jV.tradeId
      local data = serverCache[tradeId]
      if data == nil then
        data = TradeStationItemData.New()
        serverCache[tradeId] = data
      end
      data:ParseData(jV)
      list[tradeId] = data
    end
    EventManager:GetInstance():Broadcast(EventId.UpdateAllServerTradeInfo)
    EventManager:GetInstance():Broadcast(EventId.UpdateAllServerTradeInfoWithServer, {
      serverId = msg.serverId,
      list = list
    })
    return
  end
  local list = {}
  for j, jV in ipairs(msg.worldCityTradeArr) do
    local tradeId = jV.tradeId
    local data = TradeStationItemData.New()
    data:ParseData(jV)
    list[tradeId] = data
  end
  EventManager:GetInstance():Broadcast(EventId.UpdateAllServerTradeInfoWithServer, {
    serverId = msg.serverId,
    list = list
  })
end

function SeasonTradeDataManager:GetServerTradeStationData(tradeId, serverId_)
  local cache = self:GetCurServerTradeStationDic(serverId_)
  return cache and cache[tradeId]
end

function SeasonTradeDataManager:GetServerTradeStationLatestData(serverId)
  local curMillisecond = UITimeManager:GetInstance():GetServerTime()
  local cache = self:GetCurServerTradeStationDic(serverId)
  local result
  for k, v in pairs(cache) do
    if curMillisecond >= v.battleStartTime and curMillisecond <= v.battleEndTime then
      result = v
      break
    end
  end
  if result then
    return result
  end
  for k, v in pairs(cache) do
    if curMillisecond < v.battleStartTime and (result == nil or v.battleStartTime < result.battleStartTime) then
      result = v
    end
  end
  if result then
    return result
  end
  for k, v in pairs(cache) do
    if result == nil or v.battleEndTime > result.battleEndTime then
      result = v
    end
  end
  return result
end

function SeasonTradeDataManager:GetTradeDistance(trade)
  local curPos = LuaEntry.Player.world_main_pos
  if curPos and 0 < curPos then
    curPos = SceneUtils.IndexToTilePos(LuaEntry.Player.world_main_pos, ForceChangeScene.World)
    return Vector2.Distance(curPos, trade.pos)
  end
  return 0
end

function SeasonTradeDataManager:GetServerTradeStationLatestList(serverId)
  local curMillisecond = UITimeManager:GetInstance():GetServerTime()
  local cache = self:GetCurServerTradeStationDic(serverId)
  local result1 = {}
  for k, v in pairs(cache) do
    if curMillisecond >= v.battleStartTime and curMillisecond <= v.battleEndTime then
      local last = result1[v.level]
      if last == nil or self:GetTradeDistance(v) < self:GetTradeDistance(last) then
        result1[v.level] = v
      end
    end
  end
  local result2 = {}
  for k, v in pairs(cache) do
    if curMillisecond < v.battleStartTime then
      local last = result2[v.level]
      if last == nil or v.battleStartTime < last.battleStartTime or self:GetTradeDistance(v) < self:GetTradeDistance(last) then
        result2[v.level] = v
      end
    end
  end
  local result3 = {}
  for k, v in pairs(cache) do
    local last = result3[v.level]
    if last == nil or v.battleEndTime > last.battleEndTime or self:GetTradeDistance(v) < self:GetTradeDistance(last) then
      result3[v.level] = v
    end
  end
  local result = {}
  for k, v in pairs(result1) do
    result[k] = v
  end
  for k, v in pairs(result2) do
    if result[k] == nil then
      result[k] = v
    end
  end
  for k, v in pairs(result3) do
    if result[k] == nil then
      result[k] = v
    end
  end
  local sortList = {}
  for k, v in pairs(result) do
    table.insert(sortList, v)
  end
  table.sort(sortList, function(a, b)
    return a.level < b.level
  end)
  return sortList
end

function SeasonTradeDataManager:GetTradeStationOpenTime(level, serverId)
  local curMillisecond = UITimeManager:GetInstance():GetServerTime()
  local cache = self:GetCurServerTradeStationDic(serverId)
  for k, v in pairs(cache) do
    if v.level == level and curMillisecond < v.battleStartTime then
      return v.battleStartTime
    end
  end
end

function SeasonTradeDataManager:GetTradeStationDataByState(state, serverId)
  local cache = self:GetCurServerTradeStationDic(serverId)
  for k, v in pairs(cache) do
    if v:GetTimeState() == state then
      return v
    end
  end
end

function SeasonTradeDataManager:GetTodayBattleTradeStation(serverId)
  serverId = serverId or LuaEntry.Player:GetCurServerId()
  local todayZero = UITimeManager:GetInstance():GetTodayZero()
  local endOfToday = UITimeManager:GetInstance():GetTomorrowZero()
  local cache = self:GetCurServerTradeStationDic(serverId)
  local result
  for k, v in pairs(cache) do
    if todayZero <= v.battleStartTime and endOfToday >= v.battleStartTime then
      result = v
      break
    end
  end
  return result
end

function SeasonTradeDataManager:GetShowBuffData()
  local effectId = 0
  local effectVelue = 0
  if 0 < LuaEntry.Effect:GetGameEffect(EffectDefine.TradeOfficial_5) then
    effectId = EffectDefine.TradeOfficial_5
    effectVelue = LuaEntry.Effect:GetGameEffect(EffectDefine.TradeOfficial_5)
  elseif 0 < LuaEntry.Effect:GetGameEffect(EffectDefine.TradeOfficial_4) then
    effectId = EffectDefine.TradeOfficial_4
    effectVelue = LuaEntry.Effect:GetGameEffect(EffectDefine.TradeOfficial_4)
  elseif 0 < LuaEntry.Effect:GetGameEffect(EffectDefine.TradeOfficial_3) then
    effectId = EffectDefine.TradeOfficial_3
    effectVelue = LuaEntry.Effect:GetGameEffect(EffectDefine.TradeOfficial_3)
  elseif 0 < LuaEntry.Effect:GetGameEffect(EffectDefine.TradeOfficial_2) then
    effectId = EffectDefine.TradeOfficial_2
    effectVelue = LuaEntry.Effect:GetGameEffect(EffectDefine.TradeOfficial_2)
  elseif 0 < LuaEntry.Effect:GetGameEffect(EffectDefine.TradeOfficial_1) then
    effectId = EffectDefine.TradeOfficial_1
    effectVelue = LuaEntry.Effect:GetGameEffect(EffectDefine.TradeOfficial_1)
  end
  if 0 < effectId then
    local buffViewData = {}
    local effectLine = LocalController:instance():getLine(TableName.LW_Effect_Number, effectId)
    buffViewData.icon = effectLine.icon
    buffViewData.name = Localization:GetString(effectLine.name)
    buffViewData.desc = Localization:GetString(effectLine.desc)
    buffViewData.effectId = effectId
    buffViewData.effectValue = effectVelue
    buffViewData.nameKey = effectLine.name
    buffViewData.descKey = effectLine.desc
    return buffViewData
  end
end

function SeasonTradeDataManager:GotoTradeStationShop(serverId)
  local result, nearestDis
  local curPos = LuaEntry.Player.world_main_pos
  if curPos and 0 < curPos then
    curPos = SceneUtils.IndexToTilePos(LuaEntry.Player.world_main_pos, ForceChangeScene.World)
    local cache = self:GetCurServerTradeStationDic(serverId)
    for k, v in pairs(cache) do
      if v:GetShopState() == 1 then
        local dis = Vector2.Distance(curPos, v.pos)
        if nearestDis == nil or nearestDis > dis then
          nearestDis = dis
          result = v
        end
      end
    end
  end
  self:GotoTradeStation(result)
end

function SeasonTradeDataManager:GotoTradeStation(target)
  if target then
    SceneUtils.ChangeToWorld(function()
      local serverId = target.serverId or LuaEntry.Player:GetCurServerId()
      local worldPos = SceneUtils.TileToWorld(target.pos, ForceChangeScene.World, serverId)
      
      local function onComplete()
        WorldArrowManager:GetInstance():ShowArrowEffect(0, worldPos)
      end
      
      GoToUtil.GotoPos(worldPos, nil, nil, onComplete, serverId)
      GoToUtil.CloseAllWindows()
    end)
    return
  end
  UIUtil.ShowTipsId("season_s3_trading_post_desc11")
end

function SeasonTradeDataManager:ChangeSkin(mgr, isCur)
  mgr:SetAsync(true)
  if isCur then
    local seasonType = SeasonUtil.CurServerTypeInSeason(true)
    if seasonType == SeasonMapType.Darkness and DataCenter.BloodyNightDataManager:IsBloodyNight(LuaEntry.Player:GetCurServerId()) then
      mgr:ActiveSkin(SeasonMapType.Nothing)
      return
    end
    mgr:ActiveSkin(seasonType)
    return
  end
  local seasonType = SeasonUtil.GetSeasonType(nil, true)
  if seasonType == SeasonMapType.Darkness and DataCenter.BloodyNightDataManager:IsBloodyNight() then
    mgr:ActiveSkin(SeasonMapType.Nothing)
    return
  end
  mgr:ActiveSkin(seasonType)
end

return SeasonTradeDataManager
