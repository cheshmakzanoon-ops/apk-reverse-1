local LWAllyStationDataManager = BaseClass("LWAllyStationDataManager")
local TrainData = require("DataCenter.LWRailway.Train.TrainData")
local PlatformData = require("DataCenter.LWRailway.Station.PlatformData")
local Localization = CS.GameEntry.Localization

function LWAllyStationDataManager:__init()
  self:AddListener()
  self.allyTrains = {}
  self.platforms = {}
  self.todayBuyCount = 0
  self.buyCountOverTime = 0
  self.defaultList = {}
  self.trainThumbsUpList = nil
  self.alreadyThumbsUp = false
  self.thumbsUpCanReward = false
  self.closeStartTime = -1
  self.closeEndTime = -1
  self.isNewTrainFunctionOn = false
  self.skipJoinAllianceCD = false
  self.alreadyThumbsUpVip = false
  self.toggleNumsSelectGet = true
  self.freeRefreshTimes = 0
end

function LWAllyStationDataManager:__delete()
  self.closeStartTime = -1
  self.closeEndTime = -1
  self.isNewTrainFunctionOn = false
  self.cacheRefreshGoldTrainTimes = nil
  self.cacheJudgeHighGoodsStandardList = nil
  self:RemoveListener()
  self:ClearData()
  self:ClearTimer()
end

function LWAllyStationDataManager:GetMeta(index)
  local meta = LocalController:instance():getLine(TableName.LW_Train_Para, index)
  return meta and meta.val
end

function LWAllyStationDataManager:Startup()
  self.MAX_DAILY_BUY = LuaEntry.DataConfig:TryGetNum("alliance_train", "k3", 6)
  self.BUY_TRAIN_COST_ITEM = LuaEntry.DataConfig:TryGetNum("alliance_train", "k5", 1520003)
  self.CHANGE_TRAIN_COST_ITEM = LuaEntry.DataConfig:TryGetNum("alliance_train", "k7", 1520004)
  self.CHANGE_TRAIN_COST_NUM = LuaEntry.DataConfig:TryGetNum("alliance_train", "k18", 1)
  self.MAX_LOOT_PER_TRAIN = LuaEntry.DataConfig:TryGetNum("alliance_train", "k10", 3)
  self.CHECK_TICKET_TIME = LuaEntry.DataConfig:TryGetNum("alliance_train", "k14", 5) * 60000
  self.BUY_TRAIN_GIFT_ID = tostring(LuaEntry.DataConfig:TryGetNum("alliance_train", "k21", 720008))
  self.Train_Speed_Param = DataCenter.LWAllianceRightShowTemplateManager:GetTemplate(801)
  self.Delete_Train_Times = DataCenter.LWAllianceRightShowTemplateManager:GetTemplate(1201)
end

function LWAllyStationDataManager:OnEnterGame()
  self.MAX_PASSENGER = tonumber(self:GetMeta(42))
  self.JOIN_ALLIANCE_TIME_LIMIT = LuaEntry.DataConfig:TryGetNum("alliance_train", "k12", 0) * 60 * 60 * 1000
  local thanks = self:GetMeta(40)
  if not string.IsNullOrEmpty(thanks) then
    self.thanksLangList = string.split(thanks, ",")
  else
    self.thanksLangList = {}
  end
  self.thanksLangListCount = #self.thanksLangList
  local passengers = self:GetMeta(41)
  if not string.IsNullOrEmpty(passengers) then
    self.passengersLangList = string.split(passengers, ",")
  else
    self.passengersLangList = {}
  end
  self.passengersLangListCount = #self.passengersLangList
  local emojis = self:GetMeta(43)
  if not string.IsNullOrEmpty(emojis) then
    local emojiArray = string.split(emojis, ",")
    self.emojiList = {}
    for _, v in ipairs(emojiArray) do
      table.insert(self.emojiList, tonumber(v) or 59)
    end
  else
    self.emojiList = {}
  end
  self.emojiListCount = #self.emojiList
  self.seasonSceneMap = nil
  self.seasonLoadingMap = nil
  self.urTrainRewardHighlightList = nil
  self.urTrainRewardHighlightMap = nil
  self.thanksItemMin = 1
  self.thanksItemMax = 3
  local thanksItemData = self:GetMeta(47)
  if not string.IsNullOrEmpty(thanksItemData) then
    local thanksItemDataArray = string.split(thanksItemData, ";")
    if #thanksItemDataArray == 2 then
      self.thanksItemMin = tonumber(thanksItemDataArray[1]) or 1
      self.thanksItemMax = tonumber(thanksItemDataArray[2]) or 3
    end
  end
  self.bubbleShowMember = 0
  self.bubbleShowTimerMin = 0
  self.bubbleShowTimerMax = 0
  local bubbleData = self:GetMeta(48)
  if not string.IsNullOrEmpty(bubbleData) then
    local dataArray = string.split(bubbleData, ";")
    if #dataArray == 3 then
      self.bubbleShowMember = tonumber(dataArray[1]) or 0
      self.bubbleShowTimerMin = tonumber(dataArray[2]) or 0
      self.bubbleShowTimerMax = tonumber(dataArray[3]) or 0
    end
  end
end

function LWAllyStationDataManager:ClearData()
  self.buyCountOverTime = 0
  self.todayBuyCount = 0
  self.trainThumbsUpList = nil
  self.alreadyThumbsUp = false
  self.thumbsUpCanReward = false
  self.alreadyThumbsUpVip = false
  self.toggleNumsSelectGet = nil
  self:RemoveAllAllyTrain()
  self:RemoveAllPlatform()
end

function LWAllyStationDataManager:AddListener()
end

function LWAllyStationDataManager:RemoveListener()
end

function LWAllyStationDataManager:InitMsg(msg)
  self:OnRefreshStartInfo(msg.allianceTrainStartInfo)
end

function LWAllyStationDataManager:InitData(msg)
  self:TryGetAllyStationData()
end

function LWAllyStationDataManager:TryGetAllyStationData()
  if not self:IsTrainFunctionLock() then
    local now = UITimeManager:GetInstance():GetServerSeconds()
    if self.lastSendTime and now < self.lastSendTime + 5 then
      return
    end
    self.lastSendTime = now
    SFSNetwork.SendMessage(MsgDefines.AllianceTrainInfo)
  end
end

function LWAllyStationDataManager:OnAllyStationDataGet(msg)
  self:RefreshAllyStationData(msg)
  self:RefreshRailwayStationView()
end

function LWAllyStationDataManager:PushAllyTrainAdd(msg)
  self:AddOrUpdateOneAllyTrain(msg)
  self:RefreshRailwayStationView()
end

function LWAllyStationDataManager:PushAllyTrainRefresh(msg)
  self:AddOrUpdateOneAllyTrain(msg)
  self:RefreshRailwayStationView()
end

function LWAllyStationDataManager:PushAllyTrainDel(msg)
  self:DelOneAllyTrain(msg)
  EventManager:GetInstance():Broadcast(EventId.DelAllyTrain)
end

function LWAllyStationDataManager:PushPlatformAdd(msg)
  self:AddOrUpdateOnePlatform(msg)
  self:RefreshRailwayStationView()
end

function LWAllyStationDataManager:PushPlatformRefresh(msg)
  self:AddOrUpdateOnePlatform(msg)
  self:RefreshRailwayStationView()
end

function LWAllyStationDataManager:RecMsgPushAllianceJoin()
  self:TryGetAllyStationData()
end

function LWAllyStationDataManager:RecMsgPushAllianceLeave()
  self:RefreshAllyStationData()
  self:RefreshRailwayStationView()
end

function LWAllyStationDataManager:On3v3BattleFinish(msg)
  EventManager:GetInstance():Broadcast(EventId.Arena3V3BattleFinish, msg)
end

function LWAllyStationDataManager:OnKOFBattleFinish(msg)
  EventManager:GetInstance():Broadcast(EventId.KOFBattleFinish, msg)
end

function LWAllyStationDataManager:OnFormationGet(msg)
  local isNewTrain = self:IsNewTrainFunctionOn()
  if isNewTrain then
    if msg.type == 1 then
      for i = 1, 3 do
        local teamInfo = msg.formation["armyUnit" .. i]
        DataCenter.LWKOFBattleManager:ParseOneAtkTeam(TypeKOF.Train, i, teamInfo)
      end
      DataCenter.LWKOFBattleManager:RobTrain()
    elseif msg.type == 2 then
      for i = 1, 3 do
        local teamInfo = msg.formation["armyUnit" .. i]
        DataCenter.LWKOFBattleManager:ParseOneDefenseTeam(TypeKOF.Train, LuaEntry.Player.uid, i, teamInfo)
      end
    end
  elseif msg.type == 1 then
    for i = 1, 3 do
      local teamInfo = msg.formation["armyUnit" .. i]
      DataCenter.LW3V3Manager:ParseOneAtkTeam(Type3v3.Train, i, teamInfo)
    end
    DataCenter.LW3V3Manager:RobTrain()
  elseif msg.type == 2 then
    for i = 1, 3 do
      local teamInfo = msg.formation["armyUnit" .. i]
      DataCenter.LW3V3Manager:ParseOneDefenseTeam(Type3v3.Train, LuaEntry.Player.uid, i, teamInfo)
    end
  end
end

function LWAllyStationDataManager:OnAllianceTrainBuySuccess(msg)
  self.buyCountOverTime = msg.buyCountOverTime
  self.todayBuyCount = msg.todayBuyCount
  EventManager:GetInstance():Broadcast(EventId.AllianceTrainBuySuccess)
end

function LWAllyStationDataManager:OnAllianceTrainThumbsUpList(msg)
  if msg.array then
    self.trainThumbsUpList = msg.array
    self.alreadyThumbsUp = false
    self.thumbsUpCanReward = false
    local myUid = LuaEntry.Player.uid
    for _, v in ipairs(self.trainThumbsUpList) do
      if v.uid == myUid then
        self.alreadyThumbsUp = true
        if self.thumbsUpCanReward then
          break
        end
      end
      if v.num > 0 and v.state ~= 1 then
        self.thumbsUpCanReward = true
        if self.alreadyThumbsUp then
          break
        end
      end
    end
  else
    self.trainThumbsUpList = nil
    self.alreadyThumbsUp = false
    self.thumbsUpCanReward = false
  end
  if msg.reward then
    DataCenter.RewardManager:ShowCommonReward(msg)
    DataCenter.RewardManager:AddRewardsAndRes(msg)
  end
  EventManager:GetInstance():Broadcast(EventId.AllianceTrainThumbsUpListReceived)
end

function LWAllyStationDataManager:OnAllianceTrainThumbsUp(msg)
  if msg.suc then
    self.alreadyThumbsUp = true
    EventManager:GetInstance():Broadcast(EventId.AllianceTrainThumbsUpReceived)
  end
end

function LWAllyStationDataManager:OnPushAllianceTrainThumbsUp(msg)
  if self.thumbsUpCanReward == false and self.trainThumbsUpList ~= nil then
    if msg.num > 0 and msg.state ~= 1 then
      self.thumbsUpCanReward = true
    end
  elseif self.trainThumbsUpList == nil and msg.num > 0 and msg.state ~= 1 then
    local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
    if trainData and trainData:IsMyTrain() then
      DataCenter.LWAllyStationDataManager:GetAllianceTrainThumbsUpList(1, true)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.OnPushAllianceTrainThumbsUp, msg)
  local pos = Vector3.New(41.65, 13, 80.15)
  local text = Localization:GetString("alliance_train_036")
  local icon
  UIUtil.ShowThumbsUpBroadcastPopUIInCity(pos, msg, text, icon)
end

function LWAllyStationDataManager:ThumbsTest()
  local pos = Vector3.New(41.65, 13, 80.15)
  UIUtil.ShowThumbsUpBroadcastPopUIInCity(pos, {})
end

function LWAllyStationDataManager:OnAllianceTrainVipHasThumbs(msg)
  self.alreadyThumbsUpVip = msg.suc
  EventManager:GetInstance():Broadcast(EventId.AllianceTrainVipThumbsUpResult, self.alreadyThumbsUpVip)
end

function LWAllyStationDataManager:SendAllianceTrainVipThumbsUp(platformId)
  SFSNetwork.SendMessage(MsgDefines.AllianceTrainVipThumbsUp, platformId)
end

function LWAllyStationDataManager:SendAllianceTrainVipHasThumbsUp(platformId)
  SFSNetwork.SendMessage(MsgDefines.AllianceTrainVipHasThumbsUp, platformId)
end

function LWAllyStationDataManager:GetAlreadyThumbsUpVipValue()
  return self.alreadyThumbsUpVip
end

function LWAllyStationDataManager:OnAllianceTrainHasThumbs(msg)
  self.alreadyThumbsUp = msg.suc
end

function LWAllyStationDataManager:SendAllianceTrainThumbsUp(platformId, num, index)
  SFSNetwork.SendMessage(MsgDefines.AllianceTrainThumbsUp, platformId, num, index)
end

function LWAllyStationDataManager:GetAllianceTrainThumbsUpList(platformId, onlyList)
  SFSNetwork.SendMessage(MsgDefines.AllianceTrainThumbsUpList, platformId, onlyList)
end

function LWAllyStationDataManager:GetAllianceTrainHasThumbs(platformId)
  SFSNetwork.SendMessage(MsgDefines.AllianceTrainHasThumbs, platformId)
end

function LWAllyStationDataManager:OnPushAllianceTrainStartInfo(message)
  self:OnRefreshStartInfo(message)
end

function LWAllyStationDataManager:RefreshAllyStationData(msg)
  self:ClearData()
  if msg then
    self:AddAllAllyTrain(msg.trainList)
    if msg.station then
      self.buyCountOverTime = msg.station.buyCountOverTime
      self.todayBuyCount = msg.station.todayBuyCount
      self:AddAllPlatform(msg.station.trainPlatform)
    end
    self.freeRefreshTimes = msg.remainFreeCount or 0
  end
end

function LWAllyStationDataManager:RemoveAllPlatform()
  if self.platforms then
    for _, v in pairs(self.platforms) do
      v:Destroy()
    end
  end
  self.platforms = {}
end

function LWAllyStationDataManager:AddAllPlatform(platformMsg)
  if not platformMsg then
    return
  end
  for _, msg in pairs(platformMsg) do
    self.platforms[msg.platformId] = PlatformData.New(msg)
    self:GetThePlatformVipInfo(self.platforms[msg.platformId])
  end
end

function LWAllyStationDataManager:AddOrUpdateOnePlatform(msg)
  if not msg then
    return
  end
  if self.platforms[msg.platformId] then
    self.platforms[msg.platformId]:Refresh(msg)
  else
    self.platforms[msg.platformId] = PlatformData.New(msg)
  end
  self:GetThePlatformVipInfo(self.platforms[msg.platformId])
end

function LWAllyStationDataManager:GetThePlatformVipInfo(platform)
  if platform.vipInvite and platform.vipInvite.vipId == LuaEntry.Player.uid then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < platform.vipInvite.endTime then
      EventManager:GetInstance():Broadcast(EventId.AllianceTrainVipInfo, platform.vipInvite)
    end
  end
end

function LWAllyStationDataManager:RemoveAllAllyTrain()
  if self.allyTrains then
    for k, v in pairs(self.allyTrains) do
      v:Destroy()
    end
  end
  self.allyTrains = {}
end

local rapidjson = require("rapidjson")

function LWAllyStationDataManager:AddAllAllyTrain(trainsMsg)
  if not trainsMsg then
    return
  end
  local jsonData = rapidjson.encode(trainsMsg)
  Logger.Log("TrainData:" .. jsonData)
  for _, msg in pairs(trainsMsg) do
    self.allyTrains[msg.uuid] = TrainData.New(msg)
  end
end

function LWAllyStationDataManager:AddOrUpdateOneAllyTrain(msg)
  if not msg then
    return
  end
  local jsonData = rapidjson.encode(msg)
  Logger.Log("TrainData:" .. jsonData)
  if self.allyTrains[msg.uuid] then
    self.allyTrains[msg.uuid]:Refresh(msg)
  else
    self.allyTrains[msg.uuid] = TrainData.New(msg)
  end
end

function LWAllyStationDataManager:DelOneAllyTrain(msg)
  if self.allyTrains[msg.uuid] then
    self.allyTrains[msg.uuid]:Destroy()
    self.allyTrains[msg.uuid] = nil
  end
end

function LWAllyStationDataManager:OnRefreshStartInfo(message)
  local oldStartTime = self.closeStartTime
  local oldEndTime = self.closeEndTime
  local oldFunctionOn = self.isNewTrainFunctionOn
  local closeStartTime = 0
  local closeEndTime = 0
  local isNewTrainFunctionOn = false
  if message ~= nil then
    closeStartTime = message.startTime or 0
    closeEndTime = message.endTime or 0
    isNewTrainFunctionOn = message.isFunctionOn or false
    Logger.LogInfo("OnRefreshTrainStartInfo : closeStartTime : " .. closeStartTime .. " ; closeEndTime : " .. closeEndTime .. " ; isNewTrainFunctionOn : " .. tostring(isNewTrainFunctionOn))
  end
  if oldStartTime == closeStartTime and oldEndTime == closeEndTime and oldFunctionOn == isNewTrainFunctionOn then
    return
  end
  local oldClosed = self:IsTrainClosed()
  self.closeStartTime = closeStartTime
  self.closeEndTime = closeEndTime
  self.isNewTrainFunctionOn = isNewTrainFunctionOn
  self:RefreshTimer()
  if oldStartTime < 0 or oldEndTime < 0 then
    return
  end
  self:RefreshRailwayStationView()
  EventManager:GetInstance():Broadcast(EventId.OnAllianceTrainStartInfoChanged)
  local closed = self:IsTrainClosed()
  if not oldClosed and closed then
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UITrainPrepare) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UITrainPrepare)
    end
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UITrainPrepareScene) or DataCenter.LWTrainPrepareSceneManager.dataValid then
      DataCenter.LWTrainPrepareSceneManager:Exit()
    end
  end
end

function LWAllyStationDataManager:RefreshRailwayStationView()
  EventManager:GetInstance():Broadcast(EventId.RefreshTrainStationView)
end

function LWAllyStationDataManager:GetTrainByPlatformId(id)
  if self.platforms[id] == nil then
    return nil
  end
  local trainUuid = self.platforms[id].trainUuid
  if trainUuid and 0 < trainUuid then
    return self.allyTrains[trainUuid]
  end
  return nil
end

function LWAllyStationDataManager:GetMyTravelingTrain()
  for k, v in pairs(self.allyTrains) do
    if v:GetTrainState() == TrainState.Travelling then
      return v
    end
  end
end

function LWAllyStationDataManager:GetAllyTrainByUuid(uuid)
  return self.allyTrains[uuid]
end

function LWAllyStationDataManager:GetAllyTrains()
  return self.allyTrains
end

function LWAllyStationDataManager:GetAllyDepartureTrains()
  local ret = {}
  for _, v in pairs(self.allyTrains) do
    if v:GetTrainState() > TrainState.BeforeDeparture then
      table.insert(ret, v)
    end
  end
  return ret
end

function LWAllyStationDataManager:GetPlatform(id)
  return self.platforms[id]
end

function LWAllyStationDataManager:BuyCount()
  return self.todayBuyCount, self.MAX_DAILY_BUY
end

function LWAllyStationDataManager:IsTrainFunctionLock()
  local id = DataCenter.MonopolyManager.player.curId
  if id and id < DataCenter.LWMyStationDataManager:GET_TRAIN_FOG_ID() then
    return true
  end
  if self:IsTrainActivityOpen() then
    return false
  end
  return true
end

function LWAllyStationDataManager:IsTrainActivityOpen()
  local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.TrainActivity.Type)
  if dataList and dataList[1] and DataCenter.ActivityListDataManager:CheckIsSend(dataList[1]) then
    return true
  end
  return false
end

function LWAllyStationDataManager:GetThumbsUpList()
  return self.trainThumbsUpList and self.trainThumbsUpList or self.defaultList
end

function LWAllyStationDataManager:AlreadyThumbsUp()
  return self.alreadyThumbsUp
end

function LWAllyStationDataManager:ThumbsUpCanReward()
  return self.thumbsUpCanReward
end

function LWAllyStationDataManager:RandomThanksLangIndex()
  if self.thanksLangListCount > 0 then
    return Mathf.Random(1, self.thanksLangListCount)
  end
  return 0
end

function LWAllyStationDataManager:GetThanksLang(index)
  if self.thanksLangListCount > 0 then
    local ind = Mathf.Clamp(index, 1, self.thanksLangListCount)
    return self.thanksLangList[ind]
  end
  return nil
end

function LWAllyStationDataManager:GetPassengerLang()
  if self.passengersLangListCount > 0 then
    local ind = Mathf.Random(1, self.passengersLangListCount)
    return self.passengersLangList[ind]
  end
  return nil
end

function LWAllyStationDataManager:GetEmoji(index)
  if self.emojiListCount > 0 then
    local ind = Mathf.Clamp(index, 1, self.emojiListCount)
    return self.emojiList[ind]
  end
  return nil
end

function LWAllyStationDataManager:IsNewTrainFunctionOn()
  return self.isNewTrainFunctionOn
end

function LWAllyStationDataManager:IsTrainClosed()
  if self.closeStartTime > 0 and 0 < self.closeEndTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    if now >= self.closeStartTime and now <= self.closeEndTime then
      return true, self.closeEndTime
    end
  end
  return false
end

function LWAllyStationDataManager:GetPrepareScenePath()
  if self.seasonSceneMap == nil then
    local scenePaths = self:GetMeta(44)
    if not string.IsNullOrEmpty(scenePaths) then
      self.seasonSceneMap = {}
      local pathArray = string.split(scenePaths, "|")
      for _, v in ipairs(pathArray) do
        if not string.IsNullOrEmpty(v) then
          local array = string.split(v, ";")
          local seasonId = tonumber(array[1])
          local path = array[2]
          self.seasonSceneMap[seasonId] = path
        end
      end
    else
      self.seasonSceneMap = {}
    end
  end
  local curSeason = SeasonUtil.GetSeason()
  local path = self.seasonSceneMap[curSeason]
  if path == nil then
    return self.seasonSceneMap[-1]
  end
  return path
end

function LWAllyStationDataManager:GetTrainRobLoadingImg(ur)
  if self.seasonLoadingMap == nil then
    local loadingPaths = self:GetMeta(45)
    if not string.IsNullOrEmpty(loadingPaths) then
      self.seasonLoadingMap = {}
      local pathArray = string.split(loadingPaths, "|")
      for _, v in ipairs(pathArray) do
        if not string.IsNullOrEmpty(v) then
          local array = string.split(v, ";")
          local seasonId = tonumber(array[1])
          local normalPath = array[2]
          local urPath = array[3]
          self.seasonLoadingMap[seasonId] = {normalPath, urPath}
        end
      end
    else
      self.seasonLoadingMap = {}
    end
  end
  local index = ur == true and 2 or 1
  local curSeason = SeasonUtil.GetSeason()
  local data = self.seasonLoadingMap[curSeason]
  if data == nil then
    data = self.seasonLoadingMap[-1]
  end
  if data then
    return data[index]
  end
  return nil
end

function LWAllyStationDataManager:GetURTrainRewardHighlight()
  if self.urTrainRewardHighlightList == nil then
    local rewardData = self:GetMeta(46)
    if not string.IsNullOrEmpty(rewardData) then
      self.urTrainRewardHighlightList = {}
      self.urTrainRewardHighlightMap = {}
      local rewardArray = string.split(rewardData, ";")
      for _, v in ipairs(rewardArray) do
        local ind = tonumber(v) or 0
        if 0 < ind then
          table.insert(self.urTrainRewardHighlightList, ind)
          self.urTrainRewardHighlightMap[ind] = #self.urTrainRewardHighlightList
        end
      end
    else
      self.urTrainRewardHighlightList = {}
    end
  end
  return self.urTrainRewardHighlightList
end

function LWAllyStationDataManager:GetURTrainRewardHighlightIndex(index)
  if self.urTrainRewardHighlightMap == nil then
    return -1
  end
  return self.urTrainRewardHighlightMap[index] or -1
end

function LWAllyStationDataManager:GetThanksItemMin()
  return self.thanksItemMin or 1
end

function LWAllyStationDataManager:GetThanksItemMax()
  return self.thanksItemMax or 1
end

function LWAllyStationDataManager:GetBubbleShowMember()
  return self.bubbleShowMember or 0
end

function LWAllyStationDataManager:GetBubbleShowTimer()
  if self.bubbleShowTimerMax > 0 then
    return Mathf.Random(self.bubbleShowTimerMin, self.bubbleShowTimerMax)
  end
  return 0
end

function LWAllyStationDataManager:ClearTimer()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function LWAllyStationDataManager:RefreshTimer()
  self:ClearTimer()
  if self.closeStartTime > 0 and 0 < self.closeEndTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local diff = self.closeStartTime - curTime
    if diff < 0 then
      diff = self.closeEndTime - curTime
    end
    if 0 < diff then
      diff = math.ceil((diff + 500) / 1000)
      self.timer = TimerManager:GetInstance():DelayInvoke(function()
        DataCenter.LWAllyStationDataManager:OnTimer()
      end, diff)
    end
  end
end

function LWAllyStationDataManager:OnTimer()
  self:RefreshRailwayStationView()
  self:RefreshTimer()
  local closed = self:IsTrainClosed()
  if closed then
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UITrainPrepare) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UITrainPrepare)
    end
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UITrainPrepareScene) or DataCenter.LWTrainPrepareSceneManager.dataValid then
      DataCenter.LWTrainPrepareSceneManager:Exit()
    end
  end
end

function LWAllyStationDataManager:OnPushOffSeasonSkipCD(message)
  if message.open and message.open == 1 then
    self.skipJoinAllianceCD = true
  else
    self.skipJoinAllianceCD = false
  end
end

function LWAllyStationDataManager:SetVipMemberListData(message)
  self.vipMemberList = message.list
end

function LWAllyStationDataManager:GetVipMemberListData()
  return self.vipMemberList
end

function LWAllyStationDataManager:SetToggleNumSelect(value)
  self.toggleNumsSelectGet = value
end

function LWAllyStationDataManager:GetToggleNumSelect()
  return self.toggleNumsSelectGet
end

function LWAllyStationDataManager:GetRefreshGoldTrainTimes()
  if self.cacheRefreshGoldTrainTimes == nil then
    self.cacheRefreshGoldTrainTimes = LuaEntry.DataConfig:TryGetNum("alliance_train", "k23")
  end
  return self.cacheRefreshGoldTrainTimes
end

function LWAllyStationDataManager:GetJudgeHighGoodsStandardList()
  if self.cacheJudgeHighGoodsStandardList == nil then
    local str = LuaEntry.DataConfig:TryGetStr("alliance_train", "k24")
    if not string.IsNullOrEmpty(str) then
      local strArr = string.split(str, "_")
      local count = table.count(strArr)
      if 0 < count then
        self.cacheJudgeHighGoodsStandardList = {}
        for i = 1, count do
          local goodsStrArr = string.split(strArr[i], "|")
          local goodsStrArrCount = table.count(goodsStrArr)
          if 0 < goodsStrArrCount then
            local needGoodsMap = {}
            for j = 1, goodsStrArrCount do
              local oneGoodArr = string.split(goodsStrArr[j], ";")
              if table.count(oneGoodArr) == 2 then
                local goodsId = tonumber(oneGoodArr[1]) or 0
                local goodsCount = tonumber(oneGoodArr[2]) or 0
                if 0 < goodsId then
                  needGoodsMap[goodsId] = goodsCount
                end
              end
            end
            table.insert(self.cacheJudgeHighGoodsStandardList, needGoodsMap)
          end
        end
      end
    end
  end
  return self.cacheJudgeHighGoodsStandardList
end

function LWAllyStationDataManager:GetMaxFreeRefreshTimes()
  return LuaEntry.DataConfig:TryGetNum("alliance_train", "k25") or 0
end

function LWAllyStationDataManager:GetFreeRefreshTimes()
  return self.freeRefreshTimes or 0
end

function LWAllyStationDataManager:UpdateFreeRefreshTimes(times)
  if not times then
    return
  end
  self.freeRefreshTimes = times
end

function LWAllyStationDataManager:IsFirstDriverTrain()
  local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  if trainData and trainData:IsMyTrain() then
    Setting:GetPrivateBool("IsFirstDriverTrain", false)
  end
  Setting:GetPrivateBool("IsFirstDriverTrain", true)
end

return LWAllyStationDataManager
