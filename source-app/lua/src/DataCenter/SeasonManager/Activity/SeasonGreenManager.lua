local SeasonGreenManager = BaseClass("SeasonGreenManager")
local Localization = CS.GameEntry.Localization

function SeasonGreenManager:__init()
  self.init = false
  self.activityId = nil
  self.allianceCityInfo = nil
  self.areaLevelInfo = nil
  self.curOpenLevel = 0
  self.areaTotalRate = 0
  self.rankArray = nil
  self.rankArrayWeek = nil
  self.rankReward = nil
  self:AddListener()
end

function SeasonGreenManager:__delete()
  self:RemoveListener()
end

function SeasonGreenManager:Init()
  if not self:IsActive() then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.SeasonGreenCityProgressInfo)
  self:TryGetStage2LevelInfo()
end

function SeasonGreenManager:Startup()
end

function SeasonGreenManager:AddListener()
  EventManager:GetInstance():AddListenerWithSelf(EventId.OnEnterWorld, self.OnEnterWorld, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.OnPassDay, self.OnPassDay, self)
end

function SeasonGreenManager:RemoveListener()
  EventManager:GetInstance():RemoveListener2(EventId.OnEnterWorld, self.OnEnterWorld, self)
  EventManager:GetInstance():RemoveListener2(EventId.OnPassDay, self.OnPassDay, self)
end

function SeasonGreenManager:InitData(data)
  self.activityId = data.id
  self:Init()
end

function SeasonGreenManager:GetConfigData(id)
end

function SeasonGreenManager:GetMainCfg()
  local viewSeasonInfo = SeasonUtil.GetSeasonInfo(LuaEntry.Player:GetCurServerId())
  local config = viewSeasonInfo and viewSeasonInfo.currentSeasonConfig
  if not config then
    return nil
  end
  local cfgId = config and toInt(config.oasis)
  if cfgId == nil or cfgId <= 0 then
    return nil
  end
  local cfg = LocalController:instance():getLine(TableName.LW_Season_Oasis, cfgId or 0)
  if cfg == nil then
    Logger.LogInfo("Season_Oasis is nil, id = " .. cfgId)
  end
  return cfg
end

function SeasonGreenManager:IsActive(includePrepare)
  return SeasonUtil.IsSeasonActivityOpen(self.activityId, SeasonMapType.Mummy, includePrepare)
end

function SeasonGreenManager:GetActivityData(includePrepare)
  if not self:IsActive(includePrepare) then
    return
  end
  return DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
end

function SeasonGreenManager:GotoActivity()
  if not self:IsActive() then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.SingleActivityContainerType2, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, self.activityId)
end

function SeasonGreenManager:GetStage()
  if not self:IsActive() then
    return 0
  end
  local _, day = DataCenter.SeasonDataManager:GetNowSeasonAndSeasonDay()
  local mainCfg = DataCenter.SeasonGreenManager:GetMainCfg()
  local secondDay = mainCfg and toInt(mainCfg.second_stage) or 0
  if day >= secondDay then
    return 2, day - secondDay
  end
  return 1
end

function SeasonGreenManager:GetActivityDurationWeek()
  local activity = self:GetActivityData()
  if not activity then
    return 0
  end
  local duration = activity.endTime - activity.startTime
  return math.ceil(duration / 604800000)
end

function SeasonGreenManager.getters:staminaCost()
  local mainCfg = self:GetMainCfg()
  return mainCfg and toInt(mainCfg.cost) or 0
end

function SeasonGreenManager.getters:cityGreenCondition()
  local mainCfg = DataCenter.SeasonGreenManager:GetMainCfg()
  return mainCfg and tonumber(mainCfg.city_green_rate) or 0
end

function SeasonGreenManager:GetAreaUnlockGreenRate(level)
  local mainCfg = DataCenter.SeasonGreenManager:GetMainCfg()
  if not mainCfg then
    return 0
  end
  if not self.areaUnlockDict then
    self.areaUnlockDict = {}
    local unlockRate = mainCfg.second_stage_para
    if unlockRate then
      local unlockList = string.split(unlockRate, ";")
      for i, v in ipairs(unlockList) do
        local unlockData = string.split(v, ",")
        if unlockData and 3 <= #unlockData then
          self.areaUnlockDict[toInt(unlockData[1])] = toInt(unlockData[3])
        end
      end
    end
  end
  return self.areaUnlockDict[level] or 0
end

function SeasonGreenManager:IsGreen(pointId)
  return CS.SceneManager.World:IsGreen(pointId)
end

function SeasonGreenManager:CanGreen(pointId, showTips, noNeedCheckTile)
  local stage = self:GetStage()
  if stage <= 0 then
    if showTips then
      UIUtil.ShowTipsId("season_oasis_tips_1")
    end
    return false
  end
  local pos = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
  if DataCenter.BirthPointTemplateManager:IsInKingCityOccupiedRange(pos.x, pos.y) then
    if showTips then
      UIUtil.ShowTipsId("season_oasis_tips_8")
    end
    return false
  end
  local serverId = LuaEntry.Player:GetCurServerId()
  local cityId = SceneUtils.GetZoneIdByPosId(pointId, serverId)
  local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, serverId)
  if not meta then
    if showTips then
      UIUtil.ShowTipsId("season_oasis_tips_1")
    end
    return false
  end
  local hasFirstOccupy = DataCenter.WorldAllianceCityDataManager:HasFirstOccupy(serverId, cityId)
  if stage == 1 then
    if not LuaEntry.Player:IsInSourceServer() then
      if showTips then
        UIUtil.ShowTipsId("season_oasis_tips_12")
      end
      return false
    end
    local selfAid = LuaEntry.Player:GetAllianceUid()
    if string.IsNullOrEmpty(selfAid) then
      if showTips then
        UIUtil.ShowTipsId("456550")
      end
      return false
    end
    if not meta:IsCity() then
      if showTips then
        UIUtil.ShowTipsId("season_oasis_tips_10")
      end
      return false
    end
    if not hasFirstOccupy and showTips then
      UIUtil.ShowTipsId("season_oasis_tips_10")
    end
    return noNeedCheckTile or CS.SceneManager.World:CanGreen(pointId, showTips or false)
  end
  if not DataCenter.SeasonDataManager:IsSameGroup() then
    if showTips then
      UIUtil.ShowTipsId("season_oasis_tips_13")
    end
    return false
  end
  if meta.level <= self.curOpenLevel then
    return noNeedCheckTile or CS.SceneManager.World:CanGreen(pointId, showTips or false)
  end
  if meta:IsCity() and hasFirstOccupy then
    return noNeedCheckTile or CS.SceneManager.World:CanGreen(pointId, showTips or false)
  end
  if not noNeedCheckTile and not CS.SceneManager.World:CanGreen(pointId, showTips or false) then
    return false
  end
  if showTips then
    UIUtil.ShowTips(Localization:GetString("season_oasis_tips_9", self.curOpenLevel))
  end
  return false
end

function SeasonGreenManager:CanMarchToGreen(pointId, showTips)
  if not self:CanGreen(pointId, showTips) then
    return
  end
  local curStamina = LuaEntry.Player:GetCurStamina()
  local staminaCost = MarchUtil.GetCostStaminaByTargetType(MarchTargetType.GREEN)
  if curStamina < staminaCost then
    if showTips then
      LWResourceLackUtil:GotoSpecialResLack(ResLackContextType.Energy)
    end
    return false
  end
  return true
end

function SeasonGreenManager:MarchToGreen(pointId)
  if not self:CanMarchToGreen(pointId, true) then
    UIUtil.CheckEventTrigger(OpMode.ClickBtnWorldGreen, 1)
    return
  end
  UIUtil.TryShowConfirm(TodayNoSecondConfirmType.SeasonGreenMarch, CS.GameEntry.Localization:GetString("season_oasis_tips_march", self.staminaCost), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    MarchUtil.LaunchScout(MarchTargetType.GREEN, pointId, pointId)
  end, function()
  end, nil, nil, false, nil, nil)
end

function SeasonGreenManager:IsGreenCity(cityId)
  if SeasonUtil.CurServerTypeInSeason() == SeasonMapType.Mummy then
    local temp = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, LuaEntry.Player:GetCurServerId())
    if not temp then
      return false
    end
    return temp.type == WorldAllianceCityType.City or temp.type == WorldAllianceCityType.Stronghold or temp.type == WorldAllianceCityType.TradingStation or temp.type == WorldAllianceCityType.King or temp.type == WorldAllianceCityType.GoldTree or temp.type == WorldAllianceCityType.Mountain
  end
  return false
end

function SeasonGreenManager:CanGreenCity(cityId)
  if SeasonUtil.CurServerTypeInSeason() ~= SeasonMapType.Mummy then
    return
  end
  local stage = self:GetStage()
  if stage == 0 then
    return false
  end
  local temp = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, LuaEntry.Player:GetCurServerId())
  if not temp then
    return false
  end
  if stage == 1 then
    if temp.type == WorldAllianceCityType.City and DataCenter.WorldAllianceCityDataManager:GetMyAlCityInfo(cityId) then
      return true
    end
  elseif stage == 2 then
    return temp.type == WorldAllianceCityType.City or temp.type == WorldAllianceCityType.Stronghold or temp.type == WorldAllianceCityType.TradingStation or temp.type == WorldAllianceCityType.King or temp.type == WorldAllianceCityType.GoldTree or temp.type == WorldAllianceCityType.Mountain
  end
  return false
end

function SeasonGreenManager:OnEnterWorld()
  self:TryGetStage2LevelInfo()
end

function SeasonGreenManager:OnPassDay()
  self:TryGetStage2LevelInfo()
end

function SeasonGreenManager:TryGetStage2LevelInfo()
  if not self:IsActive() then
    return
  end
  local stage, day = self:GetStage()
  if stage ~= 2 then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  SFSNetwork.SendMessage(MsgDefines.SeasonGreenCityStage2LevelInfo)
  if day == 0 and UIUtil.GetWeekActiveCount(string.format("%s_%s", "season_green_notice_2", LuaEntry.Player.uid), true) < 1 then
    DataCenter.UIPopWindowManager:Push(UIWindowNames.SeasonGreenNotice, {anim = true})
  end
end

function SeasonGreenManager:GetSeasonGreenCityRankRewardInfo()
  if self.rankReward then
    return self.rankReward
  end
  SFSNetwork.SendMessage(MsgDefines.SeasonGreenCityRankReward)
end

function SeasonGreenManager:SeasonGreenCityAllianceInfo(allianceCityInfo)
  self.allianceCityInfo = allianceCityInfo
  EventManager:GetInstance():Broadcast(EventId.SeasonGreenCityAllianceInfo)
end

function SeasonGreenManager:SeasonGreenCityStage2LevelInfo(areaLevelInfo, curOpenLevel, areaTotalRate)
  self.areaLevelInfo = areaLevelInfo
  self.curOpenLevel = curOpenLevel or 1
  self.areaTotalRate = areaTotalRate or 0
  EventManager:GetInstance():Broadcast(EventId.SeasonGreenCityStage2LevelInfo)
end

function SeasonGreenManager:GetAreaLevelValue(level, list)
  level = level or DataCenter.SeasonGreenManager.curOpenLevel
  list = list or DataCenter.SeasonGreenManager.areaLevelInfo
  local listCount = list and #list or 0
  local curValue, hasNext = nil, false
  if 0 < listCount then
    for i = 1, listCount do
      local value = list[i]
      if value.level == level then
        curValue = value
        hasNext = i < listCount
        break
      end
    end
  end
  return curValue, hasNext
end

function SeasonGreenManager:GetRankList(rankType, week)
  if rankType == SeasonGreenRank.Week then
    if not week then
      local seasonId, weekNum = DataCenter.SeasonDataManager:GetSeasonWeekInfo()
      week = weekNum or 1
    end
    local data = self.rankArrayWeek and self.rankArrayWeek[week] or {}
    return data.list or {}, data.selfRank or 0, data.selfScore or 0
  end
  local data = self.rankArray and self.rankArray[rankType] or {}
  return data.list or {}, data.selfRank or 0, data.selfScore or 0
end

function SeasonGreenManager:SeasonGreenCityRank(rankArray, type, weekNum, selfRank, selfScore)
  type = type or 1
  weekNum = weekNum or 1
  if type == SeasonGreenRank.Week then
    if not self.rankArrayWeek then
      self.rankArrayWeek = {}
    end
    self.rankArrayWeek[weekNum] = {
      list = rankArray,
      selfRank = selfRank,
      selfScore = selfScore
    }
  else
    if not self.rankArray then
      self.rankArray = {}
    end
    self.rankArray[type] = {
      list = rankArray,
      selfRank = selfRank,
      selfScore = selfScore
    }
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonGreenCityRank, type, weekNum)
end

function SeasonGreenManager:GetRedCount()
  return self.canGetRewardCount or 0
end

function SeasonGreenManager:SeasonGreenCityProgressInfo(t)
  self.curNum = t.greenCityNumber or 0
  local rewardRecord = {}
  if t.rewardRecord then
    for k, v in ipairs(t.rewardRecord) do
      rewardRecord[v] = true
    end
  end
  self.rewardInfo = t.rewardInfo or {}
  for k, v in ipairs(self.rewardInfo) do
    v.state = rewardRecord[v.index] and 1 or 0
  end
  self.canGetRewardCount, self.canGetReward = self:GetGreenCityCanGetReward()
  EventManager:GetInstance():Broadcast(EventId.SeasonGreenCityProgressInfo)
end

function SeasonGreenManager:SeasonGreenCityProgressGetReward(index)
  if not self.rewardInfo then
    return
  end
  for k, v in ipairs(self.rewardInfo) do
    if v.index == index then
      v.state = 1
      break
    end
  end
  self.canGetRewardCount, self.canGetReward = self:GetGreenCityCanGetReward()
  EventManager:GetInstance():Broadcast(EventId.SeasonGreenCityProgressInfo)
end

function SeasonGreenManager:GetGreenCityCanGetReward()
  if not self.rewardInfo then
    return
  end
  local curNum = self.curNum or 0
  local canGetRewardCount = 0
  local canGetReward
  for i, reward in ipairs(self.rewardInfo) do
    if curNum >= reward.num and reward.state ~= 1 then
      canGetRewardCount = canGetRewardCount + 1
      canGetReward = canGetReward or reward
    end
  end
  return canGetRewardCount, canGetReward
end

return SeasonGreenManager
