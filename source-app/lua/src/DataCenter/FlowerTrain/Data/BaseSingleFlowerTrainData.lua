local BaseSingleFlowerTrainData = BaseClass("BaseSingleFlowerTrainData")
local Localization = CS.GameEntry.Localization
local FlowerTrainConstant = require("DataCenter.FlowerTrain.FlowerTrainConstant")

function BaseSingleFlowerTrainData:__init()
  self.uuid = nil
  self.fromGoodsId = nil
  self.lv = 0
  self.upLvTime = 0
  self.sendTime = 0
  self.arriveTime = 0
  self.connectNum = 0
  self.likeCount = 0
  self.cheerCount = 0
  self.playerUid = nil
  self.headPicVer = 0
  self.name = ""
  self.abbr = nil
  self.cheerHistoryPlayerDic = nil
  self.serverId = nil
  self.expFireConfigList = nil
  self.isSelf = false
  self.lastSyncDataTime = 0
  self.maxLikeCountPerPlayer = 0
  self.cheerCostGoodsId = 0
  self.cheerCostGoodsNum = 0
  self.historyStationList = nil
  self.marchUuid = nil
end

function BaseSingleFlowerTrainData:__delete()
  self.uuid = nil
  self.fromGoodsId = nil
  self.lv = nil
  self.upLvTime = nil
  self.sendTime = nil
  self.arriveTime = nil
  self.connectNum = nil
  self.isSelf = nil
  self.expFireConfigList = nil
  self.lastSyncDataTime = nil
  self.maxLikeCountPerPlayer = nil
  self.cheerCostGoodsId = nil
  self.cheerCostGoodsNum = nil
  self.likeCount = nil
  self.cheerCount = nil
  self.marchUuid = nil
  self.cheerHistoryPlayerDic = nil
  self.serverId = nil
end

function BaseSingleFlowerTrainData:UpdateData(serverData)
  self.serverData = serverData
  self.uuid = serverData.uuid or ""
  self.fromGoodsId = serverData.cfgId or 0
  self.lv = serverData.curLv or 0
  self.upLvTime = serverData.upLvTime or 0
  self.sendTime = serverData.sendTime or 0
  self.arriveTime = serverData.arriveTime or 0
  self.connectNum = serverData.connectNum or 0
  self.startPoint = serverData.startPoint or 0
  self.endPoint = serverData.endPoint or 0
  self.playerUid = serverData.uid or ""
  self.headPicVer = serverData.headPicVer or 0
  self.name = serverData.name or ""
  self.abbr = serverData.abbr or ""
  self.likeCount = serverData.likeCount or serverData.praise or 0
  self.cheerCount = serverData.cheerCount or serverData.cheer or 0
  self.marchUuid = serverData.marchUuid
  self.curExp = serverData.curExp
  self.serverId = serverData.serverId or LuaEntry.Player:GetCurServerId()
  self.isSelf = LuaEntry.Player.uid == serverData.uid
  self.isArrived = serverData.arrived == 1
  local lvGroupId = FlowerTrainUtils.GetFlowerLvGroupByGoodsId(self.fromGoodsId)
  self.lvMeta = FlowerTrainUtils.GetFlowerTrainLvMeta(lvGroupId, self.lv)
  self.showMeta = FlowerTrainUtils.GetFlowerTrainDisplayMetaByGoodsId(self.fromGoodsId, self.lv)
  self.trainConfigMeta = FlowerTrainUtils.GetFlowerTrainConfigMetaByGoodsId(self.fromGoodsId)
  self.paraMeta = FlowerTrainUtils.GetFlowerTrainParaMetaByGoodsId(self.fromGoodsId)
  self.lvBoxGiftId = self.lvMeta.gift_1_group
  self.cheerGiftId = self.lvMeta.gift_2_group
  self.tileSpeed = self.trainConfigMeta.para6
  self.speed = self.tileSpeed * TileSize
  self.addExpPerSecond = self.paraMeta.para5 or 0
  self.addExpPerLike = self.paraMeta.para6 or 0
  self.addExpPreCheer = self.paraMeta.para7 or 0
  self.lastSyncDataTime = UITimeManager:GetInstance():GetServerTime()
  self.maxLikeCountPerPlayer = self.paraMeta.para1 or 0
  self.isCacheOverFlowerReward = false
  self:ParseData()
  self:CheckAndGetHistoryStationList()
  self:UpdateCurCheerPlayerInfo()
end

function BaseSingleFlowerTrainData:ParseData()
  local cheerCostInfoList = self.lvMeta.cheer_cost
  if cheerCostInfoList and #cheerCostInfoList == 2 then
    self.cheerCostGoodsId = toInt(cheerCostInfoList[1])
    self.cheerCostGoodsNum = toInt(cheerCostInfoList[2])
  end
end

function BaseSingleFlowerTrainData:CheckAndGetHistoryStationList()
  self.historyStationList = {}
  local historyStationStr = self.serverData.historyStation
  if not historyStationStr then
    Logger.LogError("BaseSingleFlowerTrainData:CheckAndGetHistoryStationList historyStationStr is nil")
    return
  end
  historyStationStr = string.split(historyStationStr, ";")
  for _, v in ipairs(historyStationStr) do
    table.insert(self.historyStationList, toInt(v))
  end
end

function BaseSingleFlowerTrainData:GetFlowerTrainUuid()
  return self.uuid
end

function BaseSingleFlowerTrainData:GetLvImgPath()
  return self.showMeta and self.showMeta.level_icon
end

function BaseSingleFlowerTrainData:GetArrivedDesc()
  return self.showMeta and self.showMeta.end_desc
end

function BaseSingleFlowerTrainData:GetCurAddExpFromLike()
  return self.likeCount * self.addExpPerLike
end

function BaseSingleFlowerTrainData:GetCurAddExpFromCheer()
  return self.cheerCount * self.addExpPreCheer
end

function BaseSingleFlowerTrainData:GetCurExpFromTime()
  local now = UITimeManager:GetInstance():GetServerTime()
  local passTime = now - self.sendTime
  local ret = passTime * self.addExpPerSecond // 1000
  return ret
end

function BaseSingleFlowerTrainData:GetCurTotalExp()
  if self.isArrived then
    return self.curExp
  end
  return self:GetCurExpFromTime() + self:GetCurAddExpFromLike() + self:GetCurAddExpFromCheer()
end

function BaseSingleFlowerTrainData:GetCurLvUpgradeCostTotalExp()
  return self.lvMeta and self.lvMeta.exp
end

function BaseSingleFlowerTrainData:GetCurLvUpgradeCostExp()
  return self.lvMeta and self.lvMeta.cur_exp or 0
end

function BaseSingleFlowerTrainData:GetCurLvFullExp()
  return self:GetCurLvUpgradeCostTotalExp() + self:GetCurLvUpgradeCostExp()
end

function BaseSingleFlowerTrainData:GetCurOverFlowExp()
  return self:GetCurTotalExp() - self:GetCurLvUpgradeCostTotalExp()
end

function BaseSingleFlowerTrainData:IsMaxLv()
  return self.lvMeta and self.lvMeta.cur_exp < 0
end

function BaseSingleFlowerTrainData:GetFlowerTrainName()
  return self.showMeta and self.showMeta.name or ""
end

function BaseSingleFlowerTrainData:GetFinishRewardPicPath()
  return self.showMeta and self.showMeta.end_banner
end

function BaseSingleFlowerTrainData:GetPreviewBoxPicPath()
  return self.showMeta and self.showMeta.preview_box_pic
end

function BaseSingleFlowerTrainData:GetExpFireImgPath()
  if not self.expFireConfigList then
    self.expFireConfigList = FlowerTrainUtils.ParesExpFireImgPath(self.paraMeta.id)
  end
  return FlowerTrainUtils.GetExpFireImgPath(self.expFireConfigList, self:GetCurTotalExp())
end

function BaseSingleFlowerTrainData:GetFinishRewardData()
  local strReward = self.lvMeta and self.lvMeta.reward_show
  if not strReward then
    return {}
  end
  return FlowerTrainUtils.ParseRewardStr(strReward)
end

function BaseSingleFlowerTrainData:GetCurExpOverFlowerRewardData()
  if not self.isCacheOverFlowerReward then
    self:ParseExpOverFlowerRewardData()
  end
  local curOverFlowExp = self:GetCurOverFlowExp()
  local extraRewardNum = Mathf.Ceil(curOverFlowExp / self.overExpVal)
  local addGoodsId = self.addGoodsId
  if extraRewardNum <= 0 then
    return nil
  end
  local ret = {}
  ret.itemId = addGoodsId
  ret.count = extraRewardNum * self.addCount
  return ret
end

function BaseSingleFlowerTrainData:ParseExpOverFlowerRewardData()
  self.isCacheOverFlowerReward = true
  self.overExpVal = IntMaxValue
  self.addGoodsId = 0
  self.addCount = 0
  if not self.lvMeta then
    return
  end
  local extra_reward = self.lvMeta.extra_reward
  if not extra_reward then
    return
  end
  local strInfo = string.split(extra_reward, "|")
  if #strInfo == 2 then
    self.overExpVal = toInt(strInfo[1])
    local rewardInfoStr = string.split(strInfo[2], ";")
    if #rewardInfoStr == 3 then
      self.addGoodsId = toInt(rewardInfoStr[2])
      self.addCount = toInt(rewardInfoStr[3])
    end
  end
end

function BaseSingleFlowerTrainData:GetCurLvBoxData()
  local giftMeta = LocalController:instance():tryGetLine(TableName.WorldTreasure, self.lvBoxGiftId)
  return giftMeta
end

function BaseSingleFlowerTrainData:GetCheerRewardData()
  local giftMeta = LocalController:instance():tryGetLine(TableName.WorldTreasure, self.cheerGiftId)
  if not giftMeta then
    return {}
  end
  local boxShowParaId = giftMeta.custom_para
  local boxShowMeta = DataCenter.FlowerTrainDataManager:GetWorldBoxRewardShowMeta(boxShowParaId)
  if not boxShowMeta then
    return {}
  end
  local rewardStr = boxShowMeta.box_show_reward
  if not rewardStr or rewardStr == "" then
    return {}
  end
  return FlowerTrainUtils.ParseRewardStr(rewardStr)
end

function BaseSingleFlowerTrainData:GetCurFinishRewardBoxTipsData(tagType)
  local finishRewardDataList = self:GetFinishRewardData()
  if not finishRewardDataList then
    return
  end
  local extraGoodsId, extraGoodsCount
  local expOverFlowReward = self:GetCurExpOverFlowerRewardData()
  if expOverFlowReward then
    extraGoodsId = expOverFlowReward.itemId
    extraGoodsCount = expOverFlowReward.count
  end
  local isStackExtraReward = false
  tagType = tagType or CapacityBoxTagType.default
  local ret = {}
  local dataList = {}
  ret[tagType] = dataList
  for _, v in ipairs(finishRewardDataList) do
    local data = {}
    data.itemId = v.itemId
    data.count = v.count
    if extraGoodsId and extraGoodsId == data.itemId and not isStackExtraReward then
      data.count = data.count + extraGoodsCount
      isStackExtraReward = true
    end
    table.insert(dataList, data)
  end
  if not isStackExtraReward and expOverFlowReward then
    local extraReward = {}
    extraReward.itemId = extraGoodsId
    extraReward.count = extraGoodsCount
    table.insert(dataList, extraReward)
  end
  return ret
end

function BaseSingleFlowerTrainData:GetAddExpFromLike()
  return self.addExpPerLike
end

function BaseSingleFlowerTrainData:GetAddExpFromCheer()
  return self.addExpPreCheer
end

function BaseSingleFlowerTrainData:GetAddExpPerSecond()
  return self.addExpPerSecond or 0
end

function BaseSingleFlowerTrainData:GetIsArrived()
  if self.isArrived then
    return true
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  return now >= self.arriveTime
end

function BaseSingleFlowerTrainData:IsSelfFlowerTrain()
  return self.isSelf
end

function BaseSingleFlowerTrainData:GetFlowerTrainIcon4CollectRewardView()
  if not self.showMeta then
    return ""
  end
  return self.showMeta.pic2
end

function BaseSingleFlowerTrainData:GetArrivedTime()
  return self.arriveTime
end

function BaseSingleFlowerTrainData:GetMarchUuid()
  return self.marchUuid
end

function BaseSingleFlowerTrainData:GetCurMarchWorldPos()
  local fromPointId = self.startPoint
  local toPointId = self.endPoint
  local fromWorldPos = SceneUtils.TileIndexToWorld(fromPointId)
  local toWorldPos = SceneUtils.TileIndexToWorld(toPointId)
  local fromWorldPosVec = Vector3.New(fromWorldPos.x, fromWorldPos.y, fromWorldPos.z)
  local toWorldPosVec = Vector3.New(toWorldPos.x, toWorldPos.y, toWorldPos.z)
  local vec = toWorldPosVec - fromWorldPosVec
  local dir = vec.normalized
  local curMarchPassTime = self:GetCurMarchPassTime() / 1000
  local curPos = fromWorldPosVec + dir * self.speed * curMarchPassTime
  return curPos
end

function BaseSingleFlowerTrainData:GetCurMarchPointId()
  local curWorldPos = self:GetCurMarchWorldPos()
  local curPointId = SceneUtils.WorldToTileIndex(curWorldPos)
  return curPointId
end

function BaseSingleFlowerTrainData:GetCurMarchPassTime()
  local curTotalPassTime = self:GetCurMarchTotalPassTime()
  local curHistoryStationCostDuration = self:GetCurHistoryStationCostDuration()
  local curLinePassTime = curTotalPassTime - curHistoryStationCostDuration
  return curLinePassTime
end

function BaseSingleFlowerTrainData:GetCurMarchTotalPassTime()
  local now = UITimeManager:GetInstance():GetServerTime()
  local passTime = now - self.sendTime
  return passTime
end

function BaseSingleFlowerTrainData:GetCurHistoryStationCostDuration()
  if not self.historyStationList or #self.historyStationList <= 0 then
    return 0
  end
  if not self.speed or 0 >= self.speed then
    return 0
  end
  local costDuration = 0
  for index, stationPointId in ipairs(self.historyStationList) do
    if index ~= 1 then
      local fromPointId = self.historyStationList[index - 1]
      local toPointId = stationPointId
      local fromWorldPos = SceneUtils.TileIndexToWorld(fromPointId)
      local toWorldPos = SceneUtils.TileIndexToWorld(toPointId)
      local fromWorldPosVec = Vector3.New(fromWorldPos.x, fromWorldPos.y, fromWorldPos.z)
      local toWorldPosVec = Vector3.New(toWorldPos.x, toWorldPos.y, toWorldPos.z)
      local moveVec = toWorldPosVec - fromWorldPosVec
      local distance = moveVec.magnitude
      costDuration = costDuration + distance / self.speed
    end
  end
  return costDuration * 1000
end

function BaseSingleFlowerTrainData:GetLikeCount()
  return self.likeCount or 0
end

function BaseSingleFlowerTrainData:GetCheerCount()
  return self.cheerCount or 0
end

function BaseSingleFlowerTrainData:GetDuration()
  return self.arriveTime - self.sendTime
end

function BaseSingleFlowerTrainData:GetFlowerTrainLv()
  return self.lv
end

function BaseSingleFlowerTrainData:GetTipBubbleIconPath()
  return self.paraMeta and self.paraMeta.bubble_pic1
end

function BaseSingleFlowerTrainData:GetWaitingRewardTime()
  if not self.trainConfigMeta or not self.trainConfigMeta.para2 then
    return 0
  end
  return toInt(self.trainConfigMeta.para2) * 1000
end

function BaseSingleFlowerTrainData:GetNextThrowLvBoxTime()
  return self.upLvTime + toInt(self.trainConfigMeta.para2) * 1000
end

function BaseSingleFlowerTrainData:IsInWaitingRewardTime()
  local now = UITimeManager:GetInstance():GetServerTime()
  local nextThrowLvBoxTime = self:GetNextThrowLvBoxTime()
  return now < nextThrowLvBoxTime and now >= self.upLvTime
end

function BaseSingleFlowerTrainData:GetCurState()
  local isArrived = self:GetIsArrived()
  if isArrived then
    return FlowerTrainState.Arrived
  end
  local isInWaitingRewardTime = self:IsInWaitingRewardTime()
  return isInWaitingRewardTime and FlowerTrainState.WaitingReward or FlowerTrainState.Normal
end

function BaseSingleFlowerTrainData:GetWorldLodIconPath()
  if not self.lvMeta then
    return ""
  end
  local ret = self.isSelf and self.lvMeta.world_lod_icon_self or self.lvMeta.world_lod_icon
  return ret or ""
end

function BaseSingleFlowerTrainData:GetCheerPlayerInfo()
  self:CheckExpireCheerData()
  return self.cheerHistoryPlayerDic or {}
end

function BaseSingleFlowerTrainData:UpdateCurCheerPlayerInfo()
  if not self.cheerHistoryPlayerDic then
    self.cheerHistoryPlayerDic = {}
  end
  if self.serverData.allCheerPlayerList and self.serverData.allCheerPlayerList.Count > 0 then
    for i = 0, self.serverData.allCheerPlayerList.Count - 1 do
      local cheerInfoStr = string.split(self.serverData.allCheerPlayerList[i], ";")
      if #cheerInfoStr == 2 then
        local uid = cheerInfoStr[1]
        local tmpStrArr = string.split(cheerInfoStr[2], "|")
        if #tmpStrArr == 5 then
          local cheerData = self.cheerHistoryPlayerDic[uid] or {}
          cheerData.cheerTime = toInt(tmpStrArr[1])
          cheerData.headSkinId = toInt(tmpStrArr[2])
          cheerData.headSkinET = tonumber(tmpStrArr[3])
          cheerData.pic = tmpStrArr[4]
          cheerData.picVer = toInt(tmpStrArr[5])
          self.cheerHistoryPlayerDic[uid] = cheerData
        end
      end
    end
  end
  self:CheckExpireCheerData()
end

function BaseSingleFlowerTrainData:CheckExpireCheerData()
  local now = UITimeManager:GetInstance():GetServerTime()
  local passTime = now - (self.lastCheckExpireCheerDataTime or 0)
  if passTime <= 5 then
    return
  end
  if not self.cheerHistoryPlayerDic then
    return
  end
  local needRemoveList
  for key, cheerData in pairs(self.cheerHistoryPlayerDic) do
    local cheerTime = cheerData.cheerTime
    local disappearTime = cheerTime * 1000 + FlowerTrainUtils.GetCheerActorExistDuration()
    if now > disappearTime then
      needRemoveList = needRemoveList or {}
      table.insert(needRemoveList, key)
    end
  end
  if needRemoveList then
    for _, key in ipairs(needRemoveList) do
      self.cheerHistoryPlayerDic[key] = nil
    end
  end
  self.lastCheckExpireCheerDataTime = now
end

function BaseSingleFlowerTrainData:GetCheerCostGoodsIdAndNum()
  return self.cheerCostGoodsId, self.cheerCostGoodsNum
end

function BaseSingleFlowerTrainData:GetPrevUpgradeTime()
  return self.upLvTime or 0
end

function BaseSingleFlowerTrainData:GetArrivedPanelBGConfig()
  return self.paraMeta and self.paraMeta.arrivedPanelBG
end

function BaseSingleFlowerTrainData:GetCheerActorPrefabPath()
  return self.showMeta and self.showMeta.cheerActorPath or nil
end

return BaseSingleFlowerTrainData
