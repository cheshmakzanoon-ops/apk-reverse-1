local SeasonNineKingManager = BaseClass("SeasonNineKingManager")
local FetchHeroEventCfgInfo = require("Net.Msgs.FetchHeroEventCfgInfoMessage")
local RewardUtil = require("Util.RewardUtil")

function SeasonNineKingManager:__init()
  self.activityId = nil
  self.throneConnectedInfo = nil
  self.allianceDic = nil
  self.sourceInfo = nil
  self.viewInfo = nil
  self.redPointCount = 0
  self.reward = {}
  self._crossDayReload = false
end

function SeasonNineKingManager:__delete()
  self:RemoveListener()
end

function SeasonNineKingManager:AddListener()
  if self.__addListener then
    return
  end
  self.__addListener = true
  EventManager:GetInstance():AddListenerWithSelf(EventId.WorldCityOwnerInfoChanged, self.WorldCityOwnerInfoChanged, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.OnPassDay, self.OnPassDay, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.HeroEventCfgInfoUpdate, self.OnHeroEventUpdate, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.HeroEventClaimBoxReward, self.OnHeroEventUpdate, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.HeroEventDataUpdate, self.OnHeroEventUpdate, self)
end

function SeasonNineKingManager:RemoveListener()
  if not self.__addListener then
    return
  end
  self.__addListener = false
  EventManager:GetInstance():RemoveListener2(EventId.WorldCityOwnerInfoChanged, self.WorldCityOwnerInfoChanged, self)
  EventManager:GetInstance():RemoveListener2(EventId.OnPassDay, self.OnPassDay, self)
  EventManager:GetInstance():RemoveListener2(EventId.HeroEventCfgInfoUpdate, self.OnHeroEventUpdate, self)
  EventManager:GetInstance():RemoveListener2(EventId.HeroEventClaimBoxReward, self.OnHeroEventUpdate, self)
  EventManager:GetInstance():RemoveListener2(EventId.HeroEventDataUpdate, self.OnHeroEventUpdate, self)
end

function SeasonNineKingManager:InitData(data)
  self.activityId = data.id
  self:AddListener()
  SFSNetwork.SendMessage(MsgDefines.ThroneConnectedInfo)
  DataCenter.SeasonNineKingManager:SendCenterThroneInfo()
  self:UpdateRewardCount(true)
end

function SeasonNineKingManager:GetActivityId()
  return self.activityId
end

function SeasonNineKingManager:IsActive(includePrepare)
  if not SeasonUtil.IsSeasonActivityOpen(self.activityId, SeasonMapType.NineNation, includePrepare) then
    return false
  end
  local sourceInfo = self.sourceInfo
  if not sourceInfo then
    return true
  end
  if sourceInfo.id ~= self.activityId then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < sourceInfo.startTime or curTime > sourceInfo.endViewTime then
    return false
  end
  if DataCenter.BuildManager.MainLv < sourceInfo.needMainCityLevel then
    return false
  end
  return true
end

function SeasonNineKingManager:IsCurWorldActive(serverId_, checkIsBattle_)
  if not self.viewInfo then
    return false
  end
  if not self:CheckCenterServer(self.viewInfo.serverId) then
    return false
  end
  if serverId_ and 0 < serverId_ and not DataCenter.SeasonDataManager:IsInNinePalacesMode(serverId_, ServerEnum.View) then
    return false
  end
  local info = self.viewInfo
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < info.startTime or curTime > info.endViewTime then
    return false
  end
  if checkIsBattle_ then
    local shieldData = info.weekShieldInfo[info.curWeek or 0]
    if not shieldData or curTime < shieldData.breakShieldTime then
      return false
    end
    local weekData = info.weekData[info.curWeek or 0]
    if weekData and weekData.fightEndTime and 0 < weekData.fightEndTime and curTime > weekData.fightEndTime then
      return false
    end
  end
  return true
end

function SeasonNineKingManager:CheckCenterServer(serverId)
  local centerServerId = DataCenter.SeasonDataManager:GetNinePalacesServer(5, ServerEnum.View)
  return 0 < centerServerId and centerServerId == serverId
end

function SeasonNineKingManager:GotoCenterCity(ServerEnum_)
  local centerServerId = DataCenter.SeasonDataManager:GetNinePalacesServer(5, ServerEnum_ or ServerEnum.Source)
  if not centerServerId or centerServerId <= 0 then
    return
  end
  local cityId, pointId = SeasonUtil.GetKingCityId(centerServerId)
  local pos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, centerServerId)
  local position = CS.UnityEngine.Vector3(pos.x, 0, pos.z)
  GoToUtil.GotoWorldPos(position, 150, nil, function()
  end, centerServerId)
  GoToUtil.CloseAllWindows()
end

function SeasonNineKingManager:CanJoinBattle(allianceId_, cityServerId_)
  allianceId_ = allianceId_ or LuaEntry.Player.allianceId
  if string.IsNullOrEmpty(allianceId_) then
    return false
  end
  if not cityServerId_ or cityServerId_ <= 0 then
    cityServerId_ = LuaEntry.Player:GetCurServerId()
  end
  if not DataCenter.SeasonDataManager:IsInNinePalacesMode(cityServerId_, ServerEnum.Source) then
    return false
  end
  if not self:CheckCenterServer(cityServerId_) then
    return false
  end
  if not self.allianceDic then
    return false
  end
  return self.allianceDic[allianceId_] ~= nil
end

function SeasonNineKingManager:IsAlly(ownerAllianceId, allianceId_)
  allianceId_ = allianceId_ or LuaEntry.Player.allianceId
  if string.IsNullOrEmpty(ownerAllianceId) or string.IsNullOrEmpty(allianceId_) then
    return false
  end
  return ownerAllianceId == allianceId_
end

function SeasonNineKingManager:GetMyEnemyNow(ownerAllianceId)
  local dic = self.allianceDic
  if dic and DataCenter.SeasonDataManager:IsInNinePalacesMode(LuaEntry.Player:GetCurServerId(), ServerEnum.Source) then
    for k, v in pairs(dic) do
      if k ~= ownerAllianceId then
        return v.serverId, k, v.allianceAbbr
      end
    end
  end
  return 0, "", ""
end

function SeasonNineKingManager:ParseKillScoreData(killInfo, ownerServerId_, ownerAllianceId_, ownerAbbr_)
  if table.IsNullOrEmpty(killInfo) then
    return
  end
  if string.IsNullOrEmpty(ownerAllianceId_) then
    ownerServerId_, ownerAllianceId_ = DataCenter.ZoneWarManager:GetOwnerServerIdKingCity()
  end
  if string.IsNullOrEmpty(ownerAllianceId_) then
    return
  end
  if killInfo.hasParse then
    return killInfo[1], killInfo[2]
  end
  if killInfo[1] == nil then
    local attackerServer, attackerAllianceId, attackerAbbr = self:GetMyEnemyNow(ownerAllianceId_)
    killInfo[1] = {
      num = 0,
      serverId = ownerServerId_,
      allianceId = ownerAllianceId_,
      allianceAbbr = ownerAbbr_
    }
    killInfo[2] = {
      num = 0,
      serverId = attackerServer,
      allianceId = attackerAllianceId,
      allianceAbbr = attackerAbbr
    }
  elseif killInfo[2] == nil then
    if killInfo[1].allianceId == ownerAllianceId_ then
      local attackerServer, attackerAllianceId, attackerAbbr = self:GetMyEnemyNow(ownerAllianceId_)
      killInfo[2] = {
        num = 0,
        serverId = attackerServer,
        allianceId = attackerAllianceId,
        allianceAbbr = attackerAbbr
      }
    else
      killInfo[2] = {
        num = 0,
        serverId = ownerServerId_,
        allianceId = ownerAllianceId_,
        allianceAbbr = ownerAbbr_
      }
    end
  end
  local selfAllianceId = LuaEntry.Player.allianceId
  if not string.IsNullOrEmpty(selfAllianceId) then
    table.sort(killInfo, function(a, b)
      if a.allianceId == selfAllianceId and b.allianceId ~= selfAllianceId then
        return true
      elseif a.allianceId ~= selfAllianceId and b.allianceId == selfAllianceId then
        return false
      end
      return a.num > b.num
    end)
  end
  return killInfo[1], killInfo[2]
end

function SeasonNineKingManager:TryShowWinner(battleJustEnded, passDayReload, forceShow_)
  if not (self.sourceInfo and self:IsActive()) or not DataCenter.SeasonDataManager:IsInNinePalacesMode(LuaEntry.Player:GetCurServerId(), ServerEnum.Source) then
    return
  end
  local weekData = self.sourceInfo.weekData[self.sourceInfo.curWeek or 0]
  if not weekData or string.IsNullOrEmpty(weekData.allianceUserId) then
    weekData = self.sourceInfo.weekData[(self.sourceInfo.curWeek or 0) - 1]
    if not weekData or string.IsNullOrEmpty(weekData.allianceUserId) then
      return
    end
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if not weekData.fightEndTime or 0 >= weekData.fightEndTime or curTime > weekData.fightEndTime + 518400000 then
    return
  end
  if forceShow_ or 1 > UIUtil.GetMonthActiveCount(string.format("%s_%s_%s", "9king_", weekData.fightEndTime, LuaEntry.Player.uid), false) then
    if battleJustEnded or passDayReload then
      DataCenter.UIPopWindowManager:Push(UIWindowNames.UINewKing, {anim = true}, weekData)
    else
      local isFunctionOn = DataCenter.LWPopupManager:IsFunctionOnNewPopupStyle()
      if not isFunctionOn then
        DataCenter.UIPopWindowManager:Push(UIWindowNames.UINewKing, {anim = true}, weekData)
      else
        DataCenter.LWPopupManager:TryAddPopupNotification(PopupNotificationType.NineNationKingBattle, weekData)
      end
    end
  end
end

function SeasonNineKingManager:GetWorldBattleEndTime(cityServerId_)
  local info = self.viewInfo
  if not cityServerId_ or cityServerId_ <= 0 then
    cityServerId_ = DataCenter.SeasonDataManager:GetNinePalacesServer(5, ServerEnum.View)
  elseif DataCenter.SeasonDataManager:IsInNinePalacesMode(cityServerId_, ServerEnum.Source) then
    info = self.sourceInfo
  end
  if not (info and info.weekShieldInfo) or info.serverId ~= cityServerId_ then
    return UITimeManager:GetInstance():GetServerTime()
  end
  local weekData = info.weekData[info.curWeek or 0]
  if weekData and weekData.fightEndTime and 0 < weekData.fightEndTime then
    return weekData.fightEndTime, UITimeManager:GetInstance():IsTodayServer(weekData.fightEndTime)
  end
  weekData = info.weekShieldInfo[info.curWeek or 0]
  if not weekData or not weekData.breakShieldTime then
    return UITimeManager:GetInstance():GetServerTime()
  end
  local maxBattleTime = LuaEntry.DataConfig:TryGetNum("wonder_zone_war", "k1", 14400)
  return weekData.breakShieldTime + maxBattleTime * 1000
end

function SeasonNineKingManager:GetWorldTotalScore(cityServerId_)
  if not self.viewInfo or cityServerId_ and 0 < cityServerId_ and self.viewInfo.serverId ~= cityServerId_ then
    return 360000
  end
  local actData = LocalController:instance():getLine(TableName.Activity, self.viewInfo.id)
  if not actData then
    return 360000
  end
  local totalScores = actData.para_2
  if string.IsNullOrEmpty(totalScores) then
    return 360000
  end
  local scoresList = string.split(totalScores, "|") or {}
  local score = scoresList[self.viewInfo.curWeek] or scoresList[#scoresList]
  return score and tonumber(score) or 360000
end

function SeasonNineKingManager:GetWorldPointSpeed(cityServerId_)
  if not self.viewInfo or cityServerId_ and 0 < cityServerId_ and self.viewInfo.serverId ~= cityServerId_ then
    return 1
  end
  local actData = LocalController:instance():getLine(TableName.Activity, self.viewInfo.id)
  if not actData then
    return 1
  end
  return actData.para_3 and tonumber(actData.para_3) or 1
end

function SeasonNineKingManager:GetTowerSpeedAdd(cityServerId_)
  if not self.viewInfo or cityServerId_ and 0 < cityServerId_ and self.viewInfo.serverId ~= cityServerId_ then
    return 0
  end
  local actData = LocalController:instance():getLine(TableName.Activity, self.viewInfo.id)
  if not actData then
    return 0
  end
  return actData.para_4 and tonumber(actData.para_4) or 0
end

function SeasonNineKingManager:SendCenterThroneInfo(serverId)
  if not self.sourceInfo and self:IsActive() then
    SFSNetwork.SendMessage(MsgDefines.CenterThroneActivityInfo)
    if not serverId or serverId <= 0 or DataCenter.SeasonDataManager:IsInBattleServerGroup(serverId) then
      return
    end
  end
  if serverId and 0 < serverId and serverId ~= LuaEntry.Player:GetCurServerId() then
    return
  end
  serverId = DataCenter.SeasonDataManager:GetNinePalacesServer(5, ServerEnum.View)
  if serverId <= 0 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.CenterThroneActivityInfo, serverId)
end

function SeasonNineKingManager:SetThroneConnectedInfo(info)
  self.throneConnectedInfo = info
  local list, dic = info.ls, {}
  for _, v in ipairs(list) do
    if not string.IsNullOrEmpty(v.allianceId) then
      if not dic[v.allianceId] then
        dic[v.allianceId] = v
      else
        v.hide = true
      end
    end
  end
  if info.throne and not string.IsNullOrEmpty(info.throne.allianceId) then
    dic[info.throne.allianceId] = info.throne
  end
  self.allianceDic = dic
  EventManager:GetInstance():Broadcast(EventId.ThroneConnectedInfoUpdate)
end

function SeasonNineKingManager:OnGetInfo(msg)
  if self.activityId and self.activityId ~= msg.id then
    Logger.LogError("SeasonNineKingManager:OnGetInfo activityId mismatch:" .. tostring(self.activityId) .. "!=" .. tostring(msg.id))
    return
  end
  local data = DataCenter.ActivityListDataManager:GetActivityDataById(msg.id)
  if data then
    data.startTime = msg.startTime
    data.endTime = msg.endTime
  end
  if self.sourceInfo then
    self.sourceInfo.startTime = msg.startTime
    self.sourceInfo.endTime = msg.endTime
    self.sourceInfo.endViewTime = msg.endViewTime
    self.sourceInfo.needMainCityLevel = msg.needMainCityLevel
  end
  EventManager:GetInstance():Broadcast(EventId.NineNationKingBattleEventInfoUpdate)
end

function SeasonNineKingManager:WorldCityOwnerInfoChanged(serverId)
  if not self.throneConnectedInfo or not self:IsActive(true) then
    return
  end
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local seasonInfo = SeasonUtil.GetSeasonInfo(mySourceServerId)
  if seasonInfo == nil or not seasonInfo:IsInBattleServerGroupInt(serverId) then
    Logger.Log(string.format("SeasonNineKingManager:WorldCityOwnerInfoChanged: %s, %s", mySourceServerId, serverId))
    return
  end
  local list = self.throneConnectedInfo.ls
  if table.IsNullOrEmpty(list) then
    return
  end
  local midServerId = seasonInfo:GetNinePalacesServer(5)
  for _, v in ipairs(list) do
    local data = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(v.cityId, midServerId)
    if data then
      v.allianceId = data.allianceId or ""
      v.allianceAbbr = data.abbr or ""
      v.allianceName = data.allianceName or ""
      v.serverId = data.occupyServerId or 0
    else
      v.allianceId = ""
      v.allianceAbbr = ""
      v.allianceName = ""
      v.serverId = 0
    end
  end
  self:SetThroneConnectedInfo(self.throneConnectedInfo)
end

function SeasonNineKingManager:OnPassDay()
  if self.redPointCount > 0 or self:IsActive() then
    self._crossDayReload = true
    self.sourceInfo = nil
    DataCenter.SeasonNineKingManager:SendCenterThroneInfo()
  end
end

function SeasonNineKingManager:CenterThroneActivityInfo(msg)
  local serverId = msg.serverId
  if DataCenter.SeasonDataManager:IsInBattleServerGroup(msg.serverId) then
    local isFirstLoad = not self.sourceInfo
    if not self.sourceInfo then
      self:UpdateRewardCount(true)
    end
    local curWeek = msg.curWeek or 0
    local newWeekData = msg.weekData and msg.weekData[curWeek]
    local oldWeekData = self.sourceInfo and self.sourceInfo.weekData and self.sourceInfo.weekData[curWeek]
    local battleJustEnded = not isFirstLoad and newWeekData and newWeekData.fightEndTime and 0 < newWeekData.fightEndTime and (not oldWeekData or not oldWeekData.fightEndTime or 0 >= oldWeekData.fightEndTime)
    local passDayReload = isFirstLoad and self._crossDayReload
    self.sourceInfo = msg
    DataCenter.SeasonNineKingManager:TryShowWinner(battleJustEnded, passDayReload)
    self._crossDayReload = false
  end
  if self:CheckCenterServer(msg.serverId) then
    self.viewInfo = msg
  end
  EventManager:GetInstance():Broadcast(EventId.CenterThroneActivityInfoUpdate, serverId)
end

function SeasonNineKingManager:IsFighting(serverId)
  local throneActivityInfo
  if DataCenter.SeasonDataManager:IsInBattleServerGroup(serverId) then
    throneActivityInfo = self.sourceInfo
  elseif self:CheckCenterServer(serverId) then
    throneActivityInfo = self.viewInfo
  end
  if throneActivityInfo == nil then
    return false
  end
  local isFightEnd = throneActivityInfo.isFightEnd
  if isFightEnd == 1 then
    return false
  end
  local weekData = throneActivityInfo.weekData
  local weekShieldInfo = throneActivityInfo.weekShieldInfo
  local curWeek = throneActivityInfo.curWeek
  if weekShieldInfo == nil or weekData == nil or curWeek == -1 or weekShieldInfo[curWeek] == nil then
    return false
  end
  local shieldInfo = weekShieldInfo[curWeek]
  if shieldInfo == nil or shieldInfo.week == nil or shieldInfo.breakShieldTime == nil then
    return false
  end
  local theWeekData = weekData[curWeek]
  if theWeekData == nil or theWeekData.fightEndTime == nil then
    return false
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  return now > shieldInfo.breakShieldTime and (now < theWeekData.fightEndTime or theWeekData.fightEndTime == 0)
end

function SeasonNineKingManager:OnHeroEventUpdate()
  if not self:IsActive() then
    return
  end
  self:UpdateRewardCount()
end

function SeasonNineKingManager:UpdateRewardCount(forceRequest, clearCache_)
  local oldCount = self.redPointCount
  self.redPointCount = self:GetRedPointCount(forceRequest, clearCache_)
  if oldCount ~= self.redPointCount then
    EventManager:GetInstance():Broadcast(EventId.SeasonNineKingRewardRedPointChange, self.redPointCount)
  end
  return self.redPointCount
end

function SeasonNineKingManager:GetRedPointCount(forceRequest, clearCache_)
  if not self:IsActive() then
    return 0
  end
  local id, heroEventInfo = self:TryGetCurHeroEventInfo(forceRequest, nil, nil, clearCache_)
  if not heroEventInfo then
    return 0
  end
  local heroEventUserInfo = self:GetCurHeroEventUserInfo()
  if not heroEventUserInfo or 0 >= heroEventUserInfo.score then
    return 0
  end
  local count = #heroEventInfo.scoreBox
  local result = 0
  for i = 1, count do
    local boxState = self:GetScoreBoxState(heroEventInfo.scoreBox, heroEventUserInfo.score, i, heroEventUserInfo.scoreRewardIndex)
    if boxState == ActivityBoxState.CanOpen then
      result = result + 1
    end
  end
  return result
end

function SeasonNineKingManager:GetScoreBoxState(scoreBox, score, index, scoreRewardIndex)
  if scoreBox == nil then
    return ActivityBoxState.Close
  end
  local boxData = scoreBox[index]
  if boxData == nil then
    return ActivityBoxState.Close
  end
  local boxState = ActivityBoxState.Close
  if score >= boxData.target then
    boxState = ActivityBoxState.CanOpen
  end
  if DataCenter.ZoneWarManager:HasZoneScoreRewardOpen(scoreRewardIndex, index) then
    boxState = ActivityBoxState.Open
  end
  return boxState
end

function SeasonNineKingManager:GetCurHeroEventUserInfo()
  local result, theUuid
  local throneActivityInfo = DataCenter.SeasonNineKingManager.sourceInfo
  if throneActivityInfo then
    local curWeek = throneActivityInfo.curWeek
    local uuidList = throneActivityInfo.uuidList
    local curShieldInfo = throneActivityInfo.weekShieldInfo and throneActivityInfo.weekShieldInfo[curWeek]
    if uuidList and curShieldInfo and UITimeManager:GetInstance():IsTodayServer(curShieldInfo.breakShieldTime) then
      theUuid = uuidList[curWeek]
      result = RewardUtil.FetchHeroEventData(theUuid)
      if result then
        result.uuid = theUuid
      end
    end
  end
  return result or {
    uuid = theUuid or "",
    score = 0,
    scoreRewardIndex = {}
  }
end

function SeasonNineKingManager:TryGetCurHeroEventInfo(forceRequest, hero_event_id_use_, actData_, clearCache_)
  local throneActivityInfo = DataCenter.SeasonNineKingManager.sourceInfo
  if not throneActivityInfo then
    return
  end
  hero_event_id_use_ = hero_event_id_use_ or self:GetHeroEventIdUse(throneActivityInfo, actData_)
  if not hero_event_id_use_ then
    return
  end
  if clearCache_ then
    FetchHeroEventCfgInfo.ClearCache(hero_event_id_use_)
  end
  return hero_event_id_use_, FetchHeroEventCfgInfo.GetCfgInfo(hero_event_id_use_, true, forceRequest)
end

function SeasonNineKingManager:GetHeroEventIdUse(throneActivityInfo, actData)
  if throneActivityInfo == nil then
    return
  end
  actData = actData or DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  local hero_event_ids, hero_event_id_use
  if actData and actData.para_1 then
    hero_event_ids = string.split_ii_array(actData.para_1, "|")
  end
  if hero_event_ids then
    local curWeek = toInt(throneActivityInfo.curWeek)
    for k, v in ipairs(hero_event_ids) do
      if k == curWeek then
        hero_event_id_use = v
        break
      end
    end
  end
  return hero_event_id_use
end

function SeasonNineKingManager:HandleRewardList(msg, rewardType)
  self.reward[rewardType or 1] = msg
  EventManager:GetInstance():Broadcast(EventId.CenterThroneActivityRewardShow)
end

function SeasonNineKingManager:GetRewardList(rewardType)
  return self.reward[rewardType or 1] or {}
end

return SeasonNineKingManager
