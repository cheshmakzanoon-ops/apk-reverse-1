local HSRDataManager = BaseClass("HSRDataManager")
local HSRData = require("DataCenter.LWRailway.HighSpeedRailway.HSRData")

function HSRDataManager:__init()
  self.simpleActivityData = nil
  self.activityData = nil
  self.stationHistoryDetail = {}
  self.stationHistorySimpleRawData = {}
  self.stationHistorySimple = {}
  self.myHistoryDetail = {}
  self.myHistorySimple = {}
  self.rankData = {}
  self.sortType = HSRStationSortType.Station
end

function HSRDataManager:__delete()
  self:Destroy()
end

function HSRDataManager:Destroy()
  self.simpleActivityData = nil
  self.activityData = nil
  self.stationHistoryDetail = {}
  self.stationHistorySimpleRawData = {}
  self.stationHistorySimple = {}
  self.myHistoryDetail = {}
  self.myHistorySimple = {}
  self.rankData = {}
end

function HSRDataManager:InitActivityData(data)
  self.simpleActivityData = data
  self:FetchActivityData()
  DataCenter.HSRViewManager:Init()
end

function HSRDataManager:HandelActivityData(msg)
  local errCode = msg.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    self.activityData = msg
    if msg.createTrainTime and msg.createTrainTime > 0 then
      if not self.hsrData then
        self.hsrData = HSRData.New()
      end
      self.hsrData:InitByNet(msg)
    elseif self.hsrData then
      DataCenter.HSRViewManager:ClearHSRView()
      self.hsrData:Destroy()
      self.hsrData = nil
    end
    EventManager:GetInstance():Broadcast(EventId.HSRActivityDataRefresh)
  end
end

function HSRDataManager:SetHeadInfos(msg)
  if self.hsrData then
    self.hsrData:SetHeadInfos(msg)
  end
end

function HSRDataManager:GetActivityData()
  return self.activityData
end

function HSRDataManager:GetHSRData(uuid)
  if uuid then
    if self.hsrData and self.hsrData.uuid == uuid then
      return self.hsrData
    end
    return nil
  end
  return self.hsrData
end

function HSRDataManager:GetCurPosition()
  if self.hsrData then
    return self.hsrData:GetPosition(UITimeManager:GetInstance():GetServerTime())
  else
    return nil
  end
end

function HSRDataManager:FetchActivityData()
  SFSNetwork.SendMessage(MsgDefines.SeasonGetZoneTrainActivityInfo)
end

function HSRDataManager:FetchActivityDataWithCD(now)
  if self.lastFetchTime and now - self.lastFetchTime < 1000 then
    return
  end
  self.lastFetchTime = now
  self:FetchActivityData()
end

function HSRDataManager:GetServer2Order()
  if not self.activityData then
    return nil
  end
  local ret = {}
  if self.activityData.buyMaxNumList then
    for i, v in ipairs(self.activityData.buyMaxNumList) do
      ret[v.serverId] = i
    end
  end
  return ret
end

function HSRDataManager:FetchAllStationOldHistory(time)
  SFSNetwork.SendMessage(MsgDefines.SeasonGetTrainStationInfo, time)
end

function HSRDataManager:HandelAllStationOldHistory(msg)
  self.stationHistorySimpleRawData[msg.trainTime] = msg.stationInfo
  self:DoSort(msg.trainTime)
  EventManager:GetInstance():Broadcast(EventId.HSRStationHistorySimpleListRefresh)
end

function HSRDataManager:FetchAllStationCurHistory()
  if self:HasRunningHSR() then
    SFSNetwork.SendMessage(MsgDefines.SeasonGetStationMiniInfo)
  else
    local lastTime = self:GetLastCreateTimes(1)[1]
    if lastTime then
      self:FetchAllStationOldHistory(lastTime)
    end
  end
end

function HSRDataManager:HandelAllStationCurHistory(msg)
  local lastTime = self:GetLastCreateTimes(1)[1]
  if lastTime == nil then
    return
  end
  self.stationHistorySimpleRawData[lastTime] = msg.stationInfo
  self:InitSortType()
  EventManager:GetInstance():Broadcast(EventId.HSRStationHistorySimpleListRefresh)
end

function HSRDataManager:DoSort(time)
  if time == nil then
    time = 0
    for k, v in pairs(self.stationHistorySimpleRawData) do
      if k > time then
        time = k
      end
    end
  end
  if not self.stationHistorySimpleRawData[time] or 0 >= #self.stationHistorySimpleRawData[time] then
    return
  end
  local dataList = {}
  for _, v in pairs(self.stationHistorySimpleRawData[time]) do
    table.insert(dataList, v)
  end
  if self.sortType == HSRStationSortType.Station then
    local server2Order = DataCenter.HSRDataManager:GetServer2Order()
    table.sort(dataList, function(a, b)
      return server2Order[a.server] < server2Order[b.server]
    end)
    table.insert(dataList, 1, dataList[#dataList - 1])
    table.insert(dataList, 1, dataList[#dataList])
  elseif self.sortType == HSRStationSortType.Price then
    table.sort(dataList, function(a, b)
      if a.maxPrice ~= b.maxPrice then
        return a.maxPrice > b.maxPrice
      end
      if a.buyMaxNum ~= b.buyMaxNum then
        return a.buyMaxNum > b.buyMaxNum
      end
      return a.server < b.server
    end)
  elseif self.sortType == HSRStationSortType.Count then
    table.sort(dataList, function(a, b)
      if a.buyMaxNum ~= b.buyMaxNum then
        return a.buyMaxNum > b.buyMaxNum
      end
      if a.maxPrice ~= b.maxPrice then
        return a.maxPrice > b.maxPrice
      end
      return a.server < b.server
    end)
  end
  self.stationHistorySimple[time] = dataList
end

function HSRDataManager:GetAllStationHistory(time)
  if time == nil then
    local latest = 0
    for k, v in pairs(self.stationHistorySimple) do
      if k > latest then
        latest = k
      end
    end
    return self.stationHistorySimple[latest] or {}
  end
  return self.stationHistorySimple[time] or {}
end

function HSRDataManager:ChangeSortType(time)
  local lastTime = self:GetLastCreateTimes(1)[1]
  if time == lastTime then
    if self:HasRunningHSR() then
      self.sortType = (self.sortType + 1) % HSRStationSortType.MAX
    else
      self.sortType = self.sortType == HSRStationSortType.Price and HSRStationSortType.Count or HSRStationSortType.Price
    end
    self:DoSort(time)
  else
    self.sortType = self.sortType == HSRStationSortType.Price and HSRStationSortType.Count or HSRStationSortType.Price
    self:DoSort(time)
  end
end

function HSRDataManager:ChangeTime(time)
  local lastTime = self:GetLastCreateTimes(1)[1]
  if time ~= lastTime then
    if self.sortType == HSRStationSortType.Station then
      self.sortType = HSRStationSortType.Price
    end
    self:DoSort(time)
    self:FetchAllStationOldHistory(time)
  end
end

function HSRDataManager:InitSortType()
  if self:HasRunningHSR() then
    self.sortType = HSRStationSortType.Station
  else
    self.sortType = HSRStationSortType.Price
  end
  self:DoSort()
end

function HSRDataManager:GetSortType()
  return self.sortType
end

function HSRDataManager:FetchOneStationHistory(cityId)
  SFSNetwork.SendMessage(MsgDefines.SeasonGetStationDetailInfo, cityId)
end

function HSRDataManager:HandelOneStationHistory(msg)
  if not msg.stationId then
    return
  end
  self.stationHistoryDetail[msg.stationId] = msg
  table.sort(msg.priceRecords, function(a, b)
    return a.createTrainTime > b.createTrainTime
  end)
  msg.chartData = {}
  EventManager:GetInstance():Broadcast(EventId.HSRStationHistoryDetailRefresh, msg.stationId)
end

function HSRDataManager:GetOneStationChartData(cityId, type)
  local historyDetail = self.stationHistoryDetail[cityId]
  if not historyDetail then
    historyDetail = {}
    self.stationHistoryDetail[cityId] = historyDetail
  end
  if not historyDetail.chartData then
    historyDetail.chartData = {}
  end
  if historyDetail.chartData[type] then
    return historyDetail.chartData[type]
  end
  local ret = {}
  if type == HSRChartType.Today then
    local todayZero = UITimeManager:GetInstance():GetTodayZero()
    local today24 = todayZero + 86400000
    if historyDetail.priceRecords then
      for _, v in ipairs(historyDetail.priceRecords) do
        if todayZero <= v.createTrainTime and today24 > v.createTrainTime then
          table.insert(ret, {
            time = v.createTrainTime,
            price = v.price
          })
        else
          break
        end
      end
    end
    local sendTimes = self:GetAllSendTimesBetween(todayZero, today24 - 1)
    for _, time in ipairs(sendTimes) do
      local have
      for _, v in pairs(ret) do
        if v.time == time then
          have = true
          break
        end
      end
      if not have then
        table.insert(ret, {time = time, price = 0})
      end
    end
    table.sort(ret, function(a, b)
      return a.time > b.time
    end)
  elseif type == HSRChartType.Week then
    local day = 0
    local dayZero = UITimeManager:GetInstance():GetTodayZero()
    local dailyPrice = {time = dayZero, price = 0}
    table.insert(ret, dailyPrice)
    if historyDetail.priceRecords then
      for _, v in pairs(historyDetail.priceRecords) do
        if dayZero <= v.createTrainTime then
          if dailyPrice.price < v.price then
            dailyPrice.price = v.price
          end
        else
          if day <= -6 then
            break
          end
          day = day - 1
          dayZero = dayZero - 86400000
          dailyPrice = {
            time = dayZero,
            price = v.price
          }
          table.insert(ret, dailyPrice)
        end
      end
    end
  elseif type == HSRChartType.Month then
    local week = 0
    local weekZero = UITimeManager:GetInstance():WeekZero()
    local weeklyPrice = {time = weekZero, price = 0}
    table.insert(ret, weeklyPrice)
    if historyDetail.priceRecords then
      for _, v in pairs(historyDetail.priceRecords) do
        if weekZero <= v.createTrainTime then
          if weeklyPrice.price < v.price then
            weeklyPrice.price = v.price
          end
        else
          if week <= -4 then
            break
          end
          week = week - 1
          weekZero = weekZero - 604800000
          weeklyPrice = {
            time = weekZero,
            price = v.price
          }
          table.insert(ret, weeklyPrice)
        end
      end
    end
  end
  historyDetail.chartData[type] = ret
  return ret
end

function HSRDataManager:GetOneStationHistoryFive(cityId)
  local historyDetail = self.stationHistoryDetail[cityId]
  if not historyDetail then
    return {}
  end
  local tradeRecords = historyDetail.tradeRecords
  if not tradeRecords or #tradeRecords <= 0 then
    return {}
  end
  table.sort(tradeRecords, function(a, b)
    return a.time > b.time
  end)
  local ret = {}
  local max = math.min(#tradeRecords, 5)
  for i = 1, max do
    table.insert(ret, 1, tradeRecords[i])
  end
  return ret
end

function HSRDataManager:GetOneStationTodaySaleNum(cityId)
  local historyDetail = self.stationHistoryDetail[cityId]
  if not historyDetail then
    return 0
  end
  return historyDetail.todaySellNum or 0
end

function HSRDataManager:GetOneStationTodayMaxPrice(cityId)
  local historyDetail = self.stationHistoryDetail[cityId]
  if not historyDetail then
    return 0
  end
  local ret = 0
  local todayZero = UITimeManager:GetInstance():GetTodayZero()
  local today24 = todayZero + 86400000
  if historyDetail.priceRecords then
    for _, v in ipairs(historyDetail.priceRecords) do
      if todayZero <= v.createTrainTime and today24 > v.createTrainTime then
        if ret < v.price then
          ret = v.price
        end
      else
        break
      end
    end
  end
  return ret
end

function HSRDataManager:GetOneStationPrevAndNextByStationId(cityId)
  if not self.activityData or not self.activityData.buyMaxNumList then
    return nil, nil
  end
  local stationList = self.activityData.buyMaxNumList
  for i, v in ipairs(stationList) do
    if v.station ~= cityId or i == 1 then
    elseif i == #stationList then
      return stationList[i - 1].station, nil
    else
      return stationList[i - 1].station, stationList[i + 1].station
    end
  end
  return nil, nil
end

function HSRDataManager:GetServerIdPrevAndCurByStationId(cityId)
  if not self.activityData or not self.activityData.buyMaxNumList then
    return nil, nil
  end
  local stationList = self.activityData.buyMaxNumList
  for i, v in ipairs(stationList) do
    if v.station ~= cityId or i == 1 then
    else
      return stationList[i - 1].serverId, stationList[i].serverId
    end
  end
  return nil, nil
end

function HSRDataManager:FetchAllMyHistory()
  SFSNetwork.SendMessage(MsgDefines.SeasonGetMyTradeRecords)
end

function HSRDataManager:HandleAllMyHistory(msg)
  if msg.tradeRecords then
    self.myHistorySimple = msg.tradeRecords
    table.sort(self.myHistorySimple, function(a, b)
      return a.createTrainTime > b.createTrainTime
    end)
    EventManager:GetInstance():Broadcast(EventId.HSRPersonalHistoryListRefresh)
  end
end

function HSRDataManager:GetAllMyHistory()
  local curUuid = self:GetCurHSRUuid()
  local ret = {}
  for _, v in ipairs(self.myHistorySimple) do
    if v.uuid ~= curUuid then
      table.insert(ret, v)
    end
  end
  return ret
end

function HSRDataManager:FetchMyHistoryByTrain(hsrUuid)
  SFSNetwork.SendMessage(MsgDefines.SeasonGetZoneTrainTradeRecords, hsrUuid)
end

function HSRDataManager:HandleMyHistoryByTrain(msg)
  self.myHistoryDetail[msg.uuid] = msg
  local trade = msg.trade
  local records = {}
  for _, v in pairs(trade.tradeRecords) do
    if v.tradeNum <= 0 then
      table.insert(records, {
        type = HSRSellType.Failure,
        time = v.tradeTime,
        serverId = v.serverId,
        tradeNum = v.tradeNum,
        tradeMoney = v.tradeMoney,
        remainNum = v.remainNum,
        unitPrice = v.unitPrice,
        maxSellPrice = v.maxSellPrice
      })
    else
      table.insert(records, {
        type = trade.sellType,
        time = v.tradeTime,
        serverId = v.serverId,
        tradeNum = v.tradeNum,
        tradeMoney = v.tradeMoney,
        remainNum = v.remainNum,
        unitPrice = v.unitPrice
      })
    end
  end
  for _, v in pairs(trade.loots) do
    table.insert(records, {
      type = HSRSellType.BeLooted,
      time = v.lootTime,
      lootNum = v.lootNum,
      lootUid = v.lootUid,
      lootName = v.lootName,
      lootServer = v.lootServer
    })
  end
  table.sort(records, function(a, b)
    return a.time > b.time
  end)
  msg.records = records
  EventManager:GetInstance():Broadcast(EventId.HSRPersonalHistoryDetailRefresh, msg.uuid)
end

function HSRDataManager:GetMyHistoryByUuid(hsrUuid)
  return self.myHistoryDetail[hsrUuid]
end

function HSRDataManager:GetOnHSR(price, goodsNum, formationIndex)
  if goodsNum <= 0 then
    return
  end
  if price and price <= 0 then
    return
  end
  if not self.activityData or not self.activityData.uuid then
    return
  end
  local formation = DataCenter.LWMyStationDataManager:GetDefenceFormationByIndex(formationIndex)
  if not formation then
    return false
  end
  local curHeroes = formation.localHeroes
  if 0 >= table.count(curHeroes) then
    UIUtil.ShowTipsId(457564)
    return false
  end
  local heroArray = formation:GenerateServerHeroArray()
  local curChipSetId = formation:GetLocalTWSkillChipSetId()
  local teamBuffIndex = formation.localSquadNo
  DataCenter.LWMyStationDataManager:TrySaveTruckFormation(formation, false)
  SFSNetwork.SendMessage(MsgDefines.SeasonJoinZoneTrain, price, goodsNum, self.activityData.uuid, heroArray, curChipSetId, teamBuffIndex)
end

function HSRDataManager:IsDumpLock()
  if self.simpleActivityData and self.simpleActivityData.startTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    local k9 = LuaEntry.DataConfig:TryGetNum("server_train", "k9", 8)
    local unlockTime = self.simpleActivityData.startTime + (k9 - 1) * 86400000
    if now < unlockTime then
      return unlockTime
    end
  end
  return false
end

function HSRDataManager:FetchVictimList(trainUuid)
  if not trainUuid and self.activityData then
    trainUuid = self.activityData.uuid
  end
  if trainUuid then
    SFSNetwork.SendMessage(MsgDefines.SeasonGetLootZoneTrainInfo, trainUuid)
  end
end

function HSRDataManager:FetchNewVictimList()
  SFSNetwork.SendMessage(MsgDefines.SeasonRefreshLootZoneTrainInfo)
end

function HSRDataManager:ClearVictimList()
  self.victimList = {}
  EventManager:GetInstance():Broadcast(EventId.HSRRobVictimRefresh)
end

function HSRDataManager:HandleVictimList(msg)
  self:SetDailyLootNum(msg.dailyLootNum)
  self.refreshTimes = msg.refreshTimes
  self.victimList = msg.atkUserArr
  if self.victimList then
    for _, v in pairs(self.victimList) do
      local armyDBUnitInfo = PBController.ParsePbFromBytes(v.armyUnit, "protobuf.ArmyDBUnitInfo")
      if armyDBUnitInfo then
        local soldiers = {}
        for _, soldier in pairs(armyDBUnitInfo.soldiers) do
          soldiers[toInt(soldier.armsId)] = soldier
        end
        if armyDBUnitInfo.weapon then
          v.weaponData = {
            id = armyDBUnitInfo.weapon.id,
            lv = armyDBUnitInfo.weapon.lv,
            props = armyDBUnitInfo.weapon.effectInfos,
            uavSkinId = armyDBUnitInfo.weapon.skinId
          }
        end
        v.heroInfo = {}
        for _, hero in pairs(armyDBUnitInfo.heroes) do
          if hero.dominator then
            v.heroInfo[hero.index] = {
              heroId = hero.dominator.dominatorId,
              heroLevel = hero.heroLevel,
              weaponLevel = hero.weaponLevel,
              rankLv = hero.dominator.rankLv
            }
          else
            v.heroInfo[hero.index] = {
              heroId = hero.heroId,
              heroLevel = hero.heroLevel,
              weaponLevel = hero.weaponLevel,
              rankLv = hero.rankLv,
              awakenLv = hero.awakenLv,
              heroSkinId = hero.heroSkinId
            }
          end
          local soldier = soldiers[hero.index]
          if soldier then
            v.heroInfo[hero.index].hp = 1 - (soldier.cure + soldier.dead + soldier.injured + soldier.wounded) / soldier.total
          end
        end
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.HSRRobVictimRefresh)
  if self.oldVictimUid then
    local victim = self:GetVictimByUid(self.oldVictimUid)
    if victim and victim.lootNum == self.oldVictimLootNum then
      self:RealAttackHSR()
    else
      UIUtil.ShowMessage(CS.GameEntry.Localization:GetString("server_train_snatch_limit_16"), 2, "server_train_btn_confirm", "server_train_btn_cancel", function()
        self:RealAttackHSR()
      end, function()
        self:GiveUpAttackHSR()
      end, function()
        self:GiveUpAttackHSR()
      end)
    end
  end
end

function HSRDataManager:GetVictimList()
  return self.victimList or {}
end

function HSRDataManager:GetVictimByUid(victimUid)
  if not self.victimList then
    return
  end
  for _, v in ipairs(self.victimList) do
    if v.uid == victimUid then
      return v
    end
  end
end

function HSRDataManager:GetRemainFreeRefreshTimes()
  local refreshTimes = self.refreshTimes or 0
  local allFreeTimes = self:GetFreeChangeCount()
  return allFreeTimes - refreshTimes
end

function HSRDataManager:GetDailyLootNum()
  return self.dailyLootNum or 0
end

function HSRDataManager:SetDailyLootNum(num)
  if num then
    self.dailyLootNum = num
  end
end

function HSRDataManager:TryAttackHSR(playerUid, formation)
  if not formation then
    return false
  end
  local curHeroes = formation.localHeroes
  if table.count(curHeroes) <= 0 then
    UIUtil.ShowTipsId(457564)
    return false
  end
  local victim = self:GetVictimByUid(playerUid)
  if not victim then
    UIUtil.ShowTipsId("E100123")
    return false
  end
  self.oldVictimUid = victim.uid
  self.oldVictimLootNum = victim.lootNum
  self.attackFormation = formation
  DataCenter.HSRDataManager:FetchVictimList()
end

function HSRDataManager:RealAttackHSR()
  local heroArray = self.attackFormation:GenerateServerHeroArray()
  local curChipSetId = self.attackFormation:GetLocalTWSkillChipSetId()
  local teamBuffIndex = self.attackFormation.localSquadNo
  SFSNetwork.SendMessage(MsgDefines.SeasonLootZoneTrain, self.oldVictimUid, heroArray, curChipSetId, teamBuffIndex)
  self.oldVictimUid = nil
  self.oldVictimLootNum = nil
  self.attackFormation = nil
end

function HSRDataManager:GiveUpAttackHSR()
  self.oldVictimUid = nil
  self.oldVictimLootNum = nil
  self.attackFormation = nil
  DataCenter.LWBattleManager:Exit()
end

function HSRDataManager:FetchRankData(type, subType)
  SFSNetwork.SendMessage(MsgDefines.SeasonGetZoneTrainRank, type, subType)
end

function HSRDataManager:HandleRankData(msg)
  local type = msg.type
  local subType = msg.subType
  if not type or not subType then
    return
  end
  self.rankData[type] = self.rankData[type] or {}
  self.rankData[type][subType] = msg
  msg.myRank = msg.owner or {}
  msg.rankList = msg.rankArr or {}
  EventManager:GetInstance():Broadcast(EventId.HSRRankDataRefresh)
end

function HSRDataManager:GetRankData(rankType, subType)
  if self.rankData[rankType] then
    return self.rankData[rankType][subType] or {}
  end
  return {}
end

function HSRDataManager:GetHSRSpeed()
  if not self.HSRSpeed then
    self.HSRSpeed = LuaEntry.DataConfig:TryGetNum("server_train", "k11", 1)
  end
  return self.HSRSpeed
end

function HSRDataManager:GetDistanceBetweenAdjacentStations()
  return WorldTileCount
end

function HSRDataManager:GetSellingState()
  if not self.activityData then
    return HSRSellState.Unboard
  end
  local activityData = self.activityData
  if activityData.finish then
    return HSRSellState.Finish
  end
  if activityData.passengerInfo then
    if activityData.passengerInfo.state == 1 then
      return HSRSellState.Selling
    elseif activityData.passengerInfo.state == 0 then
      if self.activityData.buyMaxNumList then
        local _, progress = self:GetDrivingProgress()
        local lastStation = self.activityData.buyMaxNumList[math.floor(progress) + 1]
        if lastStation and lastStation.station == self.activityData.nextCity then
          return HSRSellState.Selling
        end
      end
      return HSRSellState.Loading
    end
  end
  return HSRSellState.Unboard
end

function HSRDataManager:GetDrivingProgress()
  if not self.activityData or not self.hsrData then
    return 0, 0
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local start = self.activityData.sendTime
  if not start or start <= 0 then
    start = self.activityData.createTrainTime + toInt(self.simpleActivityData.para_1) * 1000
  end
  local drivingTime = now - start
  if drivingTime <= 0 then
    return start, 0
  end
  local speed = self:GetHSRSpeed()
  local distance = self:GetDistanceBetweenAdjacentStations()
  local interval = 1000 * distance / speed
  local progress = drivingTime / interval
  progress = math.min(progress, self:GetStationCount())
  return start + math.ceil(progress) * interval, progress
end

function HSRDataManager:GetHSRWaitTime()
  return self.simpleActivityData and self.simpleActivityData.para_1 * 1000 or 600000
end

function HSRDataManager:GetStationCount()
  return 10
end

function HSRDataManager:GetGoodsCountInBag()
  return DataCenter.ItemData:GetItemCount(self:GetGoodsId())
end

function HSRDataManager:GetGoodsCountCanConsign()
  local inBag = self:GetGoodsCountInBag()
  local _, progress = self:GetDrivingProgress()
  local remain = self:GetStationCount() - math.ceil(progress)
  local ret = math.min(inBag, remain * self:GetMaxSaleNumPerStation(), self:GetGetOnCount())
  return toInt(ret)
end

function HSRDataManager:GetMaxSaleNumPerStation()
  return self.simpleActivityData and self.simpleActivityData.para_5 or 10
end

function HSRDataManager:GetConsignPrice()
  local ret = LuaEntry.DataConfig:TryGetNum("server_train", "k6", 1000)
  return ret
end

function HSRDataManager:GetGoodsId()
  local ret = LuaEntry.DataConfig:TryGetNum("server_train", "k3", 650087)
  return ret
end

function HSRDataManager:GetGoldId()
  local ret = LuaEntry.DataConfig:TryGetNum("server_train", "k5", 650053)
  return ret
end

function HSRDataManager:GetFreeChangeCount()
  local ret = LuaEntry.DataConfig:TryGetNum("server_train", "k4", 3)
  return ret
end

function HSRDataManager:GetChangeItemPrice()
  local ret = LuaEntry.DataConfig:TryGetNum("server_train", "k8", 300)
  return ret
end

function HSRDataManager:GetChangeItemId()
  local ret = LuaEntry.DataConfig:TryGetNum("server_train", "k7", 650053)
  return ret
end

function HSRDataManager:GetMaxPassengerPerCarriage()
  local ret = LuaEntry.DataConfig:TryGetNum("server_train", "k13", 10)
  return ret
end

function HSRDataManager:GetDumpPriceInterval()
  local ret = LuaEntry.DataConfig:TryGetStr("server_train", "k14", "0.5;5")
  ret = string.split(ret, ";")
  local minPrice = tonumber(ret[1]) or 0.5
  local maxPrice = tonumber(ret[2]) or 5
  return minPrice, maxPrice
end

function HSRDataManager:GetDumpNumInterval()
  local ret = LuaEntry.DataConfig:TryGetStr("server_train", "k15", "10;20")
  ret = string.split(ret, ";")
  local minNum = tonumber(ret[1]) or 10
  local maxNum = tonumber(ret[2]) or 20
  return minNum, maxNum
end

function HSRDataManager:GetRobCount()
  return self.activityData and self.activityData.lootTimes or 0
end

function HSRDataManager:SetRobCount(num)
  if self.activityData then
    self.activityData.lootTimes = num
  end
end

function HSRDataManager:GetGetOnCount()
  return self.activityData and self.activityData.joinTimes or 0
end

function HSRDataManager:IsFilterOn()
  return self.activityData and self.activityData.filterServer and self.activityData.filterServer == 1
end

function HSRDataManager:SetFilterOn(isOn)
  if isOn ~= self:IsFilterOn() then
    SFSNetwork.SendMessage(MsgDefines.SeasonZoneTrainSetLootFilter, isOn)
  end
end

function HSRDataManager:HandleFilter(msg)
  if self.activityData then
    self.activityData.filterServer = msg.status
  end
  EventManager:GetInstance():Broadcast(EventId.HSRRobFilterRefresh)
end

function HSRDataManager:GetRedPoint()
  if self:GetRobCount() + self:GetGetOnCount() <= 0 then
    return 0
  end
  local lastOpenTime = CommonUtil.PlayerPrefsGetLong(SettingKeys.LATEST_OPEN_HSR_MAIN_UI, 0)
  local now = UITimeManager:GetInstance():GetServerSeconds()
  if UITimeManager:GetInstance():IsSameDayForServer(lastOpenTime, now) then
    return 0
  end
  return 1
end

function HSRDataManager:GetCurHSRUuid()
  return self.activityData and self.activityData.uuid
end

function HSRDataManager:GetLastCreateTimes(n)
  if not self.simpleActivityData or not self.simpleActivityData.para then
    Logger.LogError("HSRDataManager:GetLastCreateTimes() self.simpleActivityData is nil")
    return {}
  end
  local interval = tonumber(self.simpleActivityData.para) * 1000
  local startTime = self.simpleActivityData.startTime
  local now = UITimeManager:GetInstance():GetServerTime()
  local mod = (now - startTime) % interval
  local last = now - mod
  local ret = {}
  for i = 0, n - 1 do
    local time = last - i * interval
    if startTime <= time then
      table.insert(ret, time)
    else
      break
    end
  end
  return ret
end

function HSRDataManager:GetAllSendTimesBetween(fromTime, toTime)
  if not self.simpleActivityData or not self.simpleActivityData.para then
    Logger.LogError("HSRDataManager:GetAllSendTimesBetween() self.simpleActivityData is nil")
    return {}
  end
  local interval = tonumber(self.simpleActivityData.para) * 1000
  local startTime = self.simpleActivityData.startTime
  local mod = (toTime - startTime) % interval
  local last = toTime - mod
  local ret = {}
  while fromTime <= last do
    table.insert(ret, last)
    last = last - interval
  end
  return ret
end

function HSRDataManager:HasRunningHSR()
  return self.activityData and self.activityData.buyMaxNumList and #self.activityData.buyMaxNumList > 0
end

return HSRDataManager
