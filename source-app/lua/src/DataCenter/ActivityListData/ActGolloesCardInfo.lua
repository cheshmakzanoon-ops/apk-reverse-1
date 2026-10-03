local ActGolloesCardInfo = BaseClass("ActGolloesCardInfo")
local ActGolloesCardRankInfo = require("DataCenter.ActivityListData.ActGolloesCardRankInfo")

local function __init(self)
  self.cost_item = {}
  self.cost_1 = {}
  self.cost_all = 0
  self.refresh_cost = {}
  self.times = 0
  self.flipCards = {}
  self.free_all = 0
  self.cardInfo = {}
  self.free_refresh = 0
  self.showRewardArr = {}
  self.nextShowRewardArr = {}
  self.selfScore = 0
  self.selfRank = 0
  self.rankList = {}
  self.rankRewardArr = {}
  self.lastFlipCards = nil
end

local function __delete(self)
  self.cost_item = nil
  self.cost_1 = nil
  self.cost_all = nil
  self.refresh_cost = nil
  self.times = nil
  self.flipCards = nil
  self.free_all = nil
  self.cardInfo = nil
  self.free_refresh = nil
  self.showRewardArr = nil
  self.nextShowRewardArr = nil
  self.rankList = nil
  self.rankRewardArr = nil
  self.lastFlipCards = nil
end

local function ParseGolloesCard(self, message)
  if message == nil then
    return
  end
  if message.cost_item ~= nil then
    self.cost_item = string.split(message.cost_item, ";")
  end
  if message.cost_1 ~= nil then
    self.cost_1 = string.split(message.cost_1, ";")
  end
  if message.cost_all then
    self.cost_all = message.cost_all
  end
  if message.refresh_cost then
    self.refresh_cost = string.split(message.refresh_cost, ";")
  end
  if message.times then
    self.times = message.times
  end
  if message.free_all then
    self.free_all = message.free_all
  end
  if message.free_refresh_times then
    self.free_refresh = message.free_refresh_times
  end
  if message.flipCards and next(message.flipCards) then
    self:ParseFlipCards(message.flipCards)
  end
  if message.cardInfo then
    self:ParseCardInfo(message.cardInfo)
  end
end

local function ParseFlipCards(self, message)
  self.flipCards = {}
  for i = 1, #message do
    local param = {}
    param.index = message[i].index
    param.reward = DataCenter.RewardManager:ReturnRewardParamForView(message[i].reward)
    table.insert(self.flipCards, param)
  end
  table.sort(self.flipCards, function(a, b)
    if a.index < b.index then
      return true
    end
    return false
  end)
end

local function UpdateFlipCard(self, message)
  table.insert(self.flipCards, message)
  table.sort(self.flipCards, function(a, b)
    if a.index < b.index then
      return true
    end
    return false
  end)
end

local function ClearFlipCards(self)
  self.flipCards = {}
end

local function ParseCardInfo(self, message)
  self.cardInfo.refreshCount = message.refreshCount
  self.cardInfo.group = message.group
  self.cardInfo.flipCount = message.flipCount
  self.cardInfo.flipAllCount = message.flipAllCount
end

local function UpdateShowArr(self, message)
  self.showRewardArr = {}
  local n = 1
  if message and next(message) then
    n = math.random(1, #message)
  end
  for i = 1, #message do
    if i <= n then
      table.insert(self.showRewardArr, DataCenter.RewardManager:ReturnRewardParamForView(message[i]))
    else
      table.insert(self.showRewardArr, 1, DataCenter.RewardManager:ReturnRewardParamForView(message[i]))
    end
  end
end

local function UpdateNextShowArr(self, message)
  self.nextShowRewardArr = {}
  local n = math.random(1, 9)
  for i = 1, #message do
    if i <= n then
      table.insert(self.nextShowRewardArr, DataCenter.RewardManager:ReturnRewardParamForView(message[i]))
    else
      table.insert(self.nextShowRewardArr, 1, DataCenter.RewardManager:ReturnRewardParamForView(message[i]))
    end
  end
end

local function GetShowArr(self)
  return self.showRewardArr
end

local function GetNextShowArr(self, previewRw)
  local data
  for i = 1, #self.nextShowRewardArr do
    if tonumber(self.nextShowRewardArr[i][1].itemId) == previewRw then
      data = self.nextShowRewardArr[i]
      table.remove(self.nextShowRewardArr, i)
      break
    end
  end
  if data then
    table.insert(self.nextShowRewardArr, 5, data)
  end
  return self.nextShowRewardArr
end

local function ParseRankInfo(self, message)
  if message.selfScore then
    self.selfScore = message.selfScore
  end
  if message.selfRank then
    self.selfRank = message.selfRank
  end
  if message.rankList and next(message.rankList) then
    for i = 1, #message.rankList do
      local info = ActGolloesCardRankInfo.New()
      info:ParseRankInfo(message.rankList[i])
      self.rankList[i] = info
    end
  end
  if message.rankRewardArr and next(message.rankRewardArr) then
    for i = 1, #message.rankRewardArr do
      self.rankRewardArr[i] = {}
      self.rankRewardArr[i].reward = DataCenter.RewardManager:ReturnRewardParamForView(message.rankRewardArr[i].reward)
      self.rankRewardArr[i].startN = message.rankRewardArr[i].start
      self.rankRewardArr[i].endN = message.rankRewardArr[i]["end"]
    end
  end
end

local function GetRankList(self)
  return self.rankList
end

local function GetRewardArr(self)
  return self.rankRewardArr
end

local function GetRedNum(self)
  local count = 0
  local goodsList = DataCenter.CommonShopManager:GetGoodsListByShopType(CommonShopType.GolloesShop)
  if 0 < #goodsList then
    for i = 1, #goodsList do
      local soldOut = false
      local state = false
      if goodsList[i].discount and 0 < goodsList[i].discount then
        state = true
      end
      local switch = CS.GameEntry.Setting:GetBool("GolloesCardShopCellS_" .. goodsList[i].itemId .. goodsList[i].costNum .. LuaEntry.Player.uid, state)
      if goodsList[i].maxTimes and 0 < goodsList[i].maxTimes then
        local goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(goodsList[i].shopType, goodsList[i].id)
        local boughtTimes = goodsInfo and goodsInfo.boughtTimes or 0
        if boughtTimes < goodsList[i].maxTimes then
          soldOut = false
        else
          soldOut = true
        end
      end
      local resType = RewardToResType[goodsList[i].currencyType]
      if resType and DataCenter.ResourceManager:GetResourceIconByType(resType) then
        if resType == ResourceType.Gold then
          if LuaEntry.Player.gold >= goodsList[i].costNum and soldOut == false and switch then
            count = count + 1
          end
        else
          local cnt = LuaEntry.Resource:GetCntByResType(resType)
          if cnt >= goodsList[i].costNum and soldOut == false and switch then
            count = count + 1
          end
        end
      else
        local curNum = DataCenter.ItemData:GetItemCount(goodsList[i].currencyId)
        if curNum >= goodsList[i].costNum and soldOut == false and switch then
          count = count + 1
        end
      end
    end
  end
  return count
end

local function SetLastFlipCards(self)
  self.lastFlipCards = self.flipCards
end

local function GetLastFlipCards(self)
  return self.lastFlipCards
end

local function ClearLastFlipCards(self)
  self.lastFlipCards = nil
end

ActGolloesCardInfo.__init = __init
ActGolloesCardInfo.__delete = __delete
ActGolloesCardInfo.ParseGolloesCard = ParseGolloesCard
ActGolloesCardInfo.ParseFlipCards = ParseFlipCards
ActGolloesCardInfo.ParseCardInfo = ParseCardInfo
ActGolloesCardInfo.UpdateFlipCard = UpdateFlipCard
ActGolloesCardInfo.ClearFlipCards = ClearFlipCards
ActGolloesCardInfo.UpdateShowArr = UpdateShowArr
ActGolloesCardInfo.UpdateNextShowArr = UpdateNextShowArr
ActGolloesCardInfo.GetShowArr = GetShowArr
ActGolloesCardInfo.GetNextShowArr = GetNextShowArr
ActGolloesCardInfo.ParseRankInfo = ParseRankInfo
ActGolloesCardInfo.GetRankList = GetRankList
ActGolloesCardInfo.GetRewardArr = GetRewardArr
ActGolloesCardInfo.GetRedNum = GetRedNum
ActGolloesCardInfo.SetLastFlipCards = SetLastFlipCards
ActGolloesCardInfo.GetLastFlipCards = GetLastFlipCards
ActGolloesCardInfo.ClearLastFlipCards = ClearLastFlipCards
return ActGolloesCardInfo
