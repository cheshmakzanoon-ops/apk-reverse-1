local ActGiftBoxData = BaseClass("ActGiftBoxData")
local ActGiftBoxInfo = require("DataCenter.ActivityListData.ActGiftBoxInfo")
local ActGiftBoxOpenTemplate = require("DataCenter.ActivityListData.ActGiftBoxOpenTemplate")
local ActGiftBoxItemTemplate = require("DataCenter.ActivityListData.ActGiftBoxItemTemplate")

local function __init(self)
  self.list = {}
  self.boxOpenDict = {}
  self.boxItemDict = {}
  self.boxOpenDataMap = {}
  LocalController:instance():visitTable(TableName.ActivityBoxOpen, function(_, line)
    local template = ActGiftBoxOpenTemplate.New()
    template:InitData(line)
    table.insert(self.boxOpenDict, template)
  end)
  LocalController:instance():visitTable(TableName.ActivityBoxOpenPara, function(_, line)
    local template = ActGiftBoxItemTemplate.New()
    template:InitData(line)
    table.insert(self.boxItemDict, template)
  end)
  self.giftInfo = nil
  self.isNewGift = {}
  self.lotteryItems = {}
  self.activityConfigId = 0
end

local function __delete(self)
  self.list = nil
  self.giftInfo = nil
  self.isNewGift = nil
  self.lotteryItems = nil
  self.activityConfigId = nil
  self.boxOpenDataMap = nil
end

local function SetActivityId(self, id)
  self.list[tonumber(id)] = ActGiftBoxInfo.New()
end

local function ParseActivityData(self, message)
  if message == nil then
    return
  end
  if self.list[message.activityId] then
    self.list[message.activityId]:ParseInfo(message)
  end
  EventManager:GetInstance():Broadcast(EventId.ActGiftBoxGetInfo)
end

local function OpenGiftBoxHandle(self, message)
  if message == nil then
    return
  end
  if self.list[message.activityId] then
    if message.reward ~= nil then
      DataCenter.RewardManager:AddRewards(message.reward)
      DataCenter.RewardManager:ShowGiftBoxOpenReward(message)
    end
    if message.uuid then
      self.list[message.activityId]:RefreshBox(message.uuid)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.ActGiftBoxOpen)
end

local function DelGiftBoxHandle(self, message)
  if message == nil then
    return
  end
  if self.list[message.activityId] and message.state == 1 and message.uuid then
    self.list[message.activityId]:RefreshBox(message.uuid)
  end
  EventManager:GetInstance():Broadcast(EventId.ActGiftBoxDel)
end

local function ReceiveGiftBoxScoreHandle(self, message)
  if message == nil then
    return
  end
  if self.list[message.activityId] then
    local reward = message.reward
    if reward then
      DataCenter.RewardManager:AddRewards(reward)
      DataCenter.RewardManager:ShowCommonReward(message)
    end
    self.list[message.activityId]:ReceiveScoreReward(message)
  end
  EventManager:GetInstance():Broadcast(EventId.ActGiftBoxScoreRewardReceive)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

local function GetFreeRewardHandle(self, message)
  if message == nil then
    return
  end
  if self.list[message.activityId] then
    local reward = message.reward
    if reward then
      DataCenter.RewardManager:AddRewards(reward)
      DataCenter.RewardManager:ShowCommonReward(message)
    end
    self.list[message.activityId]:ReceiveFreeReward(message)
  end
  EventManager:GetInstance():Broadcast(EventId.ActGiftFreeRewardReceive)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

local function GiftBoxLotteryHandle(self, message)
  if message == nil then
    return
  end
  if self.list[message.activityId] then
    if message.fiveLottery and message.useFree == 0 then
      self.list[message.activityId]:RefreshCount(message.fiveLottery)
    end
    if message.newGiftBoxs then
      self.isNewGift = {}
      for i = 1, table.count(message.newGiftBoxs) do
        table.insert(self.isNewGift, message.newGiftBoxs[i].itemId)
      end
      self.list[message.activityId]:ParseGiftBox(message)
    end
    if message.useFreeTimes then
      self.list[message.activityId]:RefreshUseFreeTimes(message)
    end
  end
  if message.reward ~= nil then
    DataCenter.RewardManager:AddRewards(message.reward)
  end
  self.lotteryItems = message
  if message.gold then
    LuaEntry.Player.gold = message.gold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
  EventManager:GetInstance():Broadcast(EventId.ActGiftBoxLottery)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

local function GetLottery(self)
  return self.lotteryItems
end

local function ClearLottery(self)
  self.lotteryItems = {}
end

local function GetIsNewGift(self)
  return self.isNewGift
end

local function ClearNewGift(self)
  self.isNewGift = {}
end

local function BoxTimeEnd(self, activityId, uuid)
  if self.list[activityId] then
    self.list[activityId]:RefreshBox(uuid)
  end
  EventManager:GetInstance():Broadcast(EventId.ActGiftBoxGetInfo)
end

local function GiftBoxLotteryCount(self, message)
  if message == nil then
    return
  end
  if self.list[message.activityId] and message.lotteryCounts then
    self.list[message.activityId]:ParseLotteryCount(message)
  end
  EventManager:GetInstance():Broadcast(EventId.ActGiftBoxLotteryCount)
end

local function GetInfoByActId(self, activityId)
  if self.list[activityId] then
    return self.list[activityId]
  end
  return nil
end

local function GetActRed(self, id)
  if self.list[id] and next(self.list[id]) then
    return self.list[id]:GetActRed()
  end
  return 0
end

local function GetActBoxRed(self, id)
  if self.list[id] and next(self.list[id]) then
    return self.list[id]:GetActBoxRed()
  end
  return 0
end

local function GetActCurAllNum(self, id)
  if self.list and self.list[id] and next(self.list[id]) then
    return self.list[id]:CompareAllNum()
  end
end

local function SetParam(self, param)
  self.giftInfo = param
end

local function GetParam(self)
  return self.giftInfo
end

local function GetActTemplateByActId(self, activityId)
  if self.boxOpenDict then
    for i = 1, table.count(self.boxOpenDict) do
      if self.boxOpenDict[i].activity == activityId then
        return self.boxOpenDict[i]
      end
    end
  end
  return nil
end

local function GetOpenTemplateListByActId(self, activityId)
  local result = {}
  if self.boxOpenDict then
    for i = 1, table.count(self.boxOpenDict) do
      if self.boxOpenDict[i].activity == activityId then
        table.insert(result, self.boxOpenDict[i])
      end
    end
  end
  return result
end

local function GetActDrawNax(self, activityId)
  if self.boxOpenDict then
    for i = 1, table.count(self.boxOpenDict) do
      if self.boxOpenDict[i].activity == activityId then
        return self.boxOpenDict[i].draw_max_daily
      end
    end
  end
  return 0
end

local function GetActMaxBoxById(self, activityId)
  if self.boxOpenDict then
    for i = 1, table.count(self.boxOpenDict) do
      if self.boxOpenDict[i].activity == activityId then
        return self.boxOpenDict[i].box_num
      end
    end
  end
  return 0
end

local function GetActKeyById(self, activityId)
  if self.boxOpenDict then
    for i = 1, table.count(self.boxOpenDict) do
      if self.boxOpenDict[i].activity == activityId then
        return self.boxOpenDict[i].unlock_goods
      end
    end
  end
  return nil
end

local function GetActKeyByIdNew(self, activityId)
  if self.boxOpenDict then
    local actData = self.list[activityId]
    local configId = actData.configId
    for i = 1, table.count(self.boxOpenDict) do
      if self.boxOpenDict[i].id == configId then
        return self.boxOpenDict[i].unlock_goods
      end
    end
  end
  return nil
end

local function GetActScoreById(self, activityId)
  if self.list[activityId] then
    return self.list[activityId]:GetScore()
  end
end

local function GetActNextTargetScoreById(self, activityId)
  if self.list[activityId] then
    local score = self.list[activityId]:GetScore()
    local scoreArr = self.list[activityId]:GetScoreArr()
    for k, v in ipairs(scoreArr) do
      if score < v.targetScore then
        return v.targetScore
      end
    end
  end
end

local function GetActNextTargetScoreDataById(self, activityId)
  if self.list[activityId] then
    local score = self.list[activityId]:GetScore()
    local scoreArr = self.list[activityId]:GetScoreArr()
    for k, v in ipairs(scoreArr) do
      if score < v.targetScore then
        return v
      end
    end
  end
end

local function GetActCanGetRewardFirstScoreDataById(self, activityId)
  if self.list[activityId] then
    local score = self.list[activityId]:GetScore()
    local scoreArr = self.list[activityId]:GetScoreArr()
    for k, v in ipairs(scoreArr) do
      if score >= v.targetScore and v.state == 0 then
        return v
      end
    end
  end
  return nil
end

local function GetFinalScoreDataById(self, activityId)
  local scoreArr = self.list[activityId]:GetScoreArr()
  return scoreArr[table.count(scoreArr)]
end

local function GetActScoreBoxListById(self, activityId)
  if self.list[activityId] then
    return self.list[activityId]:GetScoreArr()
  end
end

local function GetActBoxInfoByItemId(self, itemID)
  if self.boxItemDict then
    for i = 1, table.count(self.boxItemDict) do
      if self.boxItemDict[i].id == itemID then
        return self.boxItemDict[i]
      end
    end
  end
  return nil
end

local function GetActReward(self, activityId)
  local id
  local rewardList = {}
  rewardList.itemReward = {}
  rewardList.giftReward = {}
  if self.boxOpenDict then
    for i = 1, table.count(self.boxOpenDict) do
      if self.boxOpenDict[i].activity == activityId then
        id = self.boxOpenDict[i].id
      end
    end
  end
  if id and self.boxItemDict then
    for i = 1, table.count(self.boxItemDict) do
      if self.boxItemDict[i].boxopen_id == tonumber(id) and not string.IsNullOrEmpty(self.boxItemDict[i].goods) then
        if self.boxItemDict[i].type == 0 then
          local strReward = string.split(self.boxItemDict[i].goods, "|")
          for k = 1, table.count(strReward) do
            local str = string.split(strReward[k], ";")
            local param = {}
            param.itemId = str[1]
            param.count = str[2]
            param.rewardType = RewardType.GOODS
            param.prop = 0
            local str = string.split(self.boxItemDict[i].rate, ";")
            if not table.IsNullOrEmpty(str) then
              param.prop = tonumber(str[#str]) or 0
            end
            table.insert(rewardList.itemReward, param)
          end
        elseif self.boxItemDict[i].type == 1 then
          local param = {}
          param.time = tonumber(self.boxItemDict[i].reward_time)
          param.icon = self.boxItemDict[i].reward_icon
          param.id = tonumber(self.boxItemDict[i].id)
          param.quality = self.boxItemDict[i].quality
          param.propReward = {}
          local paraReward = {}
          local str = string.split(self.boxItemDict[i].goods, ";")
          paraReward.itemId = str[1]
          paraReward.count = str[2]
          paraReward.rewardType = RewardType.GOODS
          paraReward.prop = 1
          local str = string.split(self.boxItemDict[i].rate, ";")
          if not table.IsNullOrEmpty(str) then
            paraReward.prop = tonumber(str[#str]) or 0
          end
          paraReward.constant = true
          table.insert(param.propReward, paraReward)
          local strReward = string.split(self.boxItemDict[i].box_random_goods, "|")
          for k = 1, table.count(strReward) do
            local tmpStr = string.split(strReward[k], ";")
            local ret = table.choose(param.propReward, function(k1, v1)
              if v1.itemId == tmpStr[1] then
                return true
              end
            end)
            if table.IsNullOrEmpty(ret) then
              do
                local para = {}
                para.itemId = tmpStr[1]
                para.count = tmpStr[2]
                para.prop = tmpStr[3]
                para.rewardType = RewardType.GOODS
                if para.itemId ~= "0" then
                  table.insert(param.propReward, para)
                end
                para.constant = false
              end
            end
          end
          table.insert(rewardList.giftReward, param)
        end
      end
    end
  end
  if rewardList.itemReward then
    local totalProp = 0
    for k, v in pairs(rewardList.itemReward) do
      totalProp = totalProp + v.prop
    end
    for k, v in pairs(rewardList.itemReward) do
      v.resultProp = v.prop / totalProp
    end
  end
  return rewardList
end

local function GetActRewardNew(self, activityId)
  local infoData = self.list[tonumber(activityId)]
  local openConfigId = infoData.configId
  local id
  Logger.Log("=================>GiftBox<===================  boxOpen ConfigId:" .. openConfigId)
  if self.boxOpenDict then
    for i = 1, table.count(self.boxOpenDict) do
      if self.boxOpenDict[i].id == openConfigId then
        id = self.boxOpenDict[i].boxopen_id
        Logger.Log("=================>GiftBox<===================   filed boxopen_id: " .. id)
        break
      end
    end
  end
  return self:GetBoxOpenDataByOpenId(id)
end

local function GetBoxOpenDataByOpenId(self, id)
  Logger.Log("=================>GiftBox<===================  boxOpen openId:" .. id)
  if self.boxOpenDataMap[id] then
    return self.boxOpenDataMap[id].generateItemRewardList, self.boxOpenDataMap[id].boxList
  end
  local boxOpenData = {}
  local generateItemRewardList = {}
  local boxMap = {}
  local boxList = {}
  local allItemTotalWeight = 0
  if id and self.boxItemDict then
    for i = 1, table.count(self.boxItemDict) do
      if self.boxItemDict[i].boxopen_id == tonumber(id) then
        local config = self.boxItemDict[i]
        if config.type == 0 then
          table.insert(generateItemRewardList, config)
        elseif config.type == 1 then
          allItemTotalWeight = allItemTotalWeight + config.weight
          if not string.IsNullOrEmpty(self.boxItemDict[i].goods) then
            if boxMap[config.quality] == nil then
              local newBoxData = {}
              boxMap[config.quality] = {}
              newBoxData.weight = 0
              newBoxData.quality = config.quality
              newBoxData.groupWeightMap = {}
              newBoxData.groupWeightPercentMap = {}
              newBoxData.goodsConfigListMap = {}
              newBoxData.goodsConfigTotalList = {}
              for k = 1, 6 do
                newBoxData.groupWeightMap[k] = 0
                newBoxData.goodsConfigListMap[k] = {}
              end
              boxMap[config.quality] = newBoxData
            end
            local boxData = boxMap[config.quality]
            boxData.weight = boxData.weight + config.weight
            local rewardGroupWeight = boxData.groupWeightMap[config.reward_group]
            rewardGroupWeight = rewardGroupWeight + config.weight
            boxData.groupWeightMap[config.reward_group] = rewardGroupWeight
            table.insert(boxData.goodsConfigListMap[config.reward_group], config)
            if boxData.goodsConfigTotalList == nil then
              boxData.goodsConfigTotalList = {}
            end
            table.insert(boxData.goodsConfigTotalList, config)
            boxMap[config.quality] = boxData
          end
        end
      end
    end
  end
  if generateItemRewardList then
    local totalWeight = 0
    for k, v in ipairs(generateItemRewardList) do
      totalWeight = totalWeight + v.goodsItem.weight
    end
    for k, v in ipairs(generateItemRewardList) do
      v.goodsItem.weightPercent = v.goodsItem.weight / totalWeight
    end
  end
  for k, v in pairs(boxMap) do
    for i = 1, 6 do
      table.sort(v.goodsConfigListMap[i], function(a, b)
        if a.order ~= b.order then
          return a.order < b.order
        else
          return a.id < b.id
        end
      end)
    end
    table.insert(boxList, v)
  end
  for k, v in ipairs(boxList) do
    local boxData = v
    boxData.weightPercent = boxData.weight / allItemTotalWeight
    for groupId, _ in pairs(boxData.groupWeightMap) do
      boxData.groupWeightPercentMap[groupId] = boxData.groupWeightMap[groupId] / boxData.weight
    end
    for _, goodsConfig in ipairs(boxData.goodsConfigTotalList) do
      goodsConfig.goodsItem.weightPercent = goodsConfig.goodsItem.weight / boxData.weight
    end
  end
  if 1 < #boxList then
    table.sort(boxList, function(a, b)
      if a.quality > b.quality then
        return true
      end
    end)
  end
  table.sort(generateItemRewardList, function(a, b)
    if a.order ~= b.order then
      return a.order < b.order
    else
      return a.id < b.id
    end
  end)
  boxOpenData.generateItemRewardList = generateItemRewardList
  boxOpenData.boxList = boxList
  self.boxOpenDataMap[id] = boxOpenData
  return self.boxOpenDataMap[id].generateItemRewardList, self.boxOpenDataMap[id].boxList
end

local function GetActBoxGetProp(self, activityId, quality)
  local id
  local totalRate = 0
  local qualityRate = 0
  if self.boxOpenDict then
    for i = 1, table.count(self.boxOpenDict) do
      if self.boxOpenDict[i].activity == activityId then
        id = self.boxOpenDict[i].id
      end
    end
  end
  if id and self.boxItemDict then
    for i = 1, table.count(self.boxItemDict) do
      if self.boxItemDict[i].boxopen_id == tonumber(id) and self.boxItemDict[i].type == 1 then
        local str = string.split(self.boxItemDict[i].rate, ";")
        local rate = tonumber(str[#str])
        totalRate = totalRate + rate
        if self.boxItemDict[i].quality == quality and not string.IsNullOrEmpty(self.boxItemDict[i].goods) then
          qualityRate = qualityRate + rate
        end
      end
    end
  end
  return qualityRate / totalRate
end

local function GetActGiftRewardByBoxId(self, activityId, boxId)
  local id
  if self.boxOpenDict then
    for i = 1, table.count(self.boxOpenDict) do
      if self.boxOpenDict[i].activity == activityId then
        id = self.boxOpenDict[i].id
      end
    end
  end
  if id and self.boxItemDict then
    for i = 1, table.count(self.boxItemDict) do
      if self.boxItemDict[i].boxopen_id == tonumber(id) and self.boxItemDict[i].id == boxId and self.boxItemDict[i].type == 1 then
        local param = {}
        param.time = tonumber(self.boxItemDict[i].reward_time)
        param.icon = self.boxItemDict[i].reward_icon
        param.id = tonumber(self.boxItemDict[i].id)
        local strReward = string.split(self.boxItemDict[i].goods, "|")
        for k = 1, table.count(strReward) do
          local str = string.split(strReward[k], ";")
          param.itemId = str[1]
          param.count = str[2]
          param.rewardType = RewardType.GOODS
        end
        return param
      end
    end
  end
end

local function GetActGiftRewardByBoxIdNew(self, activityId, boxId)
  local id
  local actData = self.list[activityId]
  local configId = actData.configId
  if self.boxOpenDict then
    for i = 1, table.count(self.boxOpenDict) do
      if self.boxOpenDict[i].id == configId then
        id = self.boxOpenDict[i].boxopen_id
      end
    end
  end
  if id and self.boxItemDict then
    for i = 1, table.count(self.boxItemDict) do
      if self.boxItemDict[i].boxopen_id == tonumber(id) and self.boxItemDict[i].id == boxId and self.boxItemDict[i].type == 1 then
        local param = {}
        param.time = tonumber(self.boxItemDict[i].reward_time)
        param.icon = self.boxItemDict[i].reward_icon
        param.id = tonumber(self.boxItemDict[i].id)
        local strReward = string.split(self.boxItemDict[i].goods, "|")
        for k = 1, table.count(strReward) do
          local str = string.split(strReward[k], ";")
          param.itemId = str[1]
          param.count = str[2]
          param.rewardType = RewardType.GOODS
        end
        return param
      end
    end
  end
end

local function GetBoxRankHandle(self, message)
  local data = self:GetInfoByActId(message.activityId)
  if data and next(data) then
    if message then
      data:ParseRankInfo(message)
    end
    EventManager:GetInstance():Broadcast(EventId.ActGiftBoxRankUpdate)
  end
end

local function ParseActGiftBoxScore(self, message)
  if self.list[message.id] then
    local actGiftBoxInfo = self.list[message.id]
    if message.extra then
      actGiftBoxInfo:UpdateScore(message.extra)
      EventManager:GetInstance():Broadcast(EventId.ActGiftBoxScoreUpdate)
    end
  end
end

local function CanGetFreePack(self, actId)
  if self.list[actId] then
    return self.list[actId].activityFreeRewardData:CanGetFreePack()
  end
  return false
end

local function CanGotoPackShop(self, actId)
  if self.list[actId] then
    return self.list[actId].activityFreeRewardData:CanGotoPackShop()
  end
  return false
end

local function GetKeyGiftPackId(self, actId)
  if self.list[actId] then
    return self.list[actId].activityFreeRewardData:GetGiftPackId()
  end
end

local function GetBoxOpenConfigById(self, configId)
  if self.boxOpenDict then
    for i = 1, table.count(self.boxOpenDict) do
      local template = self.boxOpenDict[i]
      if template.id == configId then
        return template
      end
    end
  end
  Logger.LogError("not find template by configId:" .. configId)
  return nil
end

local function GetCurActConfigId(self, activityId)
  local infoData = self.list[tonumber(activityId)]
  if infoData == nil then
    Logger.LogError("\232\191\153tm\228\185\159\232\131\189\228\184\186nil\239\188\159\239\188\159 activityId:" .. activityId)
    return 0
  end
  return infoData.configId
end

ActGiftBoxData.__init = __init
ActGiftBoxData.__delete = __delete
ActGiftBoxData.SetActivityId = SetActivityId
ActGiftBoxData.ParseActivityData = ParseActivityData
ActGiftBoxData.ParseActGiftBoxScore = ParseActGiftBoxScore
ActGiftBoxData.GetInfoByActId = GetInfoByActId
ActGiftBoxData.OpenGiftBoxHandle = OpenGiftBoxHandle
ActGiftBoxData.DelGiftBoxHandle = DelGiftBoxHandle
ActGiftBoxData.ReceiveGiftBoxScoreHandle = ReceiveGiftBoxScoreHandle
ActGiftBoxData.GetFreeRewardHandle = GetFreeRewardHandle
ActGiftBoxData.GetLottery = GetLottery
ActGiftBoxData.ClearLottery = ClearLottery
ActGiftBoxData.GetIsNewGift = GetIsNewGift
ActGiftBoxData.ClearNewGift = ClearNewGift
ActGiftBoxData.GiftBoxLotteryHandle = GiftBoxLotteryHandle
ActGiftBoxData.BoxTimeEnd = BoxTimeEnd
ActGiftBoxData.GiftBoxLotteryCount = GiftBoxLotteryCount
ActGiftBoxData.GetActRed = GetActRed
ActGiftBoxData.GetActBoxRed = GetActBoxRed
ActGiftBoxData.GetActCurAllNum = GetActCurAllNum
ActGiftBoxData.SetParam = SetParam
ActGiftBoxData.GetParam = GetParam
ActGiftBoxData.GetActTemplateByActId = GetActTemplateByActId
ActGiftBoxData.GetActDrawNax = GetActDrawNax
ActGiftBoxData.GetActMaxBoxById = GetActMaxBoxById
ActGiftBoxData.GetActKeyById = GetActKeyById
ActGiftBoxData.GetActScoreById = GetActScoreById
ActGiftBoxData.GetActNextTargetScoreById = GetActNextTargetScoreById
ActGiftBoxData.GetActScoreBoxListById = GetActScoreBoxListById
ActGiftBoxData.GetActBoxInfoByItemId = GetActBoxInfoByItemId
ActGiftBoxData.GetActReward = GetActReward
ActGiftBoxData.GetActBoxGetProp = GetActBoxGetProp
ActGiftBoxData.GetActGiftRewardByBoxId = GetActGiftRewardByBoxId
ActGiftBoxData.GetBoxRankHandle = GetBoxRankHandle
ActGiftBoxData.CanGotoPackShop = CanGotoPackShop
ActGiftBoxData.CanGetFreePack = CanGetFreePack
ActGiftBoxData.GetKeyGiftPackId = GetKeyGiftPackId
ActGiftBoxData.GetActNextTargetScoreDataById = GetActNextTargetScoreDataById
ActGiftBoxData.GetActCanGetRewardFirstScoreDataById = GetActCanGetRewardFirstScoreDataById
ActGiftBoxData.GetFinalScoreDataById = GetFinalScoreDataById
ActGiftBoxData.GetActRewardNew = GetActRewardNew
ActGiftBoxData.GetActKeyByIdNew = GetActKeyByIdNew
ActGiftBoxData.GetActGiftRewardByBoxIdNew = GetActGiftRewardByBoxIdNew
ActGiftBoxData.GetOpenTemplateListByActId = GetOpenTemplateListByActId
ActGiftBoxData.GetBoxOpenDataByOpenId = GetBoxOpenDataByOpenId
ActGiftBoxData.GetBoxOpenConfigById = GetBoxOpenConfigById
ActGiftBoxData.GetCurActConfigId = GetCurActConfigId
return ActGiftBoxData
