local ActivityDecorationGachaData = BaseClass("ActivityDecorationGachaData")
local ActivityDecorationGachaItemData = require("DataCenter/ActivityDecorationGacha/ActivityDecorationGachaItemData")

function ActivityDecorationGachaData:__init()
end

function ActivityDecorationGachaData:__delete()
end

function ActivityDecorationGachaData:InitData(data, activityId)
  self.activityId = activityId
  if self.data == nil then
    self.data = {}
  end
  if data ~= nil then
    for i, v in pairs(data) do
      self.data[i] = v
    end
  end
end

function ActivityDecorationGachaData:CanClaimFreePackage()
  local res = false
  if self.data ~= nil and self.data.freeReward ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.data.nextResetTime == nil or curTime >= self.data.nextResetTime * 1000 then
      res = true
    else
      res = self.data.freeState == 0
    end
  end
  return res
end

function ActivityDecorationGachaData:CanBuyGoldPackage(index)
  local res = false
  if self.data ~= nil and self.data.diamondRewardArr ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.data.nextResetTime == nil or curTime >= self.data.nextResetTime * 1000 then
      res = true
    else
      res = true
      if self.data.diamondState ~= nil then
        for i, v in pairs(self.data.diamondState) do
          if v == index - 1 then
            res = false
            break
          end
        end
      end
    end
  end
  return res
end

function ActivityDecorationGachaData:CanOpenGiftPackage()
  if self:CanClaimFreePackage() then
    return true
  end
  local rewardPackGroupId = self:GetGiftPackId()
  local packs = GiftPackManager.GetPacksByGroupId(rewardPackGroupId, false)
  return not table.IsNullOrEmpty(packs)
end

function ActivityDecorationGachaData:GetEndTime()
  if self.data ~= nil then
    return tonumber(self.data.endTime)
  end
  return 0
end

function ActivityDecorationGachaData:GetActivityId()
  return self.activityId
end

function ActivityDecorationGachaData:HasShownGuide()
  local key = "activity_decoration_gacha_guide_show_" .. tostring(self:GetActivityId()) .. tostring(self:GetEndTime())
  return CS.GameEntry.Setting:GetBool(key .. LuaEntry.Player.uid, false)
end

function ActivityDecorationGachaData:SetHasShownGuide()
  local key = "activity_decoration_gacha_guide_show_" .. tostring(self:GetActivityId()) .. tostring(self:GetEndTime())
  CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, true)
end

function ActivityDecorationGachaData:GetLeftTime()
  local endTime = self:GetEndTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = endTime - curTime
  return leftTime
end

function ActivityDecorationGachaData:GetProgressData()
  if self.data ~= nil then
    return self.data.boxRewards
  end
end

function ActivityDecorationGachaData:GetProgressMaxScore()
  local res = 0
  if self.data ~= nil and self.data.boxRewards ~= nil then
    for i, v in pairs(self.data.boxRewards) do
      if res < v.target then
        res = v.target
      end
    end
  end
  return res
end

function ActivityDecorationGachaData:GetProgressCurScore()
  if self.data ~= nil and self.data.totalScore ~= nil then
    return self.data.totalScore
  end
  return 0
end

function ActivityDecorationGachaData:GetProgressDataByIndex(index)
  local progressData = self:GetProgressData()
  if progressData ~= nil then
    for i, v in pairs(progressData) do
      if v.index == index then
        return v
      end
    end
  end
end

function ActivityDecorationGachaData:GetProgressClaimedData()
  if self.data ~= nil then
    return self.data.boxReceive
  end
end

function ActivityDecorationGachaData:GetProgressState(index)
  local curScore = self:GetProgressCurScore()
  local data = self:GetProgressDataByIndex(index)
  if data ~= nil then
    if curScore < data.target then
      return 0
    else
      local claimedData = self:GetProgressClaimedData()
      local hasClaimed = false
      if claimedData ~= nil then
        for i, v in pairs(claimedData) do
          if v == index then
            hasClaimed = true
            break
          end
        end
      end
      if hasClaimed then
        return 2
      else
        return 1
      end
    end
  end
  return 0
end

function ActivityDecorationGachaData:GetAllItemDataInOrder()
  if self.allItemData == nil then
    self.allItemData = {}
    if self.data ~= nil and self.data.dataArr ~= nil then
      for i, v in pairs(self.data.dataArr) do
        local itemData = ActivityDecorationGachaItemData.New()
        itemData:InitData(v)
        table.insert(self.allItemData, itemData)
      end
    end
    table.sort(self.allItemData, function(a, b)
      return a:GetOrder() < b:GetOrder()
    end)
  end
  return self.allItemData
end

function ActivityDecorationGachaData:GetAllBuildIdInWheelBoxItem()
  local res = {}
  local allItemData = self:GetAllItemDataInOrder()
  for _, v in pairs(allItemData) do
    if v.itemTemplate ~= nil and v.itemTemplate.tipsType == GOODS_TIPS_TYPE.Box then
      local paramData = v.itemTemplate:GetTipsPara2Data()
      for _, j in pairs(paramData) do
        local itemData = self:GetItemDataByItemId(j.itemId)
        if itemData ~= nil and itemData.decorationBuildingId > 0 then
          table.insert(res, itemData.decorationBuildingId)
        end
      end
    end
  end
  return res
end

function ActivityDecorationGachaData:GetItemDataByItemId(itemId)
  local allItemData = self:GetAllItemDataInOrder()
  for i, v in pairs(allItemData) do
    if v.itemId == itemId then
      return v
    end
  end
  if self.extraItemDataList == nil then
    self.extraItemDataList = {}
  end
  for i, v in pairs(self.extraItemDataList) do
    if v.itemId == itemId then
      return v
    end
  end
  local itemData = ActivityDecorationGachaItemData.New()
  itemData:InitDataByItemId(itemId, 0)
  table.insert(self.extraItemDataList, itemData)
  return itemData
end

function ActivityDecorationGachaData:GetRecommendItems()
  local res = {}
  if self.data ~= nil and not string.IsNullOrEmpty(self.data.recommend) then
    local recommendStrs = string.split(self.data.recommend, "|")
    for i, v in pairs(recommendStrs) do
      if tonumber(v) > 0 then
        table.insert(res, tonumber(v))
      end
    end
  end
  return res
end

function ActivityDecorationGachaData:GetCurFreeGachaRefreshLeftTime()
  if self.activityId ~= nil and self.data ~= nil and self.data.nextFreeResetTime ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    return math.max(0, self.data.nextFreeResetTime * 1000 - curTime)
  end
  return 0
end

function ActivityDecorationGachaData:GetCurFreeGachaLeftTime()
  local res = 0
  if self.activityId ~= nil then
    local activityInfo = DataCenter.ActivityDecorationGachaManager:GetActivityInfo(self.activityId)
    if activityInfo ~= nil then
      local totalFreeTime = checknumber(activityInfo.freeTime)
      if self.data ~= nil and self.data.nextFreeResetTime ~= nil then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if curTime < self.data.nextFreeResetTime * 1000 and self.data.freeTimes ~= nil then
          res = totalFreeTime - self.data.freeTimes
        else
          res = totalFreeTime
        end
      end
    end
  end
  return res
end

function ActivityDecorationGachaData:GetCurGachaTimes()
  if self.data ~= nil and self.data.totalTimes ~= nil then
    return self.data.totalTimes
  end
  return 0
end

function ActivityDecorationGachaData:GetTotalGachaLeftTimes()
  if self.data ~= nil and self.data.totalTimes ~= nil and self.data.max_limit ~= nil then
    return self.data.max_limit - self.data.totalTimes
  end
  return 0
end

function ActivityDecorationGachaData:GetPity()
  if self.data ~= nil and self.data.pity ~= nil then
    return self.data.pity
  end
  return 0
end

function ActivityDecorationGachaData:CanClaimWish()
  local maxScore = self:GetPity()
  if 0 < maxScore and maxScore <= self:GetCurWishScore() and self:GetCurSelectWishData() ~= nil then
    return true
  end
  return false
end

function ActivityDecorationGachaData:GetPityLeftTimes()
  if self.data ~= nil and self.data.pityRemainTimes ~= nil then
    return self.data.pityRemainTimes
  end
  return 0
end

function ActivityDecorationGachaData:GetPityQuality()
  if self.data ~= nil and self.data.pityQuality ~= nil then
    return self.data.pityQuality
  end
  return 0
end

function ActivityDecorationGachaData:GetFreeRewardData()
  local res = {}
  if self.data ~= nil and self.data.freeReward ~= nil then
    for i, v in pairs(self.data.freeReward) do
      local data = {
        rewardType = v.type,
        itemId = v.value.id,
        count = v.value.num
      }
      table.insert(res, data)
    end
  end
  return res
end

function ActivityDecorationGachaData:GetGoldRewardData()
  if self.data ~= nil then
    return self.data.diamondRewardArr
  end
end

function ActivityDecorationGachaData:GetCurWishScore()
  if self.data ~= nil then
    return self.data.wishScore
  end
  return 0
end

function ActivityDecorationGachaData:GetAllWishDataInOrder()
  local res = {}
  if self.data ~= nil and not string.IsNullOrEmpty(self.data.wish_list_id) then
    local strs1 = string.split(self.data.wish_list_id, "|")
    for i, v in pairs(strs1) do
      local strs2 = string.split(v, ";")
      if #strs2 == 3 then
        local data = {
          rewardType = tonumber(strs2[1]),
          itemId = tonumber(strs2[2]),
          count = tonumber(strs2[3]),
          index = i
        }
        table.insert(res, data)
      end
    end
  end
  return res
end

function ActivityDecorationGachaData:GetCurSelectWishData()
  if self.data ~= nil and self.data.wishItem ~= nil and self.data.wishItem > 0 and self.data.wishNum ~= nil then
    return {
      rewardType = RewardType.GOODS,
      itemId = self.data.wishItem,
      count = self.data.wishNum
    }
  end
end

function ActivityDecorationGachaData:GetCanCritDecorationNameStr()
  local res = ""
  local allItemData = self:GetAllItemDataInOrder()
  for _, itemData in pairs(allItemData) do
    if itemData.crit > 0 and itemData.decorationBuildingTemplate ~= nil then
      if string.IsNullOrEmpty(res) then
        res = CS.GameEntry.Localization:GetString(itemData.decorationBuildingTemplate.name)
      else
        res = res .. "," .. CS.GameEntry.Localization:GetString(itemData.decorationBuildingTemplate.name)
      end
    end
  end
  return res
end

return ActivityDecorationGachaData
