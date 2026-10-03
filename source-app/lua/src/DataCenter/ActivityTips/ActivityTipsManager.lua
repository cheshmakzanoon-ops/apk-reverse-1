local ActivityTipsManager = BaseClass("ActivityTipsManager")
local Localization = CS.GameEntry.Localization
local ActivityTipsMeta = require("DataCenter.ActivityTips.ActivityTipsMeta")

local function Compare(a, b)
  if a.priority ~= b.priority then
    return a.priority > b.priority
  elseif a.activity_type ~= b.activity_type then
    return a.activity_type > b.activity_type
  end
  return a.id > b.id
end

function ActivityTipsManager:__init()
  self:Init()
  EventManager:GetInstance():AddListener(EventId.OnPassDay, self.OnPassDay)
end

function ActivityTipsManager:__delete()
  EventManager:GetInstance():RemoveListener(EventId.OnPassDay, self.OnPassDay)
  self:Destroy()
end

function ActivityTipsManager:Destroy()
  self.allMeta = nil
  self.customMeta = nil
  self.type2MetaList = nil
  self.queue = nil
  self.activityType2Meta = nil
  self.order2type = nil
  self.historyId2type = nil
  self.historyTypes = nil
  self.historyLogin = nil
end

function ActivityTipsManager:Init()
  self.queue = {}
  self.type2MetaList = {}
  self.activityType2Meta = {}
  self.allMeta = {}
  self.customMeta = {}
  self.order2type = LuaEntry.DataConfig:TryGetStr("actvity_tips_type_display_priority", "k1", "6,2,5,3,4,1")
  self.order2type = string.split(self.order2type, ",")
  for i = 1, #self.order2type do
    self.order2type[i] = tonumber(self.order2type[i])
  end
  local seasonNum = SeasonUtil.GetSeason()
  local seasonDay = SeasonUtil.GetSeasonDay()
  LocalController:instance():visitTable(TableName.LW_Activity_Tips, function(id, lineData)
    if lineData ~= nil then
      local close_time = lineData.close_time
      if not string.IsNullOrEmpty(lineData.close_time) then
        close_time = string.split(close_time, ";")
        if #close_time == 2 then
          local closeSeasonNum = tonumber(close_time[1])
          local closeSeasonDay = tonumber(close_time[2])
          if closeSeasonNum < seasonNum or closeSeasonNum == seasonNum and closeSeasonDay <= seasonDay then
            return
          end
        end
      end
      local type = tonumber(lineData.type)
      if not self.type2MetaList[type] then
        self.type2MetaList[type] = {}
        if 6 < type then
          table.insert(self.order2type, 1, type)
        end
      end
      local meta = ActivityTipsMeta.New()
      meta:InitConfig(lineData)
      table.insert(self.allMeta, meta)
      table.insert(self.type2MetaList[type], meta)
      if meta.condition < MainUITipCondition.Custom then
        self.activityType2Meta[meta.activity_type] = meta
      else
        self.customMeta[meta.condition] = meta
      end
    end
  end)
  for _, v in pairs(self.type2MetaList) do
    table.sort(v, Compare)
  end
  table.sort(self.allMeta, Compare)
end

function ActivityTipsManager:LoadHistory()
  self.historyId2type = CommonUtil.PlayerPrefsGetTable("ACTIVITY_TIPS_HISTORY", {})
  self.historyTypes = {}
  for _, v in pairs(self.historyId2type) do
    self.historyTypes[v] = true
  end
  self.historyLogin = {}
end

function ActivityTipsManager:OnEnterGame()
  TimerManager:GetInstance():DelayInvoke(function()
    DataCenter.ActivityTipsManager:LoadHistory()
    DataCenter.ActivityTipsManager:CheckAllMeta()
    DataCenter.ActivityTipsManager.isLoadComplete = true
  end, 2)
end

function ActivityTipsManager:OnPassDay()
  if DataCenter.ActivityTipsManager.isLoadComplete then
    DataCenter.ActivityTipsManager:CheckAllMeta()
  end
end

function ActivityTipsManager:OnMainUIRefresh()
  if DataCenter.ActivityTipsManager.isLoadComplete then
    DataCenter.ActivityTipsManager:CheckAllCustomMeta()
  end
end

function ActivityTipsManager:CheckAllMeta()
  local todayZero = UITimeManager:GetInstance():TodayZero()
  local ignoreDict = {}
  for i = 1, #self.order2type do
    local curType = self.order2type[i]
    local metaList = self.type2MetaList[curType]
    if metaList and 0 < #metaList then
      for j = 1, #metaList do
        local meta = self.type2MetaList[curType][j]
        ignoreDict[meta.id] = true
        if self:CheckAndPrepare(meta, todayZero) then
          table.insert(self.queue, meta)
          break
        end
      end
    end
  end
  for i = 1, #self.allMeta do
    local meta = self.allMeta[i]
    if not ignoreDict[meta.id] and self:CheckAndPrepare(meta, todayZero) then
      table.insert(self.queue, meta)
    end
  end
  if self.queue[1] then
    EventManager:GetInstance():Broadcast(EventId.OnMainUITipsQueueCreate)
  end
end

function ActivityTipsManager:CheckAllCustomMeta()
  self:CheckOneCustomMeta(MainUITipCondition.ActDragon1)
  self:CheckOneCustomMeta(MainUITipCondition.ActDragon2)
  self:CheckOneCustomMeta(MainUITipCondition.StrongCmd1)
  self:CheckOneCustomMeta(MainUITipCondition.StrongCmd2)
  self:CheckOneCustomMeta(MainUITipCondition.AccountBindTip)
  self:CheckOneCustomMeta(MainUITipCondition.SeasonNuclearActivityMonster)
  self:CheckOneCustomMeta(MainUITipCondition.SeasonNuclearActivityNonFinish)
  self:CheckOneCustomMeta(MainUITipCondition.ActMigrationOpen)
  self:CheckOneCustomMeta(MainUITipCondition.ActQueenOfBlood)
end

function ActivityTipsManager:CheckOneCustomMeta(condition)
  if not condition then
    return
  end
  local meta = self.customMeta[condition]
  if not meta then
    return
  end
  for i = 1, #self.queue do
    if self.queue[i].id == meta.id then
      return
    end
  end
  if self:CheckNeedShowCustom(meta) then
    table.insert(self.queue, meta)
  end
end

function ActivityTipsManager:GetNext()
  if #self.queue == 0 then
    return nil
  end
  local queueLength = #self.queue
  for i = 1, queueLength do
    local next = self.queue[1]
    if self:CheckAndPrepare(next) then
      return next
    else
      table.remove(self.queue, 1)
    end
  end
  return nil
end

function ActivityTipsManager:Dequeue()
  if self.queue[1] then
    table.remove(self.queue, 1)
  end
end

function ActivityTipsManager:Enqueue(condition, fakeMeta)
  if not DataCenter.ActivityTipsManager.isLoadComplete then
    return
  end
  if not condition then
    return
  end
  local meta = fakeMeta or self.customMeta[condition]
  if not meta then
    return
  end
  for i = 1, #self.queue do
    if self.queue[i].id == meta.id then
      return
    end
  end
  table.insert(self.queue, meta)
  EventManager:GetInstance():Broadcast(EventId.OnMainUITipsQueueCreate)
end

function ActivityTipsManager:CheckAndPrepare(meta, todayZero)
  local checkNeedShow = self:CheckNeedShow(meta, todayZero)
  if checkNeedShow and meta.tips_value == 1 then
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(meta.activity_type)
    if dataList ~= nil and 0 < #dataList then
      local activityData = dataList[1]
      local tipTxt = Localization:GetString(meta.tips, Localization:GetString(activityData.name))
      meta:SetTipsContent(tipTxt)
    end
  end
  return checkNeedShow
end

function ActivityTipsManager:CheckNeedShow(meta, todayZero)
  if meta.condition == MainUITipCondition.ActivityId then
    local actId = DataCenter.ActivityListDataManager:GetOpenIdByTypeAndEnterType(meta.activity_type, meta.type)
    if actId and not self.historyId2type[actId] then
      return true
    end
  elseif meta.condition == MainUITipCondition.ActivityType then
    if not self.historyTypes[meta.activity_type] and DataCenter.ActivityListDataManager:CheckIfActivityOpen(meta.activity_type) then
      return true
    end
  elseif meta.condition == MainUITipCondition.Daily then
    local actId = DataCenter.ActivityListDataManager:GetOpenIdByTypeAndEnterType(meta.activity_type, meta.type)
    if actId then
      local prefKey = "LAST_OPEN_TIMESTAMP_" .. actId
      local lastOpenTime = CommonUtil.PlayerPrefsGetLong(prefKey, 0)
      todayZero = todayZero or UITimeManager:GetInstance():TodayZero()
      return lastOpenTime < todayZero
    end
  elseif meta.condition == MainUITipCondition.Login then
    if DataCenter.ActivityListDataManager:CheckIfActivityOpen(meta.activity_type) and not self.historyLogin[meta.id] then
      if meta.activity_type == EnumActivity.WorldBoss.Type then
        local need = DataCenter.ActBossDataManager:IsNeedMainUIShowTip()
        if need and DataCenter.ActBossDataManager.activityId ~= nil then
          local tipTxt = Localization:GetString(meta.tips, DataCenter.ActBossDataManager.bossName)
          meta:SetTipsContent(tipTxt)
          return true
        else
          return false
        end
      end
      return true
    end
  elseif meta.condition == MainUITipCondition.ActivityOpen then
    if (meta.activity_type == EnumActivity.ActDragon.Type or meta.activity_type == EnumActivity.ActWinterStorm.Type) and not RaceEntranceUtil.IsOldEntranceOpen() then
      return
    end
    if meta.activity_type == EnumActivity.BattlePass.Type or meta.activity_type == EnumActivity.BattlePass_new.Type then
      local actIds = DataCenter.ActivityListDataManager:GetAllOpenIdsByType(meta.activity_type)
      for _, id in pairs(actIds) do
        local isNew = DataCenter.ActivityListDataManager:IsActivityNew(id)
        if isNew then
          return true
        end
      end
    else
      local actId = DataCenter.ActivityListDataManager:GetOpenIdByTypeAndEnterType(meta.activity_type, meta.type)
      if actId then
        return DataCenter.ActivityListDataManager:IsActivityNew(actId)
      end
    end
  elseif meta.type == MainUITipType.Season then
    return self:CheckNeedShowSeason(meta, todayZero)
  else
    return self:CheckNeedShowCustom(meta, todayZero)
  end
end

function ActivityTipsManager:CheckNeedShowSeason(meta, todayZero)
  if meta == nil or meta.activity_type == nil or meta.activity_type == 0 or not SeasonUtil.IsInSeason() then
    return false
  end
  local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(meta.activity_type)
  local actInfo = actList and actList[1] or nil
  if actInfo == nil or actInfo.id == nil or not actInfo:IsValid() then
    return false
  end
  local theSeasonStartTime = DataCenter.SeasonDataManager:GetSeasonStartTime()
  if meta.condition == MainUITipCondition.SeasonCityOccupy_Declare then
    if not LuaEntry.Player:IsInAlliance() then
      return false
    end
    local state, declareInfo = DataCenter.AllianceDeclareWarManager:GetDeclareState()
    if state == DeclareWarState.Formal and declareInfo and declareInfo.content then
      local cityId = toInt(declareInfo.content)
      local cnt = UIUtil.GetActiveCount(theSeasonStartTime, "SeasonCityOccupy_Declare" .. cityId, false)
      return 0 < cityId and cnt == 0
    end
  elseif meta.condition == MainUITipCondition.SeasonCityOccupy_CityOpen then
    if not LuaEntry.Player:IsInAlliance() then
      return false
    end
    local cityWarInfo = DataCenter.WorldAllianceCityDataManager.theCityWarInfo
    if cityWarInfo ~= nil and cityWarInfo.nextOpen ~= nil then
      local openLevel = toInt(cityWarInfo.nextOpen.level or 7) - 1
      local cnt = UIUtil.GetActiveCount(theSeasonStartTime, "SeasonCityOccupy_CityOpen" .. openLevel, false)
      return 0 < openLevel and openLevel < 7 and cnt == 0
    end
  elseif meta.condition == MainUITipCondition.SeasonBlackKnight then
    if not LuaEntry.Player:IsInAlliance() then
      return false
    end
    local cnt = UIUtil.GetTodayActiveCount("SeasonBlackKnight", false)
    return cnt == 0 and DataCenter.CounterAttackDataManager:GetStage() == CounterAttackStage.Attack and DataCenter.CounterAttackDataManager:GetState() == 1
  elseif meta.condition == MainUITipCondition.SeasonCrossAttackCity_Open then
    if not LuaEntry.Player:IsInAlliance() then
      return false
    end
    local cnt = UIUtil.GetActiveCount(theSeasonStartTime, "SeasonCrossAttackCity_Open", false)
    return cnt == 0
  elseif meta.condition == MainUITipCondition.SeasonCrossAttackCity_HasBuild then
    if not LuaEntry.Player:IsInAlliance() then
      return false
    end
    local dataList = DataCenter.SeasonDataManager.ActCrossAttackDesertInfo
    if dataList then
      for i, v in ipairs(dataList) do
        local buildId = toInt(v.buildingId)
        if v.hasCreate == 1 and 0 < buildId then
          local cnt = UIUtil.GetActiveCount(theSeasonStartTime, "SeasonCrossAttackCity_HasBuild" .. buildId, false)
          if cnt == 0 then
            return true
          end
        end
      end
    elseif meta.requestActivityDataCount == 0 then
      meta.requestActivityDataCount = 1
      SFSNetwork.SendMessage(MsgDefines.SeasonCrossAttackCityInfo)
    end
  elseif meta.condition == MainUITipCondition.SeasonCrossAttackCity_CanPutBuild then
    if not LuaEntry.Player:IsInAlliance() then
      return false
    end
    if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
      return false
    end
    local dataList = DataCenter.SeasonDataManager.ActCrossAttackDesertInfo
    if dataList then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      for i, v in ipairs(dataList) do
        local buildId = toInt(v.buildingId)
        if v.hasCreate == 0 and 0 < buildId and v.openTime and curTime > v.openTime then
          local cnt = UIUtil.GetActiveCount(theSeasonStartTime, "SeasonCrossAttackCity_CanPutBuild" .. buildId, false)
          if cnt == 0 then
            return true
          end
        end
      end
    elseif meta.requestActivityDataCount == 0 then
      meta.requestActivityDataCount = 1
      SFSNetwork.SendMessage(MsgDefines.SeasonCrossAttackCityInfo)
    end
  elseif meta.condition == MainUITipCondition.SeasonCrossDeclareWar_MyDeclare then
    if not LuaEntry.Player:IsInAlliance() then
      return false
    end
    local data = DataCenter.SeasonDataManager.CrossDeclareWarInfo
    if data then
      if data.declareList then
        for _, v in ipairs(data.declareList) do
          if v.result == 0 then
            local cnt = UIUtil.GetTodayActiveCount("SeasonCrossDeclareWar_MyDeclare" .. v.cityId, false)
            if cnt == 0 then
              return true
            end
          end
        end
      end
    elseif meta.requestActivityDataCount == 0 then
      meta.requestActivityDataCount = 1
      SFSNetwork.SendMessage(MsgDefines.GetCrossDeclareWarInfo)
    end
  elseif meta.condition == MainUITipCondition.SeasonCrossDeclareWar_BeDeclare then
    if not LuaEntry.Player:IsInAlliance() then
      return false
    end
    local data = DataCenter.SeasonDataManager.CrossDeclareWarInfo
    if data then
      if data.beDeclareList then
        for _, v in ipairs(data.beDeclareList) do
          if v.result == 0 then
            local cnt = UIUtil.GetTodayActiveCount("SeasonCrossDeclareWar_BeDeclare" .. v.cityId, false)
            if cnt == 0 then
              return true
            end
          end
        end
      end
    elseif meta.requestActivityDataCount == 0 then
      meta.requestActivityDataCount = 1
      SFSNetwork.SendMessage(MsgDefines.GetCrossDeclareWarInfo)
    end
  elseif meta.condition == MainUITipCondition.SeasonFactionSelection_Open then
    local cnt = UIUtil.GetActiveCount(theSeasonStartTime, "SeasonFactionSelection_Open", false)
    if cnt == 0 then
      return true
    end
  elseif meta.condition == MainUITipCondition.SeasonFactionSelection_Shown then
    local cnt = UIUtil.GetActiveCount(theSeasonStartTime, "SeasonFactionSelection_Shown", false)
    if cnt == 0 and DataCenter.SeasonFactionWarDataManager:IsGroupingShownMode() then
      return true
    end
  elseif meta.condition == MainUITipCondition.SeasonFactionSelection_Move then
    local cnt = UIUtil.GetTodayActiveCount("SeasonFactionSelection_Move", false)
    if cnt ~= 0 then
      return false
    end
    if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
      return false
    end
    if not LuaEntry.Player:IsPresident(LuaEntry.Player:GetSourceServerId()) then
      return false
    end
    local factionMgr = DataCenter.SeasonFactionWarDataManager
    local myCampId = toInt(Setting:GetPrivateInt("SelectSeasonFaction", -1))
    if not factionMgr:IsGroupingShownMode() and 0 < toInt(factionMgr.myCampId) and 0 < myCampId and myCampId ~= toInt(factionMgr.myCampId) then
      return true
    end
  elseif meta.condition == MainUITipCondition.SeasonFactionDeclareWar_Declare then
    local cnt = UIUtil.GetTodayActiveCount("SeasonFactionDeclareWar_Declare", false)
    if cnt ~= 0 then
      return false
    end
    if not LuaEntry.Player:IsInAlliance() then
      return false
    end
    if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
      return false
    end
    if DataCenter.SeasonFactionWarDataManager:GetCurrStep() ~= SeasonFactionDeclareWarStep.declare then
      return false
    end
    local myAllianceId = LuaEntry.Player:GetAllianceUid()
    local myCampId = DataCenter.SeasonFactionWarDataManager.myCampId
    local attackCampId = DataCenter.SeasonFactionWarDataManager.attackCampId
    local targetAllianceId = DataCenter.SeasonFactionWarDataManager.targetAllianceId
    if (targetAllianceId == nil or targetAllianceId == "") and myCampId == attackCampId then
      return cnt == 0
    end
  elseif meta.condition == MainUITipCondition.SeasonFactionDeclareWar_CanJoin then
    local cnt = UIUtil.GetTodayActiveCount("SeasonFactionDeclareWar_CanJoin", false)
    if cnt ~= 0 then
      return false
    end
    if not LuaEntry.Player:IsInAlliance() then
      return false
    end
    local factionMgr = DataCenter.SeasonFactionWarDataManager
    local myAllianceId = LuaEntry.Player:GetAllianceUid()
    if myCampId ~= 0 and (factionMgr.currStep == SeasonFactionDeclareWarStep.battle_before or factionMgr.currStep == SeasonFactionDeclareWarStep.battle or factionMgr.currStep == SeasonFactionDeclareWarStep.invite) and (factionMgr.theAttackerList[myAllianceId] or factionMgr.theDefenderList[myAllianceId]) then
      return cnt == 0
    end
  elseif meta.condition == MainUITipCondition.SeasonFactionDeclareWar_Battle then
    local cnt = UIUtil.GetTodayActiveCount("SeasonFactionKingWar_Start", false)
    if cnt ~= 0 then
      return false
    end
    if not LuaEntry.Player:IsInAlliance() then
      return false
    end
    if DataCenter.SeasonFactionWarDataManager:GetCurrStep() == SeasonFactionDeclareWarStep.battle then
      return cnt == 0
    end
  elseif meta.condition == MainUITipCondition.SeasonFactionDeclareWar_CanInvite then
    local cnt = UIUtil.GetTodayActiveCount("SeasonFactionDeclareWar_CanInvite", false)
    if cnt ~= 0 then
      return false
    end
    if not LuaEntry.Player:IsInAlliance() then
      return false
    end
    if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
      return false
    end
    if DataCenter.SeasonFactionWarDataManager:GetCurrStep() ~= SeasonFactionDeclareWarStep.invite then
      return false
    end
    local factionMgr = DataCenter.SeasonFactionWarDataManager
    local myCampId = factionMgr.myCampId
    local attackCampId = factionMgr.attackCampId
    local targetAllianceId = factionMgr.targetAllianceId
    if cnt == 0 and attackCampId ~= myCampId and targetAllianceId == myCampId then
      local warInfo = factionMgr.warInfo
      if warInfo and warInfo.vsInfo and warInfo.vsInfo.defence then
        if table.count(warInfo.vsInfo.defence) < 3 then
          return cnt == 0
        end
      elseif meta.requestActivityDataCount == 0 then
        meta.requestActivityDataCount = 1
        SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionWarVsInfo)
      end
    end
  elseif meta.condition == MainUITipCondition.SeasonFactionDeclareWar_BeInvite then
    local cnt = UIUtil.GetTodayActiveCount("SeasonFactionDeclareWar_BeInvite", false)
    if cnt ~= 0 then
      return false
    end
    if not LuaEntry.Player:IsInAlliance() then
      return false
    end
    if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
      return false
    end
    if DataCenter.SeasonFactionWarDataManager:GetCurrStep() ~= SeasonFactionDeclareWarStep.invite then
      return false
    end
    local factionMgr = DataCenter.SeasonFactionWarDataManager
    local myCampId = factionMgr.myCampId
    local attackCampId = factionMgr.attackCampId
    local targetAllianceId = factionMgr.targetAllianceId
    if cnt == 0 and attackCampId ~= myCampId then
      local warInfo = factionMgr.warInfo
      if warInfo and warInfo.inviteList and 0 < table.count(warInfo.inviteList) then
        return cnt == 0
      elseif meta.requestActivityDataCount == 0 then
        meta.requestActivityDataCount = 1
        SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionWarVsInfo)
      end
    end
  elseif meta.condition == MainUITipCondition.SeasonFactionKingWar_Open then
    local cnt = UIUtil.GetActiveCount(theSeasonStartTime, "SeasonFactionKingWar_Open", false)
    return cnt == 0
  elseif meta.condition == MainUITipCondition.SeasonFactionKingWar_Start then
    local zMgr = DataCenter.ZoneWarManager
    local mySeverId = LuaEntry.Player:GetSourceServerId()
    local cnt = UIUtil.GetTodayActiveCount("SeasonFactionKingWar_Start", false)
    if cnt == 0 and zMgr:IsBattleDay() then
      local s1, s2 = zMgr:GetBattleServer()
      if s1 and s2 then
        if zMgr:IsAlly(s2, mySeverId) then
          return true
        end
      elseif zMgr:IsBattleServer(mySeverId) then
        return true
      end
    end
  elseif meta.condition == MainUITipCondition.SeasonHeroUpdate then
    local cnt = UIUtil.GetActiveCount(theSeasonStartTime, "SeasonHeroUpdate", false)
    return cnt == 0
  elseif meta.condition == MainUITipCondition.SeasonFactionBigWar then
    if not LuaEntry.Player:IsInAlliance() then
      return false
    end
    local cnt = UIUtil.GetActiveCount(theSeasonStartTime, "SeasonFactionBigWar", false)
    return cnt == 0
  elseif meta.condition == MainUITipCondition.SeasonNuclearActivityMonster or meta.condition == MainUITipCondition.SeasonNuclearActivityNonFinish then
    return DataCenter.SeasonNuclearPowerPlantDataManager:CheckShowTip(meta.condition)
  end
  return false
end

function ActivityTipsManager:CheckNeedShowCustom(meta, todayZero)
  if not meta.activity_type or meta.activity_type <= EnumActivity.None.Type then
    if meta.condition == MainUITipCondition.AllOut then
      return true
    elseif meta.condition == MainUITipCondition.CityWarSuccess then
      return DataCenter.WorldAllianceCityDataManager:GetFirstNewOccupy()
    elseif meta.condition == MainUITipCondition.ZoneWar1 or meta.condition == MainUITipCondition.ZoneWar2 then
      local needShow = false
      if DataCenter.ZoneWarManager:CheckShowMainUIBtn() then
        local roundInfo = DataCenter.ZoneWarManager:GetCrossKingRoundInfoNow()
        if roundInfo and roundInfo.curVsRound then
          local mySeverId, myInfo, targetInfo = DataCenter.ZoneWarManager:ParseVsRound(roundInfo.curVsRound)
          if mySeverId and myInfo and targetInfo then
            local vsServerId = myInfo.vsServerId
            local checkOld = CommonUtil.PlayerPrefsGetString("LAST_OPEN_UI_ZONE_WAR", "")
            local checkNew
            if meta.condition == MainUITipCondition.ZoneWar1 and myInfo.scoreSettled == 1 then
              checkNew = "UIKingBtn_" .. vsServerId .. "_vs"
              needShow = true
            elseif meta.condition == MainUITipCondition.ZoneWar2 and myInfo.scoreSettled ~= 1 then
              checkNew = "UIKingBtn_" .. vsServerId .. "_new"
              needShow = true
            end
            if checkNew == checkOld then
              needShow = false
            end
          end
        end
        return needShow
      end
      return needShow
    elseif meta.condition == MainUITipCondition.ActivityGroupIsHaveFin then
      local needShow = false
      local activityGroup = meta.type
      local activityList = DataCenter.ActivityListDataManager:GetNowActivityList()
      if activityList ~= nil then
        for actId, data in pairs(activityList) do
          local groupId = data.festivalEntrance
          if groupId == activityGroup and data:CheckIfIsToEnd() then
            needShow = true
            break
          end
        end
      end
      return needShow
    elseif meta.condition == MainUITipCondition.AccountBindTip then
      return DataCenter.LWAccountBindTipManager:CheckTipBubbleShow()
    end
  end
  local activityId = DataCenter.ActivityListDataManager:GetOpenIdByTypeAndEnterType(meta.activity_type, meta.type)
  if not activityId then
    return false
  end
  if meta.condition == MainUITipCondition.AllyDuel1 or meta.condition == MainUITipCondition.AllyDuel2 or meta.condition == MainUITipCondition.AllyDuel3 then
    local prefKey = "LAST_OPEN_TIMESTAMP_" .. activityId
    local lastOpenTime = CommonUtil.PlayerPrefsGetLong(prefKey, 0)
    todayZero = todayZero or UITimeManager:GetInstance():TodayZero()
    if lastOpenTime < todayZero then
      local now = UITimeManager:GetInstance():GetServerTime()
      local weekday = UITimeManager:GetInstance():GetWeekdayIndex(now)
      if meta.condition == MainUITipCondition.AllyDuel1 and weekday == 1 then
        return true
      elseif meta.condition == MainUITipCondition.AllyDuel2 and 2 <= weekday and weekday <= 5 then
        return true
      elseif meta.condition == MainUITipCondition.AllyDuel3 and weekday == 6 then
        return true
      end
    end
  elseif meta.condition == MainUITipCondition.AllyDuel4 or meta.condition == MainUITipCondition.AllyDuel5 then
    local now = UITimeManager:GetInstance():GetServerTime()
    local weekday = UITimeManager:GetInstance():GetWeekdayIndex(now)
    if meta.condition == MainUITipCondition.AllyDuel4 and 1 <= weekday and weekday <= 5 or meta.condition == MainUITipCondition.AllyDuel5 and weekday == 6 then
      local flag = DataCenter.AllianceCompeteDataManager:Check9BoxCanOpen()
      if flag and DataCenter.LeagueMatchManager:BNewPop() then
        local curTime = UITimeManager:GetInstance():GetServerSeconds()
        local partTime = LuaEntry.DataConfig:TryGetNum("alliance_duel_tip", "k1", 0)
        local signTime = CommonUtil.PlayerPrefsGetInt("ALLY_DUEL_TIP_TIME", 0)
        local todaySign = CommonUtil.PlayerPrefsGetInt("ALLY_DUEL_TIP_TODAY_SIGN", 0)
        if not UITimeManager:GetInstance():IsToday(todaySign * 1000) then
          CommonUtil.PlayerPrefsSetInt("ALLY_DUEL_TIP_TODAY_SIGN", curTime)
          signTime = curTime
        end
        if signTime ~= 0 and partTime > curTime - signTime then
          flag = false
        else
          local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
          local eventInfo = actInfo ~= nil and actInfo:GetEventInfo() or nil
          if eventInfo == nil or eventInfo.vsAllianceList == nil then
            flag = false
          elseif 2 > table.count(eventInfo.vsAllianceList) then
            flag = false
          end
        end
      end
      return flag
    end
  elseif meta.condition == MainUITipCondition.CityWar then
    return DataCenter.AllianceDeclareWarManager:GetDeclareState() == DeclareWarState.Formal
  elseif meta.condition == MainUITipCondition.CityWarPre then
    return DataCenter.AllianceDeclareWarManager:GetDeclareState() == DeclareWarState.PreDeclare
  elseif meta.condition == MainUITipCondition.ActDragon1 or meta.condition == MainUITipCondition.ActDragon2 then
    if meta.activity_type == EnumActivity.ActDragon.Type then
      if LuaEntry.Player:IsInAlliance() then
        local tipTxtKey = DataCenter.ActDragonManager:CheckGotoTipStatus(meta.condition == MainUITipCondition.ActDragon1)
        return not string.IsNullOrEmpty(tipTxtKey)
      end
    elseif meta.activity_type == EnumActivity.ActWinterStorm.Type then
      local tipTxtKey = DataCenter.ActWinterStormManager:CheckGotoTipStatus()
      return not string.IsNullOrEmpty(tipTxtKey)
    end
  elseif meta.condition == MainUITipCondition.StrongCmd1 then
    self.prevStrComRedPointCount = self.prevStrComRedPointCount or 0
    local rewardCount = DataCenter.StrongestCommanderDataManager:GetEventCanRewardCount()
    return rewardCount > self.prevStrComRedPointCount
  elseif meta.condition == MainUITipCondition.StrongCmd2 then
    local lastStageId = Setting:GetInt(SettingKeys.NEWEST_STR_COM_STAGE_ID, 0)
    local curStageId = DataCenter.StrongestCommanderDataManager:GetCurStage()
    return curStageId ~= lastStageId
  elseif meta.condition == MainUITipCondition.AllyDrill1 or meta.condition == MainUITipCondition.AllyDrill2 then
    return DataCenter.AllyDrillDataManager:CheckShowTip(meta.condition)
  elseif meta.condition == MainUITipCondition.ActMigrationOpen then
    local tipTxtKey = DataCenter.ActMigrationManager:CheckGotoTipStatus()
    return not string.IsNullOrEmpty(tipTxtKey)
  elseif meta.condition == MainUITipCondition.ActQueenOfBlood then
    return DataCenter.OffSeason1QueenOfBloodManager:CheckGotoTipStatus()
  end
  return false
end

function ActivityTipsManager:RecordSeenActivity(activityId, activityType)
  if self.historyId2type[activityId] then
    return
  end
  self.historyId2type[activityId] = activityType
  self.historyTypes[activityType] = true
  CommonUtil.PlayerPrefsSetTable("ACTIVITY_TIPS_HISTORY", self.historyId2type)
end

function ActivityTipsManager:RecordSeenUI(activityId, activityType)
  if not activityId or not activityType then
    return
  end
  activityId = tostring(activityId)
  local meta = self.activityType2Meta[activityType]
  if not meta then
    return
  end
  if meta.condition == MainUITipCondition.ActivityId or meta.condition == MainUITipCondition.ActivityType then
    self:RecordSeenActivity(activityId, activityType)
  elseif meta.condition == MainUITipCondition.Daily then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    CommonUtil.PlayerPrefsSetLong("LAST_OPEN_TIMESTAMP_" .. activityId, curTime)
  elseif meta.condition == MainUITipCondition.Login then
    self.historyLogin[meta.id] = true
  end
end

function ActivityTipsManager:RecordSeenTip(meta)
  if meta.condition == MainUITipCondition.ActivityId or meta.condition == MainUITipCondition.ActivityType then
    local actId = DataCenter.ActivityListDataManager:GetOpenIdByTypeAndEnterType(meta.activity_type, meta.type)
    self:RecordSeenActivity(actId, meta.activity_type)
  elseif meta.condition == MainUITipCondition.Daily then
    local actId = DataCenter.ActivityListDataManager:GetOpenIdByTypeAndEnterType(meta.activity_type, meta.type)
    if actId then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      CommonUtil.PlayerPrefsSetLong("LAST_OPEN_TIMESTAMP_" .. actId, curTime)
    end
  elseif meta.condition == MainUITipCondition.Login then
    self.historyLogin[meta.id] = true
  elseif meta.condition > MainUITipCondition.Custom then
    if meta.condition == MainUITipCondition.ZoneWar1 or meta.condition == MainUITipCondition.ZoneWar2 then
      self:RecordZoneWarSeenState()
    elseif meta.condition == MainUITipCondition.AllyDuel1 or meta.condition == MainUITipCondition.AllyDuel2 or meta.condition == MainUITipCondition.AllyDuel3 then
      local now = UITimeManager:GetInstance():GetServerTime()
      CommonUtil.PlayerPrefsSetLong("LAST_OPEN_TIMESTAMP_" .. EnumActivity.AllianceCompete.ActId, now)
    elseif meta.condition == MainUITipCondition.ActDragon1 or meta.condition == MainUITipCondition.ActDragon2 then
      if meta.activity_type == EnumActivity.ActDragon.Type then
        DataCenter.ActDragonManager:RecordGotoTipStatus(meta.condition == MainUITipCondition.ActDragon1)
      elseif meta.activity_type == EnumActivity.ActWinterStorm.Type then
        DataCenter.ActWinterStormManager:RecordGotoTipStatus()
      end
    elseif meta.condition == MainUITipCondition.StrongCmd1 then
      self.prevStrComRedPointCount = DataCenter.StrongestCommanderDataManager:GetEventCanRewardCount()
    elseif meta.condition == MainUITipCondition.StrongCmd2 then
      local curStageId = DataCenter.StrongestCommanderDataManager:GetCurStage()
      Setting:SetInt(SettingKeys.NEWEST_STR_COM_STAGE_ID, curStageId)
    elseif meta.condition == MainUITipCondition.AllyDrill1 or meta.condition == MainUITipCondition.AllyDrill2 then
      DataCenter.AllyDrillDataManager:SetShowTip(meta.condition)
    elseif meta.condition == MainUITipCondition.AccountBindTip then
      DataCenter.LWAccountBindTipManager:SetTipBubbleShow()
    elseif meta.condition == MainUITipCondition.SeasonNuclearActivityMonster or meta.condition == MainUITipCondition.SeasonNuclearActivityNonFinish then
      DataCenter.SeasonNuclearPowerPlantDataManager:SetTipBubbleShow(meta.condition)
    elseif meta.condition == MainUITipCondition.ActMigrationOpen then
      DataCenter.ActMigrationManager:RecordGotoTipStatus()
    elseif meta.condition == MainUITipCondition.ActQueenOfBlood then
      DataCenter.OffSeason1QueenOfBloodManager:RecordGotoTipStatus()
    end
  end
end

function ActivityTipsManager:RecordZoneWarSeenState()
  local roundInfo = DataCenter.ZoneWarManager:GetCrossKingRoundInfoNow()
  if roundInfo and roundInfo.curVsRound then
    local mySeverId, myInfo, targetInfo = DataCenter.ZoneWarManager:ParseVsRound(roundInfo.curVsRound)
    if mySeverId and myInfo and targetInfo then
      local vsServerId = myInfo.vsServerId
      local prefKey
      if myInfo.scoreSettled == 1 then
        prefKey = "UIKingBtn_" .. vsServerId .. "_vs"
      else
        prefKey = "UIKingBtn_" .. vsServerId .. "_new"
      end
      CommonUtil.PlayerPrefsSetString("LAST_OPEN_UI_ZONE_WAR", prefKey)
    end
  end
end

function ActivityTipsManager:OnBtnClick(meta)
  if not meta then
    return
  end
  if meta.condition == MainUITipCondition.AllyDrill1 or meta.condition == MainUITipCondition.AllyDrill2 then
    DataCenter.AllyDrillDataManager:JumpToDrill()
    return
  elseif meta.condition == MainUITipCondition.CityWar or meta.condition == MainUITipCondition.CityWarPre or meta.condition == MainUITipCondition.AllOut then
    local data = DataCenter.AllianceDeclareWarManager:GetSelfDeclareWarData()
    if data and data.content then
      local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(tonumber(data.content))
      local worldPos = SceneUtils.TileToWorld(cityMeta.pos)
      GoToUtil.GotoWorldPos(worldPos)
    end
  elseif meta.condition == MainUITipCondition.ActivityGroupIsHaveFin then
    local activityGroup = meta.type
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCommonGroupShow, activityGroup)
    return
  elseif meta.condition == MainUITipCondition.CityWarSuccess then
    local newOccupy = DataCenter.WorldAllianceCityDataManager:GetFirstNewOccupy()
    if newOccupy then
      local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.S0AttackCityNew.Type)
      if actList and 0 < #actList then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UISiegeSuccessS0, {anim = true}, {
          cityId = newOccupy.cityId
        })
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UISiegeSuccess, {anim = true}, {
          cityId = newOccupy.cityId
        })
      end
    end
  elseif meta.condition == MainUITipCondition.AccountBindTip then
    DataCenter.LWAccountBindTipManager:GuideToAccountBind()
    return
  elseif meta.condition == MainUITipCondition.ZoneMobilization then
    DataCenter.LWZoneMobilizationManager:DonateTabGotoPointHandler()
    return
  end
  if meta.type == MainUITipType.Activity then
    local actId = DataCenter.ActivityListDataManager:GetOpenIdByTypeAndEnterType(meta.activity_type, meta.type)
    if actId then
      GoToUtil.GotoOpenView(UIWindowNames.UIActivityCenterTable, actId)
    end
  elseif meta.type == MainUITipType.Gift then
    if meta.activity_type == EnumActivity.BattlePass.Type or meta.activity_type == EnumActivity.BattlePass_new.Type then
      local actIds = DataCenter.ActivityListDataManager:GetAllOpenIdsByType(meta.activity_type)
      for _, id in pairs(actIds) do
        local isNew = DataCenter.ActivityListDataManager:IsActivityNew(id)
        if isNew then
          GoToUtil.GotoOpenView(UIWindowNames.LWBuyDiamond, {
            anim = false,
            UIMainAnim = UIMainAnimType.AllHide
          }, nil, nil, RechargeEntryType.DailySale, nil, id)
          return
        end
      end
    else
      local actId = DataCenter.ActivityListDataManager:GetOpenIdByTypeAndEnterType(meta.activity_type, meta.type)
      if actId then
        GoToUtil.GotoOpenView(UIWindowNames.LWBuyDiamond, {
          anim = false,
          UIMainAnim = UIMainAnimType.AllHide
        }, nil, nil, RechargeEntryType.DailySale, nil, actId)
      end
    end
  elseif meta.type == MainUITipType.AllyCity then
    if DataCenter.ActivityListDataManager:CheckIfActivityOpen(EnumActivity.KingActivity.Type) then
      UIUtil.ShowGovernmentActivityMain()
    end
  elseif meta.type == MainUITipType.WarZone then
    local configSchedule = DataCenter.ZoneWarManager:GetCrossKingSchedule()
    if configSchedule then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentServerBattleMain)
    end
  elseif meta.type == MainUITipType.AllyDuel then
    DataCenter.AllianceCompeteDataManager:TryOpenAllyDuelUI()
  elseif meta.type == MainUITipType.Season then
    local activityData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(meta.activity_type)
    if activityData then
      meta:RecordClickSeason()
      SeasonUtil.OpenSeasonActivity(activityData)
    else
      UIUtil.ShowTipsId(120018)
    end
  elseif meta.type == MainUITipType.ActMigration then
    local activityId = DataCenter.ActMigrationManager:GetCurActId(true)
    if activityId then
      DataCenter.ActMigrationManager:GoToView(self.activityId)
    end
  elseif meta.type > MainUITipType.Special then
    local actId = DataCenter.ActivityListDataManager:GetOpenIdByTypeAndEnterType(meta.activity_type, meta.type)
    if actId then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCommonGroupShow, meta.type, actId)
    end
  end
end

function ActivityTipsManager:AddTempTip(btnType, condition, tipsContent, btn_name)
  local fakeMeta = ActivityTipsMeta.New()
  fakeMeta:InitFake(btnType, condition, tipsContent, btn_name)
  self:Enqueue(condition, fakeMeta)
end

return ActivityTipsManager
