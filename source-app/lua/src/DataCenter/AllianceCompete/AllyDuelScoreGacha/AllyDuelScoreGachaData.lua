local AllyDuelScoreGachaData = BaseClass("AllyDuelScoreGachaData")
local AllyDuelScoreGachaItemData = require("DataCenter/AllianceCompete/AllyDuelScoreGacha/AllyDuelScoreGachaItemData")

function AllyDuelScoreGachaData:__init()
end

function AllyDuelScoreGachaData:__delete()
end

function AllyDuelScoreGachaData:InitData(data, configId)
  self.configId = configId
  self.allItemData = nil
  self.extraItemDataList = nil
  if self.data == nil then
    self.data = {}
  end
  if data ~= nil then
    for i, v in pairs(data) do
      self.data[i] = v
    end
  end
end

function AllyDuelScoreGachaData:GetConfigId()
  return self.configId
end

function AllyDuelScoreGachaData:GetAllItemDataInOrder()
  if self.allItemData == nil then
    self.allItemData = {}
    if self.data ~= nil and self.data.posArray ~= nil then
      for i, v in pairs(self.data.posArray) do
        local itemData = AllyDuelScoreGachaItemData.New()
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

function AllyDuelScoreGachaData:GetAllBuildIdInWheelBoxItem()
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

function AllyDuelScoreGachaData:GetItemDataByItemId(itemId)
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
  local itemData = AllyDuelScoreGachaItemData.New()
  itemData:InitDataByItemId(itemId, 0)
  table.insert(self.extraItemDataList, itemData)
  return itemData
end

function AllyDuelScoreGachaData:GetPity()
  if self.data ~= nil and self.data.protect ~= nil then
    return self.data.protect.num or 0
  end
  return 0
end

function AllyDuelScoreGachaData:CanClaimWish()
  local maxScore = self:GetPity()
  if 0 < maxScore and maxScore <= self:GetCurWishScore() and self:GetCurSelectWishData() ~= nil then
    return true
  end
  return false
end

function AllyDuelScoreGachaData:GetPityQuality()
  return 5
end

function AllyDuelScoreGachaData:GetCurWishScore()
  if self.data ~= nil and self.data.protect ~= nil then
    return self.data.protect.protectNum
  end
  return 0
end

function AllyDuelScoreGachaData:GetCurSelectWishData()
  if self.data ~= nil and self.data.protect ~= nil then
    local rewardData = DataCenter.RewardManager:ParseRewardInfo(self.data.protect.reward[1])
    return rewardData
  end
end

return AllyDuelScoreGachaData
