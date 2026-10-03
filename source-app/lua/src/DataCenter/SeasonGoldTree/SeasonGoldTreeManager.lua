local SeasonGoldTreeManager = BaseClass("SeasonGoldTreeManager")
local Localization = CS.GameEntry.Localization
local GoldTreeInfo = require("DataCenter.SeasonGoldTree.Data.GoldTreeInfo")
local UserGoldTreeDataInfo = require("DataCenter.SeasonGoldTree.Data.UserGoldTreeDataInfo")
local AnnounceInfo = require("DataCenter.SeasonGoldTree.Data.AnnounceInfo")

function SeasonGoldTreeManager:__init()
  self.init = false
  self.activityId = nil
  self.goldTreeInfo = nil
  self.userGoldTreeInfo = nil
  self.announceMap = nil
  self.rankData = nil
  self.startDay = 2
  self.endDay = 6
  self:AddListener()
end

function SeasonGoldTreeManager:__delete()
  self:RemoveListener()
end

function SeasonGoldTreeManager:Init()
  if not self:IsActive() then
    return
  end
  self.announceMap = {}
  local cycle = DataCenter.SeasonGoldTreeTemplateManager:GetGoldTreeTemp("cycle")
  if not string.IsNullOrEmpty(cycle) then
    local param = string.split(cycle, "|")
    self.startDay = param[1] and tonumber(param[1]) or self.startDay
    self.endDay = param[2] and tonumber(param[2]) or self.endDay
  end
end

function SeasonGoldTreeManager:Startup()
end

function SeasonGoldTreeManager:AddListener()
  EventManager:GetInstance():AddListenerWithSelf(EventId.OnEnterWorld, self.OnEnterWorld, self)
end

function SeasonGoldTreeManager:RemoveListener()
  EventManager:GetInstance():RemoveListener2(EventId.OnEnterWorld, self.OnEnterWorld, self)
end

function SeasonGoldTreeManager:InitData(data)
  self.activityId = data.id
  self:Init()
  SFSNetwork.SendMessage(MsgDefines.GoldTreeActView)
end

function SeasonGoldTreeManager:GetConfigData(id)
  return DataCenter.SeasonGoldTreeManager:GetConfigData(id)
end

function SeasonGoldTreeManager:OnEnterWorld()
  self.rankData = nil
  if not table.IsNullOrEmpty(self.announceMap) then
    self.announceMap = {}
  end
end

function SeasonGoldTreeManager:IsActive(includePrepare)
  return SeasonUtil.IsSeasonActivityOpen(self.activityId, nil, includePrepare, true)
end

function SeasonGoldTreeManager:GetActivityData(includePrepare)
  if not self:IsActive(includePrepare) then
    return
  end
  return DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
end

function SeasonGoldTreeManager:GetActivityEndTime()
  local activityData = self:GetActivityData()
  return activityData and activityData.endTime or 0
end

function SeasonGoldTreeManager:OpenUI()
  if not self:IsActive() then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSingleActivityContainer, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, self.activityId)
end

function SeasonGoldTreeManager:IsCharge()
  return not self.goldTreeInfo or self.goldTreeInfo:IsCharge()
end

function SeasonGoldTreeManager:OpenCard(day)
  day = day or UITimeManager:GetInstance():GetNowWeekdayIndex()
  if self:HasOpen(day) then
    return
  end
  local weekTime = self.userGoldTreeInfo and self.userGoldTreeInfo.weekTime
  SFSNetwork.SendMessage(MsgDefines.GoldTreeOpenCard, day, weekTime)
end

function SeasonGoldTreeManager:IsAvailable(day, today)
  today = today or UITimeManager:GetInstance():GetNowWeekdayIndex()
  if today < self.startDay then
    today = today + 7
  end
  return day <= today
end

function SeasonGoldTreeManager:HasOpen(day)
  return self.userGoldTreeInfo and self.userGoldTreeInfo:HasPray(day)
end

function SeasonGoldTreeManager:GetPrayCardInfo(day)
  if not self.userGoldTreeInfo then
    return nil
  end
  local cardInfo = self.userGoldTreeInfo.userGoldTreeCardMap[day]
  if cardInfo then
    return cardInfo
  end
end

function SeasonGoldTreeManager:GetNextPrayTime()
  if not self:IsActive() or self:IsCharge() then
    return
  end
  local day = UITimeManager:GetInstance():GetNowWeekdayIndex()
  if day >= self.startDay and day <= self.endDay and not self:HasOpen(day) then
    return 0
  end
  local endTime = self:GetActivityEndTime()
  local nowTime = UITimeManager:GetInstance():GetServerTime()
  if 0 < endTime and endTime <= nowTime then
    return
  end
  local dayDelta = 1
  if day < self.startDay then
    dayDelta = self.startDay - day
  elseif day >= self.endDay then
    dayDelta = 7 - day + self.startDay
  end
  local nextTime = UITimeManager:GetInstance():GetFutureDayZero(nowTime, dayDelta)
  if 0 < endTime and endTime <= nextTime then
    return
  end
  return nextTime
end

function SeasonGoldTreeManager:GetNextWeekPrayTime()
  if not self:IsActive() or self:IsCharge() then
    return
  end
  local dayDelta = 0
  local day = UITimeManager:GetInstance():GetNowWeekdayIndex()
  if day < self.startDay then
    dayDelta = self.startDay - day
  else
    dayDelta = 7 - day + self.startDay
  end
  local endTime = self:GetActivityEndTime()
  local nowTime = UITimeManager:GetInstance():GetServerTime()
  local nextTime = UITimeManager:GetInstance():GetFutureDayZero(nowTime, dayDelta)
  if 0 < endTime and endTime <= nextTime then
    return
  end
  return nextTime
end

function SeasonGoldTreeManager:GetPrayWeek(timeStamp)
  local startTime = (not self.userGoldTreeInfo or not self.userGoldTreeInfo.seasonFirstFinishPowerTime) and self.goldTreeInfo and self.goldTreeInfo.finishTime
  if not startTime or startTime <= 0 then
    return 0
  end
  local startWeekZero = self:GetWeekZero(startTime)
  timeStamp = timeStamp or UITimeManager:GetInstance():GetServerTime()
  local nowWeekZero = self:GetWeekZero(timeStamp)
  return math.floor((nowWeekZero - startWeekZero) / (OneWeekTime * 1000)) + 1
end

function SeasonGoldTreeManager:GetWeekZero(timeStamp)
  local day = UITimeManager:GetInstance():GetWeekdayIndex(timeStamp)
  if self.startDay > 1 and day < self.startDay then
    timeStamp = timeStamp - OneWeekTime * 1000
  end
  return UITimeManager:GetInstance():WeekZero(timeStamp), day
end

function SeasonGoldTreeManager:CanPrayCardCount()
  if not self:IsActive() or self:IsCharge() then
    return 0
  end
  local nowTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = self:GetActivityEndTime()
  if endTime <= 0 or nowTime >= endTime then
    return 0
  end
  if not self.userGoldTreeInfo or not self.userGoldTreeInfo:IsActive() then
    return 0
  end
  local today = UITimeManager:GetInstance():GetNowWeekdayIndex()
  local count = 0
  for i = self.startDay, self.endDay do
    if self:IsAvailable(i, today) and not self:HasOpen(i) then
      count = count + 1
    end
  end
  return count
end

function SeasonGoldTreeManager:GetUserGoldTreeInfo()
  return self.userGoldTreeInfo
end

function SeasonGoldTreeManager:RequestAnnounceList(weekNum, serverId)
  weekNum = weekNum or 0
  local lastData = self.announceMap and self.announceMap[weekNum]
  if lastData and lastData.lastTime and (not serverId or lastData.serverId == serverId) and UITimeManager:GetInstance():GetServerTime() - lastData.lastTime < 15000 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.GoldTreeAnnounceView, weekNum, serverId)
end

function SeasonGoldTreeManager:GoldTreeActViewMessage(goldTreeInfo, userGoldTreeInfo)
  if goldTreeInfo then
    if self.goldTreeInfo then
      self.goldTreeInfo:RefreshData(goldTreeInfo)
    else
      self.goldTreeInfo = GoldTreeInfo.New(goldTreeInfo)
    end
  end
  if userGoldTreeInfo then
    if self.userGoldTreeInfo then
      self.userGoldTreeInfo:RefreshData(userGoldTreeInfo)
    else
      self.userGoldTreeInfo = UserGoldTreeDataInfo.New(userGoldTreeInfo)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonGoldTreeInfo)
end

function SeasonGoldTreeManager:PushGoldTreePowerFinishMessage(msg)
  if self.goldTreeInfo then
    self.goldTreeInfo:OnPowerFinish(msg)
    EventManager:GetInstance():Broadcast(EventId.SeasonGoldTreeInfo)
  end
end

function SeasonGoldTreeManager:GoldTreeOpenCardMessage(msg)
  if self.userGoldTreeInfo then
    self.userGoldTreeInfo:RefreshData(msg.userGoldTreeDataInfo)
  end
  if not table.IsNullOrEmpty(msg.cardReward) then
    DataCenter.RewardManager:AddRewards(msg.cardReward)
  end
  if not table.IsNullOrEmpty(msg.combinationRewardArr) then
    DataCenter.RewardManager:AddRewards(msg.combinationRewardArr)
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.GoldTreeResult, {anim = true}, msg)
end

local function __SortAnnounceInfo(a, b)
  return a.combinationId < b.combinationId
end

function SeasonGoldTreeManager:GoldTreeAnnounceViewMessage(msg)
  local announceList = {}
  if msg.announceArr then
    for _, announceInfo in ipairs(msg.announceArr) do
      table.insert(announceList, AnnounceInfo.New(announceInfo))
    end
    table.sort(announceList, __SortAnnounceInfo)
  end
  msg.announceArr = announceList
  if self.announceMap == nil then
    self.announceMap = {}
  end
  self.announceMap[-1] = msg
  if msg.serverId == LuaEntry.Player:GetSourceServerId() then
    msg.lastTime = UITimeManager:GetInstance():GetServerTime()
    self.announceMap[msg.weekNum] = msg
  end
  EventManager:GetInstance():Broadcast(EventId.GoldTreeAnnouncement, msg)
end

function SeasonGoldTreeManager:GoldTreePowerRankViewMessage(msg)
  if not msg then
    return
  end
  local selfUid = LuaEntry.Player.uid
  local selfData
  if msg.ranks then
    for i, v in ipairs(msg.ranks) do
      v.rank = v.rank or i
      v.score = v.score or 0
      if v.uid == selfUid then
        selfData = v
      end
    end
  end
  if msg.rank and msg.rank > 0 and not selfData then
    local player = LuaEntry.Player
    local playerInfo = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(player.uid, true)
    selfData = {}
    selfData.rank = msg.rank
    selfData.score = msg.score
    selfData.uid = player.uid
    selfData.pic = player.pic
    selfData.picver = player.picVer
    selfData.headSkinId = playerInfo and playerInfo.headSkinId or 0
    selfData.headSkinET = playerInfo and playerInfo.headSkinET or 0
    selfData.name = player.name
    selfData.abbr = playerInfo and playerInfo.alAbbr or ""
    selfData.serverId = player.serverId
  end
  msg.selfData = selfData
  self.rankData = msg
  EventManager:GetInstance():Broadcast(EventId.GoldTreePowerRank, msg.treeId)
end

return SeasonGoldTreeManager
