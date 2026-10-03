local LWMyStationDataManager = BaseClass("LWMyStationDataManager")
local TrainData = require("DataCenter.LWRailway.Train.TrainData")
local TruckBuildId2Index = {
  [BuildingTypes.LW_BUILD_TRUCK_STATION_1] = 1,
  [BuildingTypes.LW_BUILD_TRUCK_STATION_2] = 2,
  [BuildingTypes.LW_BUILD_TRUCK_STATION_3] = 3,
  [BuildingTypes.LW_BUILD_TRUCK_STATION_4] = 4
}
local MAX_TRUCK_COUNT = 4

function LWMyStationDataManager:__init()
  self:StartPassDayTimer()
  self:AddListener()
  self.myTrains = {}
  self.myTrainsByBuuid = {}
  self.myTrainsByUuid = {}
  self.myOldTrains = {}
  self.myDefenceFormation = {}
  self.indexToMyDefenceFormation = {}
  self.myAttackFormation = {}
  self.indexToMyAttackFormation = {}
  self.enemyWeaponInfo = {}
  self.curDefenceSquadIndexInView = 1
  self.cacheHighQualityIncludeItemMap = nil
  self._truckUuidsCache = {}
end

function LWMyStationDataManager:__delete()
  self:RemoveListener()
  self:ClearData()
end

function LWMyStationDataManager:StartPassDayTimer()
  if self.passDayTimer then
    self.passDayTimer:Stop()
  end
  local remainTimeS = UITimeManager:GetInstance():GetResSecondsTo24()
  local delayS = remainTimeS + 30 + math.random() * 30
  self.passDayTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:TryGetMyStationData()
  end, delayS)
end

function LWMyStationDataManager:GetMeta(index)
  local meta = LocalController:instance():getLine(TableName.LW_Train_Para, index)
  return meta and meta.val
end

function LWMyStationDataManager:GET_MAX_DAILY_COUNT_BASE()
  if not self.MAX_DAILY_COUNT_BASE then
    self.MAX_DAILY_COUNT_BASE = tonumber(self:GetMeta(5)) or 2
  end
  return self.MAX_DAILY_COUNT_BASE
end

function LWMyStationDataManager:GET_CD_BASE()
  if not self.CD_BASE then
    self.CD_BASE = (tonumber(self:GetMeta(7)) or 640) * 60 * 1000
  end
  return self.CD_BASE
end

function LWMyStationDataManager:GET_CHANGE_COST()
  if not self.CHANGE_COST then
    self.CHANGE_COST = {}
    local str = self:GetMeta(9) or "0,0,1,1"
    str = string.split(str, ",")
    for i = 1, #str do
      self.CHANGE_COST[i] = tonumber(str[i])
    end
  end
  return self.CHANGE_COST
end

function LWMyStationDataManager:GET_CARRIAGE_LENGTH()
  if not self.CARRIAGE_LENGTH then
    local carriageLength = tonumber(self:GetMeta(10)) or 10
    self.CARRIAGE_LENGTH = carriageLength * TileSize
  end
  return self.CARRIAGE_LENGTH
end

function LWMyStationDataManager:GET_MAX_DAILY_LOOT_COUNT()
  if not self.MAX_DAILY_LOOT_COUNT then
    self.MAX_DAILY_LOOT_COUNT = tonumber(self:GetMeta(11)) or 5
  end
  return self.MAX_DAILY_LOOT_COUNT
end

function LWMyStationDataManager:GET_CHANGE_TRAIN_ITEM_ID()
  if not self.CHANGE_TRAIN_ITEM_ID then
    self.CHANGE_TRAIN_ITEM_ID = tonumber(self:GetMeta(12)) or 1520001
  end
  return self.CHANGE_TRAIN_ITEM_ID
end

function LWMyStationDataManager:GET_TRAIN_FOG_ID()
  if not self.TRAIN_FOG_ID then
    self.TRAIN_FOG_ID = tonumber(self:GetMeta(16)) or 3
  end
  return self.TRAIN_FOG_ID
end

function LWMyStationDataManager:GET_MAX_LOOT_PER_TRUCK()
  if not self.MAX_LOOT_PER_TRUCK then
    self.MAX_LOOT_PER_TRUCK = tonumber(self:GetMeta(21)) or 2
  end
  return self.MAX_LOOT_PER_TRUCK
end

function LWMyStationDataManager:GetStationTruckPath()
  if not self.stationTruckPath then
    self.stationTruckPath = {}
    for i = 1, 5 do
      local configPath = self:GetMeta(29 + i)
      if string.IsNullOrEmpty(configPath) then
        self.stationTruckPath[i] = string.format("Assets/_Art_LastWar/Models/Characters/Object/A_Vehicle_truck_01/prefab/A_Vehicle_truck_0%s.prefab", i)
      else
        self.stationTruckPath[i] = configPath
      end
    end
  end
  return self.stationTruckPath
end

function LWMyStationDataManager:Startup()
end

function LWMyStationDataManager:ClearData()
  if self.myTrains then
    for _, v in pairs(self.myTrains) do
      v:Delete()
    end
    for _, v in pairs(self.myOldTrains) do
      v:Delete()
    end
    self.myTrains = {}
    self.myOldTrains = {}
    self.myTrainsByBuuid = {}
    self.myTrainsByUuid = {}
  end
  self.matchServers = {}
  self.myDefenceFormation = {}
  self.indexToMyDefenceFormation = {}
  self.myAttackFormation = {}
  self.indexToMyAttackFormation = {}
  self.curDefenceSquadIndexInView = nil
  self.enemyWeaponInfo = nil
  self.cacheHighQualityIncludeItemMap = nil
  self._truckUuidsCache = nil
end

function LWMyStationDataManager:AddListener()
  EventManager:GetInstance():AddListener(EventId.OnUpdateActivityEventData, self.OnPushActivity)
  EventManager:GetInstance():AddListener(EventId.UPDATE_SCIENCE_DATA, self.OnUpdateScienceData)
end

function LWMyStationDataManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.OnUpdateActivityEventData, self.OnPushActivity)
  EventManager:GetInstance():RemoveListener(EventId.UPDATE_SCIENCE_DATA, self.OnUpdateScienceData)
end

function LWMyStationDataManager:InitData(msg)
  if msg.trainData then
    self:RefreshMyStationData(msg.trainData)
  end
  if msg.trainServers then
    self:SetMatchServer(msg.trainServers)
  end
end

function LWMyStationDataManager:SetMatchServer(trainServers)
  local stringList = string.split(trainServers, ",")
  self.matchServers = {}
  for i = 1, #stringList do
    self.matchServers[tonumber(stringList[i])] = true
  end
end

function LWMyStationDataManager:TryGetMyStationData()
  if not self:IsTruckFunctionLock() then
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.TruckActivity.Type)
    if dataList and dataList[1] and DataCenter.ActivityListDataManager:CheckIsSend(dataList[1]) then
      SFSNetwork.SendMessage(MsgDefines.GetMyStationData)
    end
  end
end

function LWMyStationDataManager:OnMyStationDataGet(msg)
  self:RefreshMyStationData(msg)
end

function LWMyStationDataManager:OnMyStationDataPush(msg)
  self:RefreshMyStationData(msg)
  self:InitTruckFormationWithoutServer()
end

function LWMyStationDataManager:OnPushActivity(id)
  local data = DataCenter.ActivityListDataManager:GetActivityDataById(id)
  if data and data.type == EnumActivity.TruckActivity.Type then
    self:TryGetMyStationData()
  end
end

function LWMyStationDataManager:TryCollectFirstReward()
  if not LuaEntry.DataConfig:CheckSwitch("train_cross_server") and CrossServerUtil:NeedIntercept(500020) then
    return
  end
  if self.hasFirstReward then
    SFSNetwork.SendMessage(MsgDefines.CollectStationFirstReward)
  end
  return self.hasFirstReward
end

function LWMyStationDataManager:OnFirstRewardGet(msg)
  self:RefreshMyStationData(msg)
  self:InitTruckFormationWithoutServer()
end

function LWMyStationDataManager:TryChangeTrain(uuid)
  if uuid then
    SFSNetwork.SendMessage(MsgDefines.ChangeTrain, uuid)
  end
end

function LWMyStationDataManager:OnTrainChanged(myTrain)
  self:OnMyTrainRefreshOne(myTrain)
  EventManager:GetInstance():Broadcast(EventId.ChangeTrainSuccess)
end

function LWMyStationDataManager:OnTrainChangedList(myTrainList)
  local changeTrainList = {}
  for _, v in pairs(myTrainList) do
    local newTrain = self:OnMyTrainRefreshOne(v, true)
    table.insert(changeTrainList, newTrain.index)
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshMyTruck)
  EventManager:GetInstance():Broadcast(EventId.BatchChangeTrainSuccess, changeTrainList)
end

function LWMyStationDataManager:FormationToSFSObject(curHeroes)
  local heroArray = SFSArray.New()
  table.walk(curHeroes, function(k, v)
    local obj = SFSObject.New()
    obj:PutLong("heroUuid", k)
    obj:PutUtfString("index", tostring(v))
    heroArray:AddSFSObject(obj)
  end)
  return heroArray
end

function LWMyStationDataManager:TryAttackTrain(trainUuid, trainServerId, formation)
  if not trainUuid then
    Logger.LogError("no trainUuid")
    return false
  end
  if not formation then
    return false
  end
  local curHeroes = formation.localHeroes
  if table.count(curHeroes) <= 0 then
    UIUtil.ShowTipsId(457564)
    return false
  end
  local heroArray = formation:GenerateServerHeroArray()
  local curChipSetId = formation:GetLocalTWSkillChipSetId()
  local teamBuffIndex = formation.localSquadNo
  SFSNetwork.SendMessage(MsgDefines.AttackTrain, trainUuid, heroArray, trainServerId, curChipSetId, teamBuffIndex)
  self.robFormation = nil
end

function LWMyStationDataManager:OnRob(msg)
  self.todayRobCount = msg.dailyRobCount
end

function LWMyStationDataManager:TryDepartureTrain(trainUuid, formation)
  if not LuaEntry.DataConfig:CheckSwitch("train_cross_server") and not LuaEntry.Player:IsLoginSourceServer() then
    UIUtil.ShowTipsId(500020)
    return
  end
  if not trainUuid then
    Logger.LogError("no trainUuid")
    return false
  end
  if not formation then
    return false
  end
  local curHeroes = formation.localHeroes
  if table.count(curHeroes) <= 0 then
    UIUtil.ShowTipsId(457564)
    return false
  end
  local heroArray = formation:GenerateServerHeroArray()
  local curChipSetId = formation:GetLocalTWSkillChipSetId()
  local teamBuffIndex = formation.localSquadNo
  self:TrySaveTruckFormation(formation, false)
  SFSNetwork.SendMessage(MsgDefines.DepartureTrain, trainUuid, heroArray, curChipSetId, teamBuffIndex, formation.index)
  local trainData = self:GetMyTruckByUuid(trainUuid)
  if trainData then
    trainData.squadNoClient = formation.index
  end
  self.defenceFormation = nil
end

function LWMyStationDataManager:TryDepartureTrainList(truckUuid2FormationMap)
  if not LuaEntry.DataConfig:CheckSwitch("train_cross_server") and not LuaEntry.Player:IsLoginSourceServer() then
    UIUtil.ShowTipsId(500020)
    return false
  end
  for trainUuid, formation in pairs(truckUuid2FormationMap) do
    self:TrySaveTruckFormation(formation, false)
    local trainData = self:GetMyTruckByUuid(trainUuid)
    if trainData then
      trainData.squadNoClient = formation.index
    end
  end
  SFSNetwork.SendMessage(MsgDefines.TrainBatchSend, truckUuid2FormationMap)
  return true
end

function LWMyStationDataManager:OnMyTrainDeparture(msg)
  UITimeManager:GetInstance():UpdateServerMsDeltaTime(msg.lastSendTime)
  self.todayDepartureCount = msg.dailySendCount
  self.lastDepartureTime = msg.lastSendTime
  local newTrain = self:OnMyTrainRefreshOne(msg.march.train)
  DataCenter.LWMyStationManager:DepartureOneTruck(newTrain)
  EventManager:GetInstance():Broadcast(EventId.DepartureTrainSuccess, newTrain.buildUuid)
end

function LWMyStationDataManager:OnMyTrainDepartureList(msg)
  if msg.lastSendTime then
    local lastSendTime = msg.lastSendTime
    UITimeManager:GetInstance():UpdateServerMsDeltaTime(lastSendTime)
    self.lastDepartureTime = lastSendTime
  end
  if msg.dailySendCount then
    self.todayDepartureCount = msg.dailySendCount
  end
  if msg.trainInfoList then
    local trainInfoList = msg.trainInfoList
    local departureTruckList = {}
    for _, trainInfo in pairs(trainInfoList) do
      if trainInfo.march then
        local march = trainInfo.march
        local newTrain = self:OnMyTrainRefreshOne(march.train, true)
        DataCenter.LWMyStationManager:DepartureOneTruck(newTrain)
        table.insert(departureTruckList, newTrain.index)
      end
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshMyTruck)
    EventManager:GetInstance():Broadcast(EventId.BatchDepartureTrainSuccess, departureTruckList)
  end
end

function LWMyStationDataManager:TryCollectReward(trainUuid)
  SFSNetwork.SendMessage(MsgDefines.CollectTrainReward, trainUuid)
end

function LWMyStationDataManager:OnRewardCollected(trainData)
  self:RefreshMyStationData(trainData)
  EventManager:GetInstance():Broadcast(EventId.CollectTrainRewardSuccess)
end

function LWMyStationDataManager:TryReinforce()
  SFSNetwork.SendMessage(MsgDefines.ReinforceTrain)
end

function LWMyStationDataManager:OnReinforceSend()
end

function LWMyStationDataManager:On3v3BattleFinish(msg)
  if msg.dailyRobCount then
    self.todayRobCount = msg.dailyRobCount
  end
end

function LWMyStationDataManager:TrySaveTruckFormation(squad_data, isAttack)
  local cur_heroes = squad_data:GenerateServerHeroArray()
  local SquadType = isAttack and FormationSaveType.TruckAttackSquad or FormationSaveType.TruckDefenceSquad
  local curChipSetId = squad_data:GetLocalTWSkillChipSetId()
  SFSNetwork.SendMessage(MsgDefines.FormationSave, squad_data.index + SquadType, cur_heroes, SquadType, curChipSetId, squad_data.localSquadNo)
end

function LWMyStationDataManager:TrySaveAllTruckFormation(isAttack)
  local formationList = isAttack and self.myAttackFormation or self.myDefenceFormation
  for k, squad_data in pairs(formationList) do
    local cur_heroes = squad_data:GenerateServerHeroArray()
    local SquadType = isAttack and FormationSaveType.TruckAttackSquad or FormationSaveType.TruckDefenceSquad
    local curChipSetId = squad_data:GetLocalTWSkillChipSetId()
    SFSNetwork.SendMessage(MsgDefines.FormationSave, squad_data.index + SquadType, cur_heroes, SquadType, curChipSetId, squad_data.localSquadNo)
  end
end

function LWMyStationDataManager:OnGetSaveTruckFormation(message, isAttack)
  local index = message.index
  local uuId = message.uuid
  if index == nil or uuId == nil then
    return
  end
  local SquadType = isAttack and FormationSaveType.TruckAttackSquad or FormationSaveType.TruckDefenceSquad
  index = index - SquadType
  local formationList = isAttack and self.myAttackFormation or self.myDefenceFormation
  local formationIndexMap = isAttack and self.indexToMyAttackFormation or self.indexToMyDefenceFormation
  local oldFormationData = formationIndexMap[index]
  if oldFormationData then
    oldFormationData:ParseData(message)
    oldFormationData.index = message.index - SquadType
  else
    local info = ArenaArmyFormationInfo.New()
    info:ParseData(message)
    info.index = message.index - SquadType
    table.insert(formationList, info)
    formationIndexMap[index] = info
  end
  table.sort(formationList, function(a, b)
    return a:GetTotalCapacity() > b:GetTotalCapacity()
  end)
  EventManager:GetInstance():Broadcast(EventId.RefreshTruckHero)
  EventManager:GetInstance():Broadcast(EventId.RefreshTruckHeroByIndex, index)
end

local function RefreshTruckDefenceSquad(self)
  for _, train in pairs(self.myTrains) do
    for _, hero in pairs(train.heroInfo) do
      if train.squadNoClient == 0 then
        local uuid = DataCenter.HeroDataManager:GetHeroUuidByHeroId(hero.id)
        for k, v in pairs(self.myDefenceFormation) do
          if v:HasLocalHero(uuid) then
            v:RemoveOneHeroByUuid(uuid)
          end
        end
      end
    end
  end
end

local function CheckIfHasMultiHero(self, list)
  if not table.IsNullOrEmpty(list) then
    local heroUuidToIndex = {}
    for k, v in pairs(list) do
      local heroes = v.localHeroes
      for uuid, index in pairs(heroes) do
        if heroUuidToIndex[uuid] then
          v:RemoveOneHeroByUuid(uuid)
        else
          heroUuidToIndex[uuid] = index
        end
      end
    end
  end
end

function LWMyStationDataManager:InitArmyFormationListData(message)
  if message.formation_template ~= nil then
    self.myDefenceFormation = {}
    self.myAttackFormation = {}
    self.indexToMyDefenceFormation = {}
    self.indexToMyAttackFormation = {}
    if table.count(message.formation_template) > 0 then
      table.walk(message.formation_template, function(k, v)
        if v.index > FormationSaveType.TruckDefenceSquad and v.index <= FormationSaveType.TruckDefenceSquad + 4 then
          local info = ArenaArmyFormationInfo.New()
          info:ParseData(v)
          info.index = v.index - FormationSaveType.TruckDefenceSquad
          self:InitTeamUsingBuff(false, info)
          local unlock = DataCenter.ArmyFormationDataManager:HasArmyFormationInIndex(info.index, true)
          if unlock then
            table.insert(self.myDefenceFormation, info)
            self.indexToMyDefenceFormation[info.index] = info
          end
        elseif v.index > FormationSaveType.TruckAttackSquad and v.index <= FormationSaveType.TruckAttackSquad + 4 then
          local info = ArenaArmyFormationInfo.New()
          info:ParseData(v)
          info.index = v.index - FormationSaveType.TruckAttackSquad
          self:InitTeamUsingBuff(true, info)
          local unlock = DataCenter.ArmyFormationDataManager:HasArmyFormationInIndex(info.index, true)
          if unlock then
            table.insert(self.myAttackFormation, info)
            self.indexToMyAttackFormation[info.index] = info
          end
        end
      end)
      CheckIfHasMultiHero(self, self.myDefenceFormation)
      CheckIfHasMultiHero(self, self.myAttackFormation)
      table.sort(self.myDefenceFormation, function(a, b)
        return a:GetTotalCapacity() > b:GetTotalCapacity()
      end)
      table.sort(self.myAttackFormation, function(a, b)
        return a:GetTotalCapacity() > b:GetTotalCapacity()
      end)
    end
    self:InitTruckFormationWithoutServer()
  end
end

function LWMyStationDataManager:TryGetEnemyWeaponInfo(uid, serverId)
  if uid and serverId then
    SFSNetwork.SendMessage(MsgDefines.WeaponInfoView, uid, serverId)
  end
end

function LWMyStationDataManager:OnGetEnemyWeaponInfo(message)
  if message ~= nil then
    self.enemyWeaponInfo = DeepCopy(message)
    EventManager:GetInstance():Broadcast(EventId.EnemyTruckWeaponDataArrive, self.enemyWeaponInfo)
  end
end

function LWMyStationDataManager:RefreshMyStationData(msg)
  self.hasFirstReward = msg.openReward == 0
  self.todayDepartureCount = msg.dailySendCount
  self.lastDepartureTime = msg.lastSendTime
  self.todayRobCount = msg.dailyRobCount
  self.openTime = msg.openTime
  self:RefreshAllMyTruck(msg.myTrainList)
end

function LWMyStationDataManager:RefreshAllMyTruck(trainsMsg)
  if not trainsMsg then
    return
  end
  for _, v in pairs(self.myTrains) do
    table.insert(self.myOldTrains, v)
  end
  self.myTrains = {}
  for _, msg in pairs(trainsMsg) do
    local newTrain = TrainData.New(msg)
    local index = newTrain.index
    if index then
      self.myTrains[index] = newTrain
    end
  end
  self.myTrainsByBuuid = {}
  self.myTrainsByUuid = {}
  for _, train in pairs(self.myTrains) do
    self.myTrainsByBuuid[train.buildUuid] = train
    self.myTrainsByUuid[train.uuid] = train
  end
  self:RefreshRailwayStationView()
  self:RefreshTruckStationView()
  self:RefreshTruckView()
  RefreshTruckDefenceSquad(self)
end

function LWMyStationDataManager:OnMyTrainRefreshOne(msg, ignoreSendEvent)
  local newTrain = TrainData.New(msg)
  local index = newTrain.index
  self.myTrains[index] = newTrain
  self.myTrainsByBuuid[newTrain.buildUuid] = newTrain
  self.myTrainsByUuid[newTrain.uuid] = newTrain
  self:RefreshTruckStationView()
  self:RefreshTruckView(newTrain, ignoreSendEvent)
  return newTrain
end

function LWMyStationDataManager:RefreshRailwayStationView()
  local stationBuilding = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(BuildingTypes.LW_BUILD_RAILWAY_STATION)
  if stationBuilding then
    DataCenter.BuildBubbleManager:CheckShowBubble(stationBuilding.uuid)
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshTrainStationView)
end

function LWMyStationDataManager:RefreshTruckStationView(buildUuid)
  if buildUuid then
    DataCenter.BuildBubbleManager:CheckShowBubble(buildUuid)
    EventManager:GetInstance():Broadcast(EventId.RefreshTruckStationView, buildUuid)
  else
    if not self._truckUuidsCache then
      self._truckUuidsCache = {}
    end
    local uuids = self._truckUuidsCache
    local count = 0
    local buildData = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_TRUCK_STATION_4)
    if buildData and buildData[1] then
      local uuid = buildData[1].uuid
      DataCenter.BuildBubbleManager:CheckShowBubble(uuid)
      count = count + 1
      uuids[count] = uuid
    end
    for _, v in pairs(self.myTrains) do
      DataCenter.BuildBubbleManager:CheckShowBubble(v.buildUuid)
      count = count + 1
      uuids[count] = v.buildUuid
    end
    for i = count + 1, #uuids do
      uuids[i] = nil
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshTruckStationView, uuids)
  end
end

function LWMyStationDataManager:RefreshTruckView(trainData, ignoreSendEvent)
  if trainData then
    EventManager:GetInstance():Broadcast(EventId.RefreshOneMyTruck, trainData)
  else
    for _, v in pairs(self.myTrains) do
      EventManager:GetInstance():Broadcast(EventId.RefreshOneMyTruck, v)
    end
  end
  if ignoreSendEvent == nil then
    EventManager:GetInstance():Broadcast(EventId.RefreshMyTruck)
  end
end

function LWMyStationDataManager:GetMyTrainList()
  local ret = {}
  for i = 1, MAX_TRUCK_COUNT do
    ret[i] = {}
  end
  for _, v in pairs(self.myTrains) do
    ret[v.index] = v
  end
  return ret
end

function LWMyStationDataManager:GetMyTrainByIndex(index)
  return self.myTrains[index]
end

function LWMyStationDataManager:GetMyTrains()
  return self.myTrains
end

function LWMyStationDataManager:GetMyDepartureTrains()
  local ret = {}
  for _, v in pairs(self.myTrains) do
    if v:GetTrainState() > TrainState.BeforeDeparture then
      table.insert(ret, v)
    end
  end
  return ret
end

function LWMyStationDataManager:GetMySpareTrains()
  local ret = {}
  for _, v in pairs(self.myTrains) do
    if v:GetTrainState() == TrainState.BeforeDeparture then
      table.insert(ret, v)
    end
  end
  return ret
end

function LWMyStationDataManager:GetMyTruckByUuid(uuid)
  for index, v in pairs(self.myTrains) do
    if v.uuid == uuid then
      return v
    end
  end
  return nil
end

function LWMyStationDataManager:GetMyTrainByBuildUuid(buildUuid)
  return self.myTrainsByBuuid[buildUuid]
end

function LWMyStationDataManager:GetMyTrainByUuid(uuid)
  return self.myTrainsByUuid[uuid]
end

function LWMyStationDataManager:GetRailwayStationState()
  local fogLock = self:IsTruckFunctionLock()
  local activityStart = false
  if self.openTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    if now > self.openTime then
      activityStart = true
    end
  end
  if fogLock then
    if activityStart then
      return RailwayStationState.Fog
    else
      return RailwayStationState.Disable
    end
  elseif not activityStart then
    return RailwayStationState.WarmUp, self.openTime
  end
  if self.hasFirstReward then
    return RailwayStationState.FirstReward
  end
  if self.todayRobCount < self:GET_MAX_DAILY_LOOT_COUNT() then
    return RailwayStationState.CanRob
  end
  return RailwayStationState.CannotRob
end

function LWMyStationDataManager:GetTruckStationState(buildUuid)
  local trainData = self.myTrainsByBuuid[buildUuid]
  return self:GetTruckStationStateByTrainData(trainData)
end

function LWMyStationDataManager:GetTruckStationStateByTrainData(trainData)
  if not trainData then
    return TruckStationState.Lock
  end
  if trainData.departureTs and trainData.departureTs > 0 then
    local now = UITimeManager:GetInstance():GetServerTime()
    if now < trainData.arriveTs then
      return TruckStationState.Travelling, trainData.arriveTs - now
    else
      return TruckStationState.Reward
    end
  end
  local railwayStationState = self:GetRailwayStationState()
  if railwayStationState <= RailwayStationState.FirstReward then
    return TruckStationState.Lock
  end
  local unlock = DataCenter.ArmyFormationDataManager:HasArmyFormationInIndex(trainData.index, true)
  if not unlock then
    return TruckStationState.Lock
  end
  if trainData.departureTs == 0 then
    if self.todayDepartureCount >= self:GetMaxDailyCount() then
      return TruckStationState.Exhausted
    else
      return TruckStationState.Ready
    end
  end
end

function LWMyStationDataManager:GetAllTruckStationState()
  local states = {}
  for index, v in pairs(self.myTrains) do
    states[index] = self:GetTruckStationStateByTrainData(v)
  end
  return states
end

function LWMyStationDataManager:GetTruckIndexByBuildUuid(buildUuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(buildUuid)
  return buildData and TruckBuildId2Index[buildData.itemId]
end

function LWMyStationDataManager:IsTruckFunctionLock()
  local id = DataCenter.MonopolyManager.player.curId
  return id and id < self:GET_TRAIN_FOG_ID()
end

function LWMyStationDataManager:GetMaxDailyCount()
  local add = LuaEntry.Effect:GetGameEffect(EffectDefine.MAX_DAILY_COUNT_ADD)
  return self:GET_MAX_DAILY_COUNT_BASE() + math.floor(add)
end

function LWMyStationDataManager:GetCD()
  local reduce = LuaEntry.Effect:GetGameEffect(EffectDefine.TRADE_CD_REDUCE_RATE)
  return self:GET_CD_BASE() * (1 - reduce)
end

function LWMyStationDataManager:GetRobCount()
  return self.todayRobCount, self:GET_MAX_DAILY_LOOT_COUNT()
end

function LWMyStationDataManager:GetDepartureCount()
  return self.todayDepartureCount, self:GetMaxDailyCount()
end

function LWMyStationDataManager:IsDailyCountLoaded()
  return self.todayDepartureCount ~= nil and self.todayRobCount ~= nil
end

function LWMyStationDataManager:IsTruckRobCountUsedUp()
  if not self:IsDailyCountLoaded() then
    return false
  end
  local cur, max = self:GetRobCount()
  return max <= cur
end

function LWMyStationDataManager:IsTruckDepartureCountUsedUp()
  if not self:IsDailyCountLoaded() then
    return false
  end
  local cur, max = self:GetDepartureCount()
  return max <= cur
end

function LWMyStationDataManager:IsAllTruckDispatchedAndRobUsedUp()
  return self:IsTruckDepartureCountUsedUp() and self:IsTruckRobCountUsedUp()
end

function LWMyStationDataManager:GetRealReadyCount()
  local ready = 0
  local allState = self:GetAllTruckStationState()
  for i = 1, MAX_TRUCK_COUNT do
    if TruckStationState.Ready == allState[i] then
      ready = ready + 1
    end
  end
  local cur, max = self:GetDepartureCount()
  local remain = max - cur
  return math.min(ready, remain)
end

function LWMyStationDataManager:GetRealReadyCountPlusRewardCount()
  local ready = 0
  local reward = 0
  local allState = self:GetAllTruckStationState()
  for i = 1, MAX_TRUCK_COUNT do
    if TruckStationState.Ready == allState[i] then
      ready = ready + 1
    elseif TruckStationState.Reward == allState[i] then
      reward = reward + 1
    end
  end
  local cur, max = self:GetDepartureCount()
  local remain = max - cur
  return math.min(ready, remain) + reward
end

function LWMyStationDataManager:GetHeroSquadIndex(heroId)
  if self.myTrains ~= nil then
    for _, v in pairs(self.myTrains) do
      for index, trainHero in pairs(v.heroInfo) do
        if trainHero.id == heroId then
          return v.index
        end
      end
    end
  end
  return nil
end

function LWMyStationDataManager:FindBestHeroes(heroList)
  if 0 < #heroList then
    table.sort(heroList, function(a, b)
      return a.power > b.power
    end)
  end
  local heroMap = {}
  local listLen = math.min(#heroList, 5)
  for i = 1, listLen do
    if heroList[i].meta.job == 1 then
      if not heroMap[1] then
        heroMap[1] = heroList[i].uuid
        heroList[i] = nil
      elseif not heroMap[2] then
        heroMap[2] = heroList[i].uuid
        heroList[i] = nil
      end
    end
  end
  for i = 1, listLen do
    if heroList[i] then
      table.insert(heroMap, heroList[i].uuid)
    end
  end
  return heroMap
end

function LWMyStationDataManager:GetDefenceFormation(index)
  if index then
    return self:GetDefenceFormationByIndex(index)
  else
    return self:GetMaxBattlePowerFreeDefenceFormation()
  end
end

function LWMyStationDataManager:GetRobFormation(index)
  if index then
    return self:GetAttackFormationByIndex(index)
  else
    return self:GetMaxBattlePowerFreeAttackFormation()
  end
end

function LWMyStationDataManager:CheckTrainInMatchServer(serverId)
  if not serverId then
    return false
  end
  if not self.matchServers then
    return true
  end
  return self.matchServers[serverId]
end

function LWMyStationDataManager:RefreshTrainSpeed()
  for _, train in pairs(self.myTrains) do
    train:UpdateSpeed()
  end
end

function LWMyStationDataManager.OnUpdateScienceData(scienceId)
  local improveSpeedScienceId = 130003200
  if scienceId == improveSpeedScienceId then
    DataCenter.LWMyStationDataManager:RefreshTrainSpeed()
  end
end

function LWMyStationDataManager:GetBusyDefenceFormationIndexList()
  local busyFormation = {}
  for _, train in pairs(self.myTrains) do
    if train.squadNoClient > 0 then
      busyFormation[train.squadNoClient] = true
    end
  end
  return busyFormation
end

function LWMyStationDataManager:IsHeroBusyInDefenceFormation(heroUuid)
  for _, train in pairs(self.myTrains) do
    for _, hero in pairs(train.heroInfo) do
      local uuid = DataCenter.HeroDataManager:GetHeroUuidByHeroId(hero.id)
      if uuid == heroUuid then
        return true
      end
    end
  end
end

function LWMyStationDataManager:IsBusyDefenceFormationByIndex(index)
  local busyMap = self:GetBusyDefenceFormationIndexList()
  return busyMap[index]
end

function LWMyStationDataManager:GetMaxBattlePowerFreeDefenceFormation()
  local busyFormation = self:GetBusyDefenceFormationIndexList()
  if self.myDefenceFormation then
    for k, v in ipairs(self.myDefenceFormation) do
      if not busyFormation[v.index] then
        return v
      end
    end
  end
end

function LWMyStationDataManager:GetMaxBattlePowerDefenceFormation()
  if self.myDefenceFormation then
    for k, v in ipairs(self.myDefenceFormation) do
      return v
    end
  end
end

function LWMyStationDataManager:GetMaxBattlePowerFreeDefenceFormationList()
  local list = {}
  local busyFormation = self:GetBusyDefenceFormationIndexList()
  if self.myDefenceFormation then
    for k, v in ipairs(self.myDefenceFormation) do
      if not busyFormation[v.index] then
        table.insert(list, v)
      end
    end
  end
  return list
end

function LWMyStationDataManager:GetMaxBattlePowerFreeAttackFormation()
  if self.myAttackFormation then
    return self.myAttackFormation[1]
  end
end

local function InitTruckFormationWithoutServerHelper(self, isAttack)
  local list = isAttack and self.myAttackFormation or self.myDefenceFormation
  local indexMap = isAttack and self.indexToMyAttackFormation or self.indexToMyDefenceFormation
  local formationList = DataCenter.ArmyFormationDataManager:GetArmyFormationList()
  local haveIndex = {}
  for k, v in pairs(list) do
    haveIndex[v.index] = true
  end
  if table.count(list) > 0 then
    for k, v in pairs(formationList) do
      if not haveIndex[v.index] then
        local formation = ArenaArmyFormationInfo.New()
        formation:SetIndex(v.index)
        self:InitTeamUsingBuff(isAttack, formation)
        formation:SetLocalTWSkillChipSetId(999)
        self:InitTeamChipSetId(isAttack, formation)
        self:TrySaveTruckFormation(formation, isAttack)
      end
    end
  else
    for k, v in pairs(formationList) do
      local formation = ArenaArmyFormationInfo.New()
      formation:SetLocalHeroes(v:GetLocalAllHeroes())
      formation:SetIndex(v.index)
      self:InitTeamUsingBuff(isAttack, formation)
      formation:SetLocalTWSkillChipSetId(999)
      self:InitTeamChipSetId(isAttack, formation)
      self:TrySaveTruckFormation(formation, isAttack)
    end
  end
  table.sort(list, function(a, b)
    return a:GetTotalCapacity() > b:GetTotalCapacity()
  end)
end

function LWMyStationDataManager:InitTruckFormationWithoutServer()
  InitTruckFormationWithoutServerHelper(self, false)
  InitTruckFormationWithoutServerHelper(self, true)
end

function LWMyStationDataManager:GetDefenceFormationByIndex(index)
  if self.indexToMyDefenceFormation then
    return self.indexToMyDefenceFormation[index]
  end
end

function LWMyStationDataManager:GetAttackFormationByIndex(index)
  if self.indexToMyAttackFormation then
    return self.indexToMyAttackFormation[index]
  end
end

function LWMyStationDataManager:GetHeroTruckSquadIndexByHeroId(heroId, isAttack)
  local list = isAttack and self.myAttackFormation or self.myDefenceFormation
  if list ~= nil then
    for _, v in pairs(list) do
      local heroUuidMap = v:GetLocalAllHeroes()
      for _, uuid in pairs(heroUuidMap) do
        local heroInfo = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
        if heroInfo.heroId == heroId then
          return v.index
        end
      end
    end
  end
  return nil
end

function LWMyStationDataManager:GetHeroTruckSquadIndexByHeroUuid(heroUuid, isAttack)
  local list = isAttack and self.myAttackFormation or self.myDefenceFormation
  if list ~= nil then
    for _, v in pairs(list) do
      local heroUuidMap = v:GetAllHeroes()
      for _, uuid in pairs(heroUuidMap) do
        if heroUuid == uuid then
          return v.index
        end
      end
    end
  end
  return nil
end

function LWMyStationDataManager:GetAtkTeamIndexUsingBuff(buffIndex)
  if not self.myAttackFormation then
    return nil
  end
  for i, v in pairs(self.myAttackFormation) do
    if v.localSquadNo == buffIndex then
      return v.index
    end
  end
end

function LWMyStationDataManager:GetDefTeamIndexUsingBuff(buffIndex)
  local defTeams = self.myDefenceFormation
  if not defTeams then
    return nil
  end
  for i, v in pairs(defTeams) do
    if v.localSquadNo == buffIndex then
      return v.index
    end
  end
end

function LWMyStationDataManager:SetAtkTeamUsingBuff(teamIndex, buffIndex)
  if not self.indexToMyAttackFormation then
    return
  end
  local team = self.indexToMyAttackFormation[teamIndex]
  if not team then
    return
  end
  team.localSquadNo = buffIndex
  EventManager:GetInstance():Broadcast(EventId.TruckBuffChange)
end

function LWMyStationDataManager:SetDefTeamUsingBuff(teamIndex, buffIndex)
  local defTeams = self.indexToMyDefenceFormation
  if not defTeams then
    return
  end
  local team = defTeams[teamIndex]
  if not team then
    return
  end
  team.localSquadNo = buffIndex
  EventManager:GetInstance():Broadcast(EventId.TruckBuffChange)
end

function LWMyStationDataManager:IsTeamUsingBuffAvailable(isAttack, buffIndex)
  local teams = isAttack and self.myAttackFormation or self.myDefenceFormation
  if not teams then
    return false
  end
  for k, team in pairs(teams) do
    if team.localSquadNo == buffIndex then
      return false
    end
  end
  return true
end

function LWMyStationDataManager:IsTeamChipSetIdAvailable(isAttack, chipSetId)
  local teams = isAttack and self.myAttackFormation or self.myDefenceFormation
  if not teams then
    return false
  end
  for k, team in pairs(teams) do
    if team.localChipSetId == chipSetId then
      return false
    end
  end
  return true
end

function LWMyStationDataManager:InitTeamUsingBuff(isAttack, squadData)
  if squadData.squadNo == 0 then
    local isSelfBuffAvailable = self:IsTeamUsingBuffAvailable(isAttack, squadData.index)
    if isSelfBuffAvailable then
      squadData.localSquadNo = squadData.index
    else
      for i = 1, 4 do
        if self:IsTeamUsingBuffAvailable(isAttack, i) then
          squadData.localSquadNo = i
          break
        end
      end
    end
  end
end

function LWMyStationDataManager:InitTeamChipSetId(isAttack, squadData)
  local isSelfChipSetIdAvailable = self:IsTeamChipSetIdAvailable(isAttack, squadData.index)
  if isSelfChipSetIdAvailable then
    squadData.localChipSetId = squadData.index
  else
    for i = 1, 4 do
      if self:IsTeamChipSetIdAvailable(isAttack, i) then
        squadData.localChipSetId = i
        break
      end
    end
  end
end

function LWMyStationDataManager:ClearEnemyTruckWeapon()
  self.enemyWeaponInfo = nil
end

function LWMyStationDataManager:GetEnemyTruckWeapon()
  return self.enemyWeaponInfo
end

function LWMyStationDataManager:IsTrainDataIllegal()
  if self.isTrainDataIllegal then
    self.isTrainDataIllegal = false
    return true
  end
end

function LWMyStationDataManager:SetTrainDataIllegal()
  self.isTrainDataIllegal = true
end

function LWMyStationDataManager:GetHighQualityIncludeItem()
  if self.cacheHighQualityIncludeItemMap == nil then
    local config = self:GetMeta(55)
    if config and not string.IsNullOrEmpty(config) then
      local itemStrArr = string.split(config, "|")
      for i, v in ipairs(itemStrArr) do
        local itemStrArr2 = string.split(v, ";")
        if table.count(itemStrArr2) == 2 then
          local itemId = tonumber(itemStrArr2[1])
          local itemNum = tonumber(itemStrArr2[2])
          if self.cacheHighQualityIncludeItemMap == nil then
            self.cacheHighQualityIncludeItemMap = {}
          end
          self.cacheHighQualityIncludeItemMap[itemId] = itemNum
        end
      end
    end
  end
  return self.cacheHighQualityIncludeItemMap
end

return LWMyStationDataManager
