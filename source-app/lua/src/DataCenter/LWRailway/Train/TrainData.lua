local TrainData = BaseClass("TrainData")
local KeyFrame = require("DataCenter.LWRailway.Train.KeyFrame")
local Way = require("DataCenter.LWRailway.Way.Path")
local rapidjson = require("rapidjson")

function TrainData:__init(msg, isCSharp)
  self:Refresh(msg, isCSharp)
end

function TrainData:__delete()
  self:Destroy()
end

function TrainData:Refresh(msg, isCSharp)
  self.type = msg.type
  self.uuid = msg.uuid
  self.marchUid = msg.marchUid
  local meta = DataCenter.LWTrainDataManager:GetMeta(msg.cfgId)
  if not meta then
    Logger.LogError("train_property\231\129\171\232\189\166\233\133\141\231\189\174\228\184\141\229\173\152\229\156\168\239\188\154" .. (msg.cfgId or "nil"))
    return
  end
  self.cfgId = msg.cfgId
  self.meta = meta
  self.effectInfo = {}
  if msg.marchInfo and msg.marchInfo.effectInfo then
    for k, v in pairs(msg.marchInfo.effectInfo) do
      self.effectInfo[tonumber(k)] = v
    end
  end
  self.quality = meta.quality
  self.isSpecialURQuality = self.quality == 10
  self.carriageCount = meta.length
  self.serverId = msg.serverId
  self.length = DataCenter.LWMyStationDataManager:GET_CARRIAGE_LENGTH() * self.carriageCount
  self.speed = meta.speed * TileSize * 0.001
  local effectSpeedValue = 0
  if 0 < msg.sendTime then
    effectSpeedValue = self:GetEffectValue(EffectDefine.LW_IMPROVE_TRAIN_SPEED)
  else
    effectSpeedValue = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_IMPROVE_TRAIN_SPEED)
  end
  if self.type == TrainType.Truck then
    self.speed = self.speed * (1 + effectSpeedValue)
  else
    local info = DataCenter.LWAllyStationDataManager.Train_Speed_Param
    local value = 0
    if info and (msg.marchInfo.giftLv and msg.marchInfo.giftLv >= info.gift_lv or msg.buyFlag == 1) then
      value = tonumber(info.para1)
    end
    self.speed = self.speed * (1 + effectSpeedValue + value / 100)
  end
  self.slowness = 1 / self.speed
  self.period = DataCenter.LWMyStationDataManager:GET_CARRIAGE_LENGTH() * self.slowness
  self.timeLength = self.period * self.carriageCount
  self.frequency = 1 / self.period
  self.hasReward = msg.reward == 0
  self.completeness = msg.completeness
  self.maxLootPerTrain = DataCenter.LWAllyStationDataManager.MAX_LOOT_PER_TRAIN
  local info = DataCenter.LWAllyStationDataManager.Delete_Train_Times
  local value = 0
  local rightsOpenState = LuaEntry.DataConfig:CheckSwitch("alliance_train_vip")
  if msg.marchInfo.vipOn and info and rightsOpenState and (msg.marchInfo.giftLv and msg.marchInfo.giftLv >= info.gift_lv or msg.buyFlag == 1) then
    value = tonumber(info.para1)
  end
  self.maxLootPerTrain = self.maxLootPerTrain - value
  self.ownerId = msg.ownerId
  self.ownerLv = msg.level
  self.ownerPower = msg.power
  self.name = msg.name
  self.abbr = msg.abbr
  if self.ownerId == LuaEntry.Player.uid then
    self.pic = LuaEntry.Player.pic
    self.picVer = LuaEntry.Player.picVer
    self.headSkinId, self.headSkinET = LuaEntry.Player:GetHeadBgET()
  else
    self.pic = msg.headPic
    self.picVer = msg.headPicVer
    self.headSkinId = msg.headSkinId
    self.headSkinET = msg.headSkinET
  end
  self.allianceId = msg.allianceId
  self.allianceName = msg.alliancename
  self.allianceFlag = msg.icon
  local lastDepartureTs = self.departureTs
  self.departureTs = msg.sendTime or 0
  self.arriveTs = msg.arriveTime
  self.changeCountByGold = msg.changeCountByGold
  self.baseGoods = msg.baseGoods
  self.extraGoods = msg.extraGoods
  self.multiple = 1
  if self.baseGoods and self.baseGoods.multiple then
    self.multiple = self.baseGoods.multiple
  end
  self.scoutCount = msg.scoutCount
  local worldCityTableName = SeasonUtil.GetWorldCityTableNameBySeasonConfigId(msg.seasonCfgId or 1)
  local stationList = msg.stationList
  self.way = Way.New(msg.startPos, stationList, worldCityTableName, msg.serverId)
  self.heroInfo = {}
  self.power = 0
  self.marchInfo = msg.marchInfo
  if not msg.marchInfo then
    Logger.LogError("No MarchInfo")
  end
  self.keyFrames = {}
  if 0 < self.departureTs and UITimeManager:GetInstance():GetServerTime() < self.arriveTs then
    self:InitKeyFrame(msg.marchInfo)
  end
  self.vipInfo = nil
  if msg.type == TrainType.Train then
    self.teamList = {}
    local formation = msg.marchInfo.formation
    if formation then
      if formation.armyUnit1 then
        self.teamList[1] = formation.armyUnit1
      end
      if formation.armyUnit2 then
        self.teamList[2] = formation.armyUnit2
      end
      if formation.armyUnit3 then
        self.teamList[3] = formation.armyUnit3
      end
      for _, teamInfo in pairs(self.teamList) do
        teamInfo.totalPower = teamInfo.power
        self.power = self.power + teamInfo.totalPower
      end
    end
    self.vipInfo = msg.vipInfo
    self.selfSelect = msg.selfSelect
    if self.vipInfo then
      DataCenter.LWTrainPrepareSceneManager:SetAcceptVipInfoValue(true)
    end
  else
    local heroInfo = msg.marchInfo.heroInfo
    if heroInfo then
      for i = 1, ArmyFormationSlot.Dominator do
        local hero = heroInfo[tostring(i)]
        if hero then
          self.heroInfo[i] = hero
          self.power = self.power + hero.power
        end
      end
    end
    if msg.marchInfo and msg.marchInfo.power then
      self.power = msg.marchInfo.power
    end
  end
  self.buildUuid = tonumber(msg.relationId)
  self.index = DataCenter.LWMyStationDataManager:GetTruckIndexByBuildUuid(self.buildUuid)
  self.plunderRecord = msg.marchInfo and msg.marchInfo.plunderRecord
  self.squadNo = msg.marchInfo and msg.marchInfo.squadNo
  self.squadNoClient = msg.marchInfo and msg.marchInfo.squadNoClient
  self.insuranceFindBackReward = {}
  if msg.freeInsurance then
    local freeInsuranceJsonData = rapidjson.decode(msg.freeInsurance or "[]")
    for i = 1, #freeInsuranceJsonData do
      table.insert(self.insuranceFindBackReward, freeInsuranceJsonData[i])
    end
  end
  if msg.vipInsurance then
    local vipInsuranceJsonData = rapidjson.decode(msg.vipInsurance or "[]")
    for i = 1, #vipInsuranceJsonData do
      table.insert(self.insuranceFindBackReward, vipInsuranceJsonData[i])
    end
  end
  if self.plunderRecord then
    for _, v in pairs(self.plunderRecord) do
      v.combinationPlunderReward = {}
      if v.plunderReward then
        local plunderRewardCount = #v.plunderReward
        for i = 1, plunderRewardCount do
          table.insert(v.combinationPlunderReward, v.plunderReward[i])
        end
      end
      if v.extraPlunderReward then
        local extraPlunderRewardCount = #v.extraPlunderReward
        for i = 1, extraPlunderRewardCount do
          local extraReward = v.extraPlunderReward[i]
          extraReward.trainRewardState = TrainRewardState.Extra
          table.insert(v.combinationPlunderReward, extraReward)
        end
        local hasSameReward, reward2Count = self:CheckHasSameReward(v.extraPlunderReward)
        if hasSameReward then
          local logParts = {}
          for rewardId, count in pairs(reward2Count) do
            local rewardStr = string.format("rewardId: %s -> count: %s", rewardId, count)
            table.insert(logParts, rewardStr)
          end
          Logger.LogInfo(string.format("train uid: %s has repeat extraPlunderReward\239\188\154%s", self.uuid, table.concat(logParts, ";")))
        end
      end
    end
  end
  self.enemy = msg.enemy
  if msg.marchInfo.carriageList then
    self.carriages = {}
    for i = 1, #msg.marchInfo.carriageList do
      local carriageData = msg.marchInfo.carriageList[i]
      self.carriages[carriageData.carriageId + 1] = carriageData
    end
  end
  self.lastUpdateTime = msg.lastUpdateTime or 0
  if msg.type == TrainType.Train then
    if lastDepartureTs ~= nil and lastDepartureTs == 0 and 0 < self.departureTs then
      EventManager:GetInstance():Broadcast(EventId.AllianceTrainDeparted, self.uuid)
    end
    self.newAllianceTrain = msg.newAllianceTrain
  end
  self.buyFlag = msg.buyFlag
  self.giftLv = msg.marchInfo.giftLv
  self.vipOn = msg.marchInfo.vipOn
  self.cacheIsContainHighGoods = nil
  self.saveMark = false
  if msg.marchInfo and msg.marchInfo.saveMark then
    self.saveMark = msg.marchInfo.saveMark == 1 and true or false
  end
  self.cacheFullReward2DiamondPrice = nil
  self.cacheBakReward2DiamondPrice = nil
end

function TrainData:RefreshLastUpdateTime(time)
  self.lastUpdateTime = time
end

function TrainData:Destroy()
  self.uuid = nil
  self.marchUid = nil
  self.meta = nil
  self.quality = nil
  self.carriageCount = nil
  self.length = nil
  self.speed = nil
  self.slowness = nil
  self.hasReward = nil
  self.completeness = nil
  self.ownerId = nil
  self.allianceId = nil
  self.departureTs = 0
  self.arriveTs = nil
  self.changeCountByGold = nil
  self.baseGoods = nil
  self.extraGoods = nil
  self.scoutCount = nil
  if self.way then
    self.way:Destroy()
    self.way = nil
  end
  self.keyFrames = {}
  self.initState = nil
  self.full = nil
  self.effectInfo = nil
  self.lastUpdateTime = nil
  self.multiple = nil
  self.cacheIsContainHighGoods = nil
  self.saveMark = nil
  self.cacheFullReward2DiamondPrice = nil
  self.cacheBakReward2DiamondPrice = nil
end

function TrainData:UpdateSpeed()
  if self.departureTs <= 0 then
    self.speed = self.meta.speed * TileSize * 0.001
    local effectSpeedValue = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_IMPROVE_TRAIN_SPEED)
    if self.type == TrainType.Train then
      local info = DataCenter.LWAllianceRightShowTemplateManager:GetTemplate(801)
      local value = 0
      if info and (self.giftLv and self.giftLv >= info.gift_lv or self.buyFlag == 1) then
        value = tonumber(info.para1)
      end
      self.speed = self.speed * (1 + effectSpeedValue + value / 100)
    else
      self.speed = self.speed * (1 + effectSpeedValue)
    end
    self.slowness = 1 / self.speed
    self.period = DataCenter.LWMyStationDataManager:GET_CARRIAGE_LENGTH() * self.slowness
    self.timeLength = self.period * self.carriageCount
    self.frequency = 1 / self.period
  end
end

function TrainData:GetTravelTotalTime()
  if self.departureTs <= 0 then
    return self:GetTravelLength() * self.slowness
  else
    return self.arriveTs - self.departureTs
  end
end

function TrainData:CustomRewardSortFunc(rewardList)
  if rewardList == nil then
    return rewardList
  end
  local insertPos = 1
  for i = 1, #rewardList do
    local rewardItem = rewardList[i]
    if rewardItem.value ~= nil and type(rewardItem.value) == "table" and rewardItem.value.showType == RewardShowType.TRAIN_SEASON_EXTRA then
      table.remove(rewardList, i)
      table.insert(rewardList, insertPos, rewardItem)
      insertPos = insertPos + 1
    end
  end
end

function TrainData:GetFullRewardData()
  if not self.full then
    self.full = {}
    if self.type == TrainType.Truck then
      self.full = table.mergeArray(self.extraGoods.full, self.baseGoods.full)
    else
      for _, carriage in pairs(self.carriages) do
        for _, reward in pairs(carriage.trainGoods.full) do
          table.insert(self.full, reward)
        end
      end
    end
    self:CustomRewardSortFunc(self.full)
  end
  return self.full
end

function TrainData:GetCurRewardData()
  local ret = {}
  if self.type == TrainType.Truck then
    ret = table.mergeArray(self.extraGoods.cur, self.baseGoods.cur)
  else
    for _, carriage in pairs(self.carriages) do
      for _, reward in pairs(carriage.trainGoods.cur) do
        table.insert(ret, reward)
      end
    end
  end
  self:CustomRewardSortFunc(ret)
  return ret
end

function TrainData:GetLostRewardData()
  local ret = {}
  if self.type == TrainType.Truck then
    if self.plunderRecord then
      for _, v in pairs(self.plunderRecord) do
        if v.combinationPlunderReward then
          ret = table.mergeArray(ret, v.combinationPlunderReward)
        end
      end
    end
    self:CustomRewardSortFunc(ret)
    if self.insuranceFindBackReward and table.count(self.insuranceFindBackReward) > 0 then
      for j = 1, #ret do
        ret[j].isFindBack = false
      end
      for i = 1, #self.insuranceFindBackReward do
        local insuranceFindBackRewardItemId = 0
        local insuranceFindBackRewardNum = 0
        local insuranceFindBackRewardType = self.insuranceFindBackReward[i].type
        if type(self.insuranceFindBackReward[i].value) == "table" then
          insuranceFindBackRewardItemId = self.insuranceFindBackReward[i].value.id
          insuranceFindBackRewardNum = self.insuranceFindBackReward[i].value.num
        else
          insuranceFindBackRewardNum = self.insuranceFindBackReward[i].value
        end
        for j = 1, #ret do
          local retDataItemId = 0
          local retDataItemNum = 0
          local retDataItemType = ret[j].type
          if type(ret[j].value) == "table" then
            retDataItemId = ret[j].value.id
            retDataItemNum = ret[j].value.num * self.multiple
          else
            retDataItemNum = ret[j].value * self.multiple
          end
          if not ret[j].isFindBack and insuranceFindBackRewardNum == retDataItemNum and insuranceFindBackRewardItemId == retDataItemId and insuranceFindBackRewardType == retDataItemType then
            ret[j].isFindBack = true
            break
          end
        end
      end
    end
  else
    for _, carriage in pairs(self.carriages) do
      for _, reward in pairs(carriage.plunder) do
        table.insert(ret, reward)
      end
    end
    self:CustomRewardSortFunc(ret)
  end
  return ret
end

function TrainData:GetFullRewardByCarriageId(index)
  return self.carriages[index].trainGoods.full
end

function TrainData:GetCurRewardByCarriageId(index)
  return self.carriages[index].trainGoods.cur
end

function TrainData:GetLostRewardByCarriageId(index)
  return self.carriages[index].plunder
end

function TrainData:GetFireCountByCarriageId(index)
  if not self.carriages or not self.carriages[index] then
    return 0
  end
  local plunder = self.carriages[index].plunder
  if plunder then
    return #plunder
  else
    return 0
  end
end

function TrainData:GetBakRewardByCarriageId(index)
  return self.carriages[index].bak
end

function TrainData:InitKeyFrame(marchInfo)
  if not self.way then
    return
  end
  self.keyFrames = {}
  local lastPointOrder = marchInfo.lastPosIndex
  local lastPullInTs = marchInfo.lastArriveTime
  local lastPullOutTs = marchInfo.lastSendTime
  if lastPullOutTs == nil or lastPullInTs == nil then
    Logger.LogError("TrainData.InitKeyFrame invalid uuid : " .. (self.uuid or ""))
  end
  self.lastPointOrder = lastPointOrder
  self.lastPullInTs = lastPullInTs
  self.lastPullOutTs = lastPullOutTs
  self.nextEndTime = marchInfo.nextEndTime
  local nextKeyFrameTs = marchInfo.nextEndTime
  local frameTs, newFrame, frameDir
  local lastPoint = self.way:GetPoint(lastPointOrder)
  local nextPoint = self.way:GetPoint(lastPointOrder + 1)
  if lastPullInTs > lastPullOutTs then
    self.initState = CarriageState.PullIn
    frameDir = Vector3.Normalize(nextPoint:GetPos() - lastPoint:GetPos())
    newFrame = KeyFrame.New(lastPullOutTs, TrainKeyFrameType.PullOut, lastPoint, lastPoint:GetPos(), frameDir)
    table.insert(self.keyFrames, newFrame)
    frameTs = lastPullOutTs - self.length * self.slowness
    newFrame = KeyFrame.New(frameTs, TrainKeyFrameType.PullIn, lastPoint, lastPoint:GetPos(), frameDir)
    table.insert(self.keyFrames, 1, newFrame)
    newFrame = KeyFrame.New(lastPullInTs, TrainKeyFrameType.PullIn, nextPoint, nextPoint:GetPos(), frameDir)
    table.insert(self.keyFrames, newFrame)
    local nextNextPoint = self.way:GetPoint(lastPointOrder + 2)
    if nextNextPoint then
      frameDir = Vector3.Normalize(nextNextPoint:GetPos() - nextPoint:GetPos())
    end
    newFrame = KeyFrame.New(nextKeyFrameTs, TrainKeyFrameType.PullOut, nextPoint, nextPoint:GetPos(), frameDir)
    table.insert(self.keyFrames, newFrame)
  else
    self.initState = CarriageState.Straight
    frameDir = Vector3.Normalize(nextPoint:GetPos() - lastPoint:GetPos())
    newFrame = KeyFrame.New(lastPullOutTs, TrainKeyFrameType.PullOut, lastPoint, lastPoint:GetPos(), frameDir)
    table.insert(self.keyFrames, newFrame)
    newFrame = KeyFrame.New(lastPullInTs, TrainKeyFrameType.PullIn, lastPoint, lastPoint:GetPos(), frameDir)
    table.insert(self.keyFrames, 1, newFrame)
    newFrame = KeyFrame.New(nextKeyFrameTs, TrainKeyFrameType.PullIn, nextPoint, nextPoint:GetPos(), frameDir)
    table.insert(self.keyFrames, newFrame)
  end
end

function TrainData:CalculateDescription(ts)
  local frame1, frame2, trainState = self:GetTwoClosestKeyFrames(ts)
  if not frame1 then
    return trainState, 0, "", "", Vector3.zero, Vector3.zero
  elseif frame1.type == TrainKeyFrameType.PullIn then
    local lastPoint = self.way:GetPrevPoint(frame1.point) or frame1.point
    local lastName = lastPoint:GetName() or self:GetAbbrAndName()
    local nextName = frame1.point:GetName() or self:GetAbbrAndName()
    return trainState, frame2.ts, lastName, nextName, lastPoint:GetPos(), frame1.point:GetPos()
  elseif frame1.type == TrainKeyFrameType.PullOut then
    local lastName = frame1.point:GetName() or self:GetAbbrAndName()
    return trainState, frame2.ts, lastName, frame2.point:GetName(), frame1.point:GetPos(), frame2.point:GetPos()
  end
end

function TrainData:LogAllKeyFrames()
end

function TrainData:CalculateTransform(ts)
  local frame1, frame2 = self:GetTwoClosestKeyFrames(ts)
  if not frame1 then
    return Vector3.zero, Vector3.right, Quaternion.identity, CarriageState.PullIn
  elseif frame1.type == TrainKeyFrameType.PullIn then
    local deltaT = ts - frame1.ts
    if deltaT < self.period then
      local lerpValue = deltaT / (frame2.ts - frame1.ts)
      local pos = Vector3.Lerp(frame1.pos, frame1.pos + frame1.dir * self.length, lerpValue)
      return pos, frame1.dir, frame1:GetRot(), CarriageState.PullIn, deltaT * self.frequency, frame1
    else
      return frame1.pos, frame1.dir, frame1:GetRot(), CarriageState.Hide, nil, frame1
    end
  elseif frame1.type == TrainKeyFrameType.PullOut then
    local deltaT = ts - frame1.ts
    local lerpValue = deltaT / (frame2.ts - frame1.ts)
    local pos = Vector3.Lerp(frame1.pos, frame2.pos, lerpValue)
    if deltaT < self.period then
      return pos, frame1.dir, frame1:GetRot(), CarriageState.PullOut, deltaT * self.frequency, frame1
    else
      return pos, frame1.dir, frame1:GetRot(), CarriageState.Straight, nil, frame1
    end
  else
    Logger.LogError("frame1.type" .. frame1.type)
  end
end

function TrainData:GetTwoClosestKeyFrames(ts)
  local frame1, frame2 = self:TryGetTwoClosestKeyFrames(ts)
  while not frame1 do
    if self:CalculateNextKeyFrame() then
      frame1, frame2 = self:TryGetTwoClosestKeyFramesCycle(ts)
    else
      local latestFrame = self.keyFrames[#self.keyFrames]
      return latestFrame, latestFrame, TrainState.ArrivedFinal
    end
  end
  return frame1, frame2
end

function TrainData:TryGetTwoClosestKeyFramesCycle(ts)
  local frameCount = #self.keyFrames
  local latestFrame = self.keyFrames[frameCount]
  if ts <= latestFrame.ts then
    return self.keyFrames[frameCount - 1], latestFrame
  else
    return nil, nil
  end
end

function TrainData:TryGetTwoClosestKeyFrames(ts)
  if self.keyFrames == nil then
    Logger.LogError("TrainData.TryGetTwoClosestKeyFrames invalid uuid : " .. (self.uuid or ""))
    return nil, nil
  end
  local frameCount = #self.keyFrames
  if frameCount < 2 then
    Logger.Log("frameCount==" .. frameCount)
    return nil, nil
  end
  if ts > self.keyFrames[frameCount].ts then
    return nil, nil
  end
  if ts < self.keyFrames[1].ts then
    return self.keyFrames[1], self.keyFrames[1]
  end
  for i = frameCount, 2, -1 do
    local kf1, kf2 = self.keyFrames[i - 1], self.keyFrames[i]
    if ts >= kf1.ts and ts <= kf2.ts then
      return kf1, kf2
    end
  end
  return nil, nil
end

function TrainData:CalculateNextKeyFrame()
  local latestFrame = self.keyFrames[#self.keyFrames]
  if not latestFrame then
    return false
  end
  if latestFrame.type == TrainKeyFrameType.PullOut then
    local nextPoint = self.way:GetNextPoint(latestFrame.point)
    if not nextPoint then
      return false
    end
    local frameTs = latestFrame.ts + self.way:GetNextPointDistance(latestFrame.point) * self.slowness
    local newFrame = KeyFrame.New(frameTs, TrainKeyFrameType.PullIn, nextPoint, nextPoint:GetPos(), latestFrame.dir)
    table.insert(self.keyFrames, newFrame)
  elseif latestFrame.type == TrainKeyFrameType.PullIn then
    local nextPoint = self.way:GetNextPoint(latestFrame.point)
    if nextPoint then
      local frameTs = latestFrame.ts + self.length * self.slowness
      local frameDir = Vector3.Normalize(nextPoint:GetPos() - latestFrame.point:GetPos())
      local newFrame = KeyFrame.New(frameTs, TrainKeyFrameType.PullOut, latestFrame.point, latestFrame.pos, frameDir)
      table.insert(self.keyFrames, newFrame)
    else
      local frameTs = latestFrame.ts + self.length * self.slowness
      local newFrame = KeyFrame.New(frameTs, TrainKeyFrameType.PullOut, latestFrame.point, latestFrame.pos, latestFrame.dir)
      table.insert(self.keyFrames, newFrame)
    end
  end
  return true
end

function TrainData:GetTravelLength()
  if not self.way then
    return 0
  end
  local ret = self.way:GetLength()
  ret = ret + (self.way.numOfPoint - 1) * self.length
  return ret
end

function TrainData:GetQualityPath()
  return QualityImagePath[self.quality] or QualityImagePath[1]
end

function TrainData:GetTrainIcon()
  local ur = RailwayUtil.IsUR(self.cfgId)
  return ur and QualityTrainIconPath[self.quality] or QualityTrainIconPath[1]
end

function TrainData:GetAbbrAndName()
  if self.ownerId == LuaEntry.Player.uid then
    return LuaEntry.Player:GetFullName()
  elseif self.serverId == LuaEntry.Player:GetSelfServerId() then
    return UIUtil.FormatAllianceAndName(self.abbr, self.name, self.ownerId)
  else
    return UIUtil.FormatServerAllianceName(self.serverId, self.abbr, self.name, self.ownerId)
  end
end

function TrainData:GetAbbrAndRealName()
  if self.ownerId == LuaEntry.Player.uid then
    return LuaEntry.Player:GetFullName()
  elseif self.serverId == LuaEntry.Player:GetSelfServerId() then
    return UIUtil.FormatAllianceAndName(self.abbr, self.name)
  else
    return UIUtil.FormatServerAllianceName(self.serverId, self.abbr, self.name)
  end
end

function TrainData:GetQualityString()
  local imgPath = "UR"
  local quality = self.quality
  if quality == 1 then
    imgPath = "N"
  elseif quality == 2 then
    imgPath = "R"
  elseif quality == 3 then
    imgPath = "SR"
  elseif quality == 4 then
    imgPath = "SSR"
  end
  return imgPath
end

function TrainData:IsMyTrain()
  return self.ownerId == LuaEntry.Player.uid
end

function TrainData:IAmBigBrotherVip()
  return self.vipInfo and self.vipInfo.vipId == LuaEntry.Player.uid and self.vipInfo.vipType == TrainVipType.isBigBro
end

function TrainData:HaveVip()
  return self.vipInfo and self.vipInfo.vipId
end

function TrainData:IAmVip()
  return self.vipInfo and self.vipInfo.vipId == LuaEntry.Player.uid
end

function TrainData:IsAllyTrain()
  if string.IsNullOrEmpty(self.allianceId) then
    return false
  end
  return self.allianceId == LuaEntry.Player.allianceId
end

function TrainData:IsMyOrAllyTrain()
  return self:IsMyTrain() or self:IsAllyTrain()
end

function TrainData:GetChangeCost()
  if self.changeCountByGold then
    local CHANGE_COST = DataCenter.LWMyStationDataManager:GET_CHANGE_COST()
    return CHANGE_COST[self.changeCountByGold + 1] or CHANGE_COST[#CHANGE_COST]
  end
  return 1
end

function TrainData:GetTrainState()
  if self.departureTs <= 0 then
    return TrainState.BeforeDeparture
  elseif UITimeManager:GetInstance():GetServerTime() < self.arriveTs then
    return TrainState.Travelling
  end
  return TrainState.ArrivedFinal
end

function TrainData:GetPassengerByUid(uid)
  if self.vipInfo and self.vipInfo.vipId == uid then
    if self.carriages and #self.carriages >= 5 then
      local list = self.vipInfo.vipReward
      table.sort(list)
      return self.vipInfo, self.carriages[list[1] + 1], self.carriages[list[2] + 1]
    end
  else
    for _, carriage in pairs(self.carriages) do
      for _, passenger in pairs(carriage.passengerList) do
        if passenger.uid == uid then
          if uid == self.ownerId then
            passenger.power = self.ownerPower
          end
          return passenger, carriage
        end
      end
    end
  end
end

function TrainData:GetEffectValue(effectId)
  local value = 0
  if self.effectInfo and self.effectInfo[effectId] ~= nil then
    value = self.effectInfo[effectId]
  end
  return value
end

function TrainData:GetFailureCountByUuid(targetUuid)
  local failureCount = 0
  for i, v in pairs(self.plunderRecord) do
    if v.uid == targetUuid and v.isWin then
      failureCount = failureCount + 1
    end
  end
  return failureCount
end

function TrainData:IsUR()
  return self.cfgId == 152
end

local TruckPrefabPath = {
  [1] = "Assets/Main/Prefabs/World/WorldTruck1.prefab",
  [2] = "Assets/Main/Prefabs/World/WorldTruck2.prefab",
  [3] = "Assets/Main/Prefabs/World/WorldTruck3.prefab",
  [4] = "Assets/Main/Prefabs/World/WorldTruck4.prefab",
  [5] = "Assets/Main/Prefabs/World/WorldTruck5.prefab"
}

function TrainData:GetWorldModelPath(serverId)
  if self.type == TrainType.Truck then
    if self.quality <= 5 then
      local theServerId = serverId or self.serverId
      local seasonInfo = SeasonUtil.GetSeasonInfo(theServerId)
      if seasonInfo then
        local seasonType = seasonInfo:GetServerType()
        local mapIndex = DataCenter.SeasonDataManager:GetNinePalacesIndex(theServerId)
        local skinMeta = seasonInfo:GetWorldSkinTemplate(mapIndex)
        if skinMeta ~= nil and seasonType == SeasonMapType.Darkness and DataCenter.BloodyNightDataManager:IsDawn(theServerId) then
          skinMeta = nil
        end
        if skinMeta and skinMeta.world_truck_path then
          return string.format(skinMeta.world_truck_path, self.quality)
        end
      end
    end
    if string.IsNullOrEmpty(self.meta.world_model) then
      return TruckPrefabPath[self.quality]
    else
      return self.meta.world_model
    end
  else
    Logger.LogError("\232\191\153\228\184\170\230\150\185\230\179\149\229\143\170\232\131\189\231\148\168\230\157\165\232\142\183\229\143\150\229\141\161\232\189\166\232\183\175\229\190\132")
  end
end

function TrainData:GetCityModelPath(serverId)
  if self.type == TrainType.Truck then
    local truckPath = self.meta.city_model
    if self.quality <= 5 then
      local theServerId = serverId or self.serverId
      local seasonInfo = SeasonUtil.GetSeasonInfo(theServerId)
      if seasonInfo then
        local mapIndex = DataCenter.SeasonDataManager:GetNinePalacesIndex(theServerId)
        local skinMeta = seasonInfo:GetWorldSkinTemplate(mapIndex)
        if skinMeta and skinMeta.city_truck_path then
          truckPath = string.format(skinMeta.city_truck_path, self.quality)
        end
      end
    end
    if string.IsNullOrEmpty(truckPath) then
      local path = DataCenter.LWMyStationDataManager:GetStationTruckPath()
      truckPath = path[self.quality]
    end
    return truckPath
  else
    Logger.LogError("\232\191\153\228\184\170\230\150\185\230\179\149\229\143\170\232\131\189\231\148\168\230\157\165\232\142\183\229\143\150\229\141\161\232\189\166\232\183\175\229\190\132")
    return ""
  end
end

function TrainData:GetIcon(serverId)
  if self.type == TrainType.Truck and self.quality <= 5 then
    local theServerId = serverId or self.serverId
    local seasonInfo = SeasonUtil.GetSeasonInfo(theServerId)
    if seasonInfo then
      local mapIndex = DataCenter.SeasonDataManager:GetNinePalacesIndex(theServerId)
      local skinMeta = seasonInfo:GetWorldSkinTemplate(mapIndex)
      if skinMeta and skinMeta.truck_small_icon then
        return string.format(skinMeta.truck_small_icon, self.quality)
      end
    end
  end
  return self.meta.icon
end

function TrainData:GetBgIcon(serverId)
  if self.type == TrainType.Truck and self.quality <= 5 then
    local theServerId = serverId or self.serverId
    local seasonInfo = SeasonUtil.GetSeasonInfo(theServerId)
    if seasonInfo then
      local mapIndex = DataCenter.SeasonDataManager:GetNinePalacesIndex(theServerId)
      local skinMeta = seasonInfo:GetWorldSkinTemplate(mapIndex)
      if skinMeta and skinMeta.truck_big_icon then
        return string.format(skinMeta.truck_big_icon, self.quality)
      end
    end
  end
  return self.meta.bg_icon
end

function TrainData:GetDebugInfos()
  if self.way then
    return self.lastPointOrder or 0, self.lastPullInTs or 0, self.lastPullOutTs or 0, self.way:GetDebugWayList()
  end
  return self.lastPointOrder or 0, self.lastPullInTs or 0, self.lastPullOutTs or 0, "", ""
end

function TrainData:GetHeadAndTailPos(ts)
  local position, dir = self:CalculateTransform(ts)
  return position, position - dir * self.length
end

function TrainData:GetIsContainHighGoods()
  if self.cacheIsContainHighGoods == nil then
    if self.type == TrainType.Truck then
      self.cacheIsContainHighGoods = self:JudgeTruckIsContainHighGoods()
    else
      self.cacheIsContainHighGoods = self:JudgeTrainIsIncludeHighGoods()
    end
  end
  return self.cacheIsContainHighGoods
end

function TrainData:JudgeTruckIsContainHighGoods()
  local judgeStandardMap = DataCenter.LWMyStationDataManager:GetHighQualityIncludeItem()
  if judgeStandardMap == nil then
    return false
  end
  local fullRewardList = self:GetFullRewardData()
  local recordItemId2Count = {}
  for i, rewardData in ipairs(fullRewardList) do
    local itemId, count = 0, 0
    if type(rewardData.value) == "table" then
      itemId = tonumber(rewardData.value.id)
      count = rewardData.value.num
    else
      itemId = rewardData.type
      count = self:CorrectResourceRewardCount(rewardData.value)
    end
    local cacheCount = recordItemId2Count[itemId] or 0
    recordItemId2Count[itemId] = cacheCount + count
  end
  local findOne = false
  for goodId, goodCount in pairs(judgeStandardMap) do
    local targetCount = recordItemId2Count[goodId] or 0
    if goodCount <= targetCount then
      findOne = true
      break
    end
  end
  return findOne
end

function TrainData:JudgeTrainIsIncludeHighGoods()
  local judgeStandardList = DataCenter.LWAllyStationDataManager:GetJudgeHighGoodsStandardList()
  if judgeStandardList == nil then
    return false
  end
  local recordItemId2Count = {}
  for _, carriage in pairs(self.carriages) do
    if carriage and carriage.carriageId > 0 and carriage.trainGoods and carriage.trainGoods.full then
      for _, reward in pairs(carriage.trainGoods.full) do
        local itemId, count = 0, 0
        if type(reward.value) == "table" then
          itemId = tonumber(reward.value.id)
          count = reward.value.num
        else
          itemId = reward.type
          count = reward.value
        end
        local cacheCount = recordItemId2Count[itemId] or 0
        recordItemId2Count[itemId] = cacheCount + count
      end
    end
  end
  local findOne = false
  for i = 1, table.count(judgeStandardList) do
    local goodsMap = judgeStandardList[i]
    if goodsMap then
      local satisfyCondition = true
      for goodId, goodCount in pairs(goodsMap) do
        if recordItemId2Count[goodId] == nil or goodCount > recordItemId2Count[goodId] then
          satisfyCondition = false
          break
        end
      end
      if satisfyCondition then
        findOne = true
        break
      end
    end
  end
  return findOne
end

function TrainData:GetTrainHasSaveHighGoods()
  if self.carriages then
    for _, carriage in pairs(self.carriages) do
      if carriage and carriage.carriageId > 0 and carriage.bak and 0 < table.count(carriage.bak) then
        return true
      end
    end
  end
  return false
end

function TrainData:GetFullReward2DiamondPrice()
  if self.cacheFullReward2DiamondPrice == nil then
    local rewardList = {}
    for _, carriage in pairs(self.carriages) do
      if carriage and carriage.carriageId > 0 and carriage.trainGoods and carriage.trainGoods.full then
        for _, reward in pairs(carriage.trainGoods.full) do
          table.insert(rewardList, reward)
        end
      end
    end
    self.cacheFullReward2DiamondPrice = self:CalculateReward2DiamondPrice(rewardList)
  end
  return self.cacheFullReward2DiamondPrice
end

function TrainData:GetBakReward2DiamondPrice()
  if self.cacheBakReward2DiamondPrice == nil then
    local rewardList = {}
    for _, carriage in pairs(self.carriages) do
      if carriage and carriage.carriageId > 0 and carriage.bak then
        for _, reward in pairs(carriage.bak) do
          table.insert(rewardList, reward)
        end
      end
    end
    self.cacheBakReward2DiamondPrice = self:CalculateReward2DiamondPrice(rewardList)
  end
  return self.cacheBakReward2DiamondPrice
end

function TrainData:CalculateReward2DiamondPrice(rewardList)
  local diamondPrice = 0
  if table.count(rewardList) == 0 then
    return diamondPrice
  end
  for i, rewardData in ipairs(rewardList) do
    local itemId, count = 0, 0
    if type(rewardData.value) == "table" then
      itemId = tonumber(rewardData.value.id)
      count = rewardData.value.num
    else
      itemId = rewardData.type
      count = rewardData.value
      if self.type == TrainType.Truck then
        count = self:CorrectResourceRewardCount(count)
      end
    end
    if rewardData.type == RewardType.GOODS then
      local price = DataCenter.LWTrainAdditionPriceTemplateManager:GetPrice(TrainAdditionPriceType.Goods, itemId)
      if 0 < price then
        diamondPrice = diamondPrice + count * price
      end
    else
      local resourceType = RewardToResType[itemId]
      local price = DataCenter.LWTrainAdditionPriceTemplateManager:GetPrice(TrainAdditionPriceType.Resource, resourceType)
      if 0 < price then
        diamondPrice = diamondPrice + math.floor(count / price)
      end
    end
  end
  return diamondPrice
end

function TrainData:CorrectResourceRewardCount(oriCount)
  local effectValue = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_BASIC_RESOURCE_PRODUCT_PROMOTION)
  local newCount = oriCount * (1 + effectValue)
  return math.floor(newCount)
end

function TrainData:CheckHasSameReward(rewardList)
  local reward2Count = {}
  local hasSameReward = false
  for i = 1, #rewardList do
    local rewardData = rewardList[i]
    local rewardId = 0
    if type(rewardData.value) == "table" then
      if rewardData.value.id then
        rewardId = tonumber(rewardData.value.id)
      end
    else
      rewardId = rewardData.type
    end
    if 0 < rewardId then
      local curCount = reward2Count[rewardId] or 0
      curCount = curCount + 1
      reward2Count[rewardId] = curCount
      if 1 < curCount then
        hasSameReward = true
      end
    end
  end
  return hasSameReward, reward2Count
end

return TrainData
