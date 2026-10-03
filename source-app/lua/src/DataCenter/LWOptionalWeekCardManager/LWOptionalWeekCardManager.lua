local LWOptionalWeekCardManager = BaseClass("LWOptionalWeekCardManager")
local LWOptionalWeekCardInfo = require("DataCenter.LWOptionalWeekCardManager.LWOptionalWeekCardInfo")

function LWOptionalWeekCardManager:__init()
  self.weekCardActivityDic = {}
end

function LWOptionalWeekCardManager:__delete()
  self.weekCardActivityDic = nil
end

function LWOptionalWeekCardManager:Startup()
end

function LWOptionalWeekCardManager:SetActivityId(activityId)
  self.weekCardActivityDic[tonumber(activityId)] = {}
end

function LWOptionalWeekCardManager:ParseOptionalWeekCardMessage(message, actInfo)
  local activityId = 0
  if message.id then
    activityId = tonumber(message.id)
  end
  if self.weekCardActivityDic[activityId] then
    local weekCardDic = self.weekCardActivityDic[activityId]
    if message.extra then
      local extra = message.extra
      if extra.weekCards then
        for i, cardData in pairs(extra.weekCards) do
          local cardId = 0
          if cardData.id then
            cardId = cardData.id
          end
          local cardInfo
          local isInit = false
          if cardId ~= 0 then
            if weekCardDic[cardId] == nil then
              cardInfo = LWOptionalWeekCardInfo.New()
              weekCardDic[cardId] = cardInfo
              isInit = true
            else
              cardInfo = weekCardDic[cardId]
            end
            cardInfo:InitData(cardData, isInit)
          end
          if cardInfo and actInfo then
            cardInfo.startTime = actInfo.startTime
            cardInfo.endTime = actInfo.endTime
          end
        end
        EventManager:GetInstance():Broadcast(EventId.OptionalWeekCardInfoChange)
      end
    end
  end
end

function LWOptionalWeekCardManager:UpdateWeekCardDataByChoose(message)
  local activityId = 0
  if message.aid then
    activityId = message.aid
  end
  if message.cardObj then
    local cardObj = message.cardObj
    local cardId = 0
    if cardObj.id then
      cardId = cardObj.id
    end
    if self.weekCardActivityDic[activityId] then
      local weekCardDic = self.weekCardActivityDic[activityId]
      if weekCardDic[cardId] ~= nil then
        weekCardDic[cardId]:InitData(cardObj)
      end
    end
  end
end

function LWOptionalWeekCardManager:UpdateWeekCardDataByReceiveReward(message)
  local activityId = 0
  if message.aid then
    activityId = message.aid
  end
  if message.cardObj then
    local cardObj = message.cardObj
    local cardId = 0
    if cardObj.id then
      cardId = cardObj.id
    end
    if self.weekCardActivityDic[activityId] then
      local weekCardDic = self.weekCardActivityDic[activityId]
      if weekCardDic[cardId] ~= nil then
        weekCardDic[cardId]:InitData(cardObj)
        EventManager:GetInstance():Broadcast(EventId.RefreshOptionalWeekCardReceiveReward, cardId)
      end
    end
  end
end

function LWOptionalWeekCardManager:GetWeekCardData(activityId)
  if self.weekCardActivityDic[activityId] then
    local weekCardDic = self.weekCardActivityDic[activityId]
    local list = {}
    for i, weekCardInfo in pairs(weekCardDic) do
      table.insert(list, weekCardInfo)
    end
    table.sort(list, function(a, b)
      return a.order < b.order
    end)
    return list
  end
  return nil
end

function LWOptionalWeekCardManager:GetWeekCardDataById(activityId, cardId)
  if self.weekCardActivityDic[activityId] then
    local weekCardDic = self.weekCardActivityDic[activityId]
    if weekCardDic[cardId] then
      return weekCardDic[cardId]
    end
  end
  return nil
end

function LWOptionalWeekCardManager:GetRedNum(activityId)
  local total = 0
  if self.weekCardActivityDic[activityId] then
    local weekCardDic = self.weekCardActivityDic[activityId]
    for i, weekCardInfo in pairs(weekCardDic) do
      local canReceiveCount = weekCardInfo:GetCanReceiveCount()
      if canReceiveCount and 0 < canReceiveCount then
        total = total + canReceiveCount
      end
    end
  end
  return total
end

function LWOptionalWeekCardManager:SetSelectReward(activityId, cardId, rewardIndex, isAdd)
  if self.weekCardActivityDic[activityId] then
    local weekCardDic = self.weekCardActivityDic[activityId]
    if weekCardDic[cardId] then
      local weekCardInfo = weekCardDic[cardId]
      weekCardInfo:SetSelectRewardIndex(rewardIndex, isAdd)
    end
  end
end

function LWOptionalWeekCardManager:DeleteSelectReward(activityId, cardId, targetGridIndex)
  if self.weekCardActivityDic[activityId] then
    local weekCardDic = self.weekCardActivityDic[activityId]
    if weekCardDic[cardId] then
      local weekCardInfo = weekCardDic[cardId]
      weekCardInfo:DeleteReward(targetGridIndex)
    end
  end
end

return LWOptionalWeekCardManager
